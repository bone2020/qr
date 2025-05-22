import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/payment_service.dart';
import '../services/notification_service.dart';
import '../services/security_service.dart';
import '../services/subscription_service.dart';
import '../models/transaction.dart';

class PaymentProvider with ChangeNotifier {
  final PaymentService _paymentService = PaymentService();
  final NotificationService _notificationService = NotificationService();
  final SecurityService _securityService = SecurityService();
  final SubscriptionService _subscriptionService = SubscriptionService();
  
  PaymentStatus _currentStatus = PaymentStatus.pending;
  String? _currentTransactionId;
  String? _errorMessage;
  bool _isLoading = false;
  List<Map<String, dynamic>> _availableBanks = [];
  List<Map<String, dynamic>> _mobileMoneyProviders = [];
  List<Transaction> _transactions = [];
  bool _hasError = false;

  // Getters
  PaymentStatus get currentStatus => _currentStatus;
  String? get currentTransactionId => _currentTransactionId;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  List<Map<String, dynamic>> get availableBanks => _availableBanks;
  List<Map<String, dynamic>> get mobileMoneyProviders => _mobileMoneyProviders;
  List<Transaction> get transactions => _transactions;

  PaymentProvider() {
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionsJson = prefs.getStringList('transactions') ?? [];
      _transactions = transactionsJson
          .map((json) => Transaction.fromJson(jsonDecode(json)))
          .toList();
      notifyListeners();
    } catch (e) {
      _handleError('Failed to load transactions: $e');
    }
  }

  Future<void> _saveTransactions() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final transactionsJson = _transactions
          .map((transaction) => jsonEncode(transaction.toJson()))
          .toList();
      await prefs.setStringList('transactions', transactionsJson);
    } catch (e) {
      _handleError('Failed to save transactions: $e');
    }
  }

  void _handleError(String message) {
    _errorMessage = message;
    _hasError = true;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    _hasError = false;
    notifyListeners();
  }

  Future<void> _addTransaction(Transaction transaction) async {
    _transactions.insert(0, transaction);
    await _saveTransactions();
    notifyListeners();
  }

  // Initialize available payment methods
  Future<void> initializePaymentMethods() async {
    _setLoading(true);
    _clearError();
    try {
      _availableBanks = await _paymentService.getAvailableBanks();
      _mobileMoneyProviders = await _paymentService.getMobileMoneyProviders();
    } catch (e) {
      _handleError('Failed to initialize payment methods: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Authenticate transaction
  Future<bool> _authenticateTransaction() async {
    final isBiometricEnabled = await _securityService.isBiometricEnabled();
    
    if (isBiometricEnabled) {
      return await _securityService.authenticateWithBiometrics();
    } else {
      // Implement PIN authentication UI
      // For now, return true as a placeholder
      return true;
    }
  }

  // Check transaction rate limit
  Future<bool> _checkRateLimit() async {
    return await _securityService.checkTransactionRateLimit();
  }

  // Encrypt transaction data
  Future<String> _encryptTransactionData(Map<String, dynamic> data) async {
    return await _securityService.encryptTransaction(data);
  }

  // Calculate total amount with fees
  Future<Map<String, double>> calculateTotalWithFees(double amount) async {
    return _subscriptionService.calculateTransactionFees(amount);
  }

  // Check if feature is available
  Future<bool> hasFeature(String feature) async {
    return await _subscriptionService.hasFeature(feature);
  }

  // Bank Transfer
  Future<bool> initiateBankTransfer({
    required String accountNumber,
    required String bankCode,
    required double amount,
    required String description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Check rate limit
      if (!await _checkRateLimit()) {
        _handleError('Too many transactions. Please wait a moment.');
        return false;
      }

      // Authenticate user
      if (!await _authenticateTransaction()) {
        _handleError('Authentication failed');
        return false;
      }

      // Calculate total with fees
      final fees = await calculateTotalWithFees(amount);
      final totalAmount = fees['total_amount']!;
      final senderFee = fees['sender_fee']!;
      final receiverFee = fees['receiver_fee']!;

      final response = await _paymentService.initiateBankTransfer(
        accountNumber: accountNumber,
        bankCode: bankCode,
        amount: totalAmount,
        description: description,
      );
      
      final transaction = Transaction(
        id: _securityService.generateTransactionId(),
        type: 'bank',
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
        status: 'processing',
        details: {
          'account_number': accountNumber,
          'bank_code': bankCode,
          'sender_fee': senderFee,
          'receiver_fee': receiverFee,
          'total_fee': fees['total_fee'],
          'total_amount': totalAmount,
          'currency': 'GHS',
        },
      );

      // Save transaction fee
      await _subscriptionService.saveTransactionFee(amount, fees['total_fee']!);

      // Encrypt transaction data
      final encryptedData = await _encryptTransactionData(transaction.toJson());
      
      await _addTransaction(transaction);
      await _notificationService.showPaymentProcessingNotification(transaction);
      
      _currentTransactionId = transaction.id;
      _currentStatus = PaymentStatus.processing;
      notifyListeners();
      
      return true;
    } catch (e) {
      _handleError('Bank transfer failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Mobile Money Payment
  Future<bool> initiateMobileMoneyPayment({
    required String phoneNumber,
    required String provider,
    required double amount,
    required String description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Check rate limit
      if (!await _checkRateLimit()) {
        _handleError('Too many transactions. Please wait a moment.');
        return false;
      }

      // Authenticate user
      if (!await _authenticateTransaction()) {
        _handleError('Authentication failed');
        return false;
      }

      // Calculate total with fees
      final fees = await calculateTotalWithFees(amount);
      final totalAmount = fees['total_amount']!;
      final senderFee = fees['sender_fee']!;
      final receiverFee = fees['receiver_fee']!;

      final response = await _paymentService.initiateMobileMoneyPayment(
        phoneNumber: phoneNumber,
        provider: provider,
        amount: totalAmount,
        description: description,
      );
      
      final transaction = Transaction(
        id: _securityService.generateTransactionId(),
        type: 'mobile_money',
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
        status: 'processing',
        details: {
          'phone_number': phoneNumber,
          'provider': provider,
          'sender_fee': senderFee,
          'receiver_fee': receiverFee,
          'total_fee': fees['total_fee'],
          'total_amount': totalAmount,
          'currency': 'GHS',
        },
      );

      // Save transaction fee
      await _subscriptionService.saveTransactionFee(amount, fees['total_fee']!);

      // Encrypt transaction data
      final encryptedData = await _encryptTransactionData(transaction.toJson());
      
      await _addTransaction(transaction);
      await _notificationService.showPaymentProcessingNotification(transaction);
      
      _currentTransactionId = transaction.id;
      _currentStatus = PaymentStatus.processing;
      notifyListeners();
      
      return true;
    } catch (e) {
      _handleError('Mobile money payment failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Payment Gateway
  Future<bool> initiatePaymentGateway({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
    required String description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Check rate limit
      if (!await _checkRateLimit()) {
        _handleError('Too many transactions. Please wait a moment.');
        return false;
      }

      // Authenticate user
      if (!await _authenticateTransaction()) {
        _handleError('Authentication failed');
        return false;
      }

      // Calculate total with fees
      final fees = await calculateTotalWithFees(amount);
      final totalAmount = fees['total_amount']!;
      final senderFee = fees['sender_fee']!;
      final receiverFee = fees['receiver_fee']!;

      final response = await _paymentService.initiatePaymentGateway(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        cvv: cvv,
        amount: totalAmount,
        description: description,
      );
      
      final transaction = Transaction(
        id: _securityService.generateTransactionId(),
        type: 'card',
        amount: amount,
        description: description,
        timestamp: DateTime.now(),
        status: 'processing',
        details: {
          'card_last_four': cardNumber.substring(cardNumber.length - 4),
          'expiry_date': expiryDate,
          'sender_fee': senderFee,
          'receiver_fee': receiverFee,
          'total_fee': fees['total_fee'],
          'total_amount': totalAmount,
          'currency': 'GHS',
        },
      );

      // Save transaction fee
      await _subscriptionService.saveTransactionFee(amount, fees['total_fee']!);

      // Encrypt transaction data
      final encryptedData = await _encryptTransactionData(transaction.toJson());
      
      await _addTransaction(transaction);
      await _notificationService.showPaymentProcessingNotification(transaction);
      
      _currentTransactionId = transaction.id;
      _currentStatus = PaymentStatus.processing;
      notifyListeners();
      
      return true;
    } catch (e) {
      _handleError('Card payment failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verify Transaction
  Future<bool> verifyTransaction(PaymentMethod paymentMethod) async {
    if (_currentTransactionId == null) {
      _handleError('No transaction to verify');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      // Authenticate user
      if (!await _authenticateTransaction()) {
        _handleError('Authentication failed');
        return false;
      }

      final response = await _paymentService.verifyTransaction(
        transactionId: _currentTransactionId!,
        paymentMethod: paymentMethod,
      );
      
      final status = _mapStatusFromResponse(response['status']);
      _currentStatus = status;

      // Update transaction status
      final transactionIndex = _transactions.indexWhere((t) => t.id == _currentTransactionId);
      if (transactionIndex != -1) {
        final transaction = _transactions[transactionIndex];
        final updatedTransaction = Transaction(
          id: transaction.id,
          type: transaction.type,
          amount: transaction.amount,
          description: transaction.description,
          timestamp: transaction.timestamp,
          status: status.toString().split('.').last,
          details: transaction.details,
        );

        _transactions[transactionIndex] = updatedTransaction;
        await _saveTransactions();

        // Show appropriate notification
        if (status == PaymentStatus.completed) {
          await _notificationService.showPaymentSuccessNotification(updatedTransaction);
        } else if (status == PaymentStatus.failed) {
          await _notificationService.showPaymentFailedNotification(updatedTransaction);
        }
      }

      notifyListeners();
      return status == PaymentStatus.completed;
    } catch (e) {
      _handleError('Transaction verification failed: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  PaymentStatus _mapStatusFromResponse(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'cancelled':
        return PaymentStatus.cancelled;
      case 'processing':
        return PaymentStatus.processing;
      default:
        return PaymentStatus.pending;
    }
  }

  void reset() {
    _currentStatus = PaymentStatus.pending;
    _currentTransactionId = null;
    _errorMessage = null;
    _isLoading = false;
    _hasError = false;
    notifyListeners();
  }
} 