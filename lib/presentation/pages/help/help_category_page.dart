import 'package:flutter/material.dart';

class HelpCategoryPage extends StatelessWidget {
  final String categoryId;
  
  const HelpCategoryPage({
    Key? key,
    required this.categoryId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Category'),
      ),
      body: Center(
        child: Text('Help articles for category: $categoryId'),
      ),
    );
  }
} 