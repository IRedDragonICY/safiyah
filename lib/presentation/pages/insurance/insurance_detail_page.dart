import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsuranceDetailPage extends StatelessWidget {
  final String insuranceId;
  
  const InsuranceDetailPage({
    super.key,
    required this.insuranceId,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Travel Insurance Plus'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [colorScheme.primary, colorScheme.primaryContainer],
                  ),
                ),
                child: Icon(
                  Icons.security,
                  size: 100,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildPriceCard(context),
                const SizedBox(height: 16),
                _buildCoverageSection(context),
                const SizedBox(height: 16),
                _buildBenefitsSection(context),
                const SizedBox(height: 16),
                _buildProviderInfo(context),
                const SizedBox(height: 16),
                _buildReviews(context),
                const SizedBox(height: 100),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/insurance/comparison'),
                child: const Text('Compare'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => context.push('/insurance/booking/$insuranceId'),
                child: const Text('Buy Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Most Popular',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 20),
                    const SizedBox(width: 4),
                    const Text('4.8'),
                    const SizedBox(width: 4),
                    Text('(124 reviews)', style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '¥15,000',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            Text(
              'per month',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Complete protection for domestic and international travel',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCoverageSection(BuildContext context) {
    final coverages = [
      {'title': 'Medical Emergency', 'amount': 'Up to ¥10,000,000', 'icon': Icons.medical_services},
      {'title': 'Trip Cancellation', 'amount': 'Up to ¥500,000', 'icon': Icons.flight_takeoff_outlined},
      {'title': 'Baggage Loss', 'amount': 'Up to ¥250,000', 'icon': Icons.luggage},
      {'title': 'Personal Accident', 'amount': 'Up to ¥5,000,000', 'icon': Icons.person},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Insurance Coverage',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...coverages.map((coverage) => ListTile(
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                child: Icon(coverage['icon'] as IconData, color: Theme.of(context).colorScheme.primary),
              ),
              title: Text(coverage['title'] as String),
              subtitle: Text(coverage['amount'] as String),
              dense: true,
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBenefitsSection(BuildContext context) {
    final benefits = [
      'Cashless treatment worldwide',
      '24/7 Emergency assistance',
      'Family coverage included',
      'Pre-existing condition coverage',
      'Adventure sports coverage',
      'COVID-19 protection',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Additional Benefits',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...benefits.map((benefit) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(benefit)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildProviderInfo(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: const Text('JI', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Japan Insurance Co.', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('Licensed Insurance Provider'),
                      Row(
                        children: [
                          const Icon(Icons.verified, color: Colors.green, size: 16),
                          const SizedBox(width: 4),
                          const Text('Verified by FSA', style: TextStyle(fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      const Text('4.8', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Rating', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('50K+', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Customers', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      const Text('99%', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Text('Claim Success', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviews(BuildContext context) {
    final reviews = [
      {'name': 'Takeshi S.', 'rating': 5, 'comment': 'Excellent service, claims processed quickly'},
      {'name': 'Maria R.', 'rating': 5, 'comment': 'Highly recommended for frequent travelers'},
      {'name': 'David P.', 'rating': 4, 'comment': 'Complete coverage at affordable price'},
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Customer Reviews',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...reviews.map((review) => ListTile(
              leading: CircleAvatar(
                child: Text((review['name'] as String)[0]),
              ),
              title: Row(
                children: [
                  Text(review['name'] as String),
                  const Spacer(),
                  Row(
                    children: List.generate(5, (index) => Icon(
                      index < (review['rating'] as int) ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    )),
                  ),
                ],
              ),
              subtitle: Text(review['comment'] as String),
              dense: true,
            )),
          ],
        ),
      ),
    );
  }
} 