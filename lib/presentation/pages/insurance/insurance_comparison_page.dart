import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsuranceComparisonPage extends StatefulWidget {
  const InsuranceComparisonPage({super.key});

  @override
  State<InsuranceComparisonPage> createState() => _InsuranceComparisonPageState();
}

class _InsuranceComparisonPageState extends State<InsuranceComparisonPage> {
  List<String> _selectedInsuranceIds = [];
  final int _maxComparisons = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Insurance Comparison'),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            onPressed: _selectedInsuranceIds.isNotEmpty ? _clearComparison : null,
            icon: const Icon(Icons.clear_all),
            tooltip: 'Clear All',
          ),
        ],
      ),
      body: Column(
        children: [
          if (_selectedInsuranceIds.isEmpty) _buildSelectionHeader(),
          if (_selectedInsuranceIds.isNotEmpty) _buildComparisonHeader(),
          Expanded(
            child: _selectedInsuranceIds.isEmpty
                ? _buildInsuranceSelection()
                : _buildComparisonView(),
          ),
        ],
      ),
      floatingActionButton: _selectedInsuranceIds.length >= 2
          ? FloatingActionButton.extended(
              onPressed: _generateReport,
              icon: const Icon(Icons.description),
              label: const Text('Generate Report'),
            )
          : null,
    );
  }

  Widget _buildSelectionHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Column(
        children: [
          Icon(
            Icons.compare_arrows,
            size: 48,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
          const SizedBox(height: 8),
          Text(
            'Select Insurance Products to Compare',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Choose 2-3 insurance products to compare features, prices, and benefits',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Row(
        children: [
          Icon(
            Icons.analytics,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Comparing ${_selectedInsuranceIds.length} Products',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSecondaryContainer,
              ),
            ),
          ),
          if (_selectedInsuranceIds.length < _maxComparisons)
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _selectedInsuranceIds.clear();
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add More'),
            ),
        ],
      ),
    );
  }

  Widget _buildInsuranceSelection() {
    final insuranceProducts = [
      {
        'id': '1',
        'name': 'Travel Insurance Plus',
        'type': 'Travel Insurance',
        'price': '¥15,000',
        'rating': 4.8,
        'icon': Icons.flight_takeoff,
      },
      {
        'id': '2',
        'name': 'Health Care Premium',
        'type': 'Health Insurance',
        'price': '¥50,000',
        'rating': 4.9,
        'icon': Icons.health_and_safety,
      },
      {
        'id': '3',
        'name': 'Vehicle Protection',
        'type': 'Vehicle Insurance',
        'price': '¥30,000',
        'rating': 4.7,
        'icon': Icons.directions_car,
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: insuranceProducts.length,
      itemBuilder: (context, index) {
        final product = insuranceProducts[index];
        final isSelected = _selectedInsuranceIds.contains(product['id']);
        final canSelect = _selectedInsuranceIds.length < _maxComparisons;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                product['icon'] as IconData,
                color: isSelected
                    ? Colors.white
                    : Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            title: Text(
              product['name'] as String,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product['type'] as String),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      product['price'] as String,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 2),
                        Text('${product['rating']}'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            trailing: isSelected
                ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary)
                : canSelect
                    ? const Icon(Icons.add_circle_outline)
                    : Icon(Icons.block, color: Theme.of(context).colorScheme.outline),
            onTap: () {
              if (isSelected) {
                setState(() {
                  _selectedInsuranceIds.remove(product['id']);
                });
              } else if (canSelect) {
                setState(() {
                  _selectedInsuranceIds.add(product['id'] as String);
                });
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildComparisonView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Price Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  Row(
                    children: _selectedInsuranceIds.map((id) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text('Product $id', style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Text('¥${int.parse(id) * 15},000', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Feature Comparison', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  const Text('All selected products include comprehensive coverage and 24/7 support.'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _clearComparison() {
    setState(() {
      _selectedInsuranceIds.clear();
    });
  }

  void _generateReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Comparison report generated successfully!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
} 