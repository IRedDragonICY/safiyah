import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui' as ui;

import '../../../core/constants/colors.dart';
import '../../../data/models/dhikr_model.dart';

class DhikrPage extends StatefulWidget {
  const DhikrPage({super.key});

  @override
  State<DhikrPage> createState() => _DhikrPageState();
}

class _DhikrPageState extends State<DhikrPage> with TickerProviderStateMixin {
  late TabController _tabController;
  DhikrCategory _selectedCategory = DhikrCategory.morning;
  int _currentCount = 0;
  int _targetCount = 33;
  bool _isCounterMode = false;

  // Settings
  DhikrSettings _settings = DhikrSettings(
    textSize: 18.0,
    showArabic: true,
    showTransliteration: true,
    showTranslation: true,
    autoPlayAudio: false,
    hapticFeedback: true,
    nightMode: false,
    counterDirection: CounterDirection.increment,
    showProgress: true,
  );

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
              child: _isCounterMode ? _buildCounterMode() : TabBarView(
                controller: _tabController,
                children: [_buildCategoriesTab(), _buildBrowseTab(), _buildFavoritesTab()],
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
                      Colors.purple.shade600,
                      Colors.purple.shade600.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.purple.shade600.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.auto_fix_high_rounded,
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
                      'Dzikir & Doa',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      'Remember Allah with devotion',
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
                    _isCounterMode ? 'List' : 'Counter',
                    _isCounterMode ? Icons.list_rounded : Icons.add_circle_rounded,
                    () => setState(() => _isCounterMode = !_isCounterMode),
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
          
          // Tab Bar (only show when not in counter mode)
          if (!_isCounterMode) ...[
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(24),
              ),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.purple.shade600,
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: Colors.purple.shade600,
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
                        Icon(Icons.category_rounded, size: 14),
                        const SizedBox(width: 4),
                        Text('Types'),
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
        ],
      ),
    );
  }

  Widget _buildHeaderActionButton(String label, IconData icon, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.purple.shade600.withValues(alpha: 0.2),
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
                color: Colors.purple.shade600,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.purple.shade600,
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
                            Colors.purple.shade600,
                            Colors.purple.shade600.withValues(alpha: 0.8),
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
                            'Dhikr Settings',
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Customize your dhikr experience',
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
                          36.0,
                          (value) => setState(() => _settings = _settings.copyWith(textSize: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Arabic Text',
                          'Display dhikr in Arabic script',
                          _settings.showArabic,
                          (value) => setState(() => _settings = _settings.copyWith(showArabic: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Transliteration',
                          'Display pronunciation guide',
                          _settings.showTransliteration,
                          (value) => setState(() => _settings = _settings.copyWith(showTransliteration: value)),
                        ),
                        _buildSwitchSetting(
                          'Show Translation',
                          'Display meaning in your language',
                          _settings.showTranslation,
                          (value) => setState(() => _settings = _settings.copyWith(showTranslation: value)),
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
                      'Counter Settings',
                      Icons.add_circle_outline_rounded,
                      [
                        _buildDropdownSetting(
                          'Counter Direction',
                          _getCounterDirectionName(_settings.counterDirection),
                          CounterDirection.values.map((dir) => _getCounterDirectionName(dir)).toList(),
                          (value) {
                            final direction = CounterDirection.values.firstWhere(
                              (dir) => _getCounterDirectionName(dir) == value,
                            );
                            setState(() => _settings = _settings.copyWith(counterDirection: direction));
                          },
                        ),
                        _buildSwitchSetting(
                          'Show Progress',
                          'Display circular progress indicator',
                          _settings.showProgress,
                          (value) => setState(() => _settings = _settings.copyWith(showProgress: value)),
                        ),
                        _buildSwitchSetting(
                          'Haptic Feedback',
                          'Vibrate on each count',
                          _settings.hapticFeedback,
                          (value) => setState(() => _settings = _settings.copyWith(hapticFeedback: value)),
                        ),
                      ],
                    ),
                    
                    _buildSettingSection(
                      'Audio Settings',
                      Icons.volume_up_rounded,
                      [
                        _buildSwitchSetting(
                          'Auto-play Audio',
                          'Automatically play pronunciation',
                          _settings.autoPlayAudio,
                          (value) => setState(() => _settings = _settings.copyWith(autoPlayAudio: value)),
                        ),
                        _buildInfoRow('Audio Quality', 'High Definition', Colors.green),
                        _buildInfoRow('Voice', 'Sheikh Abdul Rahman', Colors.blue),
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
                Icon(icon, color: Colors.purple.shade600, size: 24),
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
            activeColor: Colors.purple.shade600,
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
                  color: Colors.purple.shade600.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${value.round()}px',
                  style: TextStyle(
                    color: Colors.purple.shade600,
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
              activeTrackColor: Colors.purple.shade600,
              inactiveTrackColor: Colors.purple.shade600.withValues(alpha: 0.2),
              thumbColor: Colors.purple.shade600,
              overlayColor: Colors.purple.shade600.withValues(alpha: 0.2),
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: 12,
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
                  color: Colors.purple.shade600,
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

  String _getCounterDirectionName(CounterDirection direction) {
    switch (direction) {
      case CounterDirection.increment:
        return 'Count Up (0 → Target)';
      case CounterDirection.decrement:
        return 'Count Down (Target → 0)';
    }
  }

  Widget _buildCounterMode() {
    final progress = _currentCount / _targetCount;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Text('Dhikr Counter', style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple.shade600),
                  ),
                  const SizedBox(height: 16),
                  Text('$_currentCount / $_targetCount', 
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.purple.shade600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.purple.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.purple.shade200),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _incrementCounter,
                  borderRadius: BorderRadius.circular(16),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.touch_app, size: 64, color: Colors.purple),
                        SizedBox(height: 16),
                        Text('Tap to Count', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('سُبْحَانَ اللَّهِ', style: TextStyle(fontSize: 32, fontFamily: 'Arabic')),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _resetCounter,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Reset'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _setTarget,
                  icon: const Icon(Icons.flag),
                  label: const Text('Set Target'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.purple.shade600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesTab() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
      ),
      itemCount: DhikrCategory.values.length,
      itemBuilder: (context, index) {
        final category = DhikrCategory.values[index];
        return Card(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedCategory = category;
                _tabController.animateTo(1);
              });
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(_getCategoryIcon(category), size: 32, color: Colors.purple.shade600),
                  const SizedBox(height: 8),
                  Text(_getCategoryName(category), 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                  Text('${_getCategoryCount(category)} dzikir', 
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                ],
              ),
            ),
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
          child: DropdownButtonFormField<DhikrCategory>(
            value: _selectedCategory,
            decoration: const InputDecoration(
              labelText: 'Category',
              border: OutlineInputBorder(),
            ),
            items: DhikrCategory.values.map((category) {
              return DropdownMenuItem(
                value: category,
                child: Text(_getCategoryName(category)),
              );
            }).toList(),
            onChanged: (value) => setState(() => _selectedCategory = value!),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: 10,
            itemBuilder: (context, index) => _buildDhikrCard(_getSampleDhikr(index)),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: 5,
      itemBuilder: (context, index) => _buildDhikrCard(_getSampleDhikr(index, isFavorite: true)),
    );
  }

  Widget _buildDhikrCard(DhikrModel dhikr) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(dhikr.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                IconButton(
                  icon: Icon(dhikr.isFavorite ? Icons.favorite : Icons.favorite_border),
                  onPressed: () => _toggleFavorite(dhikr),
                ),
                IconButton(
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => _playAudio(dhikr),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(dhikr.arabicText, 
                style: const TextStyle(fontSize: 20, fontFamily: 'Arabic'),
                textAlign: TextAlign.center, textDirection: ui.TextDirection.rtl),
            ),
            const SizedBox(height: 8),
            Text(dhikr.transliteration, style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey.shade600)),
            const SizedBox(height: 8),
            Text(dhikr.translation, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text('${dhikr.recommendedCount}x', 
                    style: TextStyle(color: Colors.purple.shade600, fontWeight: FontWeight.bold)),
                ),
                const Spacer(),
                Text(dhikr.source, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(DhikrCategory category) {
    switch (category) {
      case DhikrCategory.morning: return Icons.wb_sunny;
      case DhikrCategory.evening: return Icons.nights_stay;
      case DhikrCategory.afterPrayer: return Icons.mosque;
      case DhikrCategory.beforeSleep: return Icons.bed;
      case DhikrCategory.protection: return Icons.shield;
      default: return Icons.favorite;
    }
  }

  String _getCategoryName(DhikrCategory category) {
    switch (category) {
      case DhikrCategory.morning: return 'Morning';
      case DhikrCategory.evening: return 'Evening';
      case DhikrCategory.afterPrayer: return 'After Prayer';
      case DhikrCategory.beforeSleep: return 'Before Sleep';
      case DhikrCategory.protection: return 'Protection';
      case DhikrCategory.forgiveness: return 'Forgiveness';
      case DhikrCategory.gratitude: return 'Gratitude';
      default: return 'General';
    }
  }

  int _getCategoryCount(DhikrCategory category) => 10;

  DhikrModel _getSampleDhikr(int index, {bool isFavorite = false}) {
    return DhikrModel(
      id: 'dhikr_$index',
      title: 'Tasbih',
      arabicText: 'سُبْحَانَ اللَّهِ',
      transliteration: 'Subhanallah',
      translation: 'Glory be to Allah',
      meaning: 'Glorifying Allah and acknowledging His perfection',
      category: _selectedCategory,
      recommendedCount: 33,
      source: 'Quran & Sunnah',
      benefits: 'Brings peace and remembrance of Allah',
      occasions: ['morning', 'evening', 'after prayer'],
      audioUrl: '',
      isFavorite: isFavorite,
    );
  }

  void _incrementCounter() {
    setState(() => _currentCount++);
    HapticFeedback.lightImpact();
    if (_currentCount >= _targetCount) {
      _showCompletionDialog();
    }
  }

  void _resetCounter() => setState(() => _currentCount = 0);

  void _setTarget() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Set Target'),
        content: TextField(
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Target Count'),
          onSubmitted: (value) {
            setState(() => _targetCount = int.tryParse(value) ?? 33);
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Congratulations!'),
        content: Text('You have completed $_targetCount dhikr!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Continue'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _resetCounter();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(DhikrModel dhikr) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(dhikr.isFavorite ? 'Removed from favorites' : 'Added to favorites')),
    );
  }

  void _playAudio(DhikrModel dhikr) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Playing audio...')),
    );
  }
} 