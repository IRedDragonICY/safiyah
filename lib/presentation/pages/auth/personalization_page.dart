import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../routes/route_names.dart';

class PersonalizationPage extends StatefulWidget {
  const PersonalizationPage({super.key});

  @override
  State<PersonalizationPage> createState() => _PersonalizationPageState();
}

class _PersonalizationPageState extends State<PersonalizationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<ContinentData> _continents = [
    ContinentData('Africa', '🌍', {
      'Egypt': CountryInfo('🇪🇬', isPopular: true, visitors: '14.7M'),
      'Morocco': CountryInfo('🇲🇦', isPopular: true, visitors: '13M'),
      'South Africa': CountryInfo('🇿🇦', visitors: '10.2M'),
      'Nigeria': CountryInfo('🇳🇬'),
      'Kenya': CountryInfo('🇰🇪'),
      'Tunisia': CountryInfo('🇹🇳', visitors: '9.4M'),
      'Algeria': CountryInfo('🇩🇿'),
      'Sudan': CountryInfo('🇸🇩'),
      'Ethiopia': CountryInfo('🇪🇹'),
    }),
    ContinentData('Asia', '🌏', {
      'Turkey': CountryInfo('🇹🇷', region: 'Middle East', isPopular: true, visitors: '51.2M'),
      'Saudi Arabia': CountryInfo('🇸🇦', region: 'Middle East', isRecommended: true, visitors: '17.5M'),
      'United Arab Emirates': CountryInfo('🇦🇪', region: 'Middle East', isPopular: true, visitors: '15.9M'),
      'Qatar': CountryInfo('🇶🇦', region: 'Middle East', visitors: '2.1M'),
      'Kuwait': CountryInfo('🇰🇼', region: 'Middle East'),
      'Bahrain': CountryInfo('🇧🇭', region: 'Middle East'),
      'Oman': CountryInfo('🇴🇲', region: 'Middle East', isHidden: true),
      'Jordan': CountryInfo('🇯🇴', region: 'Middle East', isRecommended: true, visitors: '5.3M'),
      'Lebanon': CountryInfo('🇱🇧', region: 'Middle East'),
      'Iran': CountryInfo('🇮🇷', region: 'Middle East'),
      'Indonesia': CountryInfo('🇮🇩', region: 'Southeast Asia', isRecommended: true, isPopular: true, visitors: '16.1M'),
      'Malaysia': CountryInfo('🇲🇾', region: 'Southeast Asia', isRecommended: true, isPopular: true, visitors: '26.1M'),
      'Thailand': CountryInfo('🇹🇭', region: 'Southeast Asia', visitors: '39.9M'),
      'Singapore': CountryInfo('🇸🇬', region: 'Southeast Asia', visitors: '19.1M'),
      'Philippines': CountryInfo('🇵🇭', region: 'Southeast Asia'),
      'Vietnam': CountryInfo('🇻🇳', region: 'Southeast Asia', visitors: '18M'),
      'Cambodia': CountryInfo('🇰🇭', region: 'Southeast Asia'),
      'Laos': CountryInfo('🇱🇦', region: 'Southeast Asia'),
      'Brunei': CountryInfo('🇧🇳', region: 'Southeast Asia'),
      'Myanmar': CountryInfo('🇲🇲', region: 'Southeast Asia'),
      'Pakistan': CountryInfo('🇵🇰', region: 'South Asia'),
      'Bangladesh': CountryInfo('🇧🇩', region: 'South Asia'),
      'India': CountryInfo('🇮🇳', region: 'South Asia', visitors: '17.9M'),
      'Sri Lanka': CountryInfo('🇱🇰', region: 'South Asia'),
      'Nepal': CountryInfo('🇳🇵', region: 'South Asia'),
      'Maldives': CountryInfo('🇲🇻', region: 'South Asia'),
      'China': CountryInfo('🇨🇳', region: 'East Asia', isPopular: true, visitors: '65.7M'),
      'Japan': CountryInfo('🇯🇵', region: 'East Asia', isPopular: true, visitors: '31.9M'),
      'South Korea': CountryInfo('🇰🇷', region: 'East Asia', visitors: '17.5M'),
      'Hong Kong': CountryInfo('🇭🇰', region: 'East Asia', visitors: '29.3M'),
      'Taiwan': CountryInfo('🇹🇼', region: 'East Asia', visitors: '11.8M'),
      'Mongolia': CountryInfo('🇲🇳', region: 'East Asia'),
      'Kazakhstan': CountryInfo('🇰🇿', region: 'Central Asia'),
      'Uzbekistan': CountryInfo('🇺🇿', region: 'Central Asia'),
      'Kyrgyzstan': CountryInfo('🇰🇬', region: 'Central Asia'),
      'Tajikistan': CountryInfo('🇹🇯', region: 'Central Asia'),
      'Turkmenistan': CountryInfo('🇹🇲', region: 'Central Asia'),
    }),
    ContinentData('Europe', '🌍', {
      'United Kingdom': CountryInfo('🇬🇧', isPopular: true, visitors: '40.9M'),
      'France': CountryInfo('🇫🇷', isPopular: true, visitors: '90M'),
      'Germany': CountryInfo('🇩🇪', visitors: '39.6M'),
      'Spain': CountryInfo('🇪🇸', isPopular: true, visitors: '83.7M'),
      'Italy': CountryInfo('🇮🇹', visitors: '64.5M'),
      'Netherlands': CountryInfo('🇳🇱', visitors: '20.1M'),
      'Belgium': CountryInfo('🇧🇪'),
      'Sweden': CountryInfo('🇸🇪'),
      'Norway': CountryInfo('🇳🇴', isHidden: true),
      'Denmark': CountryInfo('🇩🇰'),
    }),
    ContinentData('North America', '🌎', {
      'United States': CountryInfo('🇺🇸', isPopular: true, visitors: '79.3M'),
      'Canada': CountryInfo('🇨🇦', visitors: '22.1M'),
      'Mexico': CountryInfo('🇲🇽', visitors: '45M'),
    }),
    ContinentData('South America', '🌎', {
      'Brazil': CountryInfo('🇧🇷', visitors: '6.6M'),
      'Argentina': CountryInfo('🇦🇷'),
      'Chile': CountryInfo('🇨🇱'),
      'Peru': CountryInfo('🇵🇪'),
      'Colombia': CountryInfo('🇨🇴'),
    }),
    ContinentData('Oceania', '🌏', {
      'Australia': CountryInfo('🇦🇺', isPopular: true, visitors: '9.5M'),
      'New Zealand': CountryInfo('🇳🇿', isRecommended: true, visitors: '3.9M'),
      'Fiji': CountryInfo('🇫🇯'),
      'Papua New Guinea': CountryInfo('🇵🇬'),
    }),
  ];

  ContinentData? _selectedContinent;
  String? _selectedCountry;
  String? _selectedRegion;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
    _animationController.forward();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedContinent != null) {
      setState(() {
        _currentStep = 1;
      });
      _animationController.reset();
      _animationController.forward();
    } else if (_currentStep == 1 && _selectedRegion != null) {
      setState(() {
        _currentStep = 2;
      });
      _animationController.reset();
      _animationController.forward();
    } else if (_currentStep == 2 && _selectedCountry != null) {
      context.go(RouteNames.home);
    }
  }

  void _previousStep() {
    if (_currentStep == 2) {
      setState(() {
        _currentStep = 1;
        _selectedCountry = null;
      });
      _animationController.reset();
      _animationController.forward();
    } else if (_currentStep == 1) {
      setState(() {
        _currentStep = 0;
        _selectedRegion = null;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface,
              colorScheme.primaryContainer.withValues(alpha: 0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Progress Indicator
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    if (_currentStep > 0)
                      IconButton.filled(
                        onPressed: _previousStep,
                        icon: const Icon(Icons.arrow_back),
                        style: IconButton.styleFrom(
                          backgroundColor: colorScheme.surfaceVariant,
                          foregroundColor: colorScheme.onSurfaceVariant,
                        ),
                      )
                    else
                      const SizedBox(width: 48),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: LinearProgressIndicator(
                          value: (_currentStep + 1) / 3,
                          minHeight: 8,
                          borderRadius: BorderRadius.circular(4),
                          backgroundColor: colorScheme.surfaceVariant,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: _currentStep == 0
                        ? _buildContinentSelection(context)
                        : _currentStep == 1
                            ? _buildRegionSelection(context)
                            : _buildCountrySelection(context),
                  ),
                ),
              ),
              // Action Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    FilledButton(
                      onPressed: (_currentStep == 0 && _selectedContinent != null) ||
                              (_currentStep == 1 && _selectedRegion != null) ||
                              (_currentStep == 2 && _selectedCountry != null)
                          ? _nextStep
                          : null,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        _currentStep == 0 ? 'Continue' : _currentStep == 1 ? 'Continue' : 'Start Exploring',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    if (_currentStep < 2) ...[
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.go(RouteNames.home),
                        child: const Text('Skip'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContinentSelection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.public,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Where are you traveling?',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your continent to get personalized recommendations',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.5,
              ),
              itemCount: _continents.length,
              itemBuilder: (context, index) {
                final continent = _continents[index];
                final isSelected = _selectedContinent == continent;
                
                return Card(
                  elevation: isSelected ? 8 : 0,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceVariant,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedContinent = continent;
                        _selectedRegion = null;
                        _selectedCountry = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            continent.emoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            continent.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? colorScheme.onPrimaryContainer
                                  : colorScheme.onSurfaceVariant,
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
    );
  }

  Widget _buildRegionSelection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final Set<String> regionSet = _selectedContinent!.countries.values
        .map((c) => c.region.isNotEmpty ? c.region : 'Other')
        .toSet();
    final List<String> _regionNames = regionSet.toList()..sort();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Select your region',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your region to get personalized recommendations',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 32),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 2.2,
              ),
              itemCount: _regionNames.length,
              itemBuilder: (context, index) {
                final region = _regionNames[index];
                final isSelected = _selectedRegion == region;

                return Card(
                  elevation: isSelected ? 8 : 0,
                  shadowColor: colorScheme.primary.withValues(alpha: 0.3),
                  color: isSelected
                      ? colorScheme.primaryContainer
                      : colorScheme.surfaceVariant,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedRegion = region;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(
                          region,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? colorScheme.onPrimaryContainer
                                : colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCountrySelection(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    // Sort countries: recommended first, then popular, then alphabetically
    final sortedCountries = _selectedContinent!.countries.entries.toList()
      ..sort((a, b) {
        if (a.value.isRecommended && !b.value.isRecommended) return -1;
        if (!a.value.isRecommended && b.value.isRecommended) return 1;
        if (a.value.isPopular && !b.value.isPopular) return -1;
        if (!a.value.isPopular && b.value.isPopular) return 1;
        return a.key.compareTo(b.key);
      });

    final filteredCountries = sortedCountries.where((entry) {
      final matchesRegion = _selectedRegion == null || entry.value.region == _selectedRegion || (_selectedRegion == 'Other' && entry.value.region.isEmpty);
      final matchesSearch = _searchQuery.isEmpty || entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesRegion && matchesSearch;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.flag,
            size: 48,
            color: colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Select your destination',
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Destinations in ${_selectedRegion ?? _selectedContinent!.name}',
            style: textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search country...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: filteredCountries.isEmpty
                ? Center(
                    child: Text(
                      'No country found',
                      style: textTheme.bodyLarge?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  )
                : ListView.separated(
              itemCount: filteredCountries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final country = filteredCountries[index];
                final isSelected = _selectedCountry == country.key;
                final info = country.value;
                
                if (info.isHidden) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          info.flag,
                          style: const TextStyle(fontSize: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                country.key,
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.errorContainer,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '🌟 Hidden Gem',
                                  style: textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onErrorContainer,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedCountry = country.key;
                      });
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? colorScheme.primaryContainer
                            : colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.outline.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text(
                            info.flag,
                            style: const TextStyle(fontSize: 40),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        country.key,
                                        style: textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: isSelected
                                              ? colorScheme.onPrimaryContainer
                                              : colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ),
                                    if (info.isRecommended)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: colorScheme.tertiary,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          '✨ Recommended',
                                          style: textTheme.labelSmall?.copyWith(
                                            color: colorScheme.onTertiary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    if (info.isPopular) ...[
                                      Icon(
                                        Icons.trending_up,
                                        size: 16,
                                        color: colorScheme.primary,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        'Popular',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.primary,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    if (info.visitors != null) ...[
                                      Icon(
                                        Icons.people_outline,
                                        size: 16,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${info.visitors} visitors/year',
                                        style: textTheme.bodySmall?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (isSelected)
                            Icon(
                              Icons.check_circle,
                              color: colorScheme.primary,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (_selectedCountry != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.secondaryContainer,
                    colorScheme.secondaryContainer.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.mosque,
                    color: colorScheme.onSecondaryContainer,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'We\'ll help you find halal restaurants, mosques, and prayer times in $_selectedCountry',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class ContinentData {
  final String name;
  final String emoji;
  final Map<String, CountryInfo> countries;

  const ContinentData(this.name, this.emoji, this.countries);
}

class CountryInfo {
  final String flag;
  final String region;
  final bool isPopular;
  final bool isRecommended;
  final bool isHidden;
  final String? visitors;

  const CountryInfo(
    this.flag, {
    this.region = '',
    this.isPopular = false,
    this.isRecommended = false,
    this.isHidden = false,
    this.visitors,
  });
} 
