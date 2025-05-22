import 'package:flutter/material.dart';
import '../models/wallet_model.dart';
import '../services/subscription_service.dart';

class WalletProvider extends ChangeNotifier {
  Wallet? _wallet;
  final SubscriptionService _subscriptionService = SubscriptionService();
  bool _isLoading = false;
  String? _error;

  Wallet? get wallet => _wallet;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initializeWallet(String userId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _wallet = Wallet(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        userId: userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _wallet!.loadWalletData();
      _error = null;
    } catch (e) {
      _error = 'Failed to initialize wallet: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addFunds(double amount) async {
    if (_wallet == null) {
      _error = 'Wallet not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fees = await _subscriptionService.calculateTransactionFees(amount);
      final totalAmount = fees['total_amount'] as double;
      final senderFee = fees['sender_fee'] as double;
      final receiverFee = fees['receiver_fee'] as double;

      _wallet!.addFunds(totalAmount);
      await _wallet!.saveWalletData();
      _error = null;
    } catch (e) {
      _error = 'Failed to add funds: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> withdrawFunds(double amount) async {
    if (_wallet == null) {
      _error = 'Wallet not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fees = await _subscriptionService.calculateTransactionFees(amount);
      final totalAmount = fees['total_amount'] as double;
      final senderFee = fees['sender_fee'] as double;
      final receiverFee = fees['receiver_fee'] as double;

      _wallet!.withdrawFunds(totalAmount);
      await _wallet!.saveWalletData();
      _error = null;
    } catch (e) {
      _error = 'Failed to withdraw funds: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> transferFunds(String recipientId, double amount) async {
    if (_wallet == null) {
      _error = 'Wallet not initialized';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final fees = await _subscriptionService.calculateTransactionFees(amount);
      final totalAmount = fees['total_amount'] as double;
      final senderFee = fees['sender_fee'] as double;
      final receiverFee = fees['receiver_fee'] as double;

      _wallet!.transferFunds(recipientId, totalAmount);
      await _wallet!.saveWalletData();
      _error = null;
    } catch (e) {
      _error = 'Failed to transfer funds: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Transaction> getTransactionHistory() {
    return _wallet?.getTransactionHistory() ?? [];
  }

  Future<void> addTransaction(Transaction transaction) async {
    try {
      if (_wallet == null) {
        throw Exception('Wallet not initialized');
      }

      await _wallet!.addTransaction(transaction);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  Future<void> updateTransactionStatus(String transactionId, String newStatus) async {
    try {
      if (_wallet == null) {
        throw Exception('Wallet not initialized');
      }

      await _wallet!.updateTransactionStatus(transactionId, newStatus);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 