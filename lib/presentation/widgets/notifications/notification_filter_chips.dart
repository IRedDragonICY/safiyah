import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/notification_model.dart';
import '../../bloc/notifications/notifications_bloc.dart';

class NotificationFilterChips extends StatefulWidget {
  const NotificationFilterChips({super.key});

  @override
  State<NotificationFilterChips> createState() => _NotificationFilterChipsState();
}

class _NotificationFilterChipsState extends State<NotificationFilterChips> {
  NotificationType? _selectedFilter;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            label: 'All',
            icon: Icons.notifications_outlined,
            isSelected: _selectedFilter == null,
            onTap: () => _applyFilter(null),
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Vouchers',
            icon: Icons.local_offer_outlined,
            isSelected: _selectedFilter == NotificationType.voucher,
            onTap: () => _applyFilter(NotificationType.voucher),
            color: Colors.green,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Transport',
            icon: Icons.flight_outlined,
            isSelected: _selectedFilter == NotificationType.transportation,
            onTap: () => _applyFilter(NotificationType.transportation),
            color: Colors.blue,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Hotels',
            icon: Icons.hotel_outlined,
            isSelected: _selectedFilter == NotificationType.accommodation,
            onTap: () => _applyFilter(NotificationType.accommodation),
            color: Colors.purple,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Prayer',
            icon: Icons.mosque_outlined,
            isSelected: _selectedFilter == NotificationType.prayer,
            onTap: () => _applyFilter(NotificationType.prayer),
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'Itinerary',
            icon: Icons.map_outlined,
            isSelected: _selectedFilter == NotificationType.itinerary,
            onTap: () => _applyFilter(NotificationType.itinerary),
            color: Colors.orange,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            label: 'General',
            icon: Icons.info_outline,
            isSelected: _selectedFilter == NotificationType.general,
            onTap: () => _applyFilter(NotificationType.general),
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
    Color? color,
  }) {
    final chipColor = color ?? AppColors.primary;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected 
                ? chipColor.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected 
                  ? chipColor
                  : Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 18,
                color: isSelected 
                    ? chipColor
                    : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected 
                      ? FontWeight.w600 
                      : FontWeight.w500,
                  color: isSelected 
                      ? chipColor
                      : Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _applyFilter(NotificationType? filterType) {
    setState(() {
      _selectedFilter = filterType;
    });
    
    context.read<NotificationsBloc>().add(
      FilterNotificationsByType(filterType),
    );
  }
} 
