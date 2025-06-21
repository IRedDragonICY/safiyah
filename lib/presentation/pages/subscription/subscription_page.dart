import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../routes/route_names.dart';
import '../../../data/models/transaction_model.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key});

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int selectedPlan = 0; // 0 = Pro, 1 = Student

  // Plan details
  final List<Map<String, dynamic>> subscriptionPlans = [
    {
      'id': 'safiyah_pro',
      'name': 'Safiyah Pro',
      'price': 29000,
      'originalPrice': 35000,
      'currency': 'IDR',
      'period': 'monthly',
      'description': 'Full premium experience with all features',
      'discount': 17, // percentage
    },
    {
      'id': 'student_plan',
      'name': 'Student Plan', 
      'price': 15000,
      'originalPrice': 29000,
      'currency': 'IDR',
      'period': 'monthly',
      'description': 'Special discount for students with verification',
      'discount': 48, // percentage
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Subscription'),
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 24),
            _buildBenefitsSection(context),
            const SizedBox(height: 32),
            _buildSubscriptionPlans(context),
            const SizedBox(height: 32),
            _buildCharityInfo(context),
            const SizedBox(height: 24),
            _buildSubscribeButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upgrade to Safiyah Pro',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Unlock premium features with our multimodal AI companion for your travels',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final benefits = [
      {
        'icon': Icons.block,
        'title': 'Ad-Free Experience',
        'description': 'Enjoy uninterrupted usage without any advertisements'
      },
      {
        'icon': Icons.access_time,
        'title': '12-Hour Realtime AI',
        'description': 'Get up to 12 hours of continuous AI assistance'
      },
      {
        'icon': Icons.visibility,
        'title': 'Multimodal AI',
        'description': 'AI that can see, hear, and understand your environment'
      },
      {
        'icon': Icons.navigation,
        'title': 'AR Navigation',
        'description': 'Advanced AR features for travel guidance'
      },
      {
        'icon': Icons.accessibility,
        'title': 'Accessibility Support',
        'description': 'Special features for visually impaired travelers'
      },
      {
        'icon': Icons.favorite,
        'title': 'Sedekah Impact',
        'description': 'Your subscription contributes to charity (sedekah)'
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Benefits',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  benefit['icon'] as IconData,
                  color: Theme.of(context).colorScheme.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      benefit['title'] as String,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      benefit['description'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildSubscriptionPlans(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          context,
          planIndex: 0,
          title: 'Safiyah Pro',
          subtitle: 'Full premium experience',
          price: 'Rp 29.000',
          period: '/month',
          features: [
            'All premium features',
            '12-hour realtime AI',
            'No advertisements',
            'AR navigation',
            'Priority support',
          ],
          isPopular: true,
        ),
        const SizedBox(height: 16),
        _buildPlanCard(
          context,
          planIndex: 1,
          title: 'Student Plan',
          subtitle: 'Special discount for students',
          price: 'Rp 15.000',
          period: '/month',
          features: [
            'All premium features',
            '6-hour realtime AI',
            'No advertisements',
            'AR navigation',
            'Student verification required',
          ],
          isPopular: false,
        ),
      ],
    );
  }

  Widget _buildPlanCard(
    BuildContext context, {
    required int planIndex,
    required String title,
    required String subtitle,
    required String price,
    required String period,
    required List<String> features,
    required bool isPopular,
  }) {
    final isSelected = selectedPlan == planIndex;
    
    return GestureDetector(
      onTap: () => setState(() => selectedPlan = planIndex),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.05)
              : null,
        ),
        child: Stack(
          children: [
            if (isPopular)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      topRight: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Radio<int>(
                        value: planIndex,
                        groupValue: selectedPlan,
                        onChanged: (value) => setState(() => selectedPlan = value!),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              subtitle,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: price,
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            TextSpan(
                              text: period,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: Theme.of(context).colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            feature,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCharityInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: Colors.green[700],
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Contributing to Charity',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Part of your subscription payment will be donated to social activities and charity. By subscribing, you not only get premium features but also earn spiritual rewards.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubscribeButton(BuildContext context) {
    final selectedPlanData = subscriptionPlans[selectedPlan];
    final selectedPlanName = selectedPlanData['name'] as String;
    final selectedPrice = 'Rp ${(selectedPlanData['price'] as int).toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
    
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _navigateToPayment(context, selectedPlanData);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Start 7-Day Free Trial',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Then $selectedPrice/month • Cancel anytime',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        Text(
          'Secure payment • No commitment • Premium features included',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  void _navigateToPayment(BuildContext context, Map<String, dynamic> planData) {
    // Create order details for payment page
    final orderDetails = {
      'type': 'subscription',
      'serviceType': 'subscription',
      'planId': planData['id'],
      'planName': planData['name'],
      'originalAmount': planData['originalPrice'],
      'period': planData['period'],
      'description': planData['description'],
      'discount': planData['discount'],
      'trialDays': 7,
      'isTrialEligible': true,
      'title': 'Subscribe to ${planData['name']}',
      'subtitle': 'Get premium features and support charity',
      'details': {
        'Service': 'Safiyah Premium Subscription',
        'Plan': planData['name'],
        'Billing': 'Monthly subscription',
        'Trial': '7 days free, then IDR ${planData['price']}/month',
        'Features': selectedPlan == 0 ? 
          'All premium features, 12-hour AI, AR navigation, No ads' :
          'All premium features, 6-hour AI, AR navigation, No ads',
      }
    };

    // Navigate using GoRouter with correct parameters
    context.go(
      RouteNames.payment,
      extra: {
        'orderDetails': orderDetails,
        'amount': (planData['price'] as int).toDouble(),
        'currency': planData['currency'] as String,
        'transactionType': TransactionType.other,
      },
    );
  }
} 
