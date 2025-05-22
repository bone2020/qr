import 'dart:convert';
import 'package:crypto/crypto.dart';

class QRCodeData {
  final String amount;
  final String purpose;
  final String senderName;
  final String receiverName;
  final String? companyName;
  final String? companyLogo;
  final DateTime timestamp;

  QRCodeData({
    required this.amount,
    required this.purpose,
    required this.senderName,
    required this.receiverName,
    this.companyName,
    this.companyLogo,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'purpose': purpose,
      'senderName': senderName,
      'receiverName': receiverName,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      amount: json['amount'],
      purpose: json['purpose'],
      senderName: json['senderName'],
      receiverName: json['receiverName'],
      companyName: json['companyName'],
      companyLogo: json['companyLogo'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  // Encrypt the data
  String encryptData() {
    final jsonString = jsonEncode(toJson());
    final bytes = utf8.encode(jsonString);
    final digest = sha256.convert(bytes);
    return base64Encode(bytes);
  }

  // Decrypt the data
  static QRCodeData decryptData(String encryptedData) {
    final bytes = base64Decode(encryptedData);
    final jsonString = utf8.decode(bytes);
    final json = jsonDecode(jsonString);
    return QRCodeData.fromJson(json);
  }
} 