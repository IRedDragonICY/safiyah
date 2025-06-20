import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';

class GuideTourDetailPage extends StatefulWidget {
  final String country;

  const GuideTourDetailPage({
    super.key,
    required this.country,
  });

  @override
  State<GuideTourDetailPage> createState() => _GuideTourDetailPageState();
}

class _GuideTourDetailPageState extends State<GuideTourDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _getCountryData() {
    final countryData = {
      'Japan': {
        'flag': '🇯🇵',
        'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.0.3',
        'capital': 'Tokyo',
        'currency': 'Japanese Yen (JPY)',
        'language': 'Japanese',
        'timezone': 'GMT+9',
        'bestTime': 'March-May, September-November',
        'muslimPopulation': '0.1%',
        'visa': {
          'required': true,
          'type': 'Tourist Visa / Visa Waiver',
          'duration': '90 days',
          'processing': '3-5 working days',
          'documents': [
            'Valid passport (6+ months)',
            'Completed visa application form',
            'Recent passport-sized photo',
            'Flight itinerary',
            'Hotel reservation',
            'Bank statement (3 months)',
            'Travel insurance',
          ],
        },
        'rules': [
          'No smoking in public areas',
          'Remove shoes when entering homes',
          'Bow when greeting people',
          'Do not tip at restaurants',
          'Follow local customs at temples',
          'Tattoos may restrict access to onsen',
          'Keep voice down in public transport',
        ],
        'halal': {
          'restaurants': 1200,
          'mosques': 80,
          'prayerRooms': 300,
          'halalCertified': true,
          'majorChains': ['Naritaya', 'Ganko', 'Sakura', 'Halal Guys'],
        },
        'transportation': {
          'metro': 'Extensive rail network',
          'ic_card': 'Suica/Pasmo cards',
          'taxi': 'Available but expensive',
          'rental': 'International license required',
        },
        'emergency': {
          'police': '110',
          'fire': '119',
          'embassy': '+81-3-3582-5511',
          'tourist': '+81-50-3816-2787',
        },
        'tips': [
          'Download Google Translate app',
          'Carry cash - many places don\'t accept cards',
          'Learn basic Japanese phrases',
          'Download offline maps',
          'Respect local customs and traditions',
          'Book accommodations in advance',
        ],
        'budget': {
          'budget': '¥8,000-12,000/day',
          'midRange': '¥15,000-25,000/day',
          'luxury': '¥30,000+/day',
        },
      },
      'Indonesia': {
        'flag': '🇮🇩',
        'image': 'https://images.unsplash.com/photo-1555212697-194d092e3b8f?ixlib=rb-4.0.3',
        'capital': 'Jakarta',
        'currency': 'Indonesian Rupiah (IDR)',
        'language': 'Indonesian',
        'timezone': 'GMT+7 to GMT+9',
        'bestTime': 'May-September (dry season)',
        'muslimPopulation': '87.2%',
        'visa': {
          'required': false,
          'type': 'Visa on Arrival / Free Visa',
          'duration': '30 days (extendable)',
          'processing': 'Immediate',
          'documents': [
            'Valid passport (6+ months)',
            'Return ticket',
            'Proof of accommodation',
            'Sufficient funds (\$25/day)',
          ],
        },
        'rules': [
          'Dress modestly in religious areas',
          'Use right hand for eating and greeting',
          'Remove shoes in mosques and homes',
          'Respect religious practices',
          'No public displays of affection',
        ],
        'halal': {
          'restaurants': 50000,
          'mosques': 800000,
          'prayerRooms': 10000,
          'halalCertified': true,
          'majorChains': ['KFC', 'McDonald\'s', 'Pizza Hut', 'Burger King'],
        },
        'transportation': {
          'metro': 'Available in Jakarta',
          'bus': 'TransJakarta, local buses',
          'taxi': 'Gojek, Grab widely available',
          'rental': 'International license required',
        },
        'emergency': {
          'police': '110',
          'ambulance': '118',
          'fire': '113',
          'tourist': '+62-21-383-8899',
        },
        'tips': [
          'Learn basic Indonesian phrases',
          'Bargaining is common in markets',
          'Try local halal street food',
          'Respect prayer times',
          'Bring mosquito repellent',
          'Use ride-sharing apps for convenience',
        ],
        'budget': {
          'budget': 'Rp200,000-400,000/day',
          'midRange': 'Rp500,000-1,000,000/day',
          'luxury': 'Rp1,500,000+/day',
        },
      },
      // Add more countries as needed
    };

