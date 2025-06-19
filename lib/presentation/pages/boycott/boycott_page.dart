import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BoycottItem {
  final String name;
  final String category; // Food, Beverage, Cosmetics, Electronics, Finance, Software, etc.
  final String accusation;
  final String? brands; // sub-brands or products
  final Color color; // category color
  final IconData icon;
  final String? website;
  final String? headquarters;
  final String? founded;
  final String? ceo;
  final String? description;
  final List<String>? alternatives;

  const BoycottItem({
    required this.name,
    required this.category,
    required this.accusation,
    this.brands,
    required this.color,
    required this.icon,
    this.website,
    this.headquarters,
    this.founded,
    this.ceo,
    this.description,
    this.alternatives,
  });
}

const List<BoycottItem> _boycottData = [
  BoycottItem(
    name: 'Ahava',
    category: 'Cosmetics',
    accusation: 'Involvement in illegal Israeli settlements.',
    color: Colors.pink,
    icon: Icons.face_retouching_natural,
    website: 'ahava.com',
    headquarters: 'Israel',
    founded: '1988',
    description: 'Israeli cosmetics company known for Dead Sea mineral products.',
    alternatives: ['The Body Shop', 'Lush', 'Garnier'],
  ),
  BoycottItem(
    name: 'AXA',
    category: 'Finance',
    accusation: 'Financing activity in illegal Israeli settlements.',
    color: Colors.blue,
    icon: Icons.account_balance,
    website: 'axa.com',
    headquarters: 'Paris, France',
    founded: '1816',
    ceo: 'Claude Brunet',
    description: 'French multinational insurance firm.',
    alternatives: ['Prudential', 'Allianz', 'Generali'],
  ),
  BoycottItem(
    name: 'Burger King',
    category: 'Food',
    accusation: 'Donating meals to the Israeli military.',
    color: Colors.orange,
    icon: Icons.lunch_dining,
    website: 'bk.com',
    headquarters: 'Miami, Florida, USA',
    founded: '1953',
    description: 'American multinational chain of hamburger fast food restaurants.',
    alternatives: ['Local burger joints', 'Subway', 'KFC alternatives'],
  ),
  BoycottItem(
    name: 'Coca-Cola',
    category: 'Beverage',
    accusation: 'Involvement in illegal Israeli settlements.',
    brands: 'Fanta, Sprite, Smartwater, Costa Coffee, Innocent',
    color: Colors.red,
    icon: Icons.local_drink,
    website: 'coca-cola.com',
    headquarters: 'Atlanta, Georgia, USA',
    founded: '1886',
    ceo: 'James Quincey',
    description: 'American multinational beverage corporation.',
    alternatives: ['Pepsi alternatives', 'Local sodas', 'Natural juices'],
  ),
  BoycottItem(
    name: 'Cisco',
    category: 'Electronics',
    accusation: 'Providing services to the Israeli military.',
    color: Colors.teal,
    icon: Icons.devices,
    website: 'cisco.com',
    headquarters: 'San Jose, California, USA',
    founded: '1984',
    ceo: 'Chuck Robbins',
    description: 'American multinational technology company.',
    alternatives: ['Juniper Networks', 'Arista Networks', 'Dell Technologies'],
  ),
  BoycottItem(
    name: 'Nestlé',
    category: 'Food',
    accusation: 'Suspected Israeli affiliation and unethical practices.',
    brands: 'Nescafé, KitKat, Maggi, Milo, Purina, Smarties',
    color: Colors.orange,
    icon: Icons.fastfood,
    website: 'nestle.com',
    headquarters: 'Vevey, Switzerland',
    founded: '1866',
    ceo: 'Ulf Mark Schneider',
    description: 'Swiss multinational food and drink processing conglomerate.',
    alternatives: ['Unilever products', 'Local brands', 'Fair trade options'],
  ),
  BoycottItem(
    name: 'Starbucks',
    category: 'Beverage',
    accusation: 'Funding pro-Israel causes and closing stores in Palestinian solidarity areas.',
    color: Colors.red,
    icon: Icons.coffee,
    website: 'starbucks.com',
    headquarters: 'Seattle, Washington, USA',
    founded: '1971',
    ceo: 'Laxman Narasimhan',
    description: 'American multinational chain of coffeehouses.',
    alternatives: ['Local coffee shops', 'Dunkin\' alternatives', 'Tim Hortons'],
  ),
  BoycottItem(
    name: 'HP',
    category: 'Electronics',
    accusation: 'Providing services to the Israeli government and military.',
    color: Colors.teal,
    icon: Icons.computer,
    website: 'hp.com',
    headquarters: 'Palo Alto, California, USA',
    founded: '1939',
    ceo: 'Enrique Lores',
    description: 'American multinational information technology company.',
    alternatives: ['Dell alternatives', 'Lenovo', 'ASUS'],
  ),
  BoycottItem(
    name: 'Unilever',
    category: 'Food & Household',
    accusation: 'Investments in Israel.',
    brands: 'Dove, Axe, Pepsodent, Sunsilk, Lipton, Wall\'s, Ben & Jerry\'s',
    color: Colors.green,
    icon: Icons.home,
    website: 'unilever.com',
    headquarters: 'London, UK',
    founded: '1880',
    ceo: 'Alan Jope',
    description: 'British-Dutch multinational consumer goods company.',
    alternatives: ['Local brands', 'Fair trade options', 'Kiss products'],
  ),
  BoycottItem(
    name: 'McDonald\'s',
    category: 'Food',
    accusation: 'Donating meals to the Israeli military.',
    color: Colors.orange,
    icon: Icons.restaurant,
    website: 'mcdonalds.com',
    headquarters: 'Chicago, Illinois, USA',
    founded: '1940',
    ceo: 'Chris Kempczinski',
    description: 'American multinational fast food corporation.',
    alternatives: ['Local restaurants', 'Subway', 'Chipotle'],
  ),
  BoycottItem(
    name: 'KFC',
    category: 'Food',
    accusation: 'Supporting Israeli forces with meals.',
    color: Colors.orange,
    icon: Icons.lunch_dining,
    website: 'kfc.com',
    headquarters: 'Louisville, Kentucky, USA',
    founded: '1952',
    ceo: 'Kevin Hochman',
    description: 'American fast food restaurant.',
    alternatives: ['Local chicken joints', 'Popeyes', 'Chick-fil-A'],
  ),
  BoycottItem(
    name: 'Puma',
    category: 'Clothing',
    accusation: 'Sponsoring Israeli football association teams in settlements.',
    color: Colors.indigo,
    icon: Icons.sports_soccer,
    website: 'puma.com',
    headquarters: 'Herzogenaurach, Germany',
    founded: '1948',
    ceo: 'Arne Freundt',
    description: 'German multinational corporation designing athletic and casual footwear.',
    alternatives: ['Nike alternatives', 'Adidas alternatives', 'Local brands'],
  ),
  BoycottItem(
    name: 'Siemens',
    category: 'Electronics',
    accusation: 'Involvement in illegal Israeli settlements.',
    color: Colors.teal,
    icon: Icons.devices,
    website: 'siemens.com',
    headquarters: 'Munich, Germany',
    founded: '1847',
    ceo: 'Roland Busch',
    description: 'German multinational conglomerate.',
    alternatives: ['Bosch', 'Schneider Electric', 'Eaton'],
  ),
  BoycottItem(
    name: 'L\'Oreal',
    category: 'Cosmetics',
    accusation: 'Operating factories in illegal settlements.',
    color: Colors.pink,
    icon: Icons.face_retouching_natural,
    website: 'loreal.com',
    headquarters: 'Clichy, France',
    founded: '1909',
    ceo: 'Jean-Paul Agon',
    description: 'French multinational cosmetics company.',
    alternatives: ['The Body Shop', 'Lush', 'Garnier'],
  ),
  BoycottItem(
    name: 'Intel',
    category: 'Electronics',
    accusation: 'Major chip manufacturing operations in Israel.',
    color: Colors.teal,
    icon: Icons.memory,
    website: 'intel.com',
    headquarters: 'Santa Clara, California, USA',
    founded: '1968',
    ceo: 'Pat Gelsinger',
    description: 'American multinational corporation and technology company.',
    alternatives: ['AMD', 'ARM processors', 'Apple Silicon'],
  ),
  BoycottItem(
    name: 'Dell',
    category: 'Electronics',
    accusation: 'Supplying the Israeli military.',
    color: Colors.teal,
    icon: Icons.computer,
    website: 'dell.com',
    headquarters: 'Round Rock, Texas, USA',
    founded: '1984',
    ceo: 'Michael Dell',
    description: 'American multinational technology company.',
    alternatives: ['HP alternatives', 'Lenovo', 'ASUS'],
  ),
  BoycottItem(
    name: 'Nokia',
    category: 'Electronics',
    accusation: 'Sponsoring Israeli military technology conferences.',
    color: Colors.teal,
    icon: Icons.devices,
    website: 'nokia.com',
    headquarters: 'Espoo, Finland',
    founded: '1865',
    ceo: 'Pekka Lundmark',
    description: 'Finnish multinational telecommunications, information technology, and consumer electronics company.',
    alternatives: ['Ericsson', 'Huawei', 'ZTE'],
  ),
  BoycottItem(
    name: 'Barclays Bank',
    category: 'Finance',
    accusation: 'Financing companies that produce military technology used against Palestinians.',
    color: Colors.blue,
    icon: Icons.account_balance,
    website: 'barclays.com',
    headquarters: 'London, UK',
    founded: '1690',
    ceo: 'Nandan Nilekani',
    description: 'British multinational investment bank.',
    alternatives: ['HSBC', 'Standard Chartered', 'Lloyds Bank'],
  ),
  BoycottItem(
    name: 'Carrefour',
    category: 'Food & Household',
    accusation: 'Involvement in illegal Israeli settlements.',
    color: Colors.green,
    icon: Icons.home,
    website: 'carrefour.com',
    headquarters: 'Boulogne-Billancourt, France',
    founded: '1959',
    ceo: 'Alexandre Bompard',
    description: 'French multinational retailer.',
    alternatives: ['Local supermarkets', 'Aldi', 'Lidl'],
  ),
  BoycottItem(
    name: 'SodaStream',
    category: 'Electronics',
    accusation: 'Exploiting local Bedouin community at its factory in the Negev Desert.',
    color: Colors.teal,
    icon: Icons.local_drink,
    website: 'sodastream.com',
    headquarters: 'Beit Haemek, Israel',
    founded: '2000',
    ceo: 'Daniel Birnbaum',
    description: 'Israeli company producing home carbonation systems.',
    alternatives: ['Local soda makers', 'Kombucha', 'Sparkling water'],
  ),
];

