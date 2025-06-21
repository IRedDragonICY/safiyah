import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HolidayPackagePage extends StatefulWidget {
  const HolidayPackagePage({super.key});

  @override
  State<HolidayPackagePage> createState() => _HolidayPackagePageState();
}

class _HolidayPackagePageState extends State<HolidayPackagePage> {
  String _selectedCategory = 'All';
  String _selectedCountry = 'Japan';
  
  final List<String> _categories = ['All', 'Family', 'Honeymoon', 'Religious', 'Adventure'];
  final List<String> _countries = ['Japan', 'Malaysia', 'Turkey', 'Indonesia', 'Singapore', 'Thailand'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text('Holiday Packages - $_selectedCountry'),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 16),
                  _buildCountrySelector(),
                  const SizedBox(height: 16),
                  _buildCategoryFilter(),
                  const SizedBox(height: 16),
                  _buildPopularPackages(),
                  const SizedBox(height: 16),
                  Text(
                    'Featured Packages',
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/holiday-package/booking'),
        icon: const Icon(Icons.book_online),
        label: const Text('Create Custom'),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            const Icon(Icons.search),
            const SizedBox(width: 12),
            const Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search your dream destination...',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCountrySelector() {
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
                Icon(Icons.public, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Select Country',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _countries.length,
                itemBuilder: (context, index) {
                  final country = _countries[index];
                  final isSelected = _selectedCountry == country;
                  
                  return Container(
                    width: 80,
                    margin: EdgeInsets.only(right: index < _countries.length - 1 ? 12 : 0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          _selectedCountry = country;
                        });
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? colorScheme.primaryContainer : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected ? colorScheme.primary : colorScheme.outline,
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: isSelected ? colorScheme.primary : colorScheme.surfaceVariant,
                              child: Text(
                                _getCountryFlag(country),
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              country,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? colorScheme.onPrimaryContainer : null,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCountryFlag(String country) {
    switch (country) {
      case 'Japan': return '🇯🇵';
      case 'Malaysia': return '🇲🇾';
      case 'Turkey': return '🇹🇷';
      case 'Indonesia': return '🇮🇩';
      case 'Singapore': return '🇸🇬';
      case 'Thailand': return '🇹🇭';
      default: return '🌍';
    }
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;
          return Padding(
            padding: EdgeInsets.only(right: index < _categories.length - 1 ? 8 : 0),
            child: FilterChip(
              selected: isSelected,
              label: Text(category),
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildPopularPackages() {
    final packages = _getPackagesForCountry(_selectedCountry);

    return SizedBox(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: packages.length,
        itemBuilder: (context, index) {
          final package = packages[index];
          final colorScheme = Theme.of(context).colorScheme;
          
          return Container(
            width: 260,
            margin: EdgeInsets.only(right: index < packages.length - 1 ? 16 : 0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.push('/holiday-package/detail/$index'),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                        ),
                      ),
                      child: Icon(
                        Icons.landscape,
                        size: 60,
                        color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.8)],
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              package['name'] as String,
                              style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: [
                                Text(
                                  package['price'] as String,
                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                ),
                                const Spacer(),
                                Text(
                                  package['days'] as String,
                                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getPackagesForCountry(String country) {
    switch (country) {
      case 'Japan':
        return [
          {'name': 'Tokyo Explorer', 'price': '¥250,000', 'days': '5D4N'},
          {'name': 'Kyoto Heritage', 'price': '¥180,000', 'days': '4D3N'},
          {'name': 'Osaka Food Tour', 'price': '¥200,000', 'days': '3D2N'},
        ];
      case 'Malaysia':
        return [
          {'name': 'KL Twin Towers', 'price': 'RM 2,500', 'days': '4D3N'},
          {'name': 'Penang Heritage', 'price': 'RM 1,800', 'days': '3D2N'},
          {'name': 'Langkawi Beach', 'price': 'RM 2,200', 'days': '5D4N'},
        ];
      case 'Turkey':
        return [
          {'name': 'Istanbul Magic', 'price': '₺ 15,000', 'days': '6D5N'},
          {'name': 'Cappadocia Dream', 'price': '₺ 12,000', 'days': '4D3N'},
          {'name': 'Antalya Coast', 'price': '₺ 10,000', 'days': '5D4N'},
        ];
      default:
        return [
          {'name': 'Cultural Discovery', 'price': '\$1,500', 'days': '5D4N'},
          {'name': 'Heritage Tour', 'price': '\$1,200', 'days': '4D3N'},
          {'name': 'Adventure Package', 'price': '\$1,800', 'days': '6D5N'},
        ];
    }
  }

  Widget _buildPackageCard(int index) {
    final packages = _getDetailedPackagesForCountry(_selectedCountry);
    final package = packages[index % packages.length];
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () => context.push('/holiday-package/detail/$index'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [colorScheme.primaryContainer, colorScheme.secondaryContainer],
                    ),
                  ),
                  child: Icon(
                    Icons.landscape,
                    size: 60,
                    color: colorScheme.onPrimaryContainer.withValues(alpha: 0.3),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${package['discount']} OFF',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Halal Certified',
                      style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    package['title'] as String,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        package['destination'] as String,
                        style: theme.textTheme.bodySmall,
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 14),
                          const SizedBox(width: 4),
                          Text('${package['rating']}', style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    package['duration'] as String,
                    style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            package['originalPrice'] as String,
                            style: theme.textTheme.bodySmall?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          Text(
                            package['price'] as String,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: () => context.push('/holiday-package/booking/$index'),
                        child: const Text('Book Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDetailedPackagesForCountry(String country) {
    switch (country) {
      case 'Japan':
        return [
          {
            'title': 'Tokyo Metropolitan Explorer',
            'destination': 'Tokyo, Japan',
            'price': '¥250,000',
            'originalPrice': '¥320,000',
            'duration': '5D4N',
            'rating': 4.9,
            'category': 'Cultural',
            'discount': '22%',
          },
          {
            'title': 'Kyoto Traditional Heritage',
            'destination': 'Kyoto, Japan',
            'price': '¥180,000',
            'originalPrice': '¥230,000',
            'duration': '4D3N',
            'rating': 4.8,
            'category': 'Cultural',
            'discount': '22%',
          },
          {
            'title': 'Osaka Culinary Journey',
            'destination': 'Osaka, Japan',
            'price': '¥200,000',
            'originalPrice': '¥260,000',
            'duration': '3D2N',
            'rating': 4.7,
            'category': 'Food',
            'discount': '23%',
          },
        ];
      case 'Malaysia':
        return [
          {
            'title': 'Kuala Lumpur Modern City',
            'destination': 'Kuala Lumpur, Malaysia',
            'price': 'RM 2,500',
            'originalPrice': 'RM 3,200',
            'duration': '4D3N',
            'rating': 4.6,
            'category': 'Urban',
            'discount': '22%',
          },
          {
            'title': 'Penang Heritage Trail',
            'destination': 'Penang, Malaysia',
            'price': 'RM 1,800',
            'originalPrice': 'RM 2,300',
            'duration': '3D2N',
            'rating': 4.8,
            'category': 'Heritage',
            'discount': '22%',
          },
        ];
      default:
        return [
          {
            'title': 'Cultural Discovery Package',
            'destination': country,
            'price': '\$1,500',
            'originalPrice': '\$2,000',
            'duration': '5D4N',
            'rating': 4.5,
            'category': 'Cultural',
            'discount': '25%',
          },
        ];
    }
  }
} 