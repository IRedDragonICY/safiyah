import 'package:flutter/material.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms of Service'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to Safiyah – Muslim Traveler!',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'These Terms of Service ("Terms") govern your use of our mobile application. By accessing or using Safiyah, you agree to be bound by these Terms. If you do not agree to these Terms, please do not use our application.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                Text(
                  '1. Use of the Application',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Safiyah grants you a limited, non-exclusive, non-transferable, and revocable license to use the application for personal and non-commercial purposes in accordance with these Terms.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '2. User Accounts',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'You are responsible for maintaining the confidentiality of your account credentials and for all activities that occur under your account.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '3. Intellectual Property',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'All content, trademarks, service marks, and logos are owned by Safiyah or its licensors and are protected by applicable intellectual property laws.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '4. Termination',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'We may suspend or terminate your access to the application at any time, without prior notice or liability, for any reason whatsoever, including breach of these Terms.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '5. Disclaimer',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'Safiyah is provided on an "AS IS" and "AS AVAILABLE" basis. We make no warranties, expressed or implied, regarding the reliability or availability of the application.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Text(
                  '6. Changes to Terms',
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Text(
                  'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. Continued use of the application constitutes acceptance of the new Terms.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),
                Center(
                  child: FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('I Understand'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 
