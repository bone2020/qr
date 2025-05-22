import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String type; // 'bank', 'mobile_money', 'card'
  final double amount;
  final String description;
  final DateTime timestamp;
  final String status;
  final Map<String, dynamic> details;
  final String? errorMessage;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
    required this.status,
    required this.details,
    this.errorMessage,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toDouble(),
      description: json['description'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: json['status'] as String,
      details: json['details'] as Map<String, dynamic>,
      errorMessage: json['error_message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amount': amount,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'details': details,
      'error_message': errorMessage,
    };
  }
} 