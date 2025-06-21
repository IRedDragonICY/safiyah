import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/currency_service.dart';

class HajjUmrohPage extends StatefulWidget {
  const HajjUmrohPage({super.key});

  @override
  State<HajjUmrohPage> createState() => _HajjUmrohPageState();
}

class _HajjUmrohPageState extends State<HajjUmrohPage> with TickerProviderStateMixin {
  late TabController _tabController;
  
  // Calculator state
  String? _selectedPackage;
  int _pilgrimCount = 1;
  Map<String, double> _packagePrices = {
    'Regular Hajj': 43333, // ~$43,333 USD base
    'Hajj Plus': 56667, // ~$56,667 USD base
    '9-Day Umroh': 14667, // ~$14,667 USD base
    '12-Day Umroh': 18667, // ~$18,667 USD base
  };
  
  // Filter state
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: const Text('Hajj & Umroh'),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: colorScheme.primary,
          unselectedLabelColor: colorScheme.onSurfaceVariant,
          indicatorColor: colorScheme.primary,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Packages'),
            Tab(text: 'Guide'),
            Tab(text: 'Calculator'),
            Tab(text: 'My Bookings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPackagesTab(),
          _buildGuideTab(),
          _buildCalculatorTab(),
          _buildMyBookingsTab(),
        ],
      ),
    );
  }

  Widget _buildPackagesTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Available Packages',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.verified, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 4),
                          Text(
                            'Certified',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildPackageFilter(),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final filteredPackages = _getFilteredPackages();
                if (index >= filteredPackages.length) return const SizedBox.shrink();
                return _buildPackageCard(filteredPackages[index]);
              },
              childCount: _getFilteredPackages().length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideTab() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Complete Guide',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'Everything you need to know for a successful pilgrimage',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildGuideSection('Pre-Journey Preparation', Icons.checklist_rtl, [
              'Required Documents',
              'Health Conditions',
              'Mental & Spiritual Preparation',
              'Hajj/Umroh Equipment',
            ], Colors.blue),
            _buildGuideSection('Religious Guidance', Icons.menu_book_outlined, [
              'Pillars of Hajj',
              'Pillars of Umroh',
              'Sunnah of Hajj',
              'Prohibitions in Ihram',
            ], Colors.green),
            _buildGuideSection('Prayers & Supplications', Icons.auto_stories_outlined, [
              'Ihram Prayers',
              'Tawaf Prayers',
              'Sa\'i Prayers',
              'Wuquf Prayers',
            ], Colors.purple),
          ]),
        ),
      ],
    );
  }

  Widget _buildCalculatorTab() {
    final calculatedTotal = _calculateTotal();
    
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.calculate,
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cost Calculator',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Calculate your pilgrimage costs',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Package Selection',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          value: _selectedPackage,
                          decoration: InputDecoration(
                            labelText: 'Choose your package',
                            prefixIcon: Icon(
                              _selectedPackage?.contains('Hajj') == true ? Icons.mosque : Icons.location_city,
                            ),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          items: ['Regular Hajj', 'Hajj Plus', '9-Day Umroh', '12-Day Umroh']
                              .map((item) => DropdownMenuItem(
                                    value: item,
                                    child: Row(
                                      children: [
                                        Icon(
                                          item.contains('Hajj') ? Icons.mosque : Icons.location_city,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(item),
                                      ],
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPackage = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Number of Pilgrims',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(Icons.people, color: Theme.of(context).colorScheme.primary),
                                    const SizedBox(width: 8),
                                    Text(
                                      '$_pilgrimCount ${_pilgrimCount == 1 ? 'Pilgrim' : 'Pilgrims'}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Theme.of(context).colorScheme.outline),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    onPressed: _pilgrimCount > 1 ? () {
                                      setState(() {
                                        _pilgrimCount--;
                                      });
                                    } : null,
                                    icon: const Icon(Icons.remove),
                                  ),
                                  Container(
                                    constraints: const BoxConstraints(minWidth: 40),
                                    child: Text(
                                      '$_pilgrimCount',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _pilgrimCount++;
                                      });
                                    },
                                    icon: const Icon(Icons.add),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_selectedPackage != null) ...[
                  Card(
                    elevation: 0,
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Cost Breakdown',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ListenableBuilder(
                            listenable: CurrencyService(),
                            builder: (context, child) {
                              final currencyService = CurrencyService();
                              final packageCost = _packagePrices[_selectedPackage!]! * _pilgrimCount;
                              final visaCost = 1667.0 * _pilgrimCount; // ~$1,667 USD base
                              final insuranceCost = 333.0 * _pilgrimCount; // ~$333 USD base
                              final total = packageCost + visaCost + insuranceCost;

                              return Column(
                                children: [
                                  _buildCostItem('Package Cost ($_selectedPackage)', currencyService.formatAmount(packageCost)),
                                  _buildCostItem('Visa & Documents', currencyService.formatAmount(visaCost)),
                                  _buildCostItem('Insurance', currencyService.formatAmount(insuranceCost)),
                                  const Divider(height: 24),
                                  _buildCostItem('Total Estimated Cost', currencyService.formatAmount(total), isTotal: true),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ] else ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.calculate_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Select a package to see cost breakdown',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  double _calculateTotal() {
    if (_selectedPackage == null) return 0;
    final packageCost = _packagePrices[_selectedPackage!]! * _pilgrimCount;
    final visaCost = 1667.0 * _pilgrimCount; // ~$1,667 USD base
    final insuranceCost = 333.0 * _pilgrimCount; // ~$333 USD base
    return packageCost + visaCost + insuranceCost;
  }

  Widget _buildMyBookingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(2, (index) => _buildBookingCard(index)),
    );
  }



  Widget _buildPackageFilter() {
    final filters = ['All', 'Hajj', 'Umroh'];
    final filterCounts = {
      'All': _getAllPackages().length,
      'Hajj': _getAllPackages().where((p) => p['type'] == 'Hajj').length,
      'Umroh': _getAllPackages().where((p) => p['type'] == 'Umroh').length,
    };

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    filter,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Theme.of(context).colorScheme.onPrimary.withValues(alpha: 0.9)
                          : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${filterCounts[filter]}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ],
              ),
              selected: isSelected,
              onSelected: (value) {
                setState(() {
                  _selectedFilter = filter;
                });
              },
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Map<String, dynamic>> _getAllPackages() {
    return [
      {
        'id': 0,
        'title': 'Regular Hajj Package 2025',
        'type': 'Hajj',
        'usdPrice': 43333.0, // ~$43,333 USD base
        'duration': '40 Days',
        'departure': 'June 15, 2025',
        'hotel': '4-Star Hotel',
        'distance': '500m from Masjidil Haram',
        'provider': 'Al-Hijrah Tours',
        'rating': 4.8,
        'certified': true,
      },
      {
        'id': 1,
        'title': 'Premium Umroh Package',
        'type': 'Umroh',
        'usdPrice': 16667.0, // ~$16,667 USD base
        'duration': '12 Days',
        'departure': 'December 20, 2024',
        'hotel': '5-Star Hotel',
        'distance': '200m from Masjidil Haram',
        'provider': 'Baitul Haram Travel',
        'rating': 4.9,
        'certified': true,
      },
      {
        'id': 2,
        'title': 'Hajj Plus Package 2025',
        'type': 'Hajj',
        'usdPrice': 56667.0, // ~$56,667 USD base
        'duration': '45 Days',
        'departure': 'May 20, 2025',
        'hotel': '5-Star Hotel',
        'distance': '100m from Masjidil Haram',
        'provider': 'Al-Hijrah Tours',
        'rating': 4.9,
        'certified': true,
      },
      {
        'id': 3,
        'title': '9-Day Umroh Package',
        'type': 'Umroh',
        'usdPrice': 14667.0, // ~$14,667 USD base
        'duration': '9 Days',
        'departure': 'January 10, 2025',
        'hotel': '4-Star Hotel',
        'distance': '300m from Masjidil Haram',
        'provider': 'Baitul Haram Travel',
        'rating': 4.7,
        'certified': true,
      },
    ];
  }

  List<Map<String, dynamic>> _getFilteredPackages() {
    final allPackages = _getAllPackages();
    if (_selectedFilter == 'All') {
      return allPackages;
    }
    return allPackages.where((package) => package['type'] == _selectedFilter).toList();
  }

  Widget _buildPackageCard(Map<String, dynamic> package) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isHajj = package['type'] == 'Hajj';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/hajj-umroh/detail/${package['id']}'),
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
                      color: isHajj ? colorScheme.primary : Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      package['type'] as String,
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Spacer(),
                  if (package['certified'] as bool)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified, color: Colors.green, size: 14),
                          const SizedBox(width: 4),
                          const Text('Certified', style: TextStyle(color: Colors.green, fontSize: 10)),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                package['title'] as String,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                package['provider'] as String,
                style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(package['duration'] as String, style: theme.textTheme.bodySmall),
                  const SizedBox(width: 16),
                  Icon(Icons.flight_takeoff, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(package['departure'] as String, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.hotel, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(package['hotel'] as String, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(package['distance'] as String, style: theme.textTheme.bodySmall),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListenableBuilder(
                        listenable: CurrencyService(),
                        builder: (context, child) {
                          final currencyService = CurrencyService();
                          return Text(
                            currencyService.formatAmount(package['usdPrice'] as double),
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          );
                        },
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text('${package['rating']}', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    children: [
                      FilledButton(
                        onPressed: () => context.push('/hajj-umroh/booking/${package['id']}'),
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () => context.push('/hajj-umroh/detail/${package['id']}'),
                        child: const Text('View Details'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGuideSection(String title, IconData icon, List<String> items, Color accentColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
      child: Card(
        elevation: 2,
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          childrenPadding: const EdgeInsets.only(bottom: 8),
          title: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  accentColor.withValues(alpha: 0.1),
                  accentColor.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: accentColor, size: 24),
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
                          color: accentColor,
                        ),
                      ),
                      Text(
                        '${items.length} topics',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          children: items.map((item) => ListTile(
            dense: true,
            leading: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(Icons.menu_book, size: 16, color: accentColor),
            ),
            title: Text(
              item,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant),
            onTap: () => context.push('/hajj-umroh/guide/$item'),
          )).toList(),
        ),
      ),
    );
  }

  Widget _buildCostItem(String title, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          const Spacer(),
          Text(
            amount,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Theme.of(context).colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(int index) {
    final bookings = [
      {
        'title': 'Premium Umroh Package',
        'bookingId': 'UP-2024-001',
        'date': 'December 20, 2024',
        'status': 'Confirmed',
        'participants': 2,
        'usdAmount': 33333.0, // ~$33,333 USD base
      },
      {
        'title': 'Regular Hajj Package 2025',
        'bookingId': 'HR-2025-002',
        'date': 'June 15, 2025',
        'status': 'Pending',
        'participants': 1,
        'usdAmount': 43333.0, // ~$43,333 USD base
      },
    ];

    final booking = bookings[index];
    final statusColor = booking['status'] == 'Confirmed' ? Colors.green : Colors.orange;

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
                  child: Text(
                    booking['title'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking['status'] as String,
                    style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('Booking ID: ${booking['bookingId']}', style: const TextStyle(fontSize: 12)),
            Text('Departure: ${booking['date']}', style: const TextStyle(fontSize: 12)),
            Text('Pilgrims: ${booking['participants']} person(s)', style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 12),
            Row(
              children: [
                ListenableBuilder(
                  listenable: CurrencyService(),
                  builder: (context, child) {
                    final currencyService = CurrencyService();
                    return Text(
                      currencyService.formatAmount(booking['usdAmount'] as double),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    );
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => context.push('/hajj-umroh/booking-detail/$index'),
                  child: const Text('Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 