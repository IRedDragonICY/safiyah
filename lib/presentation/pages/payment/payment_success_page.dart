import 'package:flutter/material.dart';
import '../../../data/models/transaction_model.dart';

class PaymentSuccessPage extends StatelessWidget {
  final String? transactionId;
  final double? amount;
  final PaymentMethod? paymentMethod;
  final Map<String, dynamic>? orderDetails;
  
  const PaymentSuccessPage({
    Key? key,
    this.transactionId,
    this.amount,
    this.paymentMethod,
    this.orderDetails,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Success'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 100,
            ),
            const SizedBox(height: 20),
            const Text(
              'Payment Successful!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (transactionId != null) ...[
              const SizedBox(height: 10),
              Text(
                'Transaction ID: $transactionId',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
} 