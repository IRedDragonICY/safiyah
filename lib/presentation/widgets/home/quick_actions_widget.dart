import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
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
                    color: AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.flash_on,
                    color: AppColors.secondary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Quick Actions',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 4,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                _buildQuickActionItem(
                  context,
                  icon: Icons.explore,
                  label: 'Qibla',
                  color: AppColors.qiblaDirection,
                  onTap: () => context.push('/prayer/qibla'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.mosque,
                  label: 'Mosques',
                  color: AppColors.mosque,
                  onTap: () => context.push('/places?type=mosque'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.restaurant,
                  label: 'Halal Food',
                  color: AppColors.halalFood,
                  onTap: () => context.push('/places?type=restaurant'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.map,
                  label: 'AR Nav',
                  color: AppColors.info,
                  onTap: () => context.push('/ar-navigation'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.hotel,
                  label: 'Hotels',
                  color: AppColors.primary,
                  onTap: () => context.push('/places?type=hotel'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.schedule,
                  label: 'Prayer Times',
                  color: AppColors.prayerTime,
                  onTap: () => context.push('/prayer'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.list_alt,
                  label: 'Itinerary',
                  color: AppColors.secondary,
                  onTap: () => context.push('/itinerary'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.store,
                  label: 'Stores',
                  color: AppColors.warning,
                  onTap: () => context.push('/places?type=store'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.no_food,
                  label: 'Boycott',
                  color: AppColors.error,
                  onTap: () => context.push('/boycott'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
