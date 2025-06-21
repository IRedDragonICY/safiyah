import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';

class TransportationGuidePage extends StatelessWidget {
  const TransportationGuidePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transportation Guide'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(context),
            const SizedBox(height: 20),
            _buildHalalTravelSection(context),
            const SizedBox(height: 20),
            _buildPaymentSection(context),
            const SizedBox(height: 20),
            _buildTipsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.directions_transit, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Text(
                'Transportation in Japan',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Japan has one of the world\'s most efficient transportation systems. This guide will help Muslim travelers navigate comfortably.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildHalalTravelSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Halal-Friendly Transportation',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildGuideCard(
          context,
          'Halal Airlines',
          'JAL and ANA offer halal meals on flights. Pre-order when booking.',
          Icons.flight,
          AppColors.success,
        ),
        _buildGuideCard(
          context,
          'Prayer-Friendly Services',
          'Some airlines provide prayer time notifications and Qibla direction.',
          Icons.schedule,
          AppColors.primary,
        ),
        _buildGuideCard(
          context,
          'Clean Transportation',
          'Japanese public transport is very clean and well-maintained.',
          Icons.verified,
          AppColors.info,
        ),
      ],
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Methods',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildGuideCard(
          context,
          'NFC Payment',
          'Use your phone for quick payments on trains and buses.',
          Icons.nfc,
          AppColors.info,
        ),
        _buildGuideCard(
          context,
          'IC Cards',
          'Get a Suica or Pasmo card for easy travel on all public transport.',
          Icons.credit_card,
          AppColors.primary,
        ),
        _buildGuideCard(
          context,
          'QR Codes',
          'PayPay, Line Pay, and other QR payment apps are widely accepted.',
          Icons.qr_code,
          AppColors.success,
        ),
      ],
    );
  }

  Widget _buildTipsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Essential Tips',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        _buildTipCard(context, 'Punctuality', 'Trains are extremely punctual. Arrive 5 minutes early.'),
        _buildTipCard(context, 'Quiet Zones', 'Keep conversations low and avoid phone calls on trains.'),
        _buildTipCard(context, 'Rush Hours', 'Avoid 7:30-9:30 AM and 5:30-7:30 PM for comfort.'),
        _buildTipCard(context, 'Priority Seats', 'Give up seats for elderly, pregnant, and disabled passengers.'),
        _buildTipCard(context, 'Luggage', 'Use delivery services for large bags on trains.'),
      ],
    );
  }

  Widget _buildGuideCard(BuildContext context, String title, String description, IconData icon, Color color) {
    return Card(
      elevation: AppConstants.cardElevation,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, String title, String description) {
    return Card(
      elevation: AppConstants.cardElevation,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.secondary,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: '$title: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: description),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 