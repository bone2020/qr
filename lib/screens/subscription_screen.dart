import 'package:flutter/material.dart';
import '../services/subscription_service.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final _subscriptionService = SubscriptionService();
  Map<String, dynamic>? _feeDetails;
  List<Map<String, dynamic>> _feeHistory = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFeeDetails();
  }

  Future<void> _loadFeeDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final feeDetails = await _subscriptionService.getTransactionFeeDetails();
      final feeHistory = await _subscriptionService.getTransactionFeeHistory();
      
      setState(() {
        _feeDetails = feeDetails;
        _feeHistory = feeHistory;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading fee details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Fees'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Transaction Fee Structure',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '• ${_feeDetails?['percentage']}% per transaction\n'
                      '• Minimum fee: GHS ${_feeDetails?['min_fee']}\n'
                      '• Maximum fee: GHS ${_feeDetails?['max_fee']}\n'
                      '• Currency: ${_feeDetails?['currency']}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Recent Transaction Fees',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            if (_feeHistory.isEmpty)
              const Center(
                child: Text('No transaction fees recorded yet'),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _feeHistory.length,
                itemBuilder: (context, index) {
                  final fee = _feeHistory[index];
                  return Card(
                    child: ListTile(
                      title: Text('Amount: GHS ${fee['amount']}'),
                      subtitle: Text('Fee: GHS ${fee['fee']}'),
                      trailing: Text(
                        DateTime.parse(fee['timestamp']).toString().split('.')[0],
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
} 