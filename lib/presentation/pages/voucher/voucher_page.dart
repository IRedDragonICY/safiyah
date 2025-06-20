import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/voucher_model.dart';
import '../../../data/services/voucher_history_service.dart';
import '../../widgets/voucher/voucher_card.dart';
import '../../widgets/voucher/voucher_category_chip.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> with TickerProviderStateMixin {
  VoucherType _selectedCategory = VoucherType.all;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  bool _isSearching = false;
  String _sortBy = 'expiry'; // expiry, popularity, discount, newest
  
  late AnimationController _searchAnimationController;
  late AnimationController _fabAnimationController;

  @override
  void initState() {
    super.initState();
    _searchAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabAnimationController.forward();
    
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
    
    // Add some mock expired vouchers for demo
    _addMockExpiredVouchers();
  }

  void _addMockExpiredVouchers() async {
    // Add some mock expired vouchers to demonstrate the history feature
    final expiredVouchers = [
      _allVouchers[5].copyWith(
        id: 'expired_1',
        title: 'Expired Food Discount',
        status: VoucherStatus.expired,
        expiryDateTime: DateTime.now().subtract(const Duration(days: 5)),
      ),
      _allVouchers[6].copyWith(
        id: 'expired_2', 
        title: 'Expired Transport Deal',
        status: VoucherStatus.expired,
        expiryDateTime: DateTime.now().subtract(const Duration(days: 12)),
      ),
    ];
    
    for (final voucher in expiredVouchers) {
      await VoucherHistoryService.instance.markVoucherAsExpired(voucher);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchAnimationController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
    });
    
    if (_isSearching) {
      _searchAnimationController.forward();
    } else {
      _searchAnimationController.reverse();
      _searchController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  final List<VoucherModel> _allVouchers = [
    // Currency/Transfer Vouchers (connecting to currency page)
    VoucherModel(
      id: 'curr_1',
      title: 'Free Transfer Fee',
      description: 'Get free transfer fee for your first international money transfer',
      discountText: 'FREE',
      discountType: DiscountType.free,
      discountValue: 100,
      code: 'FREETRANSFER',
      expiryDate: 'Expires in 30 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 30)),
      imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      brandName: 'Safiyah Transfer',
      type: VoucherType.currency,
      isNewUserVoucher: true,
      isFeatured: true,
      brandColor: AppColors.primary,
      terms: ['Valid for first-time users only', 'Maximum transfer amount \$1000', 'Cannot be combined with other offers'],
      rating: 4.8,
      reviewCount: 1520,
      locations: ['Global'],
      partnershipInfo: 'Official Safiyah Service',
    ),
    
    VoucherModel(
      id: 'curr_2',
      title: '50% Off Transfer Fees',
      description: 'Save 50% on transfer fees for transfers above \$500',
      discountText: '50% OFF',
      discountType: DiscountType.percentage,
      discountValue: 50,
      minPurchase: 500,
      maxDiscount: 25,
      code: 'TRANSFER50',
      expiryDate: 'Expires in 15 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 15)),
      imageUrl: 'https://images.unsplash.com/photo-1607863680198-23d4b2565df0?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/3135/3135715.png',
      brandName: 'Safiyah Transfer',
      type: VoucherType.currency,
      isPopular: true,
      brandColor: AppColors.secondary,
      terms: ['Minimum transfer \$500', 'Maximum discount \$25', 'Valid for all destinations'],
      rating: 4.6,
      reviewCount: 890,
      locations: ['Global'],
      usageLimit: 3,
      partnershipInfo: 'Official Safiyah Service',
    ),

    // Food & Dining Vouchers
    VoucherModel(
      id: 'food_1',
      title: 'Halal Feast 70% Off',
      description: 'Enjoy authentic halal cuisine with massive discount at participating restaurants',
      discountText: '70% OFF',
      discountType: DiscountType.percentage,
      discountValue: 70,
      minPurchase: 50,
      maxDiscount: 35,
      code: 'HALAL70',
      expiryDate: 'Expires in 7 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 7)),
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/857/857681.png',
      brandName: 'HalalBites Network',
      type: VoucherType.food,
      isNewUserVoucher: true,
      isFeatured: true,
      isPopular: true,
      brandColor: AppColors.halalFood,
      terms: ['Valid at 500+ restaurants', 'Minimum order \$50', 'Dine-in and delivery available'],
      rating: 4.9,
      reviewCount: 2340,
      locations: ['Tokyo', 'Osaka', 'Kyoto', 'Yokohama'],
      usageLimit: 2,
    ),

    VoucherModel(
      id: 'food_2',
      title: 'Buy 1 Get 1 Free Ramen',
      description: 'Delicious halal ramen at premium locations across Japan',
      discountText: 'B1G1',
      discountType: DiscountType.buyOneGetOne,
      code: 'RAMENB1G1',
      expiryDate: 'Expires in 5 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 5)),
      imageUrl: 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/1046/1046784.png',
      brandName: 'Halal Ramen Co.',
      type: VoucherType.food,
      brandColor: Colors.orange,
      terms: ['Valid Monday-Friday only', 'Exclude premium toppings', 'One voucher per table'],
      rating: 4.7,
      reviewCount: 867,
      locations: ['Shinjuku', 'Shibuya', 'Harajuku'],
      usageLimit: 1,
    ),

    // Transportation Vouchers
    VoucherModel(
      id: 'transport_1',
      title: '\$50 Off International Flights',
      description: 'Book flights to any halal-friendly destination with guaranteed halal meals',
      discountText: '\$50 OFF',
      discountType: DiscountType.fixed,
      discountValue: 50,
      minPurchase: 300,
      code: 'FLYHALAL50',
      expiryDate: 'Expires Dec 31, 2024',
      expiryDateTime: DateTime(2024, 12, 31),
      imageUrl: 'https://images.unsplash.com/photo-1530521954074-e64f6810b32d?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968393.png',
      brandName: 'AirSafiya Airlines',
      type: VoucherType.transport,
      isFeatured: true,
      brandColor: AppColors.info,
      terms: ['Minimum booking \$300', 'Halal meals included', 'Valid for all international routes'],
      rating: 4.5,
      reviewCount: 1456,
      locations: ['Global'],
      usageLimit: 1,
      isTransferable: true,
    ),

    VoucherModel(
      id: 'transport_2',
      title: 'Free Airport Transfer',
      description: 'Complimentary airport pickup and drop-off service',
      discountText: 'FREE',
      discountType: DiscountType.free,
      code: 'FREETRANSFER',
      expiryDate: 'Expires in 20 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 20)),
      imageUrl: 'https://images.unsplash.com/photo-1544620347-c4fd4a3d5957?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/3774/3774299.png',
      brandName: 'Muslim Taxi Service',
      type: VoucherType.transport,
      brandColor: Colors.green,
      terms: ['Valid for airport transfers only', '24/7 service available', 'Prayer time accommodations'],
      rating: 4.8,
      reviewCount: 543,
      locations: ['Tokyo', 'Narita', 'Haneda'],
    ),

    // Hotel & Accommodation
    VoucherModel(
      id: 'hotel_1',
      title: '30% Off Luxury Hotels',
      description: 'Stay at premium halal-certified hotels with prayer facilities',
      discountText: '30% OFF',
      discountType: DiscountType.percentage,
      discountValue: 30,
      minPurchase: 200,
      maxDiscount: 150,
      code: 'LUXURY30',
      expiryDate: 'Expires in 45 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 45)),
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/2163/2163350.png',
      brandName: 'Halal Luxury Stays',
      type: VoucherType.hotel,
      isFeatured: true,
      brandColor: AppColors.secondaryDark,
      terms: ['Minimum 2 nights stay', 'Prayer room included', 'Halal breakfast available'],
      rating: 4.9,
      reviewCount: 2100,
      locations: ['Tokyo', 'Osaka', 'Kyoto', 'Hiroshima'],
      usageLimit: 1,
    ),

    // Shopping
    VoucherModel(
      id: 'shop_1',
      title: 'Modest Fashion Sale',
      description: 'Latest collection of modest clothing and accessories',
      discountText: '40% OFF',
      discountType: DiscountType.percentage,
      discountValue: 40,
      minPurchase: 100,
      code: 'MODEST40',
      expiryDate: 'Expires in 10 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 10)),
      imageUrl: 'https://images.unsplash.com/photo-1445205170230-053b83016050?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/2331/2331966.png',
      brandName: 'Modest Boutique',
      type: VoucherType.shopping,
      isPopular: true,
      brandColor: Colors.purple,
      terms: ['Online and in-store purchases', 'Latest fashion trends', 'Free shipping over \$150'],
      rating: 4.6,
      reviewCount: 789,
      locations: ['Online', 'Tokyo', 'Osaka'],
    ),

    // Health & Wellness
    VoucherModel(
      id: 'health_1',
      title: 'Halal Spa Package',
      description: 'Relaxing spa treatments with halal-certified products',
      discountText: '25% OFF',
      discountType: DiscountType.percentage,
      discountValue: 25,
      minPurchase: 80,
      code: 'SPALAX25',
      expiryDate: 'Expires in 25 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 25)),
      imageUrl: 'https://images.unsplash.com/photo-1544161515-4ab6ce6db874?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/2913/2913465.png',
      brandName: 'Serenity Spa',
      type: VoucherType.health,
      brandColor: Colors.teal,
      terms: ['Female therapists available', 'Halal certified products', 'Private treatment rooms'],
      rating: 4.8,
      reviewCount: 456,
      locations: ['Tokyo', 'Kyoto'],
    ),

    // Entertainment
    VoucherModel(
      id: 'ent_1',
      title: 'Family Entertainment Pass',
      description: 'Access to halal-friendly entertainment venues and activities',
      discountText: 'B2G1',
      discountType: DiscountType.buyOneGetOne,
      code: 'FAMILY3',
      expiryDate: 'Expires in 35 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 35)),
      imageUrl: 'https://images.unsplash.com/photo-1502920917128-1aa500764cbd?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/3081/3081329.png',
      brandName: 'Muslim Family Fun',
      type: VoucherType.entertainment,
      brandColor: Colors.indigo,
      terms: ['Family-friendly activities', 'Prayer time breaks', 'Halal food courts available'],
      rating: 4.7,
      reviewCount: 634,
      locations: ['Tokyo', 'Osaka', 'Yokohama'],
    ),

    // Education
    VoucherModel(
      id: 'edu_1',
      title: 'Arabic Language Course',
      description: 'Learn Arabic with certified instructors',
      discountText: '60% OFF',
      discountType: DiscountType.percentage,
      discountValue: 60,
      minPurchase: 200,
      code: 'ARABIC60',
      expiryDate: 'Expires in 60 days',
      expiryDateTime: DateTime.now().add(const Duration(days: 60)),
      imageUrl: 'https://images.unsplash.com/photo-1434030216411-0b793f4b4173?auto=format&fit=crop&w=800&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/3002/3002543.png',
      brandName: 'Islamic Learning Center',
      type: VoucherType.education,
      brandColor: Colors.brown,
      terms: ['Online and offline classes', 'Beginner to advanced levels', '6-month course access'],
      rating: 4.9,
      reviewCount: 234,
      locations: ['Online', 'Tokyo'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    final filteredVouchers = _getFilteredVouchers();
    final sortedVouchers = _getSortedVouchers(filteredVouchers);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(theme, colorScheme),
          
          // Search Results Info
          if (_searchQuery.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Found ${sortedVouchers.length} voucher(s)',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Featured Vouchers Section
          if (_searchQuery.isEmpty && _selectedCategory == VoucherType.all)
            SliverToBoxAdapter(child: _buildFeaturedSection(theme, colorScheme)),

          // Category Filter
          SliverToBoxAdapter(child: _buildCategoryFilters(theme, colorScheme)),
          
          // Sort & Filter Options
          SliverToBoxAdapter(child: _buildSortFilterBar(theme, colorScheme)),

          // Vouchers List
          sortedVouchers.isEmpty 
              ? SliverToBoxAdapter(child: _buildEmptyState(theme, colorScheme))
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return Padding(
                        padding: EdgeInsets.fromLTRB(
                          16.0,
                          index == 0 ? 16.0 : 8.0,
                          16.0,
                          index == sortedVouchers.length - 1 ? 120.0 : 8.0,
                        ),
                        child: VoucherCard(voucher: sortedVouchers[index]),
                      );
                    },
                    childCount: sortedVouchers.length,
                  ),
                                  ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimationController,
        child: FloatingActionButton.extended(
          onPressed: _showMyVouchersDialog,
          icon: const Icon(Icons.wallet),
          label: const Text('My Vouchers'),
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, ColorScheme colorScheme) {
    return SliverAppBar(
      title: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching 
            ? _buildSearchField(theme, colorScheme)
            : Text(
                'Vouchers & Deals',
                key: const ValueKey('title'),
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      elevation: 0,
      scrolledUnderElevation: 1,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.surfaceTint,
      floating: true,
      pinned: true,
      actions: [
        IconButton(
          icon: AnimatedRotation(
            turns: _isSearching ? 0.25 : 0,
            duration: const Duration(milliseconds: 300),
            child: Icon(_isSearching ? Icons.close : Icons.search),
          ),
          onPressed: _toggleSearch,
          tooltip: _isSearching ? 'Close Search' : 'Search Vouchers',
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            switch (value) {
              case 'my_vouchers':
                _showMyVouchersDialog();
                break;
              case 'share_app':
                _shareApp();
                break;
              case 'help':
                _showHelpDialog();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'my_vouchers',
              child: Row(
                children: [
                  Icon(Icons.wallet, size: 20, color: colorScheme.onSurface),
                  const SizedBox(width: 12),
                  const Text('My Vouchers'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'share_app',
              child: Row(
                children: [
                  Icon(Icons.share, size: 20, color: colorScheme.onSurface),
                  const SizedBox(width: 12),
                  const Text('Share App'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'help',
              child: Row(
                children: [
                  Icon(Icons.help_outline, size: 20, color: colorScheme.onSurface),
                  const SizedBox(width: 12),
                  const Text('Help & FAQ'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchField(ThemeData theme, ColorScheme colorScheme) {
    return TextField(
      key: const ValueKey('search'),
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search vouchers...',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
        ),
        border: InputBorder.none,
        prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant),
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurface,
      ),
    );
  }

  List<VoucherModel> _getFilteredVouchers() {
    if (_searchQuery.isNotEmpty) {
      return _allVouchers.where((v) => v.title.toLowerCase().contains(_searchQuery)).toList();
    } else {
      return _allVouchers;
    }
  }

  List<VoucherModel> _getSortedVouchers(List<VoucherModel> vouchers) {
    List<VoucherModel> filtered = _selectedCategory == VoucherType.all
        ? vouchers
        : vouchers.where((v) => v.type == _selectedCategory).toList();

    switch (_sortBy) {
      case 'expiry':
        filtered.sort((a, b) => a.expiryDateTime.compareTo(b.expiryDateTime));
        break;
      case 'popularity':
        filtered.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
        break;
      case 'discount':
        filtered.sort((a, b) => (b.discountValue ?? 0).compareTo(a.discountValue ?? 0));
        break;
      case 'newest':
        filtered.sort((a, b) => b.expiryDateTime.compareTo(a.expiryDateTime));
        break;
    }
    return filtered;
  }

  Widget _buildFeaturedSection(ThemeData theme, ColorScheme colorScheme) {
    final featuredVouchers = _allVouchers.where((v) => v.isFeatured).toList();
    if (featuredVouchers.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.05),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
            child: Row(
              children: [
                Icon(
                  Icons.star,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Featured Vouchers',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(
              minHeight: 200,
              maxHeight: 400,
            ),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: featuredVouchers.length,
              itemBuilder: (context, index) {
                return Container(
                  width: 320,
                  margin: const EdgeInsets.only(right: 12.0),
                  child: VoucherCard(voucher: featuredVouchers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          VoucherCategoryChip(
            label: 'All',
            icon: Icons.all_inclusive,
            isSelected: _selectedCategory == VoucherType.all,
            onTap: () => setState(() => _selectedCategory = VoucherType.all),
          ),
          VoucherCategoryChip(
            label: 'Currency',
            icon: Icons.currency_exchange,
            isSelected: _selectedCategory == VoucherType.currency,
            onTap: () => setState(() => _selectedCategory = VoucherType.currency),
          ),
          VoucherCategoryChip(
            label: 'Food',
            icon: Icons.restaurant,
            isSelected: _selectedCategory == VoucherType.food,
            onTap: () => setState(() => _selectedCategory = VoucherType.food),
          ),
          VoucherCategoryChip(
            label: 'Transport',
            icon: Icons.flight_takeoff,
            isSelected: _selectedCategory == VoucherType.transport,
            onTap: () => setState(() => _selectedCategory = VoucherType.transport),
          ),
          VoucherCategoryChip(
            label: 'Hotels',
            icon: Icons.hotel,
            isSelected: _selectedCategory == VoucherType.hotel,
            onTap: () => setState(() => _selectedCategory = VoucherType.hotel),
          ),
          VoucherCategoryChip(
            label: 'Shopping',
            icon: Icons.shopping_bag,
            isSelected: _selectedCategory == VoucherType.shopping,
            onTap: () => setState(() => _selectedCategory = VoucherType.shopping),
          ),
          VoucherCategoryChip(
            label: 'Health',
            icon: Icons.health_and_safety,
            isSelected: _selectedCategory == VoucherType.health,
            onTap: () => setState(() => _selectedCategory = VoucherType.health),
          ),
          VoucherCategoryChip(
            label: 'Entertainment',
            icon: Icons.attractions,
            isSelected: _selectedCategory == VoucherType.entertainment,
            onTap: () => setState(() => _selectedCategory = VoucherType.entertainment),
          ),
          VoucherCategoryChip(
            label: 'Education',
            icon: Icons.school,
            isSelected: _selectedCategory == VoucherType.education,
            onTap: () => setState(() => _selectedCategory = VoucherType.education),
          ),
        ],
      ),
    );
  }

  Widget _buildSortFilterBar(ThemeData theme, ColorScheme colorScheme) {
    return SizedBox(
      height: 50,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          TextButton(
            onPressed: () => setState(() => _sortBy = 'expiry'),
            child: Text(
              'Expiry',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _sortBy == 'expiry' ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _sortBy = 'popularity'),
            child: Text(
              'Popularity',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _sortBy == 'popularity' ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _sortBy = 'discount'),
            child: Text(
              'Discount',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _sortBy == 'discount' ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => setState(() => _sortBy = 'newest'),
            child: Text(
              'Newest',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: _sortBy == 'newest' ? colorScheme.primary : colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search,
            size: 48,
            color: colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No vouchers found',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showMyVouchersDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Mock user vouchers
    final myVouchers = _allVouchers.take(3).toList();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  
                  // Header
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.wallet,
                          color: colorScheme.onPrimaryContainer,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'My Vouchers',
                              style: theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${myVouchers.length} active vouchers',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Voucher Statistics
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          'Saved This Month',
                          '\$124.50',
                          Icons.savings,
                          colorScheme.primary,
                          theme,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          'Used Vouchers',
                          '8',
                          Icons.check_circle,
                          colorScheme.secondary,
                          theme,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // My Vouchers List
                  Text(
                    'Active Vouchers',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  ...myVouchers.map((voucher) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            voucher.brandLogoUrl,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                Container(
                                  width: 40,
                                  height: 40,
                                  color: colorScheme.surfaceContainer,
                                  child: Icon(
                                    Icons.local_offer,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                voucher.title,
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                voucher.expiryDate,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: voucher.statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            voucher.discountText,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: voucher.statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                  
                  const SizedBox(height: 24),
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            context.push('/voucher/history');
                          },
                          icon: const Icon(Icons.history),
                          label: const Text('View History'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            _shareVouchers();
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const Spacer(),
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  void _shareApp() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              Text(
                'Share Safiyah App',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              Text(
                'Invite friends to discover amazing halal-friendly vouchers and deals!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Share Link
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'https://safiyah.app/download',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Clipboard.setData(const ClipboardData(
                          text: 'https://safiyah.app/download',
                        ));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Link copied to clipboard!'),
                            backgroundColor: colorScheme.primary,
                          ),
                        );
                      },
                      icon: const Icon(Icons.copy, size: 20),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              
              // Share buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildShareButton('WhatsApp', Icons.message, colorScheme.primary),
                  _buildShareButton('Email', Icons.email, colorScheme.secondary),
                  _buildShareButton('More', Icons.share, colorScheme.tertiary),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(String label, IconData icon, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  void _shareVouchers() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Sharing vouchers with friends...'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  void _showHelpDialog() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.help_outline, color: colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Help & FAQ'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFaqItem(
                'How do I redeem a voucher?',
                'Tap "Claim" on any voucher and follow the instructions. Each voucher has specific terms and conditions.',
                theme,
              ),
              _buildFaqItem(
                'Can I share vouchers with friends?',
                'Some vouchers are transferable. Look for the transfer icon on the voucher card.',
                theme,
              ),
              _buildFaqItem(
                'How are vouchers connected to currency transfers?',
                'Currency vouchers give you discounts on money transfer fees. They automatically apply when you make transfers.',
                theme,
              ),
              _buildFaqItem(
                'What happens if a voucher expires?',
                'Expired vouchers cannot be used. We recommend claiming and using vouchers before their expiry date.',
                theme,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              // Open contact support
            },
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            answer,
            style: theme.textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
