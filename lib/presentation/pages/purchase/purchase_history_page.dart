import 'package:flutter/material.dart';

class PurchaseHistoryPage extends StatelessWidget {
  const PurchaseHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Purchase History'),
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          bottom: TabBar(
            isScrollable: true,
            tabs: const [
              Tab(text: 'All'),
              Tab(text: 'Hotels'),
              Tab(text: 'Packages'),
              Tab(text: 'Flights'),
            ],
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.onSurfaceVariant,
            indicatorColor: theme.colorScheme.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildPurchaseList(context, 'all'),
            _buildPurchaseList(context, 'hotel'),
            _buildPurchaseList(context, 'package'),
            _buildPurchaseList(context, 'flight'),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseList(BuildContext context, String category) {
    final theme = Theme.of(context);
    
    // Mock data based on category
    final purchases = _getMockPurchases(category);
    
    if (purchases.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64,
              color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No purchases yet',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your purchase history will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.7),
              ),
            ),
          ],
        ),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: purchases.length,
      itemBuilder: (context, index) {
        final purchase = purchases[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              // Navigate to purchase detail
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: _getIconColor(purchase['type'], theme).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          _getIcon(purchase['type']),
                          color: _getIconColor(purchase['type'], theme),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              purchase['name'],
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              purchase['type'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${purchase['amount']}',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(purchase['status']).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              purchase['status'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: _getStatusColor(purchase['status']),
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            purchase['date'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      if (purchase['reference'] != null)
                        Row(
                          children: [
                            Icon(
                              Icons.confirmation_number,
                              size: 16,
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              purchase['reference'],
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  if (purchase['status'] == 'Active') ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              // View details
                            },
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Details'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () {
                              // Use/Redeem
                            },
                            icon: const Icon(Icons.qr_code),
                            label: const Text('Use'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<Map<String, dynamic>> _getMockPurchases(String category) {
    final allPurchases = [
      {
        'name': 'Hilton Makkah Convention Hotel',
        'type': 'Hotel Booking',
        'amount': 2500,
        'status': 'Completed',
        'date': '15 Jan 2024',
        'reference': 'HTL-2024-001',
      },
      {
        'name': 'Premium Hajj Package 2024',
        'type': 'Hajj Package',
        'amount': 15000,
        'status': 'Active',
        'date': '10 Jan 2024',
        'reference': 'HAJ-2024-042',
      },
      {
        'name': 'Kuala Lumpur - Jeddah Return',
        'type': 'Flight',
        'amount': 3200,
        'status': 'Completed',
        'date': '5 Jan 2024',
        'reference': 'FLT-2024-789',
      },
      {
        'name': 'Madina Hilton Hotel',
        'type': 'Hotel Booking',
        'amount': 1800,
        'status': 'Upcoming',
        'date': '28 Dec 2023',
        'reference': 'HTL-2023-445',
      },
      {
        'name': 'Economy Umrah Package',
        'type': 'Umrah Package',
        'amount': 5500,
        'status': 'Completed',
        'date': '15 Dec 2023',
        'reference': 'UMR-2023-123',
      },
    ];
    
    if (category == 'all') return allPurchases;
    
    final typeMap = {
      'hotel': 'Hotel Booking',
      'package': 'Package',
      'flight': 'Flight',
    };
    
    return allPurchases.where((p) {
      final type = p['type'] as String;
      return type.toLowerCase().contains(typeMap[category] ?? category);
    }).toList();
  }

  IconData _getIcon(String type) {
    switch (type) {
      case 'Hotel Booking':
        return Icons.hotel;
      case 'Hajj Package':
      case 'Umrah Package':
        return Icons.mosque;
      case 'Flight':
        return Icons.flight;
      default:
        return Icons.receipt;
    }
  }

  Color _getIconColor(String type, ThemeData theme) {
    switch (type) {
      case 'Hotel Booking':
        return Colors.blue;
      case 'Hajj Package':
      case 'Umrah Package':
        return Colors.green;
      case 'Flight':
        return Colors.orange;
      default:
        return theme.colorScheme.primary;
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Active':
        return Colors.blue;
      case 'Upcoming':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
} 