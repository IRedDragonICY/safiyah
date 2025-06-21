import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../data/models/quran_model.dart';
import 'dart:ui' as ui;

class SurahInfoPage extends StatefulWidget {
  final SurahInfo surahInfo;

  const SurahInfoPage({super.key, required this.surahInfo});

  @override
  State<SurahInfoPage> createState() => _SurahInfoPageState();
}

class _SurahInfoPageState extends State<SurahInfoPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _headerAnimationController;
  late Animation<double> _headerAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _headerAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerAnimationController,
      curve: Curves.easeInOut,
    );
    _headerAnimationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _headerAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(),
            _buildSliverTabBar(),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildOverviewTab(),
            _buildHistoryTab(),
            _buildThemesTab(),
            _buildStatisticsTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 320,
      pinned: true,
      stretch: true,
      backgroundColor: Theme.of(context).primaryColor,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [
          StretchMode.zoomBackground,
          StretchMode.blurBackground,
        ],
        background: FadeTransition(
          opacity: _headerAnimation,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).primaryColor,
                  Theme.of(context).primaryColor.withValues(alpha: 0.9),
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
            ),
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    
                    // Decorative Islamic pattern
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, -0.5),
                        end: Offset.zero,
                      ).animate(_headerAnimation),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.auto_stories_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Arabic Name
                    ScaleTransition(
                      scale: _headerAnimation,
                      child: Text(
                        widget.surahInfo.nameArabic,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiri',
                          shadows: [
                            Shadow(
                              offset: Offset(0, 2),
                              blurRadius: 8,
                              color: Colors.black38,
                            ),
                          ],
                        ),
                        textDirection: ui.TextDirection.rtl,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // English Name
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(_headerAnimation),
                      child: Text(
                        widget.surahInfo.nameEnglish,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(0, 1),
                              blurRadius: 4,
                              color: Colors.black26,
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Transliteration
                    FadeTransition(
                      opacity: _headerAnimation,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          widget.surahInfo.nameTransliteration,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.95),
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () => _shareSurahInfo(),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.bookmark_add_rounded, color: Colors.white),
            onPressed: () => _addToBookmarks(),
          ),
        ),
      ],
    );
  }

  Widget _buildSliverTabBar() {
    return SliverPersistentHeader(
      delegate: _StickyTabBarDelegate(
        TabBar(
          controller: _tabController,
          labelColor: Theme.of(context).primaryColor,
          unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
          indicatorColor: Theme.of(context).primaryColor,
          indicatorWeight: 3,
          indicatorSize: TabBarIndicatorSize.label,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          tabs: const [
            Tab(
              icon: Icon(Icons.info_outline_rounded, size: 20),
              text: 'Overview',
            ),
            Tab(
              icon: Icon(Icons.history_edu_rounded, size: 20),
              text: 'History',
            ),
            Tab(
              icon: Icon(Icons.lightbulb_outline_rounded, size: 20),
              text: 'Themes',
            ),
            Tab(
              icon: Icon(Icons.analytics_outlined, size: 20),
              text: 'Statistics',
            ),
          ],
        ),
      ),
      pinned: true,
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Quick Stats Cards
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Number',
                  '${widget.surahInfo.number}',
                  Icons.numbers_rounded,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Ayahs',
                  '${widget.surahInfo.ayahCount}',
                  Icons.format_list_numbered_rounded,
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Juz',
                  '${widget.surahInfo.juzNumber}',
                  Icons.book_rounded,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Ruku',
                  '${widget.surahInfo.rukuCount}',
                  Icons.bookmark_rounded,
                  Colors.purple,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Revelation Information
          _buildInfoSection(
            'Revelation Information',
            Icons.place_rounded,
            [
              _buildInfoItem('Type', widget.surahInfo.revelationType, 
                  widget.surahInfo.revelationType == 'Meccan' ? Colors.orange : Colors.green),
              _buildInfoItem('Order', '${widget.surahInfo.revelationOrder}', Colors.blue),
              _buildInfoItem('Period', widget.surahInfo.period, Colors.purple),
              _buildInfoItem('Hizb', '${widget.surahInfo.hizbNumber}', Colors.indigo),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Main Theme
          _buildInfoSection(
            'Main Theme',
            Icons.lightbulb_outline_rounded,
            [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).primaryColor.withValues(alpha: 0.1),
                      Theme.of(context).primaryColor.withValues(alpha: 0.05),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  widget.surahInfo.mainTheme,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).primaryColor,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Description
          _buildInfoSection(
            'Description',
            Icons.description_outlined,
            [
              Text(
                widget.surahInfo.description,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          // Key Topics
          _buildInfoSection(
            'Key Topics',
            Icons.topic_outlined,
            [
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: widget.surahInfo.keyTopics.map((topic) => 
                  _buildTopicChip(topic)
                ).toList(),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _startReading(),
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start Reading'),
                  style: _buildButtonStyle(Theme.of(context).primaryColor),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _addToBookmarks(),
                  icon: const Icon(Icons.bookmark_add_rounded),
                  label: const Text('Bookmark'),
                  style: _buildOutlinedButtonStyle(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            'Historical Context',
            Icons.history_edu_rounded,
            [
              Text(
                widget.surahInfo.background,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.7,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildInfoSection(
            'Detailed Historical Information',
            Icons.timeline_rounded,
            [
              _buildHistoryCard(
                'Revelation Period',
                _getRevelationPeriodDetails(),
                Icons.calendar_today_rounded,
                Colors.blue,
              ),
              const SizedBox(height: 16),
              _buildHistoryCard(
                'Historical Significance',
                _getHistoricalSignificance(),
                Icons.star_rounded,
                Colors.amber,
              ),
              const SizedBox(height: 16),
              _buildHistoryCard(
                'Related Events',
                _getRelatedEvents(),
                Icons.event_rounded,
                Colors.green,
              ),
              const SizedBox(height: 16),
              _buildHistoryCard(
                'Impact & Influence',
                _getImpactAndInfluence(),
                Icons.waves_rounded,
                Colors.purple,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThemesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            'Central Themes',
            Icons.lightbulb_outline_rounded,
            [
              ...widget.surahInfo.keyTopics.map((topic) => 
                _buildThemeCard(topic, _getThemeDescription(topic))
              ).toList(),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildInfoSection(
            'Moral Lessons',
            Icons.school_rounded,
            [
              _buildMoralLessonCard(
                'Spiritual Guidance',
                _getSpiritualGuidance(),
                Icons.self_improvement_rounded,
                Colors.indigo,
              ),
              const SizedBox(height: 16),
              _buildMoralLessonCard(
                'Life Principles',
                _getLifePrinciples(),
                Icons.psychology_rounded,
                Colors.teal,
              ),
              const SizedBox(height: 16),
              _buildMoralLessonCard(
                'Social Values',
                _getSocialValues(),
                Icons.groups_rounded,
                Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoSection(
            'Structural Information',
            Icons.analytics_outlined,
            [
              _buildStatisticCard('Words', _getWordCount(), Icons.text_fields_rounded, Colors.blue),
              const SizedBox(height: 12),
              _buildStatisticCard('Letters', _getLetterCount(), Icons.font_download_rounded, Colors.green),
              const SizedBox(height: 12),
              _buildStatisticCard('Reading Time', _getReadingTime(), Icons.schedule_rounded, Colors.orange),
              const SizedBox(height: 12),
              _buildStatisticCard('Memorization Time', _getMemorizationTime(), Icons.psychology_rounded, Colors.purple),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildInfoSection(
            'Comparative Analysis',
            Icons.compare_arrows_rounded,
            [
              _buildComparisonCard(),
            ],
          ),
          
          const SizedBox(height: 24),
          
          _buildInfoSection(
            'Educational Information',
            Icons.school_rounded,
            [
              _buildEducationalCard(),
            ],
          ),
        ],
      ),
    );
  }

  // Helper method implementations continue...
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withValues(alpha: 0.12),
            color.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.08),
            spreadRadius: 0,
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 100,
            child: Text(
              '$label:',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.15),
            Theme.of(context).primaryColor.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.4),
          width: 1.5,
        ),
      ),
      child: Text(
        topic,
        style: TextStyle(
          color: Theme.of(context).primaryColor,
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.3,
        ),
      ),
    );
  }

  // Continue with remaining helper methods...
  ButtonStyle _buildButtonStyle(Color color) {
    return FilledButton.styleFrom(
      backgroundColor: color,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 4,
      shadowColor: color.withValues(alpha: 0.4),
    );
  }

  ButtonStyle _buildOutlinedButtonStyle() {
    return OutlinedButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 16),
      side: BorderSide(
        color: Theme.of(context).primaryColor,
        width: 2,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      foregroundColor: Theme.of(context).primaryColor,
    );
  }

  // Data methods
  String _getRevelationPeriodDetails() {
    if (widget.surahInfo.revelationType == 'Meccan') {
      return 'Revealed in Mecca during the early period of Prophet Muhammad\'s mission (610-622 CE). This period focused on establishing the foundations of Islamic belief, monotheism, and moral principles. The Meccan verses typically address the fundamental aspects of faith, the afterlife, and social justice.';
    } else {
      return 'Revealed in Medina after the Hijra (622-632 CE). This period focused on building the Muslim community, establishing Islamic law, and addressing practical matters of governance, family relations, and social organization. The Medinan verses often contain detailed guidance for community life.';
    }
  }

  String _getHistoricalSignificance() {
    return 'This Surah holds significant historical importance in the development of Islamic thought and practice. It was revealed during a crucial period that shaped the Muslim community\'s understanding of faith, morality, and social responsibility. The teachings within have influenced Islamic jurisprudence, ethics, and spiritual development for over 1400 years.';
  }

  String _getRelatedEvents() {
    return 'The revelation of this Surah is connected to specific historical events and circumstances that the early Muslim community faced. These events provided context for the divine guidance and helped establish principles that continue to guide Muslims today in similar situations.';
  }

  String _getImpactAndInfluence() {
    return 'This Surah has had a profound impact on Islamic civilization, influencing art, literature, law, and social structures. Its teachings have been studied by scholars throughout history and continue to provide guidance for contemporary issues. The moral and spiritual principles contained within have shaped the character of Muslim societies across different cultures and time periods.';
  }

  String _getThemeDescription(String theme) {
    // This would contain detailed descriptions for each theme
    return 'This theme explores fundamental aspects of Islamic belief and practice, providing guidance for both spiritual development and practical life matters. The verses related to this theme offer profound insights into the nature of existence, human purpose, and the path to spiritual fulfillment.';
  }

  String _getSpiritualGuidance() {
    return 'The Surah provides comprehensive spiritual guidance, teaching believers how to develop a closer relationship with Allah, purify their hearts, and achieve spiritual excellence. It emphasizes the importance of regular worship, remembrance of Allah, and following the prophetic example.';
  }

  String _getLifePrinciples() {
    return 'Key life principles include honesty, justice, compassion, patience, and perseverance. The Surah teaches believers how to navigate life\'s challenges while maintaining their moral integrity and spiritual values. It emphasizes the importance of balance between worldly responsibilities and spiritual obligations.';
  }

  String _getSocialValues() {
    return 'The Surah promotes social cohesion through teachings about family relationships, community responsibility, justice, and mutual support. It emphasizes the importance of caring for the less fortunate, maintaining social bonds, and working towards the betterment of society as a whole.';
  }

  String _getWordCount() {
    // Estimated word count based on surah length
    return '${widget.surahInfo.ayahCount * 10}';
  }

  String _getLetterCount() {
    // Estimated letter count
    return '${widget.surahInfo.ayahCount * 50}';
  }

  String _getReadingTime() {
    // Estimated reading time
    final minutes = (widget.surahInfo.ayahCount * 0.5).round();
    return '$minutes minutes';
  }

  String _getMemorizationTime() {
    // Estimated memorization time
    final days = (widget.surahInfo.ayahCount * 0.3).round();
    return '$days days';
  }

  Widget _buildHistoryCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String theme, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.08),
            Theme.of(context).primaryColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            theme,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).primaryColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoralLessonCard(String title, String content, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.surfaceContainerHigh,
            Theme.of(context).colorScheme.surfaceContainer,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Compared to other Surahs',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          _buildComparisonRow('Length', 'Medium', widget.surahInfo.ayahCount > 50 ? 'Long' : widget.surahInfo.ayahCount > 20 ? 'Medium' : 'Short'),
          _buildComparisonRow('Complexity', 'Moderate', 'Based on vocabulary and themes'),
          _buildComparisonRow('Frequency of Recitation', 'High', 'Commonly recited in prayers'),
        ],
      ),
    );
  }

  Widget _buildComparisonRow(String aspect, String category, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              aspect,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEducationalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withValues(alpha: 0.08),
            Theme.of(context).primaryColor.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.school_rounded,
                color: Theme.of(context).primaryColor,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Learning Resources',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEducationalItem('Tafsir Study', 'Detailed commentary and interpretation'),
          _buildEducationalItem('Memorization Guide', 'Step-by-step memorization techniques'),
          _buildEducationalItem('Recitation Practice', 'Audio guides with proper pronunciation'),
          _buildEducationalItem('Discussion Topics', 'Questions for reflection and study groups'),
        ],
      ),
    );
  }

  Widget _buildEducationalItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _shareSurahInfo() {
    HapticFeedback.lightImpact();
    // Implement share functionality
  }

  void _addToBookmarks() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.surahInfo.nameEnglish} added to bookmarks'),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }

  void _startReading() {
    Navigator.pop(context);
    // Navigate back and start reading this surah
  }
}

class _StickyTabBarDelegate extends SliverPersistentHeaderDelegate {
  const _StickyTabBarDelegate(this.tabBar);

  final TabBar tabBar;

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_StickyTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
} 