import 'package:flutter/material.dart';
import 'dart:ui' as ui;

import '../../../data/models/hadith_model.dart';

class HadithPage extends StatefulWidget {
  const HadithPage({super.key});

  @override
  State<HadithPage> createState() => _HadithPageState();
}

class _HadithPageState extends State<HadithPage> with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedCollection = 'Sahih Bukhari';
  String _selectedGrade = 'All';
  final TextEditingController _searchController = TextEditingController();
  bool _showFavorites = false;

  // Settings
  HadithSettings _settings = HadithSettings(
    textSize: 16.0,
    showArabic: true,
    showEnglish: true,
    showIndonesian: true,
    showNarrator: true,
    showChain: false,
    showGrade: true,
    nightMode: false,
    preferredTranslation: 'English',
    autoScroll: false,
  );

  final List<String> _collections = [
    'Sahih Bukhari',
    'Sahih Muslim',
    'Sunan Abu Dawood',
    'Jami` at-Tirmidhi',
    'Sunan an-Nasa\'i',
    'Sunan Ibn Majah',
    'Muwatta Malik',
    'Musnad Ahmad',
  ];

  final List<String> _grades = [
    'All',
    'Sahih',
    'Hasan',
    'Daif',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Modern Header
            _buildModernHeader(),
            
            // Main Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildCollectionsTab(),
                  _buildBrowseTab(),
                  _buildSearchTab(),
                  _buildFavoritesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surfaceContainerLow,
          ],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header Title and Actions
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.orange.shade600,
                      Colors.orange.shade600.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.shade600.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.import_contacts_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hadith Collection',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Authentic sayings of Prophet ﷺ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Action Buttons
              Row(
                children: [
                  _buildHeaderActionButton(
                    'Favorites',
                    _showFavorites ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                    () => setState(() => _showFavorites = !_showFavorites),
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderActionButton(
                    'Settings',
                    Icons.settings_rounded,
                    () => _showSettings(),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Tab Bar
          Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(24),
            ),
            child: TabBar(
              controller: _tabController,
              indicatorColor: Colors.transparent,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.orange.shade600,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.orange.shade600,
                borderRadius: BorderRadius.circular(24),
              ),
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 10,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 10,
              ),
              tabs: [
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.library_books_rounded, size: 14),
                      const SizedBox(width: 4),
                      Text('Books'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.list_rounded, size: 14),
                      const SizedBox(width: 4),
                      Text('Browse'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.search_rounded, size: 14),
                      const SizedBox(width: 4),
                      Text('Search'),
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_rounded, size: 14),
                      const SizedBox(width: 4),
                      Text('Saved'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton(String label, IconData icon, VoidCallback onTap) {
    final isActive = (label == 'Favorites' && _showFavorites);
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive 
                ? Colors.orange.shade600
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.orange.shade600.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: isActive 
                    ? Colors.white
                    : Colors.orange.shade600,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isActive 
                      ? Colors.white
                      : Colors.orange.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildSettingsModal(),
    );
  }

  Widget _buildSettingsModal() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.5,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Header
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.orange.shade600,
                            Colors.orange.shade600.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.settings_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hadith Settings',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Customize your reading experience',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              // Settings content
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  children: [
                    _buildSettingSection(
                      'Display Settings',
                      Icons.display_settings_rounded,
                      [
                        _buildSliderSetting(
                          'Text Size',
                          _settings.textSize,
                          12.0,
                          28.0,
                          (value) => setState(() => _settings = _settings.copyWith(textSize: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Arabic Text',
                          'Display hadith in original Arabic',
                          _settings.showArabic,
                          (value) => setState(() => _settings = _settings.copyWith(showArabic: value)),
                        ),
                        _buildSwitchSetting(
                          'Show English Translation',
                          'Display English translation',
                          _settings.showEnglish,
                          (value) => setState(() => _settings = _settings.copyWith(showEnglish: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Indonesian Translation',
                          'Display Indonesian translation',
                          _settings.showIndonesian,
                          (value) => setState(() => _settings = _settings.copyWith(showIndonesian: value)),
                        ),
                        _buildSwitchSetting(
                          'Night Mode',
                          'Dark theme for comfortable reading',
                          _settings.nightMode,
                          (value) => setState(() => _settings = _settings.copyWith(nightMode: value)),
                        ),
                      ],
                    ),
                    
                    _buildSettingSection(
                      'Hadith Information',
                      Icons.info_outline_rounded,
                      [
                        _buildSwitchSetting(
                          'Show Narrator',
                          'Display hadith narrator information',
                          _settings.showNarrator,
                          (value) => setState(() => _settings = _settings.copyWith(showNarrator: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Chain of Transmission',
                          'Display sanad (chain of narrators)',
                          _settings.showChain,
                          (value) => setState(() => _settings = _settings.copyWith(showChain: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Grade',
                          'Display hadith authenticity grade',
                          _settings.showGrade,
                          (value) => setState(() => _settings = _settings.copyWith(showGrade: value)),
                        ),
                      ],
                    ),
                    
                    _buildSettingSection(
                      'Reading Features',
                      Icons.auto_stories_rounded,
                      [
                        _buildDropdownSetting(
                          'Preferred Translation',
                          _settings.preferredTranslation,
                          ['English', 'Indonesian', 'Both'],
                          (value) {
                            if (value != null) {
                              setState(() => _settings = _settings.copyWith(preferredTranslation: value));
                            }
                          },
                        ),
                        _buildSwitchSetting(
                          'Auto Scroll',
                          'Automatically scroll through hadith',
                          _settings.autoScroll,
                          (value) => setState(() => _settings = _settings.copyWith(autoScroll: value)),
                        ),
                        _buildInfoRow('Collection Focus', _selectedCollection, Colors.blue),
                        _buildInfoRow('Grade Filter', _selectedGrade, Colors.green),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingSection(String title, IconData icon, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(icon, color: Colors.orange.shade600, size: 24),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSwitchSetting(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.orange.shade600,
          ),
        ],
      ),
    );
  }

  Widget _buildSliderSetting(String title, double value, double min, double max, Function(double) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${value.round()}px',
                  style: TextStyle(
                    color: Colors.orange.shade600,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: Colors.orange.shade600,
              inactiveTrackColor: Colors.orange.shade600.withValues(alpha: 0.2),
              thumbColor: Colors.orange.shade600,
              overlayColor: Colors.orange.shade600.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: 8,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(String title, String value, List<String> options, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.orange.shade600,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            items: options.map((option) {
              return DropdownMenuItem(
                value: option,
                child: Text(option),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _collections.length,
      itemBuilder: (context, index) {
        final collection = _collections[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.import_contacts,
                color: Colors.orange.shade600,
              ),
            ),
            title: Text(
              collection,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(_getCollectionInfo(collection)),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _getHadithCount(collection),
                  style: TextStyle(
                    color: Colors.orange.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Hadith', style: TextStyle(fontSize: 12)),
              ],
            ),
            onTap: () {
              setState(() {
                _selectedCollection = collection;
                _tabController.animateTo(1);
              });
            },
          ),
        );
      },
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Collection: $_selectedCollection',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedCollection,
                      decoration: const InputDecoration(
                        labelText: 'Collection',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _collections.map((collection) {
                        return DropdownMenuItem(
                          value: collection,
                          child: Text(collection),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedCollection = value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: _selectedGrade,
                      decoration: const InputDecoration(
                        labelText: 'Grade',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      ),
                      items: _grades.map((grade) {
                        return DropdownMenuItem(
                          value: grade,
                          child: Text(grade),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGrade = value);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 20, // Sample count
            itemBuilder: (context, index) {
              return _buildHadithCard(_getSampleHadith(index));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchTab() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search Hadith',
              hintText: 'Search by text, narrator, or theme',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => _searchController.clear(),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onSubmitted: (value) => _performSearch(value),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              'Prayer',
              'Charity',
              'Faith',
              'Paradise',
              'Purification',
              'Knowledge',
            ].map((theme) => FilterChip(
              label: Text(theme),
              onSelected: (selected) {
                if (selected) {
                  _searchController.text = theme;
                  _performSearch(theme);
                }
              },
            )).toList(),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _searchController.text.isEmpty
                ? const Center(
                    child: Text('Enter search terms to find relevant hadith'),
                  )
                : ListView.builder(
                    itemCount: 10, // Sample search results
                    itemBuilder: (context, index) {
                      return _buildHadithCard(_getSampleHadith(index));
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5, // Sample favorite hadith count
      itemBuilder: (context, index) {
        return _buildHadithCard(_getSampleHadith(index, isFavorite: true));
      },
    );
  }

  Widget _buildHadithCard(HadithModel hadith) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
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
                    color: _getGradeColor(hadith.grade),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    hadith.grade,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${hadith.collection} ${hadith.number}',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(
                    hadith.isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: hadith.isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () => _toggleFavorite(hadith),
                ),
                IconButton(
                  icon: const Icon(Icons.share),
                  onPressed: () => _shareHadith(hadith),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Text(
                hadith.arabicText,
                style: const TextStyle(
                  fontSize: 18,
                  fontFamily: 'Arabic',
                  height: 1.8,
                ),
                textAlign: TextAlign.right,
                textDirection: ui.TextDirection.rtl,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              hadith.englishText,
              style: const TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              hadith.indonesianText,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade700,
                fontStyle: FontStyle.italic,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Narrator: ${hadith.narrator}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (hadith.chain.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Chain: ${hadith.chain}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (hadith.themes.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: hadith.themes.map((theme) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    theme,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.orange.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toLowerCase()) {
      case 'sahih':
        return Colors.green;
      case 'hasan':
        return Colors.orange;
      case 'daif':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  String _getCollectionInfo(String collection) {
    switch (collection) {
      case 'Sahih Bukhari':
        return 'Compiled by Imam Bukhari (810-870 CE)';
      case 'Sahih Muslim':
        return 'Compiled by Imam Muslim (815-875 CE)';
      case 'Sunan Abu Dawood':
        return 'Compiled by Abu Dawood (817-889 CE)';
      case 'Jami` at-Tirmidhi':
        return 'Compiled by At-Tirmidhi (824-892 CE)';
      case 'Sunan an-Nasa\'i':
        return 'Compiled by An-Nasa\'i (829-915 CE)';
      case 'Sunan Ibn Majah':
        return 'Compiled by Ibn Majah (829-887 CE)';
      case 'Muwatta Malik':
        return 'Compiled by Imam Malik (711-795 CE)';
      case 'Musnad Ahmad':
        return 'Compiled by Ahmad ibn Hanbal (780-855 CE)';
      default:
        return 'Islamic hadith collection';
    }
  }

  String _getHadithCount(String collection) {
    switch (collection) {
      case 'Sahih Bukhari':
        return '7,563';
      case 'Sahih Muslim':
        return '4,000';
      case 'Sunan Abu Dawood':
        return '4,800';
      case 'Jami` at-Tirmidhi':
        return '3,956';
      case 'Sunan an-Nasa\'i':
        return '5,761';
      case 'Sunan Ibn Majah':
        return '4,341';
      case 'Muwatta Malik':
        return '1,720';
      case 'Musnad Ahmad':
        return '27,000+';
      default:
        return '1,000+';
    }
  }

  HadithModel _getSampleHadith(int index, {bool isFavorite = false}) {
    final sampleHadith = [
      {
        'arabic': 'إِنَّمَا الْأَعْمَالُ بِالنِّيَّاتِ، وَإِنَّمَا لِكُلِّ امْرِئٍ مَا نَوَى',
        'english': 'Actions are but by intention and every man shall have but that which he intended.',
        'indonesian': 'Sesungguhnya amal perbuatan tergantung pada niatnya, dan sesungguhnya setiap orang (akan dibalas) berdasarkan apa yang dia niatkan.',
        'narrator': 'Umar ibn al-Khattab',
        'themes': ['Intention', 'Actions', 'Faith'],
      },
      {
        'arabic': 'مَنْ كَانَ يُؤْمِنُ بِاللَّهِ وَالْيَوْمِ الْآخِرِ فَلْيَقُلْ خَيْرًا أَوْ لِيَصْمُتْ',
        'english': 'Whoever believes in Allah and the Last Day should speak a good word or remain silent.',
        'indonesian': 'Barangsiapa yang beriman kepada Allah dan hari akhir, hendaklah ia berkata baik atau diam.',
        'narrator': 'Abu Hurairah',
        'themes': ['Speech', 'Manners', 'Faith'],
      },
      {
        'arabic': 'الدِّينُ النَّصِيحَةُ',
        'english': 'Religion is advice (sincere counsel).',
        'indonesian': 'Agama adalah nasihat.',
        'narrator': 'Tamim ibn Aws',
        'themes': ['Advice', 'Religion', 'Community'],
      },
    ];

    final hadithData = sampleHadith[index % sampleHadith.length];
    
    return HadithModel(
      id: 'hadith_$index',
      collection: _selectedCollection,
      book: 'Book of Faith',
      number: index + 1,
      arabicText: hadithData['arabic']! as String,
      englishText: hadithData['english']! as String,
      indonesianText: hadithData['indonesian']! as String,
      narrator: hadithData['narrator']! as String,
      chain: 'A reliable chain of narrators',
      grade: index % 4 == 0 ? 'Sahih' : index % 3 == 0 ? 'Hasan' : 'Sahih',
      keywords: ['faith', 'belief', 'practice'],
      themes: List<String>.from(hadithData['themes'] as List),
      reference: '$_selectedCollection ${index + 1}',
      isFavorite: isFavorite,
    );
  }

  void _performSearch(String query) {
    setState(() {
      // Implement search logic
    });
  }

  void _toggleFavorite(HadithModel hadith) {
    setState(() {
      // Toggle favorite status
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hadith.isFavorite 
              ? 'Removed from favorites' 
              : 'Added to favorites',
        ),
      ),
    );
  }

  void _shareHadith(HadithModel hadith) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Hadith shared successfully'),
      ),
    );
  }
} 