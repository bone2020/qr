import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum PaymentMethod {
  bank,
  mobileMoney,
  paymentGateway,
}

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled
}

class PaymentService {
  // Singleton pattern
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // Payment configuration
  final String _apiBaseUrl = 'https://api.example.com/v1'; // Replace with your actual API endpoint
  final Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer YOUR_API_KEY', // Replace with your actual API key
  };

  // Mock data for testing
  final List<Map<String, dynamic>> _mockBanks = [
    {'code': '001', 'name': 'Bank of America'},
    {'code': '002', 'name': 'Chase Bank'},
    {'code': '003', 'name': 'Wells Fargo'},
  ];

  final List<Map<String, dynamic>> _mockProviders = [
    {'code': 'MM001', 'name': 'PayPal'},
    {'code': 'MM002', 'name': 'Venmo'},
    {'code': 'MM003', 'name': 'Cash App'},
  ];

  // Bank Integration
  Future<Map<String, dynamic>> initiateBankTransfer({
    required String accountNumber,
    required String bankCode,
    required double amount,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/bank/transfer'),
        headers: _headers,
        body: jsonEncode({
          'account_number': accountNumber,
          'bank_code': bankCode,
          'amount': amount,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to initiate bank transfer');
      }
    } catch (e) {
      debugPrint('Bank transfer error: $e');
      rethrow;
    }
  }

  // Mobile Money Integration
  Future<Map<String, dynamic>> initiateMobileMoneyPayment({
    required String phoneNumber,
    required String provider,
    required double amount,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/mobile-money/payment'),
        headers: _headers,
        body: jsonEncode({
          'phone_number': phoneNumber,
          'provider': provider,
          'amount': amount,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to initiate mobile money payment');
      }
    } catch (e) {
      debugPrint('Mobile money payment error: $e');
      rethrow;
    }
  }

  // Payment Gateway Integration
  Future<Map<String, dynamic>> initiatePaymentGateway({
    required String cardNumber,
    required String expiryDate,
    required String cvv,
    required double amount,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiBaseUrl/payment-gateway/charge'),
        headers: _headers,
        body: jsonEncode({
          'card_number': cardNumber,
          'expiry_date': expiryDate,
          'cvv': cvv,
          'amount': amount,
          'description': description,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to process payment gateway transaction');
      }
    } catch (e) {
      debugPrint('Payment gateway error: $e');
      rethrow;
    }
  }

  // Transaction Verification
  Future<Map<String, dynamic>> verifyTransaction({
    required String transactionId,
    required PaymentMethod paymentMethod,
  }) async {
    try {
      final endpoint = _getVerificationEndpoint(paymentMethod);
      final response = await http.get(
        Uri.parse('$_apiBaseUrl/$endpoint/$transactionId'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to verify transaction');
      }
    } catch (e) {
      debugPrint('Transaction verification error: $e');
      rethrow;
    }
  }

  String _getVerificationEndpoint(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.bank:
        return 'bank/verify';
      case PaymentMethod.mobileMoney:
        return 'mobile-money/verify';
      case PaymentMethod.paymentGateway:
        return 'payment-gateway/verify';
    }
  }

  // Get available banks
  Future<List<Map<String, dynamic>>> getAvailableBanks() async {
    try {
      // For testing, return mock data
      return _mockBanks;
      
      // Uncomment when ready to use real API
      // final response = await http.get(
      //   Uri.parse('$_apiBaseUrl/banks'),
      //   headers: _headers,
      // );
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = jsonDecode(response.body);
      //   return data.cast<Map<String, dynamic>>();
      // } else {
      //   throw Exception('Failed to fetch available banks');
      // }
    } catch (e) {
      debugPrint('Get banks error: $e');
      rethrow;
    }
  }

  // Get available mobile money providers
  Future<List<Map<String, dynamic>>> getMobileMoneyProviders() async {
    try {
      // For testing, return mock data
      return _mockProviders;
      
      // Uncomment when ready to use real API
      // final response = await http.get(
      //   Uri.parse('$_apiBaseUrl/mobile-money/providers'),
      //   headers: _headers,
      // );
      // if (response.statusCode == 200) {
      //   final List<dynamic> data = jsonDecode(response.body);
      //   return data.cast<Map<String, dynamic>>();
      // } else {
      //   throw Exception('Failed to fetch mobile money providers');
      // }
    } catch (e) {
      debugPrint('Get mobile money providers error: $e');
      rethrow;
    }
  }
} 