import 'dart:async';
import '../models/help_article_model.dart';

class HelpCenterRepository {
  static final HelpCenterRepository _instance = HelpCenterRepository._internal();
  factory HelpCenterRepository() => _instance;
  HelpCenterRepository._internal();

  final List<HelpArticle> _articles = [];
  final List<FAQ> _faqs = [];
  final _searchController = StreamController<String>.broadcast();

  void init() {
    _generateHelpContent();
  }

  void _generateHelpContent() {
    final now = DateTime.now();

    // Payment & Billing Articles
    _articles.addAll([
      HelpArticle(
        id: 'pay_001',
        title: 'Supported Payment Methods',
        content: 'Learn about all the payment methods we support across different regions.',
        category: HelpCategories.payment,
        tags: ['payment', 'credit card', 'debit card', 'wallet', 'bank transfer'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Credit & Debit Cards',
            content: 'We accept major international cards including Visa, Mastercard, American Express, JCB, UnionPay, and Discover. All card transactions are secured with 3D Secure authentication.',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Digital Wallets by Region',
            content: 'Indonesia: GoPay, OVO, DANA, ShopeePay, LinkAja\nMalaysia: Touch \'n Go, GrabPay, Boost\nSingapore: PayLah!, GrabPay, FavePay\nGlobal: PayPal, Alipay, Apple Pay, Google Pay',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Bank Transfers',
            content: 'Direct bank transfers are available for all major banks in your region. Virtual account numbers are provided for easy payment tracking.',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'QRIS (Indonesia)',
            content: 'Quick Response Code Indonesian Standard - scan and pay with any QRIS-compatible app for the lowest processing fees.',
            type: SectionType.text,
          ),
        ],
        isPopular: true,
        isFeatured: true,
      ),
      HelpArticle(
        id: 'pay_002',
        title: 'How to Add a Payment Method',
        content: 'Step-by-step guide to add and manage your payment methods.',
        category: HelpCategories.payment,
        tags: ['payment', 'add card', 'setup'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Adding a Credit/Debit Card',
            content: '1. Go to Settings > Payment Methods\n2. Tap "Add New Card"\n3. Enter card details\n4. Verify with OTP or 3D Secure\n5. Card is now saved for future use',
            type: SectionType.steps,
          ),
          HelpSection(
            title: 'Security Note',
            content: 'Your card details are encrypted and stored securely. We never store your CVV number.',
            type: SectionType.warning,
          ),
        ],
      ),
      HelpArticle(
        id: 'pay_003',
        title: 'Understanding Refund Policies',
        content: 'Comprehensive guide to our refund policies for different services.',
        category: HelpCategories.payment,
        tags: ['refund', 'cancellation', 'policy'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Flight Refunds',
            content: 'Refund percentages based on cancellation timing:\n• 14+ days before: 90% refund\n• 7-13 days before: 50% refund\n• 3-6 days before: 25% refund\n• Less than 3 days: No refund',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Train & Bus Refunds',
            content: 'More flexible refund policy:\n• 3+ days before: 85% refund\n• 1-2 days before: 50% refund\n• Same day: No refund',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Hotel Refunds',
            content: 'Varies by hotel policy. Check specific cancellation terms during booking. Free cancellation options are clearly marked.',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Hajj & Umroh Package Refunds',
            content: 'Special conditions apply:\n• Visa rejection: 100% refund\n• Medical emergency: 90% refund with certificate\n• Standard cancellation follows tiered system',
            type: SectionType.text,
          ),
        ],
        isFeatured: true,
      ),
    ]);

    // Transportation Articles
    _articles.addAll([
      HelpArticle(
        id: 'trans_001',
        title: 'How to Book Transportation',
        content: 'Complete guide for booking flights, trains, buses, and other transportation.',
        category: HelpCategories.transportation,
        tags: ['booking', 'flight', 'train', 'bus', 'transportation'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Search for Transportation',
            content: '1. Select transportation type (Flight/Train/Bus)\n2. Enter origin and destination\n3. Select travel dates\n4. Choose number of passengers\n5. Tap Search',
            type: SectionType.steps,
          ),
          HelpSection(
            title: 'Filters and Sorting',
            content: 'Use filters to narrow results by:\n• Price range\n• Departure time\n• Duration\n• Transit options\n• Carrier preferences',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Multi-city Bookings',
            content: 'For complex itineraries, use our multi-city option to book connecting flights or combine different transport modes.',
            type: SectionType.tip,
          ),
        ],
        isPopular: true,
      ),
      HelpArticle(
        id: 'trans_002',
        title: 'Managing Your Bookings',
        content: 'How to view, modify, or cancel your transportation bookings.',
        category: HelpCategories.transportation,
        tags: ['manage', 'modify', 'cancel', 'booking'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'View Bookings',
            content: 'Access all your bookings from:\n• Home > My Bookings\n• Transaction History\n• Individual service sections',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Modify Bookings',
            content: 'Changes depend on fare rules:\n• Name corrections: Usually free within 24 hours\n• Date changes: Subject to availability and fees\n• Route changes: Treated as new booking',
            type: SectionType.text,
          ),
        ],
      ),
    ]);

    // Hajj & Umroh Articles
    _articles.addAll([
      HelpArticle(
        id: 'hajj_001',
        title: 'Hajj & Umroh Package Guide',
        content: 'Everything you need to know about our pilgrimage packages.',
        category: HelpCategories.hajjUmroh,
        tags: ['hajj', 'umroh', 'pilgrimage', 'package'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Package Types',
            content: 'We offer various packages:\n• Economy: Basic accommodation, standard services\n• Standard: 4-star hotels, guided tours\n• Premium: 5-star hotels, VIP services\n• Exclusive: Luxury experience with personal guide',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'What\'s Included',
            content: 'All packages include:\n• Return flights\n• Accommodation in Makkah & Madinah\n• Transportation between cities\n• Visa processing\n• Guidance and religious consultation',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Documentation Required',
            content: '• Valid passport (6 months validity)\n• Meningitis vaccination certificate\n• Mahram details for women\n• Recent passport photos\n• Medical fitness certificate',
            type: SectionType.text,
          ),
        ],
        isFeatured: true,
      ),
    ]);

    // Accessibility Articles
    _articles.addAll([
      HelpArticle(
        id: 'acc_001',
        title: 'Accessibility Features Overview',
        content: 'Learn about our comprehensive accessibility features.',
        category: HelpCategories.accessibility,
        tags: ['accessibility', 'disability', 'vision', 'hearing'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Vision Assistance',
            content: '• Screen reader compatibility\n• High contrast mode\n• Font size adjustment\n• Color blind friendly interface\n• Voice navigation',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Hearing Assistance',
            content: '• Visual notifications\n• Closed captions for videos\n• Text-based customer support\n• Vibration alerts',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Motor Assistance',
            content: '• Large touch targets\n• Gesture simplification\n• Voice commands\n• One-handed operation mode',
            type: SectionType.text,
          ),
        ],
      ),
    ]);

    // Account & Settings Articles
    _articles.addAll([
      HelpArticle(
        id: 'acc_002',
        title: 'Account Security Best Practices',
        content: 'Keep your account safe with these security tips.',
        category: HelpCategories.account,
        tags: ['security', 'password', 'privacy', '2FA'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'Strong Password',
            content: 'Use a unique password with:\n• At least 8 characters\n• Mix of letters, numbers, symbols\n• No personal information\n• Different from other accounts',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Two-Factor Authentication',
            content: 'Enable 2FA for extra security:\n1. Go to Settings > Security\n2. Enable Two-Factor Auth\n3. Choose SMS or Authenticator App\n4. Follow setup instructions',
            type: SectionType.steps,
          ),
          HelpSection(
            title: 'Security Warning',
            content: 'Never share your password or OTP with anyone. We will never ask for your password via email or phone.',
            type: SectionType.warning,
          ),
        ],
        isPopular: true,
      ),
    ]);

    // Technical Support Articles
    _articles.addAll([
      HelpArticle(
        id: 'tech_001',
        title: 'Troubleshooting Common Issues',
        content: 'Solutions for common technical problems.',
        category: HelpCategories.technical,
        tags: ['troubleshoot', 'error', 'fix', 'problem'],
        createdAt: now,
        updatedAt: now,
        sections: [
          HelpSection(
            title: 'App Crashes',
            content: '1. Update to latest version\n2. Clear app cache\n3. Restart your device\n4. Reinstall if problem persists\n5. Contact support with error details',
            type: SectionType.steps,
          ),
          HelpSection(
            title: 'Payment Failures',
            content: 'Common causes:\n• Insufficient funds\n• Card expired\n• Wrong CVV/OTP\n• Bank security block\n• Network timeout',
            type: SectionType.text,
          ),
          HelpSection(
            title: 'Login Issues',
            content: 'Try these steps:\n• Check internet connection\n• Verify credentials\n• Reset password if forgotten\n• Clear browser cookies\n• Try different device',
            type: SectionType.steps,
          ),
        ],
      ),
    ]);

    // Generate FAQs
    _faqs.addAll([
      FAQ(
        id: 'faq_001',
        question: 'How do I track my refund status?',
        answer: 'Go to Transaction History > Select the transaction > View Refund Status. You\'ll see the current status and estimated completion date.',
        order: 1,
        relatedArticleIds: ['pay_003'],
      ),
      FAQ(
        id: 'faq_002',
        question: 'Can I book for someone else?',
        answer: 'Yes! During booking, you can enter passenger details different from your account. Make sure all names match official IDs exactly.',
        order: 2,
      ),
      FAQ(
        id: 'faq_003',
        question: 'What currencies are supported?',
        answer: 'We support all major currencies. Prices are shown in your selected currency with real-time conversion rates. Change currency in Settings.',
        order: 3,
      ),
      FAQ(
        id: 'faq_004',
        question: 'How do I add multiple passengers?',
        answer: 'During search, select the number of passengers. You\'ll enter each passenger\'s details during checkout. Group bookings may have special rates.',
        order: 4,
      ),
      FAQ(
        id: 'faq_005',
        question: 'Is my payment information secure?',
        answer: 'Yes! We use bank-grade encryption and are PCI DSS compliant. Your payment details are tokenized and never stored in plain text.',
        order: 5,
        relatedArticleIds: ['acc_002'],
      ),
      FAQ(
        id: 'faq_006',
        question: 'How do I get an invoice?',
        answer: 'Invoices are automatically sent to your email after payment. You can also download them from Transaction History anytime.',
        order: 6,
      ),
      FAQ(
        id: 'faq_007',
        question: 'What if my flight is delayed or cancelled?',
        answer: 'We\'ll notify you immediately via app and email. You can rebook or request a full refund for airline-caused cancellations.',
        order: 7,
      ),
      FAQ(
        id: 'faq_008',
        question: 'Can I change passenger names?',
        answer: 'Minor corrections (spelling) are usually free within 24 hours. Major changes may be treated as cancellation and rebooking.',
        order: 8,
      ),
    ]);
  }

  // Get all help categories
  List<HelpCategory> getCategories() {
    return HelpCategories.all;
  }

  // Get articles by category
  Future<List<HelpArticle>> getArticlesByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _articles
        .where((article) => article.category.id == categoryId)
        .toList();
  }

  // Get popular articles
  Future<List<HelpArticle>> getPopularArticles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _articles.where((article) => article.isPopular).toList();
  }

  // Get featured articles
  Future<List<HelpArticle>> getFeaturedArticles() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _articles.where((article) => article.isFeatured).toList();
  }

  // Search articles
  Future<List<HelpArticle>> searchArticles(String query) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final lowercaseQuery = query.toLowerCase();
    
    return _articles.where((article) {
      return article.title.toLowerCase().contains(lowercaseQuery) ||
          article.content.toLowerCase().contains(lowercaseQuery) ||
          article.tags.any((tag) => tag.toLowerCase().contains(lowercaseQuery));
    }).toList();
  }

  // Get article by ID
  Future<HelpArticle?> getArticleById(String articleId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try {
      return _articles.firstWhere((article) => article.id == articleId);
    } catch (e) {
      return null;
    }
  }

  // Get all FAQs
  Future<List<FAQ>> getFAQs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _faqs..sort((a, b) => a.order.compareTo(b.order));
  }

  // Search FAQs
  Future<List<FAQ>> searchFAQs(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final lowercaseQuery = query.toLowerCase();
    
    return _faqs.where((faq) {
      return faq.question.toLowerCase().contains(lowercaseQuery) ||
          faq.answer.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  // Track article view
  Future<void> trackArticleView(String articleId) async {
    final index = _articles.indexWhere((article) => article.id == articleId);
    if (index != -1) {
      // In a real app, this would update the backend
      // For now, we'll just increment the local view count
      final article = _articles[index];
      _articles[index] = HelpArticle(
        id: article.id,
        title: article.title,
        content: article.content,
        category: article.category,
        tags: article.tags,
        createdAt: article.createdAt,
        updatedAt: article.updatedAt,
        author: article.author,
        viewCount: article.viewCount + 1,
        helpfulRating: article.helpfulRating,
        relatedArticleIds: article.relatedArticleIds,
        sections: article.sections,
        videoUrl: article.videoUrl,
        imageUrls: article.imageUrls,
        isPopular: article.isPopular,
        isFeatured: article.isFeatured,
      );
    }
  }

  // Rate article helpfulness
  Future<void> rateArticle(String articleId, bool helpful) async {
    // In a real app, this would update the backend
    await Future.delayed(const Duration(milliseconds: 500));
  }

  void dispose() {
    _searchController.close();
  }
} 