// Add category icon mapping
Map<String, IconData> _categoryIcons = {
  'Food': Icons.restaurant,
  'Beverage': Icons.local_drink,
  'Cosmetics': Icons.face_retouching_natural,
  'Electronics': Icons.devices,
  'Finance': Icons.account_balance,
  'Clothing': Icons.checkroom,
  'Food & Household': Icons.home,
  'Software': Icons.computer,
};

class BoycottPage extends StatefulWidget {
  const BoycottPage({super.key});

  @override
  State<BoycottPage> createState() => _BoycottPageState();
}

class _BoycottPageState extends State<BoycottPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = 'All';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    
    _searchController.addListener(() {
      setState(() {
        _query = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final categories = ['All', ...{for (var i in _boycottData) i.category}];
    final filtered = _boycottData.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = _query.isEmpty || 
          item.name.toLowerCase().contains(_query.toLowerCase()) || 
          item.category.toLowerCase().contains(_query.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colorScheme.surface,
              colorScheme.surface,
              colorScheme.errorContainer.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern App Bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton.filled(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      style: IconButton.styleFrom(
                        backgroundColor: colorScheme.surfaceVariant,
                        foregroundColor: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.block,
                                color: colorScheme.error,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Boycott List',
                                style: textTheme.headlineMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${filtered.length} brands to avoid',
                            style: textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: colorScheme.outline.withOpacity(0.2),
                    ),
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search brands or categories...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Category Chips with Icons
              SizedBox(
                height: 50,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category;
                    final icon = category == 'All' ? Icons.all_inclusive : _categoryIcons[category] ?? Icons.category;
                    
                    return FilterChip(
                      avatar: Icon(
                        icon,
                        size: 18,
                        color: isSelected 
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (_) {
                        setState(() => _selectedCategory = category);
                      },
                      backgroundColor: colorScheme.surfaceVariant,
                      selectedColor: colorScheme.primaryContainer,
                      labelStyle: TextStyle(
                        color: isSelected 
                            ? colorScheme.onPrimaryContainer
                            : colorScheme.onSurfaceVariant,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                      side: BorderSide(
                        color: isSelected 
                            ? colorScheme.primary
                            : colorScheme.outline.withOpacity(0.3),
                      ),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 16),
              
              // List
              Expanded(
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No brands found',
                                style: textTheme.titleMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Try adjusting your search or filter',
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final item = filtered[index];
                            return _buildModernListItem(context, item);
                          },
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernListItem(BuildContext context, BoycottItem item) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: InkWell(
        onTap: () => _showDetails(context, item),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      item.color.withOpacity(0.8),
                      item.color.withOpacity(0.6),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Icon(
                    item.icon,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
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
                            item.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            item.category,
                            style: textTheme.labelSmall?.copyWith(
                              color: item.color,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.accusation,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (item.brands != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.label_outline,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.brands!,
                              style: textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetails(BuildContext context, BoycottItem item) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      builder: (ctx) {
        final textTheme = Theme.of(ctx).textTheme;
        final colorScheme = Theme.of(ctx).colorScheme;
        
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.surface,
                    item.color.withOpacity(0.05),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        Container(
                          width: 64,
                          height: 64,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                item.color.withOpacity(0.8),
                                item.color.withOpacity(0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Icon(
                              item.icon,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: item.color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  item.category,
                                  style: textTheme.labelMedium?.copyWith(
                                    color: item.color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    if (item.description != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'About Company',
                                  style: textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(item.description!, style: textTheme.bodyMedium),
                          ],
                        ),
                      ),
                    ],
                    
                    // Company Info
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.business, color: colorScheme.primary, size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Company Information',
                                style: textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (item.headquarters != null)
                            _buildInfoRow(Icons.location_on, 'Headquarters', item.headquarters!, textTheme),
                          if (item.founded != null)
                            _buildInfoRow(Icons.calendar_today, 'Founded', item.founded!, textTheme),
                          if (item.ceo != null)
                            _buildInfoRow(Icons.person, 'CEO', item.ceo!, textTheme),
                          if (item.website != null)
                            _buildWebsiteRow(item.website!, textTheme, colorScheme),
                        ],
                      ),
                    ),
                    
                    // Boycott Reason
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.errorContainer.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: colorScheme.error.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                color: colorScheme.error,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Reason for Boycott',
                                style: textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.error,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            item.accusation,
                            style: textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Related Brands
                    if (item.brands != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.label_outline,
                                  color: colorScheme.primary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Related Brands',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              item.brands!,
                              style: textTheme.bodyMedium?.copyWith(
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    // Alternatives
                    if (item.alternatives != null) ...[
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiaryContainer.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: colorScheme.tertiary.withOpacity(0.3),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.thumb_up_outlined,
                                  color: colorScheme.tertiary,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Alternatives',
                                  style: textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: colorScheme.tertiary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: item.alternatives!.map((alt) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: colorScheme.tertiary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: colorScheme.tertiary.withOpacity(0.3)),
                                  ),
                                  child: Text(
                                    alt,
                                    style: textTheme.bodySmall?.copyWith(
                                      color: colorScheme.tertiary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    ],
                    
                    const SizedBox(height: 32),
                    FilledButton(
                      onPressed: () => Navigator.pop(ctx),
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebsiteRow(String website, TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(Icons.language, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            'Website: ',
            style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () async {
                final url = Uri.parse('https://$website');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url);
                }
              },
              child: Text(
                website,
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 