    return countryData[widget.country] ?? countryData['Japan']!;
  }

  @override
  Widget build(BuildContext context) {
    final data = _getCountryData();

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 300,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.surface,
              surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(data['image']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.3),
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: Row(
                        children: [
                          Text(
                            data['flag'],
                            style: const TextStyle(fontSize: 48),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.country,
                                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  data['capital'],
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: Theme.of(context).colorScheme.primary,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                tabs: const [
                  Tab(text: 'Overview'),
                  Tab(text: 'Visa & Docs'),
                  Tab(text: 'Rules & Culture'),
                  Tab(text: 'Halal Info'),
                  Tab(text: 'Transport'),
                  Tab(text: 'Emergency'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(data),
            _buildVisaTab(data),
            _buildRulesTab(data),
            _buildHalalTab(data),
            _buildTransportTab(data),
            _buildEmergencyTab(data),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Basic Info Cards
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.language,
                  title: 'Language',
                  value: data['language'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.attach_money,
                  title: 'Currency',
                  value: data['currency'].split(' ')[0],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.access_time,
                  title: 'Timezone',
                  value: data['timezone'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.wb_sunny,
                  title: 'Best Time',
                  value: data['bestTime'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Budget Estimate
          Text(
            'Daily Budget Estimate',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...data['budget'].entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _getBudgetColor(entry.key).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getBudgetIcon(entry.key),
                      color: _getBudgetColor(entry.key),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key.toUpperCase(),
                          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _getBudgetColor(entry.key),
                          ),
                        ),
                        Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),

          const SizedBox(height: 24),

          // Tips Section
          Text(
            'Travel Tips',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...data['tips'].asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        '${entry.key + 1}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildVisaTab(Map<String, dynamic> data) {
    final visa = data['visa'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Visa Status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: visa['required'] 
                  ? AppColors.warning.withValues(alpha: 0.1)
                  : AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: visa['required'] 
                    ? AppColors.warning.withValues(alpha: 0.3)
                    : AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  visa['required'] ? Icons.description : Icons.check_circle,
                  size: 48,
                  color: visa['required'] ? AppColors.warning : AppColors.success,
                ),
                const SizedBox(height: 12),
                Text(
                  visa['required'] ? 'Visa Required' : 'No Visa Required',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: visa['required'] ? AppColors.warning : AppColors.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  visa['type'],
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Visa Details
          Row(
            children: [
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.schedule,
                  title: 'Duration',
                  value: visa['duration'],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInfoCard(
                  icon: Icons.access_time,
                  title: 'Processing',
                  value: visa['processing'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Required Documents
          Text(
            'Required Documents',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...visa['documents'].asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    margin: const EdgeInsets.only(top: 2),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.check,
                      size: 16,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRulesTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Cultural Rules & Etiquette',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Important guidelines to respect local customs and avoid cultural misunderstandings.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ...data['rules'].asMap().entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.errorContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.info_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildHalalTab(Map<String, dynamic> data) {
    final halal = data['halal'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Halal Status
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.verified,
                  size: 48,
                  color: AppColors.success,
                ),
                const SizedBox(height: 12),
                Text(
                  halal['halalCertified'] ? 'Halal Certified' : 'Limited Halal Options',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Muslim Population: ${data['muslimPopulation']}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Statistics
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _buildStatCard(
                context,
                icon: Icons.restaurant,
                title: 'Halal Restaurants',
                value: '${halal['restaurants']}+',
                color: AppColors.success,
              ),
              _buildStatCard(
                context,
                icon: Icons.mosque,
                title: 'Mosques',
                value: '${halal['mosques']}+',
                color: AppColors.primary,
              ),
              _buildStatCard(
                context,
                icon: Icons.self_improvement,
                title: 'Prayer Rooms',
                value: '${halal['prayerRooms']}+',
                color: AppColors.secondary,
              ),
              _buildStatCard(
                context,
                icon: Icons.verified_user,
                title: 'Certified',
                value: halal['halalCertified'] ? 'Yes' : 'Limited',
                color: AppColors.info,
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Major Chains
          Text(
            'Popular Halal Food Chains',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: halal['majorChains'].map<Widget>((chain) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  chain,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTransportTab(Map<String, dynamic> data) {
    final transport = data['transportation'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transportation Options',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...transport.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getTransportIcon(entry.key),
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
                          _getTransportTitle(entry.key),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildEmergencyTab(Map<String, dynamic> data) {
    final emergency = data['emergency'];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Emergency Contacts',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Keep these numbers handy during your travel.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          ...emergency.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getEmergencyIcon(entry.key),
                      color: Theme.of(context).colorScheme.error,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getEmergencyTitle(entry.key),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.value,
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Add phone call functionality
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 32,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Color _getBudgetColor(String type) {
    switch (type) {
      case 'budget':
        return AppColors.success;
      case 'midRange':
        return AppColors.warning;
      case 'luxury':
        return AppColors.error;
      default:
        return AppColors.primary;
    }
  }

  IconData _getBudgetIcon(String type) {
    switch (type) {
      case 'budget':
        return Icons.savings;
      case 'midRange':
        return Icons.account_balance_wallet;
      case 'luxury':
        return Icons.diamond;
      default:
        return Icons.attach_money;
    }
  }

  IconData _getTransportIcon(String type) {
    switch (type) {
      case 'metro':
        return Icons.train;
      case 'ic_card':
        return Icons.credit_card;
      case 'taxi':
        return Icons.local_taxi;
      case 'rental':
        return Icons.directions_car;
      case 'bus':
        return Icons.directions_bus;
      default:
        return Icons.directions;
    }
  }

  String _getTransportTitle(String type) {
    switch (type) {
      case 'metro':
        return 'Metro/Train';
      case 'ic_card':
        return 'IC Card';
      case 'taxi':
        return 'Taxi';
      case 'rental':
        return 'Car Rental';
      case 'bus':
        return 'Bus';
      default:
        return type;
    }
  }

  IconData _getEmergencyIcon(String type) {
    switch (type) {
      case 'police':
        return Icons.local_police;
      case 'fire':
      case 'ambulance':
        return Icons.local_hospital;
      case 'embassy':
        return Icons.account_balance;
      case 'tourist':
        return Icons.info;
      default:
        return Icons.phone;
    }
  }

  String _getEmergencyTitle(String type) {
    switch (type) {
      case 'police':
        return 'Police';
      case 'fire':
        return 'Fire Department';
      case 'ambulance':
        return 'Ambulance';
      case 'embassy':
        return 'Embassy';
      case 'tourist':
        return 'Tourist Hotline';
      default:
        return type;
    }
  }
} 
