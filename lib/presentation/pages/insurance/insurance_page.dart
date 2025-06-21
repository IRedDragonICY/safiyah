import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsurancePage extends StatefulWidget {
  const InsurancePage({super.key});

  @override
  State<InsurancePage> createState() => _InsurancePageState();
}

class _InsurancePageState extends State<InsurancePage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Insurance'),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () => context.push('/insurance/comparison'),
            icon: const Icon(Icons.compare_arrows),
            tooltip: 'Compare Products',
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          tabs: const [
            Tab(text: 'Products'),
            Tab(text: 'My Claims'),
            Tab(text: 'Active Policies'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProductsTab(),
          _buildClaimsTab(),
          _buildActivePoliciesTab(),
        ],
      ),
    );
  }

  Widget _buildProductsTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildQuickStats(),
                const SizedBox(height: 24),
                Text(
                  'Insurance Products',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.85,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildInsuranceCard(index),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildClaimsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.assignment_outlined, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    const Text('Recent Claims', style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add),
                  label: const Text('Create New Claim'),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...List.generate(3, (index) => _buildClaimCard(index)),
      ],
    );
  }

  Widget _buildActivePoliciesTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(3, (index) => _buildActivePolicyCard(index)),
    );
  }

  Widget _buildQuickStats() {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(child: _buildStatCard(Icons.shield_outlined, 'Active Policies', '3', colorScheme.primary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.assignment_outlined, 'Processing Claims', '1', colorScheme.secondary)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatCard(Icons.check_circle_outline, 'Completed Claims', '5', colorScheme.tertiary)),
      ],
    );
  }

  Widget _buildStatCard(IconData icon, String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            Text(title, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildInsuranceCard(int index) {
    final products = [
      {'title': 'Travel Insurance', 'price': '¥15,000', 'icon': Icons.flight_takeoff, 'rating': '4.8'},
      {'title': 'Health Insurance', 'price': '¥50,000', 'icon': Icons.health_and_safety, 'rating': '4.9'},
      {'title': 'Vehicle Insurance', 'price': '¥30,000', 'icon': Icons.directions_car, 'rating': '4.7'},
      {'title': 'Home Insurance', 'price': '¥20,000', 'icon': Icons.home, 'rating': '4.6'},
      {'title': 'Life Insurance', 'price': '¥10,000', 'icon': Icons.favorite, 'rating': '4.8'},
      {'title': 'Business Insurance', 'price': '¥75,000', 'icon': Icons.business, 'rating': '4.5'},
    ];

    final product = products[index];
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      child: InkWell(
        onTap: () => context.push('/insurance/detail/$index'),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(product['icon'] as IconData, color: colorScheme.primary),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(product['rating'] as String, style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                product['title'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                product['price'] as String,
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Comprehensive protection', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClaimCard(int index) {
    final claims = [
      {'title': 'Travel Insurance Claim', 'id': 'TIC-001', 'status': 'Processing', 'amount': '¥250,000'},
      {'title': 'Health Insurance Claim', 'id': 'HIC-002', 'status': 'Completed', 'amount': '¥150,000'},
      {'title': 'Vehicle Insurance Claim', 'id': 'VIC-003', 'status': 'Rejected', 'amount': '¥300,000'},
    ];

    final claim = claims[index];
    final statusColor = claim['status'] == 'Completed' ? Colors.green : 
                       claim['status'] == 'Processing' ? Colors.orange : Colors.red;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.1),
          child: Icon(Icons.assignment, color: statusColor, size: 20),
        ),
        title: Text(claim['title'] as String),
        subtitle: Text('ID: ${claim['id']}'),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(claim['amount'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(claim['status'] as String, style: TextStyle(color: statusColor, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivePolicyCard(int index) {
    final policies = [
      {'title': 'Travel Insurance Plus', 'number': 'TIP-12345', 'expiry': 'May 15, 2025', 'premium': '¥15,000/month'},
      {'title': 'Health Care Premium', 'number': 'HCP-67890', 'expiry': 'June 10, 2025', 'premium': '¥50,000/month'},
      {'title': 'Vehicle Protection', 'number': 'VP-11111', 'expiry': 'July 20, 2025', 'premium': '¥30,000/month'},
    ];

    final policy = policies[index];

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(policy['title'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('No. ${policy['number']}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text('Active', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Expires', style: TextStyle(fontSize: 12)),
                      Text(policy['expiry'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Premium', style: TextStyle(fontSize: 12)),
                      Text(policy['premium'] as String, style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Details'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: () {}, child: const Text('Renew'))),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 