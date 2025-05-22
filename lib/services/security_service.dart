import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';

class SecurityService {
  static final SecurityService _instance = SecurityService._internal();
  factory SecurityService() => _instance;
  SecurityService._internal();

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  final LocalAuthentication _localAuth = LocalAuthentication();
  final _uuid = const Uuid();

  // Encryption keys
  static const String _encryptionKey = 'transaction_encryption_key';
  static const String _pinKey = 'user_pin';
  static const String _biometricEnabledKey = 'biometric_enabled';
  static const String _lastTransactionKey = 'last_transaction';
  static const int _maxAttempts = 3;
  static const Duration _lockoutDuration = Duration(minutes: 15);

  // Initialize security features
  Future<void> initialize() async {
    // Generate and store encryption key if not exists
    if (!await _secureStorage.containsKey(key: _encryptionKey)) {
      final key = _generateEncryptionKey();
      await _secureStorage.write(key: _encryptionKey, value: key);
    }
  }

  // Generate a secure encryption key
  String _generateEncryptionKey() {
    final random = Random.secure();
    final values = List<int>.generate(32, (i) => random.nextInt(256));
    return base64Url.encode(values);
  }

  // Encrypt transaction data
  Future<String> encryptTransaction(Map<String, dynamic> transaction) async {
    final key = await _secureStorage.read(key: _encryptionKey);
    if (key == null) throw Exception('Encryption key not found');

    final jsonString = jsonEncode(transaction);
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(jsonString);
    
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(dataBytes);
    
    final encryptedData = {
      'data': base64Url.encode(dataBytes),
      'signature': digest.toString(),
      'timestamp': DateTime.now().toIso8601String(),
    };
    
    return jsonEncode(encryptedData);
  }

  // Decrypt transaction data
  Future<Map<String, dynamic>> decryptTransaction(String encryptedData) async {
    final key = await _secureStorage.read(key: _encryptionKey);
    if (key == null) throw Exception('Encryption key not found');

    final encryptedMap = jsonDecode(encryptedData) as Map<String, dynamic>;
    final data = base64Url.decode(encryptedMap['data'] as String);
    final signature = encryptedMap['signature'] as String;
    final timestamp = DateTime.parse(encryptedMap['timestamp'] as String);

    // Verify timestamp (prevent replay attacks)
    if (DateTime.now().difference(timestamp) > const Duration(minutes: 5)) {
      throw Exception('Transaction expired');
    }

    // Verify signature
    final keyBytes = utf8.encode(key);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(data);
    
    if (digest.toString() != signature) {
      throw Exception('Invalid transaction signature');
    }

    return jsonDecode(utf8.decode(data)) as Map<String, dynamic>;
  }

  // Set PIN
  Future<void> setPin(String pin) async {
    final hashedPin = _hashPin(pin);
    await _secureStorage.write(key: _pinKey, value: hashedPin);
  }

  // Verify PIN
  Future<bool> verifyPin(String pin) async {
    final storedPin = await _secureStorage.read(key: _pinKey);
    if (storedPin == null) return false;
    
    final hashedPin = _hashPin(pin);
    return storedPin == hashedPin;
  }

  // Hash PIN
  String _hashPin(String pin) {
    final bytes = utf8.encode(pin);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  // Enable/disable biometric authentication
  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorage.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  // Check if biometric authentication is enabled
  Future<bool> isBiometricEnabled() async {
    final value = await _secureStorage.read(key: _biometricEnabledKey);
    return value == 'true';
  }

  // Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      if (!canAuthenticate) return false;

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to proceed with transaction',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Validate QR code
  Future<bool> validateQRCode(String qrData) async {
    try {
      // Decode and validate QR data
      final data = await decryptTransaction(qrData);
      
      // Check for suspicious patterns
      if (_isSuspiciousTransaction(data)) {
        throw Exception('Suspicious transaction detected');
      }

      // Store last transaction for fraud prevention
      await _secureStorage.write(
        key: _lastTransactionKey,
        value: jsonEncode(data),
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  // Check for suspicious transaction patterns
  bool _isSuspiciousTransaction(Map<String, dynamic> transaction) {
    // Implement fraud detection rules
    final amount = transaction['amount'] as double;
    final timestamp = DateTime.parse(transaction['timestamp'] as String);
    
    // Rule 1: Check for unusually large amounts
    if (amount > 10000) return true;
    
    // Rule 2: Check for rapid successive transactions
    // Rule 3: Check for unusual transaction patterns
    // Add more fraud detection rules as needed
    
    return false;
  }

  // Generate secure transaction ID
  String generateTransactionId() {
    return _uuid.v4();
  }

  // Rate limiting for transactions
  Future<bool> checkTransactionRateLimit() async {
    final lastTransaction = await _secureStorage.read(key: _lastTransactionKey);
    if (lastTransaction == null) return true;

    final lastTransactionTime = DateTime.parse(
      jsonDecode(lastTransaction)['timestamp'] as String,
    );

    // Prevent more than 3 transactions within 1 minute
    if (DateTime.now().difference(lastTransactionTime) < const Duration(minutes: 1)) {
      return false;
    }

    return true;
  }
} 