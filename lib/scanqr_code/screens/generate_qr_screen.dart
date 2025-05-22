import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../models/qr_code_data.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class GenerateQRScreen extends StatefulWidget {
  const GenerateQRScreen({super.key});

  @override
  State<GenerateQRScreen> createState() => _GenerateQRScreenState();
}

class _GenerateQRScreenState extends State<GenerateQRScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _purposeController = TextEditingController();
  final _senderNameController = TextEditingController();
  final _companyNameController = TextEditingController();
  final _customMessageController = TextEditingController();
  String? _qrData;
  File? _logoFile;
  bool _showAdvancedOptions = false;

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    _senderNameController.dispose();
    _companyNameController.dispose();
    _customMessageController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _logoFile = File(image.path);
      });
    }
  }

  void _generateQR() {
    if (_formKey.currentState!.validate()) {
      final qrData = QRCodeData(
        amount: double.parse(_amountController.text),
        purpose: _purposeController.text,
        senderName: _senderNameController.text,
        companyName: _companyNameController.text.isNotEmpty ? _companyNameController.text : null,
        companyLogo: _logoFile?.path,
        transactionId: const Uuid().v4(),
        customMessage: _customMessageController.text.isNotEmpty ? _customMessageController.text : null,
        additionalMetadata: {
          'generatedAt': DateTime.now().toIso8601String(),
          'appVersion': '1.0.0',
        },
      );
      setState(() {
        _qrData = qrData.encryptData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Basic Information
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  prefixText: '₹ ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: const InputDecoration(
                  labelText: 'Purpose',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a purpose';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _senderNameController,
                decoration: const InputDecoration(
                  labelText: 'Your Name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Advanced Options Toggle
              ListTile(
                title: const Text('Advanced Options'),
                trailing: Icon(
                  _showAdvancedOptions ? Icons.expand_less : Icons.expand_more,
                ),
                onTap: () {
                  setState(() {
                    _showAdvancedOptions = !_showAdvancedOptions;
                  });
                },
              ),

              // Advanced Options
              if (_showAdvancedOptions) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _companyNameController,
                  decoration: const InputDecoration(
                    labelText: 'Company Name (Optional)',
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Company Logo'),
                  subtitle: _logoFile != null
                      ? Text(_logoFile!.path.split('/').last)
                      : const Text('No logo selected'),
                  trailing: IconButton(
                    icon: const Icon(Icons.add_photo_alternate),
                    onPressed: _pickLogo,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _customMessageController,
                  decoration: const InputDecoration(
                    labelText: 'Custom Message (Optional)',
                  ),
                  maxLines: 2,
                ),
              ],

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _generateQR,
                style: ElevatedButton.styleFrom(
                  backgroundColor: FlutterFlowTheme.of(context).primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Generate QR Code'),
              ),
              if (_qrData != null) ...[
                const SizedBox(height: 32),
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      QrImageView(
                        data: _qrData!,
                        version: QrVersions.auto,
                        size: 200.0,
                        backgroundColor: Colors.white,
                        embeddedImage: _logoFile != null
                            ? FileImage(_logoFile!)
                            : null,
                        embeddedImageStyle: QrEmbeddedImageStyle(
                          size: const Size(40, 40),
                        ),
                      ),
                      if (_logoFile != null)
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              _logoFile!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Share this QR code with others to receive payment',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium,
                ),
                if (_companyNameController.text.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    'From: ${_companyNameController.text}',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).bodyMedium,
                  ),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
} 