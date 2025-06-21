import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';

class TransportCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String departure;
  final String arrival;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final double price;
  final String currency;
  final String? duration;
  final List<String> features;
  final bool isHalalFriendly;
  final double? rating;
  final String? additionalInfo;
  final bool isRoundTrip;
  final VoidCallback onTap;

  const TransportCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.departure,
    required this.arrival,
    this.departureTime,
    this.arrivalTime,
    required this.price,
    required this.currency,
    this.duration,
    this.features = const [],
    this.isHalalFriendly = false,
    this.rating,
    this.additionalInfo,
    this.isRoundTrip = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppConstants.cardElevation,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 12),
              if (departureTime != null && arrivalTime != null)
                _buildTimeRow(context)
              else
                _buildLocationRow(context),
              if (features.isNotEmpty) ...[
                const SizedBox(height: 12),
                _buildFeaturesRow(context),
              ],
              const SizedBox(height: 12),
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isHalalFriendly
                ? AppColors.success.withValues(alpha: 0.1)
                : AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            _getTransportIcon(),
            color: isHalalFriendly ? AppColors.success : AppColors.primary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (isHalalFriendly)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.success,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'HALAL',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTimeRow(BuildContext context) {
    if (departureTime == null || arrivalTime == null) {
      return _buildLocationRow(context);
    }

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('HH:mm').format(departureTime!),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                departure,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        Column(
          children: [
            Icon(
              _getDirectionIcon(),
              color: AppColors.primary,
              size: 16,
            ),
            if (duration != null)
              Text(
                duration!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(arrivalTime!),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                arrival,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.end,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            departure,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Icon(
          Icons.arrow_forward,
          color: AppColors.primary,
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            arrival,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturesRow(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: features.take(3).map((feature) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            feature,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatPrice(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (additionalInfo != null)
              Text(
                additionalInfo!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            if (isRoundTrip)
              Text(
                'Round Trip',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
              ),
          ],
        ),
        if (rating != null)
          Row(
            children: [
              Icon(
                Icons.star,
                color: AppColors.secondary,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                rating!.toStringAsFixed(1),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
      ],
    );
  }

  IconData _getTransportIcon() {
    if (title.toLowerCase().contains('flight') || 
        title.toLowerCase().contains('airline')) {
      return Icons.flight;
    } else if (title.toLowerCase().contains('train') ||
               title.toLowerCase().contains('shinkansen')) {
      return Icons.train;
    } else if (title.toLowerCase().contains('bus')) {
      return Icons.directions_bus;
    } else if (title.toLowerCase().contains('bike') ||
               title.toLowerCase().contains('cycle')) {
      return Icons.pedal_bike;
    } else if (title.toLowerCase().contains('car') ||
               title.toLowerCase().contains('rental')) {
      return Icons.directions_car;
    } else {
      return Icons.directions;
    }
  }

  IconData _getDirectionIcon() {
    if (title.toLowerCase().contains('flight')) {
      return Icons.flight_takeoff;
    } else if (title.toLowerCase().contains('train')) {
      return Icons.train;
    } else if (title.toLowerCase().contains('bus')) {
      return Icons.directions_bus;
    } else {
      return Icons.arrow_forward;
    }
  }

  String _formatPrice() {
    switch (currency) {
      case 'JPY':
        return '¥${NumberFormat('#,###').format(price)}';
      case 'USD':
        return '\$${NumberFormat('#,###.##').format(price)}';
      case 'EUR':
        return '€${NumberFormat('#,###.##').format(price)}';
      default:
        return '${NumberFormat('#,###.##').format(price)} $currency';
    }
  }
} 