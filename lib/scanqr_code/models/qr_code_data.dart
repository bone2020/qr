import 'dart:convert';
import 'package:crypto/crypto.dart';

class QRCodeData {
  final double amount;
  final String purpose;
  final String senderName;
  final String? companyName;
  final String? companyLogo;
  final String? transactionId;
  final DateTime timestamp;
  final String? customMessage;
  final Map<String, dynamic>? additionalMetadata;

  QRCodeData({
    required this.amount,
    required this.purpose,
    required this.senderName,
    this.companyName,
    this.companyLogo,
    this.transactionId,
    DateTime? timestamp,
    this.customMessage,
    this.additionalMetadata,
  }) : timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'amount': amount,
      'purpose': purpose,
      'senderName': senderName,
      'companyName': companyName,
      'companyLogo': companyLogo,
      'transactionId': transactionId,
      'timestamp': timestamp.toIso8601String(),
      'customMessage': customMessage,
      'additionalMetadata': additionalMetadata,
    };
  }

  factory QRCodeData.fromJson(Map<String, dynamic> json) {
    return QRCodeData(
      amount: json['amount'].toDouble(),
      purpose: json['purpose'],
      senderName: json['senderName'],
      companyName: json['companyName'],
      companyLogo: json['companyLogo'],
      transactionId: json['transactionId'],
      timestamp: DateTime.parse(json['timestamp']),
      customMessage: json['customMessage'],
      additionalMetadata: json['additionalMetadata'],
    );
  }

  String encryptData() {
    final jsonString = jsonEncode(toJson());
    final bytes = utf8.encode(jsonString);
    final hash = sha256.convert(bytes);
    return base64Encode(bytes) + '.' + hash.toString();
  }

  static QRCodeData decryptData(String encryptedData) {
    final parts = encryptedData.split('.');
    if (parts.length != 2) {
      throw FormatException('Invalid QR code format');
    }

    final data = base64Decode(parts[0]);
    final hash = parts[1];

    // Verify hash
    final computedHash = sha256.convert(data).toString();
    if (computedHash != hash) {
      throw FormatException('QR code data has been tampered with');
    }

    final jsonString = utf8.decode(data);
    final json = jsonDecode(jsonString);
    return QRCodeData.fromJson(json);
  }
} 