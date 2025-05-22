import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import '../services/security_service.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({Key? key}) : super(key: key);

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  final _securityService = SecurityService();
  final _localAuth = LocalAuthentication();
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;
  bool _isPinSet = false;
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final biometricEnabled = await _securityService.isBiometricEnabled();
    final canAuthenticate = await _localAuth.canCheckBiometrics;
    final isPinSet = await _securityService.verifyPin(''); // Check if PIN exists

    setState(() {
      _isBiometricEnabled = biometricEnabled;
      _isBiometricAvailable = canAuthenticate;
      _isPinSet = isPinSet;
    });
  }

  Future<void> _setPin() async {
    if (_formKey.currentState!.validate()) {
      if (_pinController.text != _confirmPinController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PINs do not match')),
        );
        return;
      }

      await _securityService.setPin(_pinController.text);
      setState(() => _isPinSet = true);
      
      _pinController.clear();
      _confirmPinController.clear();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PIN set successfully')),
      );
    }
  }

  Future<void> _toggleBiometric() async {
    if (!_isBiometricAvailable) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Biometric authentication not available')),
      );
      return;
    }

    if (!_isBiometricEnabled) {
      final authenticated = await _securityService.authenticateWithBiometrics();
      if (authenticated) {
        await _securityService.setBiometricEnabled(true);
        setState(() => _isBiometricEnabled = true);
      }
    } else {
      await _securityService.setBiometricEnabled(false);
      setState(() => _isBiometricEnabled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Security Settings'),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'PIN Authentication',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isPinSet) ...[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _pinController,
                            decoration: const InputDecoration(
                              labelText: 'Enter PIN',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter PIN';
                              }
                              if (value.length < 4) {
                                return 'PIN must be at least 4 digits';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _confirmPinController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm PIN',
                              border: OutlineInputBorder(),
                            ),
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please confirm PIN';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _setPin,
                            child: const Text('Set PIN'),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    const Text('PIN is set'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Implement PIN change functionality
                      },
                      child: const Text('Change PIN'),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Biometric Authentication',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (!_isBiometricAvailable)
                    const Text('Biometric authentication not available on this device')
                  else
                    SwitchListTile(
                      title: const Text('Enable Biometric Authentication'),
                      value: _isBiometricEnabled,
                      onChanged: (value) => _toggleBiometric(),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Transaction Security',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    '• All transactions are encrypted\n'
                    '• QR codes are validated for security\n'
                    '• Fraud prevention measures are active\n'
                    '• Rate limiting is enabled',
                    style: TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
} 