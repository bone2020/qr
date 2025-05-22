import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class SubscriptionService {
  static final SubscriptionService _instance = SubscriptionService._internal();
  factory SubscriptionService() => _instance;
  SubscriptionService._internal();

  final _storage = const FlutterSecureStorage();
  static const String _feeHistoryKey = 'transaction_fee_history';

  // Transaction fee configuration
  static const double _feePercentage = 0.002; // 0.20%
  static const double _minFee = 0.50; // GHS 0.50
  static const double _maxFee = 10.00; // GHS 10.00

  Future<Map<String, double>> calculateTransactionFees(double amount) async {
    // Calculate sender fee
    double senderFee = amount * _feePercentage;
    senderFee = senderFee.clamp(_minFee, _maxFee);

    // Calculate receiver fee
    double receiverFee = amount * _feePercentage;
    receiverFee = receiverFee.clamp(_minFee, _maxFee);

    // Calculate total fee and amount
    double totalFee = senderFee + receiverFee;
    double totalAmount = amount + totalFee;

    return {
      'sender_fee': senderFee,
      'receiver_fee': receiverFee,
      'total_fee': totalFee,
      'total_amount': totalAmount,
    };
  }

  Future<Map<String, dynamic>> getTransactionFeeDetails() async {
    return {
      'percentage': _feePercentage * 100,
      'min_fee': _minFee,
      'max_fee': _maxFee,
      'currency': 'GHS',
    };
  }

  Future<void> saveTransactionFee(double amount, double fee) async {
    final history = await getTransactionFeeHistory();
    history.add({
      'amount': amount,
      'fee': fee,
      'timestamp': DateTime.now().toIso8601String(),
    });
    await _storage.write(
      key: _feeHistoryKey,
      value: jsonEncode(history),
    );
  }

  Future<List<Map<String, dynamic>>> getTransactionFeeHistory() async {
    final historyJson = await _storage.read(key: _feeHistoryKey);
    if (historyJson == null) return [];
    
    final List<dynamic> history = jsonDecode(historyJson);
    return history.cast<Map<String, dynamic>>();
  }

  Future<bool> hasFeature(String feature) async {
    // Since we're not using subscription tiers anymore,
    // all features are available by default
    return true;
  }
} 