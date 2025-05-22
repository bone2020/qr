import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/payment_provider.dart';
import '../services/payment_service.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import 'package:go_router/go_router.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({Key? key}) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _formKey = GlobalKey<FormState>();
  
  // Form controllers
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  // Bank transfer controllers
  final _accountNumberController = TextEditingController();
  final _bankCodeController = TextEditingController();
  
  // Mobile money controllers
  final _phoneNumberController = TextEditingController();
  String? _selectedProvider;
  
  // Payment gateway controllers
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _initializePaymentMethods();
  }

  Future<void> _initializePaymentMethods() async {
    final paymentProvider = Provider.of<PaymentProvider>(context, listen: false);
    await paymentProvider.initializePaymentMethods();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    _accountNumberController.dispose();
    _bankCodeController.dispose();
    _phoneNumberController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payments'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              context.go('/transaction-history');
            },
            tooltip: 'Transaction History',
          ),
        ],
      ),
      body: Consumer<PaymentProvider>(
        builder: (context, paymentProvider, child) {
          if (paymentProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (paymentProvider.errorMessage != null) {
            return Center(
              child: Text(
                paymentProvider.errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildBankTransferForm(paymentProvider),
              _buildMobileMoneyForm(paymentProvider),
              _buildCardPaymentForm(paymentProvider),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBankTransferForm(PaymentProvider paymentProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Bank',
                border: OutlineInputBorder(),
              ),
              items: paymentProvider.availableBanks.map((bank) {
                return DropdownMenuItem<String>(
                  value: bank['code'] as String,
                  child: Text(bank['name'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _bankCodeController.text = value ?? '';
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a bank';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _accountNumberController,
              decoration: const InputDecoration(
                labelText: 'Account Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter account number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final success = await paymentProvider.initiateBankTransfer(
                    accountNumber: _accountNumberController.text,
                    bankCode: _bankCodeController.text,
                    amount: double.parse(_amountController.text),
                    description: _descriptionController.text,
                  );
                  
                  if (success) {
                    _showSuccessDialog();
                  }
                }
              },
              child: const Text('Transfer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileMoneyForm(PaymentProvider paymentProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Select Provider',
                border: OutlineInputBorder(),
              ),
              items: paymentProvider.mobileMoneyProviders.map((provider) {
                return DropdownMenuItem<String>(
                  value: provider['code'] as String,
                  child: Text(provider['name'] as String),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedProvider = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a provider';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final success = await paymentProvider.initiateMobileMoneyPayment(
                    phoneNumber: _phoneNumberController.text,
                    provider: _selectedProvider!,
                    amount: double.parse(_amountController.text),
                    description: _descriptionController.text,
                  );
                  
                  if (success) {
                    _showSuccessDialog();
                  }
                }
              },
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardPaymentForm(PaymentProvider paymentProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAmountField(),
            const SizedBox(height: 16),
            _buildDescriptionField(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNumberController,
              decoration: const InputDecoration(
                labelText: 'Card Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryDateController,
                    decoration: const InputDecoration(
                      labelText: 'Expiry Date (MM/YY)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    decoration: const InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final success = await paymentProvider.initiatePaymentGateway(
                    cardNumber: _cardNumberController.text,
                    expiryDate: _expiryDateController.text,
                    cvv: _cvvController.text,
                    amount: double.parse(_amountController.text),
                    description: _descriptionController.text,
                  );
                  
                  if (success) {
                    _showSuccessDialog();
                  }
                }
              },
              child: const Text('Pay'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmountField() {
    return TextFormField(
      controller: _amountController,
      decoration: const InputDecoration(
        labelText: 'Amount',
        border: OutlineInputBorder(),
        prefixText: '\$',
      ),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter amount';
        }
        if (double.tryParse(value) == null) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'Description',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter description';
        }
        return null;
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Payment initiated successfully'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
} 