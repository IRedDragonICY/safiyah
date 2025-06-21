import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HajjUmrohDetailPage extends StatefulWidget {
  final String packageId;

  const HajjUmrohDetailPage({super.key, required this.packageId});

  @override
  State<HajjUmrohDetailPage> createState() => _HajjUmrohDetailPageState();
}

class _HajjUmrohDetailPageState extends State<HajjUmrohDetailPage> with TickerProviderStateMixin {
  late TabController _tabController;
  bool _isBookmarked = false;

  final packages = [
    {
      'title': 'Regular Hajj Package 2025',
      'type': 'Hajj',
      'price': '¥6,500,000',
      'originalPrice': '¥7,200,000',
      'duration': '40 Days',
      'departure': 'June 15, 2025',
      'hotel': '4-Star Hotel',
      'distance': '500m from Masjidil Haram',
      'provider': 'Al-Hijrah Tours',
      'rating': 4.8,
      'reviews': 156,
      'certified': true,
      'description': 'Complete Hajj package with comfortable accommodation and professional guidance. Includes all mandatory rituals with experienced mutawwif guides.',
      'inclusions': [
        'Round-trip flights from Japan',
        'Makkah hotel (500m from Masjidil Haram)',
        'Madinah hotel (300m from Masjid Nabawi)',
        'Mina and Arafat accommodation',
        'All meals (halal certified)',
        'Professional Mutawwif guide',
        'Group transportation',
        'Visa processing',
        'Hajj kit and supplies',
        'Medical support',
        '24/7 customer service'
      ],
      'itinerary': [
        {'day': '1', 'location': 'Tokyo - Jeddah', 'activity': 'Departure from Tokyo, arrival in Jeddah, transfer to Makkah'},
        {'day': '2-7', 'location': 'Makkah', 'activity': 'Umroh rituals, Tawaf, Sa\'i, spiritual preparation'},
        {'day': '8', 'location': 'Mina', 'activity': 'Tarwiyah day, move to Mina'},
        {'day': '9', 'location': 'Arafat', 'activity': 'Wuquf at Arafat, most important pillar of Hajj'},
        {'day': '10-13', 'location': 'Mina', 'activity': 'Jamarat stone throwing, Qurban, Halq/Taqsir'},
        {'day': '14-35', 'location': 'Makkah', 'activity': 'Tawaf al-Ifadah, additional Tawaf, prayers'},
        {'day': '36-40', 'location': 'Madinah', 'activity': 'Visit to Prophet\'s Mosque, historical sites'},
      ],
    },
    {
      'title': 'Premium Umroh Package',
      'type': 'Umroh',
      'price': '¥2,500,000',
      'originalPrice': '¥2,800,000',
      'duration': '12 Days',
      'departure': 'December 20, 2024',
      'hotel': '5-Star Hotel',
      'distance': '200m from Masjidil Haram',
      'provider': 'Baitul Haram Travel',
      'rating': 4.9,
      'reviews': 89,
      'certified': true,
      'description': 'Luxury Umroh experience with premium accommodation and personalized service. Perfect for those seeking comfort and spiritual fulfillment.',
      'inclusions': [
        'Premium round-trip flights',
        'Luxury 5-star Makkah hotel',
        'Luxury 5-star Madinah hotel', 
        'VIP airport transfers',
        'Buffet meals at finest restaurants',
        'Private Mutawwif guide',
        'Premium transportation',
        'Fast-track visa service',
        'Premium Umroh kit',
        'Spa and wellness access',
        'Shopping tour',
        'Photography service'
      ],
      'itinerary': [
        {'day': '1', 'location': 'Tokyo - Jeddah', 'activity': 'VIP departure, arrival with fast-track service'},
        {'day': '2-8', 'location': 'Makkah', 'activity': 'Umroh rituals, multiple Tawaf, spiritual activities'},
        {'day': '9-12', 'location': 'Madinah', 'activity': 'Prophet\'s Mosque visits, historical tours, shopping'},
      ],
    },
  ];

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
    final packageIndex = int.tryParse(widget.packageId) ?? 0;
    final package = packages[packageIndex % packages.length];
    final isHajj = package['type'] == 'Hajj';

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    _isBookmarked = !_isBookmarked;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(_isBookmarked ? 'Package bookmarked' : 'Bookmark removed'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                icon: Icon(_isBookmarked ? Icons.bookmark : Icons.bookmark_border),
              ),
              IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing package details...')),
                  );
                },
                icon: const Icon(Icons.share),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                package['type'] as String,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      isHajj ? colorScheme.primary : Colors.green,
                      (isHajj ? colorScheme.primary : Colors.green).withValues(alpha: 0.7),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Icon(
                        isHajj ? Icons.mosque : Icons.location_city,
                        size: 120,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    Positioned(
                      bottom: 80,
                      left: 16,
                      right: 16,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (package['certified'] as bool)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.verified, color: Colors.white, size: 16),
                                  SizedBox(width: 4),
                                  Text('Certified', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['title'] as String,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package['provider'] as String,
                    style: theme.textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: colorScheme.primary, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              '${package['rating']} (${package['reviews']} reviews)',
                              style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          if (package['originalPrice'] != null)
                            Text(
                              package['originalPrice'] as String,
                              style: theme.textTheme.bodySmall?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          Text(
                            package['price'] as String,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildQuickInfo(package),
                  const SizedBox(height: 24),
                  TabBar(
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
                ],
              ),
            ),
          ),
          SliverFillRemaining(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(package),
                _buildItineraryTab(package),
                _buildInclusionsTab(package),
                _buildReviewsTab(package),
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
              offset: const Offset(0, -2),
              blurRadius: 8,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Contact support for more information')),
                  );
                },
                icon: const Icon(Icons.chat),
                label: const Text('Contact'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: () => context.push('/hajj-umroh/booking/${widget.packageId}'),
                child: const Text('Book Now'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickInfo(Map<String, dynamic> package) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            Icons.schedule,
            'Duration',
            package['duration'] as String,
            colorScheme,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            Icons.flight_takeoff,
            'Departure',
            package['departure'] as String,
            colorScheme,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: colorScheme.primary),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> package) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Package Description',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Text(package['description'] as String),
          const SizedBox(height: 24),
          Text(
            'Accommodation',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.hotel, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        package['hotel'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(package['distance'] as String),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItineraryTab(Map<String, dynamic> package) {
    final itinerary = package['itinerary'] as List<Map<String, dynamic>>;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: itinerary.length,
      itemBuilder: (context, index) {
        final item = itinerary[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      item['day'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['location'] as String,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item['activity'] as String,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInclusionsTab(Map<String, dynamic> package) {
    final inclusions = package['inclusions'] as List<String>;
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: inclusions.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const Icon(
              Icons.check_circle,
              color: Colors.green,
            ),
            title: Text(inclusions[index]),
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(Map<String, dynamic> package) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) {
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
                      child: Text('U${index + 1}'),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'User ${index + 1}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Row(
                            children: List.generate(
                              5,
                              (starIndex) => Icon(
                                Icons.star,
                                size: 16,
                                color: starIndex < 4 ? Colors.amber : Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '2 days ago',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Excellent service and accommodation. The guides were very knowledgeable and helpful throughout the journey. Highly recommended!',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
} 