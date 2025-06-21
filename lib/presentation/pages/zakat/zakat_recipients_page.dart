import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class ZakatRecipientsPage extends StatefulWidget {
  const ZakatRecipientsPage({super.key});

  @override
  State<ZakatRecipientsPage> createState() => _ZakatRecipientsPageState();
}

class _ZakatRecipientsPageState extends State<ZakatRecipientsPage> with TickerProviderStateMixin {
  late TabController _tabController;
  final _searchController = TextEditingController();
  
  List<ZakatRecipient> _allRecipients = [];
  List<ZakatRecipient> _filteredRecipients = [];
  bool _isLoading = true;
  String _selectedCategory = 'all';

  final List<String> _categories = [
    'all',
    'mosque',
    'foundation',
    'orphanage',
    'school',
    'hospital',
    'individual',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadRecipients();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _loadRecipients() {
    setState(() {
      _isLoading = true;
    });

    // Data recipients di Jepang (dalam implementasi nyata akan dari API)
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _allRecipients = [
          ZakatRecipient(
            id: '1',
            name: 'Tokyo Camii & Turkish Culture Center',
            category: RecipientCategory.mosque,
            description: 'The largest mosque in Japan, serving Muslim community in Tokyo and surrounding areas',
            address: '1-19 Ohyama-cho, Shibuya City, Tokyo 151-0065, Japan',
            phone: '+81 3-5790-0760',
            verified: true,
            rating: 4.9,
            totalDonations: 450000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'PayPay', 'Cash'],
            accountInfo: {
              'Bank': 'MUFG Bank',
              'Account Number': '1234567890',
              'Account Name': 'Tokyo Camii',
            },
          ),
          ZakatRecipient(
            id: '2',
            name: 'Islamic Center Japan',
            category: RecipientCategory.foundation,
            description: 'Islamic cultural and educational center serving Muslims throughout Japan',
            address: '2-38-1 Nippori, Arakawa City, Tokyo 116-0014, Japan',
            phone: '+81 3-3821-8189',
            verified: true,
            rating: 4.8,
            totalDonations: 320000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'Cash'],
            accountInfo: {
              'Bank': 'Sumitomo Mitsui Banking Corporation',
              'Account Number': '9876543210',
              'Account Name': 'Islamic Center Japan',
            },
          ),
          ZakatRecipient(
            id: '3',
            name: 'Osaka Mosque',
            category: RecipientCategory.mosque,
            description: 'Historic mosque in Osaka serving the Muslim community in Kansai region',
            address: '3-1-1 Sumiyoshi, Sumiyoshi Ward, Osaka 558-0045, Japan',
            phone: '+81 6-6672-7676',
            verified: true,
            rating: 4.7,
            totalDonations: 280000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'PayPay'],
            accountInfo: {
              'Bank': 'Mizuho Bank',
              'Account Number': '5555666777',
              'Account Name': 'Osaka Mosque',
            },
          ),
          ZakatRecipient(
            id: '4',
            name: 'Muslim Women\'s Council Japan',
            category: RecipientCategory.foundation,
            description: 'Supporting Muslim women and families in Japan with social services',
            address: 'Shibuya, Tokyo, Japan',
            phone: '+81 90-1234-5678',
            verified: true,
            rating: 4.9,
            totalDonations: 180000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'PayPay', 'Cash'],
            accountInfo: {
              'Bank': 'Japan Post Bank',
              'Account Number': '3333444455',
              'Account Name': 'Muslim Women Council Japan',
            },
          ),
          ZakatRecipient(
            id: '5',
            name: 'Islamic Society of Nagoya',
            category: RecipientCategory.foundation,
            description: 'Community organization serving Muslims in central Japan',
            address: 'Nagoya, Aichi Prefecture, Japan',
            phone: '+81 52-123-4567',
            verified: true,
            rating: 4.6,
            totalDonations: 150000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'Cash'],
            accountInfo: {
              'Bank': 'Aichi Bank',
              'Account Number': '7777888999',
              'Account Name': 'Islamic Society Nagoya',
            },
          ),
          ZakatRecipient(
            id: '6',
            name: 'Kobe Muslim Association',
            category: RecipientCategory.mosque,
            description: 'Mosque and community center serving Muslims in Kobe and Hyogo',
            address: 'Kobe, Hyogo Prefecture, Japan',
            phone: '+81 78-987-6543',
            verified: true,
            rating: 4.8,
            totalDonations: 220000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'PayPay'],
            accountInfo: {
              'Bank': 'Kansai Mirai Bank',
              'Account Number': '1111333355',
              'Account Name': 'Kobe Muslim Association',
            },
          ),
          ZakatRecipient(
            id: '7',
            name: 'Japan Islamic Trust',
            category: RecipientCategory.foundation,
            description: 'Halal certification and Islamic education organization',
            address: 'Tokyo, Japan',
            phone: '+81 3-9999-8888',
            verified: true,
            rating: 4.7,
            totalDonations: 380000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'PayPay', 'Cash'],
            accountInfo: {
              'Bank': 'Resona Bank',
              'Account Number': '6666777788',
              'Account Name': 'Japan Islamic Trust',
            },
          ),
          ZakatRecipient(
            id: '8',
            name: 'Sendai Islamic Center',
            category: RecipientCategory.mosque,
            description: 'Mosque and cultural center serving Muslims in northern Japan',
            address: 'Sendai, Miyagi Prefecture, Japan',
            phone: '+81 22-555-7777',
            verified: true,
            rating: 4.5,
            totalDonations: 120000000,
            imageUrl: null,
            paymentMethods: ['Bank Transfer', 'Cash'],
            accountInfo: {
              'Bank': '77 Bank',
              'Account Number': '4444666888',
              'Account Name': 'Sendai Islamic Center',
            },
          ),
        ];
        _filteredRecipients = _allRecipients;
        _isLoading = false;
      });
    });
  }

  void _filterRecipients() {
    setState(() {
      _filteredRecipients = _allRecipients.where((recipient) {
        final matchesSearch = recipient.name
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()) ||
            recipient.description
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());
        
        final matchesCategory = _selectedCategory == 'all' ||
            recipient.category.name == _selectedCategory;
        
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _selectRecipient(ZakatRecipient recipient) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => RecipientDetailBottomSheet(recipient: recipient),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.success,
        foregroundColor: AppColors.onPrimary,
        title: const Text(
          'Zakat Recipients',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.secondary,
          labelColor: AppColors.onPrimary,
          unselectedLabelColor: AppColors.onPrimary.withOpacity(0.7),
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.search),
              text: 'Browse',
            ),
            Tab(
              icon: Icon(Icons.favorite),
              text: 'Favorites',
            ),
            Tab(
              icon: Icon(Icons.history),
              text: 'Recent',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildBrowseTab(),
          _buildFavoritesTab(),
          _buildRecentTab(),
        ],
      ),
    );
  }

  Widget _buildBrowseTab() {
    return Column(
      children: [
        // Search and Filter Section
        Container(
          padding: const EdgeInsets.all(16),
          color: Theme.of(context).cardColor,
          child: Column(
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: (value) => _filterRecipients(),
                decoration: InputDecoration(
                  hintText: 'Search recipients...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterRecipients();
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              
              // Category Filter
              SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    final isSelected = _selectedCategory == category;
                    
                    return FilterChip(
                      label: Text(_getCategoryDisplayName(category)),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          _selectedCategory = category;
                        });
                        _filterRecipients();
                      },
                      selectedColor: AppColors.success.withOpacity(0.2),
                      checkmarkColor: AppColors.success,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        
        // Recipients List
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                  ),
                )
              : _filteredRecipients.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: _filteredRecipients.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return _buildRecipientCard(_filteredRecipients[index]);
                      },
                    ),
        ),
      ],
    );
  }

  Widget _buildFavoritesTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'No Favorites Yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Mark recipients as favorites for quick access',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentTab() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: AppColors.primary,
            ),
            SizedBox(height: 16),
            Text(
              'No Recent Donations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Your recent zakat donations will appear here',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off,
                size: 64,
                color: AppColors.success,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'No Recipients Found',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search or filter criteria',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _selectedCategory = 'all';
                });
                _filterRecipients();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset Filters'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.onPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipientCard(ZakatRecipient recipient) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => _selectRecipient(recipient),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(recipient.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      _getCategoryIcon(recipient.category),
                      color: _getCategoryColor(recipient.category),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                recipient.name,
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (recipient.verified)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      color: AppColors.onPrimary,
                                      size: 12,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      'VERIFIED',
                                      style: TextStyle(
                                        color: AppColors.onPrimary,
                                        fontSize: 8,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        Text(
                          _getCategoryDisplayName(recipient.category.name),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurface.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {
                      // Add to favorites
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Added to favorites'),
                          backgroundColor: AppColors.success,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                recipient.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 14,
                    color: AppColors.onSurface.withOpacity(0.6),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      recipient.address,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.onSurface.withOpacity(0.6),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  // Rating
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.secondary,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          recipient.rating.toString(),
                          style: const TextStyle(
                            color: AppColors.secondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Total donations
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Total: Rp ${_formatCurrency(recipient.totalDonations)}',
                      style: const TextStyle(
                        color: AppColors.info,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => _selectRecipient(recipient),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.success,
                      side: const BorderSide(color: AppColors.success),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                    ),
                    child: const Text('Donate'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getCategoryDisplayName(String category) {
    switch (category) {
      case 'all':
        return 'All';
      case 'mosque':
        return 'Mosque';
      case 'foundation':
        return 'Foundation';
      case 'orphanage':
        return 'Orphanage';
      case 'school':
        return 'School';
      case 'hospital':
        return 'Hospital';
      case 'individual':
        return 'Individual';
      default:
        return category;
    }
  }

  Color _getCategoryColor(RecipientCategory category) {
    switch (category) {
      case RecipientCategory.mosque:
        return AppColors.success;
      case RecipientCategory.foundation:
        return AppColors.primary;
      case RecipientCategory.orphanage:
        return AppColors.secondary;
      case RecipientCategory.school:
        return AppColors.info;
      case RecipientCategory.hospital:
        return AppColors.error;
      case RecipientCategory.individual:
        return const Color(0xFF607D8B);
    }
  }

  IconData _getCategoryIcon(RecipientCategory category) {
    switch (category) {
      case RecipientCategory.mosque:
        return Icons.mosque;
      case RecipientCategory.foundation:
        return Icons.foundation;
      case RecipientCategory.orphanage:
        return Icons.child_care;
      case RecipientCategory.school:
        return Icons.school;
      case RecipientCategory.hospital:
        return Icons.local_hospital;
      case RecipientCategory.individual:
        return Icons.person;
    }
  }

  String _formatCurrency(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    } else {
      return amount.toStringAsFixed(0);
    }
  }
}

// Model untuk Recipient
class ZakatRecipient {
  final String id;
  final String name;
  final RecipientCategory category;
  final String description;
  final String address;
  final String phone;
  final bool verified;
  final double rating;
  final double totalDonations;
  final String? imageUrl;
  final List<String> paymentMethods;
  final Map<String, String> accountInfo;

  const ZakatRecipient({
    required this.id,
    required this.name,
    required this.category,
    required this.description,
    required this.address,
    required this.phone,
    required this.verified,
    required this.rating,
    required this.totalDonations,
    this.imageUrl,
    required this.paymentMethods,
    required this.accountInfo,
  });
}

enum RecipientCategory {
  mosque,
  foundation,
  orphanage,
  school,
  hospital,
  individual,
}

// Bottom Sheet untuk detail recipient
class RecipientDetailBottomSheet extends StatelessWidget {
  final ZakatRecipient recipient;

  const RecipientDetailBottomSheet({
    super.key,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _getCategoryColor(recipient.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  _getCategoryIcon(recipient.category),
                  color: _getCategoryColor(recipient.category),
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recipient.name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (recipient.verified)
                      Row(
                        children: [
                          const Icon(
                            Icons.verified,
                            color: AppColors.success,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Verified Recipient',
                            style: TextStyle(
                              color: AppColors.success,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Content
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Description
                  Text(
                    'About',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipient.description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),

                  // Contact Info
                  Text(
                    'Contact Information',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.location_on, recipient.address),
                  _buildInfoRow(Icons.phone, recipient.phone),
                  const SizedBox(height: 16),

                  // Payment Methods
                  Text(
                    'Payment Methods',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: recipient.paymentMethods.map((method) {
                      return Chip(
                        label: Text(method),
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Account Info
                  if (recipient.accountInfo.isNotEmpty) ...[
                    Text(
                      'Account Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: recipient.accountInfo.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4),
                            child: Text(
                              '${entry.key}: ${entry.value}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // Donate Button
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                context.push('/payment', extra: {
                  'type': 'zakat_donation',
                  'recipient': recipient,
                });
              },
              icon: const Icon(Icons.volunteer_activism),
              label: const Text('Donate Zakat'),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: AppColors.onSurface.withOpacity(0.6),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: AppColors.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(RecipientCategory category) {
    switch (category) {
      case RecipientCategory.mosque:
        return AppColors.success;
      case RecipientCategory.foundation:
        return AppColors.primary;
      case RecipientCategory.orphanage:
        return AppColors.secondary;
      case RecipientCategory.school:
        return AppColors.info;
      case RecipientCategory.hospital:
        return AppColors.error;
      case RecipientCategory.individual:
        return const Color(0xFF607D8B);
    }
  }

  IconData _getCategoryIcon(RecipientCategory category) {
    switch (category) {
      case RecipientCategory.mosque:
        return Icons.mosque;
      case RecipientCategory.foundation:
        return Icons.foundation;
      case RecipientCategory.orphanage:
        return Icons.child_care;
      case RecipientCategory.school:
        return Icons.school;
      case RecipientCategory.hospital:
        return Icons.local_hospital;
      case RecipientCategory.individual:
        return Icons.person;
    }
  }
} 