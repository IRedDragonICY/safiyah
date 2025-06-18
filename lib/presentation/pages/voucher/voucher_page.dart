import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/voucher_model.dart';
import '../../widgets/voucher/voucher_card.dart';
import '../../widgets/voucher/voucher_category_chip.dart';

class VoucherPage extends StatefulWidget {
  const VoucherPage({super.key});

  @override
  State<VoucherPage> createState() => _VoucherPageState();
}

class _VoucherPageState extends State<VoucherPage> {
  VoucherType _selectedCategory = VoucherType.all;

  final List<VoucherModel> _allVouchers = [
    VoucherModel(
      id: '1',
      title: 'Get 50% Off Your First Meal',
      description: 'Valid for all participating restaurants. Max discount \$10.',
      discountText: '50% OFF',
      expiryDate: 'Expires in 15 days',
      imageUrl: 'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/857/857681.png',
      brandName: 'HalalBites',
      type: VoucherType.food,
      isNewUserVoucher: true,
      brandColor: AppColors.halalFood,
    ),
    VoucherModel(
      id: '2',
      title: '\$25 Off Your Next Flight',
      description: 'Book a flight over \$200 to be eligible for this voucher.',
      discountText: '\$25 OFF',
      expiryDate: 'Expires on Dec 31, 2024',
      imageUrl: 'https://images.unsplash.com/photo-1530521954074-e64f6810b32d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/5968/5968393.png',
      brandName: 'AirSafiya',
      type: VoucherType.transport,
      isNewUserVoucher: true,
      brandColor: AppColors.info,
    ),
    VoucherModel(
      id: '3',
      title: '20% Off 3-Night Hotel Stay',
      description: 'Applicable for all our partner hotels worldwide.',
      discountText: '20% OFF',
      expiryDate: 'Expires in 30 days',
      imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/2163/2163350.png',
      brandName: 'SereneStays',
      type: VoucherType.hotel,
      brandColor: AppColors.secondaryDark,
    ),
    VoucherModel(
      id: '4',
      title: 'Buy 1 Get 1 Free City Tour',
      description: 'Explore the city with our guided Halal-friendly tours.',
      discountText: 'B1G1',
      expiryDate: 'Expires in 7 days',
      imageUrl: 'https://images.unsplash.com/photo-1527631746610-bca00a040d60?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80',
      brandLogoUrl: 'https://cdn-icons-png.flaticon.com/512/3081/3081329.png',
      brandName: 'MuslimTours',
      type: VoucherType.tour,
      brandColor: AppColors.primaryLight,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final filteredVouchers = _selectedCategory == VoucherType.all
        ? _allVouchers
        : _allVouchers.where((v) => v.type == _selectedCategory).toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            title: const Text('Vouchers & Deals'),
            backgroundColor: Theme.of(context).colorScheme.surface,
            foregroundColor: Theme.of(context).colorScheme.onSurface,
            pinned: true,
            floating: true,
            elevation: 1,
          ),
          SliverToBoxAdapter(
            child: _buildNewUserSection(),
          ),
          SliverToBoxAdapter(
            child: _buildSectionHeader(context, 'All Vouchers'),
          ),
          SliverToBoxAdapter(
            child: _buildCategoryFilters(),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return VoucherCard(voucher: filteredVouchers[index]);
                },
                childCount: filteredVouchers.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
      ),
    );
  }

  Widget _buildNewUserSection() {
    final newUserVouchers = _allVouchers.where((v) => v.isNewUserVoucher).toList();
    if (newUserVouchers.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
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
                  'Specials For You',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 250,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              itemCount: newUserVouchers.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: 300,
                  child: VoucherCard(voucher: newUserVouchers[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilters() {
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
            label: 'Tours',
            icon: Icons.tour,
            isSelected: _selectedCategory == VoucherType.tour,
            onTap: () => setState(() => _selectedCategory = VoucherType.tour),
          ),
        ],
      ),
    );
  }
}