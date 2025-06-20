import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TermsOfServicePage extends StatefulWidget {
  const TermsOfServicePage({super.key});

  @override
  State<TermsOfServicePage> createState() => _TermsOfServicePageState();
}

class _TermsOfServicePageState extends State<TermsOfServicePage>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final ScrollController _scrollController = ScrollController();
  bool _showScrollToTop = false;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _scrollController.addListener(() {
      if (_scrollController.offset > 300 && !_showScrollToTop) {
        setState(() => _showScrollToTop = true);
      } else if (_scrollController.offset <= 300 && _showScrollToTop) {
        setState(() => _showScrollToTop = false);
      }
    });

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    HapticFeedback.lightImpact();
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar.large(
            expandedHeight: 160,
            floating: true,
            pinned: true,
            elevation: 0,
            backgroundColor: colorScheme.surface,
            surfaceTintColor: colorScheme.surfaceTint,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: colorScheme.onSurface,
              ),
              onPressed: () {
                HapticFeedback.lightImpact();
                Navigator.pop(context);
              },
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Terms of Service',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      colorScheme.primaryContainer.withOpacity(0.3),
                      colorScheme.surface,
                    ],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.gavel_rounded,
                    size: 64,
                    color: colorScheme.primary.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      _buildHeaderCard(context),
                      const SizedBox(height: 16),
                      _buildTermSection(
                        context,
                        icon: Icons.check_circle_outline_rounded,
                        title: '1. Acceptance of Terms',
                        content: 'By downloading, installing, accessing, or using the Safiyah mobile application ("App"), you agree to be bound by these Terms of Service ("Terms"). If you do not agree to these Terms, please do not use our App. These Terms constitute a legally binding agreement between you and Safiyah.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.smartphone_rounded,
                        title: '2. Description of Service',
                        content: 'Safiyah is a comprehensive Muslim travel companion app that provides prayer times, Qibla direction, halal places, travel itinerary planning, currency conversion, weather information, and AI-powered chatbot assistance for Muslim travelers worldwide.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.person_outline_rounded,
                        title: '3. User Account and Registration',
                        content: 'To access certain features, you may need to create an account. You are responsible for:\n• Providing accurate and complete information\n• Maintaining the security of your account credentials\n• All activities that occur under your account\n• Notifying us immediately of any unauthorized use',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.security_rounded,
                        title: '4. Privacy and Data Collection',
                        content: 'We collect and process your personal data in accordance with our Privacy Policy. This includes:\n• Location data for prayer times and nearby places\n• Usage analytics to improve our services\n• Account information for personalization\n• Device information for optimal performance',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.my_location_rounded,
                        title: '5. Location Services',
                        content: 'Our App uses your device\'s location to provide accurate prayer times, Qibla direction, and nearby halal places. You can disable location services, but this may limit App functionality. Location data is processed locally and used only for service provision.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.mosque_rounded,
                        title: '6. Religious Content Accuracy',
                        content: 'While we strive for accuracy in prayer times and religious information, we recommend consulting local Islamic authorities for verification. Prayer times are calculated using recognized algorithms but may vary based on local customs and scholarly opinions.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.block_rounded,
                        title: '7. Prohibited Uses',
                        content: 'You agree not to:\n• Use the App for illegal or unauthorized purposes\n• Attempt to hack, disrupt, or damage the App\n• Upload or transmit malicious code or content\n• Violate any applicable laws or regulations\n• Misrepresent your identity or affiliation',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.copyright_rounded,
                        title: '8. Intellectual Property',
                        content: 'All content, features, and functionality of the App are owned by Safiyah and protected by international copyright, trademark, and other intellectual property laws. You may not copy, modify, distribute, or reverse engineer any part of the App.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.link_rounded,
                        title: '9. Third-Party Services',
                        content: 'Our App may integrate with third-party services (maps, weather, currency APIs). We are not responsible for the availability, accuracy, or content of these services. Your use of third-party services is subject to their respective terms.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.warning_amber_rounded,
                        title: '10. Disclaimer of Warranties',
                        content: 'The App is provided "AS IS" without warranties of any kind. We disclaim all warranties, express or implied, including merchantability, fitness for a particular purpose, and non-infringement. We do not guarantee uninterrupted or error-free service.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.shield_outlined,
                        title: '11. Limitation of Liability',
                        content: 'To the maximum extent permitted by law, Safiyah shall not be liable for any indirect, incidental, special, consequential, or punitive damages arising from your use of the App, even if we have been advised of the possibility of such damages.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.cancel_outlined,
                        title: '12. Termination',
                        content: 'We may terminate or suspend your access to the App at any time, without prior notice, for conduct that we believe violates these Terms or is harmful to other users, us, or third parties, or for any other reason at our sole discretion.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.gavel_rounded,
                        title: '13. Governing Law',
                        content: 'These Terms are governed by and construed in accordance with the laws of Indonesia. Any disputes arising under these Terms will be subject to the exclusive jurisdiction of the courts of Indonesia.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.update_rounded,
                        title: '14. Changes to Terms',
                        content: 'We reserve the right to modify these Terms at any time. We will notify you of any changes by posting the new Terms in the App. Continued use of the App after changes constitutes acceptance of the modified Terms.',
                      ),
                      _buildTermSection(
                        context,
                        icon: Icons.contact_support_rounded,
                        title: '15. Contact Information',
                        content: 'If you have any questions about these Terms, please contact us at:\n• Email: support@safiyah.app\n• Address: Indonesia\n• Phone: Available in the App',
                      ),
                                             const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: AnimatedOpacity(
        opacity: _showScrollToTop ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 300),
        child: FloatingActionButton.small(
          onPressed: _showScrollToTop ? _scrollToTop : null,
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          child: const Icon(Icons.keyboard_arrow_up_rounded),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Icon(
              Icons.info_outline_rounded,
              size: 48,
              color: colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Safiyah',
              style: textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Your trusted Muslim travel companion. Please read these terms carefully before using our services.',
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onPrimaryContainer.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Last updated: ${DateTime.now().toString().split(' ')[0]}',
                style: textTheme.bodySmall?.copyWith(
                  color: colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTermSection(BuildContext context, {
    required IconData icon,
    required String title,
    required String content,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: colorScheme.surfaceVariant.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    icon,
                    color: colorScheme.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }


} 
