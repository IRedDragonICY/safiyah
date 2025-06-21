import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/currency_service.dart';

class HolidayPackageDetailPage extends StatefulWidget {
  final String packageId;
  
  const HolidayPackageDetailPage({
    super.key,
    required this.packageId,
  });

  @override
  State<HolidayPackageDetailPage> createState() => _HolidayPackageDetailPageState();
}

class _HolidayPackageDetailPageState extends State<HolidayPackageDetailPage> with TickerProviderStateMixin {
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            pinned: true,
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Tokyo Metropolitan Explorer'),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                      ),
                    ),
                    child: Icon(
                      Icons.location_city,
                      size: 120,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        '22% OFF',
                        style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(onPressed: () {}, icon: const Icon(Icons.bookmark_border)),
              IconButton(onPressed: () {}, icon: const Icon(Icons.share)),
            ],
            bottom: TabBar(
              controller: _tabController,
              labelColor: colorScheme.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              indicatorColor: colorScheme.primary,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Itinerary'),
                Tab(text: 'Inclusions'),
                Tab(text: 'Reviews'),
              ],
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildItineraryTab(),
                _buildInclusionTab(),
                _buildReviewsTab(),
              ],
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                ListenableBuilder(
                  listenable: CurrencyService(),
                  builder: (context, child) {
                    final currencyService = CurrencyService();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currencyService.formatAmount(2133), // ~$2,133 USD base (original ¥320,000)
                          style: theme.textTheme.bodySmall?.copyWith(
                            decoration: TextDecoration.lineThrough,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          currencyService.formatAmount(1667), // ~$1,667 USD base (¥250,000)
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Text('per person'),
                      ],
                    );
                  },
                ),
                const Spacer(),
                FilledButton(
                  onPressed: () => context.push('/holiday-package/booking/${widget.packageId}'),
                  child: const Text('Book Now'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPackageInfo(),
          const SizedBox(height: 16),
          _buildHighlights(),
          const SizedBox(height: 16),
          _buildAccommodation(),
        ],
      ),
    );
  }

  Widget _buildItineraryTab() {
    final itinerary = [
      {
        'day': 1,
        'title': 'Arrival in Tokyo',
        'activities': ['Narita Airport pickup', 'Hotel check-in', 'Shibuya exploration', 'Welcome dinner'],
        'meals': ['Dinner'],
      },
      {
        'day': 2,
        'title': 'Tokyo Cultural Tour',
        'activities': ['Senso-ji Temple', 'Imperial Palace', 'Ginza shopping district', 'Tokyo Skytree'],
        'meals': ['Breakfast', 'Lunch'],
      },
      {
        'day': 3,
        'title': 'Modern Tokyo Experience',
        'activities': ['Harajuku district', 'Meiji Shrine', 'Akihabara electronics', 'Tokyo Tower'],
        'meals': ['Breakfast', 'Dinner'],
      },
      {
        'day': 4,
        'title': 'Day Trip to Kamakura',
        'activities': ['Great Buddha statue', 'Bamboo forest', 'Traditional temples'],
        'meals': ['Breakfast', 'Lunch'],
      },
      {
        'day': 5,
        'title': 'Departure',
        'activities': ['Hotel check-out', 'Last-minute shopping', 'Airport transfer'],
        'meals': ['Breakfast'],
      },
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itinerary.length,
      itemBuilder: (context, index) {
        final day = itinerary[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      child: Text('${day['day']}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        day['title'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...((day['activities'] as List<String>).map((activity) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green, size: 16),
                      const SizedBox(width: 8),
                      Expanded(child: Text(activity)),
                    ],
                  ),
                ))),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.restaurant, size: 16),
                    const SizedBox(width: 8),
                    Text('Meals: ${(day['meals'] as List<String>).join(', ')}'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInclusionTab() {
    final inclusions = [
      {'title': 'Accommodation', 'desc': '4 nights in premium hotel', 'icon': Icons.hotel},
      {'title': 'Transportation', 'desc': 'Airport transfer & tour transport', 'icon': Icons.directions_car},
      {'title': 'Meals', 'desc': 'Daily breakfast + 2 dinners', 'icon': Icons.restaurant},
      {'title': 'Activities', 'desc': 'All entrance fees included', 'icon': Icons.local_activity},
      {'title': 'Guide', 'desc': 'Professional English-speaking guide', 'icon': Icons.person},
    ];

    final exclusions = [
      'International flights',
      'Personal expenses',
      'Travel insurance',
      'Tips and gratuities',
      'Lunch on days 3 & 4',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('What\'s Included', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ...inclusions.map((item) => ListTile(
                    leading: Icon(item['icon'] as IconData, color: Colors.green),
                    title: Text(item['title'] as String),
                    subtitle: Text(item['desc'] as String),
                    dense: true,
                  )),
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
                  const Text('What\'s Not Included', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  ...exclusions.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        const Icon(Icons.close, color: Colors.red, size: 16),
                        const SizedBox(width: 12),
                        Expanded(child: Text(item)),
                      ],
                    ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    final reviews = [
      {'name': 'Yuki M.', 'rating': 5, 'comment': 'Amazing trip! Tokyo is incredible and our guide was fantastic.'},
      {'name': 'John D.', 'rating': 5, 'comment': 'Perfect mix of traditional and modern Japan. Highly recommended!'},
      {'name': 'Sarah K.', 'rating': 4, 'comment': 'Great value for money, loved every moment of the trip.'},
      {'name': 'Ahmed R.', 'rating': 5, 'comment': 'Halal food options were excellent throughout the tour.'},
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: reviews.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Text('4.8', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (i) => const Icon(Icons.star, color: Colors.amber, size: 20)),
                        ),
                        const Text('Based on 89 reviews'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final review = reviews[index - 1];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(child: Text((review['name'] as String)[0])),
            title: Row(
              children: [
                Text(review['name'] as String),
                const Spacer(),
                Row(
                  children: List.generate(5, (i) => Icon(
                    i < (review['rating'] as int) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 16,
                  )),
                ),
              ],
            ),
            subtitle: Text(review['comment'] as String),
          ),
        );
      },
    );
  }

  Widget _buildPackageInfo() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Package Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.schedule, size: 20),
                const SizedBox(width: 8),
                const Text('Duration: 5 Days 4 Nights'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on, size: 20),
                const SizedBox(width: 8),
                const Text('Destination: Tokyo, Japan'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.people, size: 20),
                const SizedBox(width: 8),
                const Text('Max: 15 participants'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.verified, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                const Text('Halal Certified', style: TextStyle(color: Colors.green)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.mosque, color: Colors.blue, size: 20),
                const SizedBox(width: 8),
                const Text('Prayer facilities available', style: TextStyle(color: Colors.blue)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlights() {
    final highlights = [
      'Experience Tokyo\'s vibrant city life',
      'Visit traditional temples and shrines',
      'Explore modern districts like Shibuya & Harajuku',
      'Day trip to historic Kamakura',
      'Halal food throughout the journey',
      'Prayer time accommodated in schedule',
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Package Highlights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            ...highlights.map((highlight) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber, size: 16),
                  const SizedBox(width: 12),
                  Expanded(child: Text(highlight)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildAccommodation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Accommodation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.hotel, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Tokyo Grand Hotel', style: TextStyle(fontWeight: FontWeight.bold)),
                      const Text('4-star hotel in Shinjuku district'),
                      Row(
                        children: List.generate(4, (i) => const Icon(Icons.star, color: Colors.amber, size: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text('Amenities: Free WiFi, Halal breakfast, Prayer room, 24/7 concierge, Near JR Station'),
          ],
        ),
      ),
    );
  }
} 