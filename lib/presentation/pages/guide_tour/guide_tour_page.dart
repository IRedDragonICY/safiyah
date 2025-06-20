import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../routes/route_names.dart';

class GuideTourPage extends StatefulWidget {
  const GuideTourPage({super.key});

  @override
  State<GuideTourPage> createState() => _GuideTourPageState();
}

class _GuideTourPageState extends State<GuideTourPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  final List<Map<String, dynamic>> _countries = [
    {
      'name': 'Japan',
      'flag': '🇯🇵',
      'capital': 'Tokyo',
      'currency': 'Japanese Yen (JPY)',
      'language': 'Japanese',
      'muslimPopulation': '0.1%',
      'difficulty': 'Easy',
      'difficultyColor': AppColors.success,
      'popularCities': ['Tokyo', 'Osaka', 'Kyoto', 'Hiroshima'],
      'image': 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.0.3',
      'description': 'A fascinating blend of ancient traditions and modern technology, perfect for Muslim travelers.'
    },
    {
      'name': 'Indonesia',
      'flag': '🇮🇩',
      'capital': 'Jakarta',
      'currency': 'Indonesian Rupiah (IDR)',
      'language': 'Indonesian',
      'muslimPopulation': '87.2%',
      'difficulty': 'Very Easy',
      'difficultyColor': AppColors.success,
      'popularCities': ['Jakarta', 'Bali', 'Yogyakarta', 'Surabaya'],
      'image': 'https://images.unsplash.com/photo-1555212697-194d092e3b8f?ixlib=rb-4.0.3',
      'description': 'The largest Muslim country in the world with incredible diversity and halal-friendly atmosphere.'
    },
    {
      'name': 'Malaysia',
      'flag': '🇲🇾',
      'capital': 'Kuala Lumpur',
      'currency': 'Malaysian Ringgit (MYR)',
      'language': 'Malay, English',
      'muslimPopulation': '61.3%',
      'difficulty': 'Very Easy',
      'difficultyColor': AppColors.success,
      'popularCities': ['Kuala Lumpur', 'Penang', 'Johor Bahru', 'Malacca'],
      'image': 'https://images.unsplash.com/photo-1596422846543-75c6fc197f07?ixlib=rb-4.0.3',
      'description': 'Modern Muslim-majority country with excellent halal infrastructure and diverse culture.'
    },
    {
      'name': 'Turkey',
      'flag': '🇹🇷',
      'capital': 'Ankara',
      'currency': 'Turkish Lira (TRY)',
      'language': 'Turkish',
      'muslimPopulation': '99.8%',
      'difficulty': 'Easy',
      'difficultyColor': AppColors.success,
      'popularCities': ['Istanbul', 'Ankara', 'Antalya', 'Cappadocia'],
      'image': 'https://images.unsplash.com/photo-1524231757912-21f4fe3a7200?ixlib=rb-4.0.3',
      'description': 'Bridge between Europe and Asia with rich Islamic heritage and stunning landscapes.'
    },
    {
      'name': 'United Arab Emirates',
      'flag': '🇦🇪',
      'capital': 'Abu Dhabi',
      'currency': 'UAE Dirham (AED)',
      'language': 'Arabic, English',
      'muslimPopulation': '76%',
      'difficulty': 'Easy',
      'difficultyColor': AppColors.success,
      'popularCities': ['Dubai', 'Abu Dhabi', 'Sharjah', 'Ras Al Khaimah'],
      'image': 'https://images.unsplash.com/photo-1512453979798-5ea266f8880c?ixlib=rb-4.0.3',
      'description': 'Luxurious destination with world-class halal facilities and modern Islamic architecture.'
    },
    {
      'name': 'Singapore',
      'flag': '🇸🇬',
      'capital': 'Singapore',
      'currency': 'Singapore Dollar (SGD)',
      'language': 'English, Malay, Mandarin, Tamil',
      'muslimPopulation': '14%',
      'difficulty': 'Easy',
      'difficultyColor': AppColors.success,
      'popularCities': ['Singapore'],
      'image': 'https://images.unsplash.com/photo-1525625293386-3f8f99389edd?ixlib=rb-4.0.3',
      'description': 'Modern city-state with excellent halal food scene and Muslim-friendly facilities.'
    },
    {
      'name': 'South Korea',
      'flag': '🇰🇷',
      'capital': 'Seoul',
      'currency': 'South Korean Won (KRW)',
      'language': 'Korean',
      'muslimPopulation': '0.2%',
      'difficulty': 'Moderate',
      'difficultyColor': AppColors.warning,
      'popularCities': ['Seoul', 'Busan', 'Incheon', 'Jeju'],
      'image': 'https://images.unsplash.com/photo-1540959733332-eab4deabeeaf?ixlib=rb-4.0.3',
      'description': 'Tech-savvy nation with growing halal awareness and beautiful cultural heritage.'
    },
    {
      'name': 'Thailand',
      'flag': '🇹🇭',
      'capital': 'Bangkok',
      'currency': 'Thai Baht (THB)',
      'language': 'Thai',
      'muslimPopulation': '4.9%',
      'difficulty': 'Moderate',
      'difficultyColor': AppColors.warning,
      'popularCities': ['Bangkok', 'Phuket', 'Chiang Mai', 'Pattaya'],
      'image': 'https://images.unsplash.com/photo-1552465011-b4e21bf6e79a?ixlib=rb-4.0.3',
      'description': 'Beautiful beaches and temples with increasing halal tourism infrastructure.'
    },
  ];

  List<Map<String, dynamic>> get _filteredCountries {
    if (_searchQuery.isEmpty) return _countries;
    return _countries.where((country) {
      return country['name'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             country['capital'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
             country['popularCities'].any((city) => 
               city.toLowerCase().contains(_searchQuery.toLowerCase()));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.secondaryContainer,
                        ],
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
                            Colors.transparent,
                            Theme.of(context).colorScheme.surface.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 24,
                    right: 24,
                    bottom: 24,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.tour_outlined,
                                size: 16,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Travel Guide',
                                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Discover Your Next\nDestination',
                          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onSurface,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete travel guides for Muslim-friendly destinations worldwide',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(28),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search countries, cities, or destinations...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      suffixIcon: _searchQuery.isNotEmpty
                          ? IconButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              icon: Icon(
                                Icons.clear,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Results
                if (_filteredCountries.isEmpty)
                  Center(
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Icon(
                          Icons.search_off,
                          size: 64,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No destinations found',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Try searching with different keywords',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            _searchQuery.isEmpty 
                                ? 'Popular Destinations' 
                                : 'Search Results',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_filteredCountries.length}',
                              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSecondaryContainer,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = _filteredCountries[index];
                          return _buildCountryCard(context, country);
                        },
                      ),
                    ],
                  ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountryCard(BuildContext context, Map<String, dynamic> country) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: InkWell(
          onTap: () => context.push('${RouteNames.guideTourDetail}?country=${country['name']}'),
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Header
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: Stack(
                  children: [
                    Container(
                      height: 180,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(country['image']),
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
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.3),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 16,
                      right: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: country['difficultyColor'].withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          country['difficulty'],
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      child: Row(
                        children: [
                          Text(
                            country['flag'],
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country['name'],
                                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                country['capital'],
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  shadows: [
                                    Shadow(
                                      offset: const Offset(0, 1),
                                      blurRadius: 3,
                                      color: Colors.black.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      country['description'],
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Stats
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatItem(
                            context,
                            icon: Icons.people,
                            label: 'Muslim Pop.',
                            value: country['muslimPopulation'],
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            icon: Icons.language,
                            label: 'Language',
                            value: country['language'].split(',')[0],
                          ),
                        ),
                        Expanded(
                          child: _buildStatItem(
                            context,
                            icon: Icons.attach_money,
                            label: 'Currency',
                            value: country['currency'].split(' ')[0],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
} 
