import 'package:flutter/material.dart';

class HelpArticlePage extends StatelessWidget {
  final String articleId;
  
  const HelpArticlePage({
    Key? key,
    required this.articleId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Article'),
      ),
      body: Center(
        child: Text('Article content for: $articleId'),
      ),
    );
  }
} 