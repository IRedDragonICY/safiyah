import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HajjUmrohPage extends StatefulWidget {
  const HajjUmrohPage({super.key});

  @override
  State<HajjUmrohPage> createState() => _HajjUmrohPageState();
}

class _HajjUmrohPageState extends State<HajjUmrohPage> with TickerProviderStateMixin {
  late TabController _tabController;

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
                _buildQuickActions(),
                const SizedBox(height: 16),
                _buildPackageFilter(),
                const SizedBox(height: 16),
                Text(
                  'Trusted Packages',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPackageCard(index),
              childCount: 6,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGuideTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildGuideSection('Preparation', Icons.checklist, [
          'Required Documents',
          'Health Conditions',
          'Mental & Spiritual Preparation',
          'Hajj/Umroh Equipment',
        ]),
        _buildGuideSection('Pillars & Sunnah', Icons.book, [
          'Pillars of Hajj',
          'Pillars of Umroh',
          'Sunnah of Hajj',
          'Prohibitions in Ihram',
        ]),
        _buildGuideSection('Prayers & Dhikr', Icons.menu_book, [
          'Ihram Prayers',
          'Tawaf Prayers',
          'Sa\'i Prayers',
          'Wuquf Prayers',
        ]),
      ],
    );
  }

  Widget _buildCalculatorTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hajj/Umroh Cost Calculator',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(labelText: 'Select Package'),
                    items: ['Regular Hajj', 'Hajj Plus', '9-Day Umroh', '12-Day Umroh']
                        .map((item) => DropdownMenuItem(value: item, child: Text(item)))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Number of Pilgrims'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {},
                    child: const Text('Calculate Cost'),
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
                  Text(
                    'Cost Estimation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildCostItem('Basic Package', '¥3,500,000'),
                  _buildCostItem('Visa & Documents', '¥250,000'),
                  _buildCostItem('Insurance', '¥50,000'),
                  const Divider(),
                  _buildCostItem('Total', '¥3,800,000', isTotal: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyBookingsTab() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: List.generate(2, (index) => _buildBookingCard(index)),
    );
  }

  Widget _buildQuickActions() {
    final actions = [
      {'title': 'Hajj', 'icon': Icons.mosque, 'color': Theme.of(context).colorScheme.primary},
      {'title': 'Umroh', 'icon': Icons.location_city, 'color': Theme.of(context).colorScheme.secondary},
      {'title': 'Guide', 'icon': Icons.book, 'color': Theme.of(context).colorScheme.tertiary},
      {'title': 'Calculator', 'icon': Icons.calculate, 'color': Theme.of(context).colorScheme.primary},
    ];

    return Row(
      children: actions.map((action) => Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          child: Card(
            child: InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(action['icon'] as IconData, color: action['color'] as Color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      action['title'] as String,
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildPackageFilter() {
    return Row(
      children: [
        Expanded(
          child: FilterChip(
            label: const Text('All'),
            selected: true,
            onSelected: (value) {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilterChip(
            label: const Text('Hajj'),
            selected: false,
            onSelected: (value) {},
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: FilterChip(
            label: const Text('Umroh'),
            selected: false,
            onSelected: (value) {},
          ),
        ),
      ],
    );
  }

  Widget _buildPackageCard(int index) {
    final packages = [
      {
        'title': 'Regular Hajj Package 2025',
        'type': 'Hajj',
        'price': '¥6,500,000',
        'duration': '40 Days',
        'departure': 'June 15, 2025',
        'hotel': '4-Star Hotel',
        'distance': '500m from Masjidil Haram',
        'provider': 'Al-Hijrah Tours',
        'rating': 4.8,
        'certified': true,
      },
      {
        'title': 'Premium Umroh Package',
        'type': 'Umroh',
        'price': '¥2,500,000',
        'duration': '12 Days',
        'departure': 'December 20, 2024',
        'hotel': '5-Star Hotel',
        'distance': '200m from Masjidil Haram',
        'provider': 'Baitul Haram Travel',
        'rating': 4.9,
        'certified': true,
      },
    ];

    final package = packages[index % packages.length];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isHajj = package['type'] == 'Hajj';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/hajj-umroh/detail/$index'),
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
                      Text(
                        package['price'] as String,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
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
                        onPressed: () => context.push('/hajj-umroh/booking/$index'),
                        child: const Text('Register'),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        onPressed: () => context.push('/hajj-umroh/detail/$index'),
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

  Widget _buildGuideSection(String title, IconData icon, List<String> items) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...items.map((item) => ListTile(
              dense: true,
              leading: const Icon(Icons.arrow_forward_ios, size: 12),
              title: Text(item),
              onTap: () => context.push('/hajj-umroh/guide/$item'),
            )),
          ],
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
        'amount': '¥5,000,000',
      },
      {
        'title': 'Regular Hajj Package 2025',
        'bookingId': 'HR-2025-002',
        'date': 'June 15, 2025',
        'status': 'Pending',
        'participants': 1,
        'amount': '¥6,500,000',
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
                Text(
                  booking['amount'] as String,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: () {}, child: const Text('Details')),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 