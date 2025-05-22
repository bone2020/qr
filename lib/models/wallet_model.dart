import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Transaction {
  final String id;
  final double amount;
  final String type; // 'credit' or 'debit'
  final String purpose;
  final String? senderName;
  final String? receiverName;
  final DateTime timestamp;
  final String status; // 'pending', 'completed', 'failed'
  final Map<String, dynamic>? metadata;
  final String? errorMessage;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.purpose,
    this.senderName,
    this.receiverName,
    DateTime? timestamp,
    this.status = 'completed',
    this.metadata,
    this.errorMessage,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'type': type,
      'purpose': purpose,
      'senderName': senderName,
      'receiverName': receiverName,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'metadata': metadata,
      'errorMessage': errorMessage,
    };
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      amount: json['amount'].toDouble(),
      type: json['type'],
      purpose: json['purpose'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
      timestamp: DateTime.parse(json['timestamp']),
      status: json['status'],
      metadata: json['metadata'],
      errorMessage: json['errorMessage'],
    );
  }
}

class Wallet extends ChangeNotifier {
  final String id;
  final String userId;
  double _balance = 0.0;
  List<Transaction> _transactions = [];
  String _currency = 'GHS';
  final DateTime createdAt;
  final DateTime updatedAt;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const String _walletKey = 'wallet_data';
  static const String _transactionsKey = 'wallet_transactions';

  Wallet({
    required this.id,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
  }) : super() {
    loadWalletData();
  }

  double get balance => _balance;
  List<Transaction> get transactions => List.unmodifiable(_transactions);
  String get currency => _currency;

  Future<void> loadWalletData() async {
    final data = await _storage.read(key: 'wallet_$id');
    if (data != null) {
      final walletData = jsonDecode(data);
      _balance = walletData['balance'];
      _currency = walletData['currency'];
    }

    final prefs = await SharedPreferences.getInstance();
    final transactionsData = prefs.getString('${_transactionsKey}_$userId');

    if (transactionsData != null) {
      final List<dynamic> transactions = jsonDecode(transactionsData);
      _transactions = transactions
          .map((t) => Transaction.fromJson(t))
          .toList();
    }

    notifyListeners();
  }

  Future<void> _saveWalletData() async {
    final prefs = await SharedPreferences.getInstance();
    final walletData = jsonEncode({
      'balance': _balance,
      'currency': _currency,
      'lastUpdated': DateTime.now().toIso8601String(),
    });
    final transactionsData = jsonEncode(_transactions.map((t) => t.toJson()).toList());

    await prefs.setString('${_walletKey}_$userId', walletData);
    await prefs.setString('${_transactionsKey}_$userId', transactionsData);
  }

  Future<void> addFunds(double amount) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    _balance += amount;
    await _saveWalletData();
    notifyListeners();
  }

  Future<void> withdrawFunds(double amount) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    if (_balance < amount) {
      throw Exception('Insufficient balance');
    }
    _balance -= amount;
    await _saveWalletData();
    notifyListeners();
  }

  Future<void> transferFunds(String recipientId, double amount) async {
    if (amount <= 0) {
      throw Exception('Amount must be greater than 0');
    }
    if (_balance < amount) {
      throw Exception('Insufficient balance');
    }
    _balance -= amount;
    await _saveWalletData();
    notifyListeners();
  }

  List<Transaction> getTransactionHistory() {
    return List.unmodifiable(_transactions);
  }

  Future<void> addTransaction(Transaction transaction) async {
    if (transaction.type == 'credit') {
      _balance += transaction.amount;
    } else if (transaction.type == 'debit') {
      if (_balance < transaction.amount) {
        throw Exception('Insufficient balance');
      }
      _balance -= transaction.amount;
    }

    _transactions.add(transaction);
    await _saveWalletData();
    notifyListeners();
  }

  Future<void> updateTransactionStatus(String transactionId, String newStatus) async {
    final index = _transactions.indexWhere((t) => t.id == transactionId);
    if (index != -1) {
      final transaction = _transactions[index];
      final updatedTransaction = Transaction(
        id: transaction.id,
        amount: transaction.amount,
        type: transaction.type,
        purpose: transaction.purpose,
        senderName: transaction.senderName,
        receiverName: transaction.receiverName,
        timestamp: transaction.timestamp,
        status: newStatus,
        metadata: transaction.metadata,
        errorMessage: transaction.errorMessage,
      );

      _transactions[index] = updatedTransaction;
      await _saveWalletData();
      notifyListeners();
    }
  }

  List<Transaction> getTransactionsByDateRange(DateTime start, DateTime end) {
    return _transactions.where((t) => 
      t.timestamp.isAfter(start) && t.timestamp.isBefore(end)
    ).toList();
  }

  List<Transaction> getTransactionsByType(String type) {
    return _transactions.where((t) => t.type == type).toList();
  }

  double getTotalIncome() {
    return _transactions
        .where((t) => t.type == 'credit')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  double getTotalExpenses() {
    return _transactions
        .where((t) => t.type == 'debit')
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  Future<void> saveWalletData() async {
    await _saveWalletData();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'balance': _balance,
      'currency': _currency,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory Wallet.fromJson(Map<String, dynamic> json) {
    return Wallet(
      id: json['id'],
      userId: json['userId'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
} 