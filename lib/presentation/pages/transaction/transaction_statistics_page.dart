import 'package:flutter/material.dart';

class TransactionStatisticsPage extends StatelessWidget {
  const TransactionStatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Statistics'),
      ),
      body: const Center(
        child: Text('Transaction statistics will be displayed here'),
      ),
    );
  }
} 