import 'package:flutter/material.dart';
import '../models/transaction.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  Future<void> initialize() async {
    // Initialize notification settings
    // This will be implemented when flutter_local_notifications is properly set up
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    // Show notification using SnackBar for now
    debugPrint('Notification: $title - $body');
  }

  Future<void> showScheduledNotification({
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? payload,
  }) async {
    // Show scheduled notification using SnackBar for now
    debugPrint('Scheduled Notification: $title - $body at ${scheduledDate.toString()}');
  }

  Future<void> showPaymentNotification({
    required Transaction transaction,
    required String title,
    required String body,
  }) async {
    debugPrint('Payment Notification: $title - $body');
  }

  Future<void> showPaymentSuccessNotification(Transaction transaction) async {
    await showPaymentNotification(
      transaction: transaction,
      title: 'Payment Successful',
      body: 'Your payment of GHS ${transaction.amount} has been processed successfully.',
    );
  }

  Future<void> showPaymentFailedNotification(Transaction transaction) async {
    await showPaymentNotification(
      transaction: transaction,
      title: 'Payment Failed',
      body: 'Your payment of GHS ${transaction.amount} has failed. ${transaction.errorMessage ?? ''}',
    );
  }

  Future<void> showPaymentProcessingNotification(Transaction transaction) async {
    await showPaymentNotification(
      transaction: transaction,
      title: 'Payment Processing',
      body: 'Your payment of GHS ${transaction.amount} is being processed.',
    );
  }
} 