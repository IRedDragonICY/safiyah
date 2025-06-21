import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HolidayPackageCard extends StatelessWidget {
  const HolidayPackageCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => context.push('/holiday-package'),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                colorScheme.secondaryContainer,
                colorScheme.secondaryContainer.withValues(alpha: 0.7),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.flight_takeoff,
                      color: colorScheme.onSecondaryContainer,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      '30% OFF',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Holiday Packages',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSecondaryContainer,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Halal-certified packages with complete itineraries',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildHighlight('Tokyo Explorer', '5D4N', colorScheme),
                  const SizedBox(width: 16),
                  _buildHighlight('Kyoto Heritage', '4D3N', colorScheme),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Starting from',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '¥180,000',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSecondaryContainer,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: colorScheme.onSecondaryContainer,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHighlight(String title, String duration, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: colorScheme.onSecondaryContainer,
          ),
        ),
        Text(
          duration,
          style: TextStyle(
            fontSize: 12,
            color: colorScheme.onSecondaryContainer.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
} 