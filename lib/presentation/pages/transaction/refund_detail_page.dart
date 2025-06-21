import 'package:flutter/material.dart';

class RefundDetailPage extends StatelessWidget {
  final String transactionId;
  
  const RefundDetailPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Refund Details'),
      ),
      body: Center(
        child: Text('Refund details for transaction: $transactionId'),
      ),
    );
  }
} 