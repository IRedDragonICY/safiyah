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
            SizedBox(
              height: 85,
              child: ListView(
                scrollDirection: Axis.horizontal,
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
                  icon: Icons.auto_awesome,
                  label: 'Smart AI',
                  color: AppColors.info,
                  onTap: () => context.push('/chatbot/realtime'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.tour,
                  label: 'Guide Tour',
                  color: AppColors.secondary,
                  onTap: () => context.push('/guide-tour'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.local_offer,
                  label: 'Vouchers',
                  color: AppColors.primaryLight,
                  onTap: () => context.push('/voucher'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.event,
                  label: 'Events',
                  color: AppColors.primary,
                  onTap: () => context.push('/events'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.no_food,
                  label: 'Boycott',
                  color: AppColors.error,
                  onTap: () => context.push('/boycott'),
                ),
                _buildQuickActionItem(
                  context,
                  icon: Icons.account_balance_wallet,
                  label: 'Zakat',
                  color: AppColors.success,
                  onTap: () => context.push('/zakat'),
                ),
                ],
              ),
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
    return Container(
      width: 75,
      margin: const EdgeInsets.only(right: 8),
      child: InkWell(
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
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 11,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
