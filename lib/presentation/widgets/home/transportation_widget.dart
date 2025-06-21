import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';

class TransportationWidget extends StatelessWidget {
  const TransportationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
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
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.directions_transit,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Transportation',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 75,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildTransportOption(
                    context,
                    'Flights',
                    Icons.flight,
                    AppColors.info,
                    () => context.push('/transportation?tab=0'),
                  ),
                  _buildTransportOption(
                    context,
                    'Trains',
                    Icons.train,
                    AppColors.success,
                    () => context.push('/transportation?tab=1'),
                  ),
                  _buildTransportOption(
                    context,
                    'Buses',
                    Icons.directions_bus,
                    AppColors.warning,
                    () => context.push('/transportation?tab=2'),
                  ),
                  _buildTransportOption(
                    context,
                    'Ride-hailing',
                    Icons.local_taxi,
                    AppColors.secondary,
                    () => context.push('/transportation?tab=3'),
                  ),
                  _buildTransportOption(
                    context,
                    'Rentals',
                    Icons.directions_car,
                    AppColors.primaryLight,
                    () => context.push('/transportation?tab=4'),
                  ),
                  _buildTransportOption(
                    context,
                    'Guide',
                    Icons.info_outline,
                    AppColors.primary,
                    () => context.push('/transportation/guide'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransportOption(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return Container(
      width: 70,
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
                  size: 18,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
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