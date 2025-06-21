import 'package:flutter/material.dart';
import 'package:safiyah/data/models/chat_message_model.dart';

class ToolResultCard extends StatelessWidget {
  final ToolCall toolCall;
  final VoidCallback? onNavigate;

  const ToolResultCard({
    super.key,
    required this.toolCall,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = toolCall.result;

    if (result == null) return const SizedBox.shrink();

    switch (toolCall.toolType) {
      case ToolType.hotelSearch:
        return _buildHotelSearchResult(context, theme, result);
      case ToolType.purchaseHistory:
        return _buildPurchaseHistoryResult(context, theme, result);
      case ToolType.prayerTime:
        return _buildPrayerTimeResult(context, theme, result);
      case ToolType.currencyConverter:
        return _buildCurrencyResult(context, theme, result);
      case ToolType.itineraryCreator:
        return _buildItineraryResult(context, theme, result);
      case ToolType.placeSearch:
        return _buildPlaceSearchResult(context, theme, result);
      case ToolType.weatherCheck:
        return _buildWeatherResult(context, theme, result);
      case ToolType.voucherSearch:
        return _buildVoucherResult(context, theme, result);
      default:
        return _buildGenericResult(context, theme, result);
    }
  }

  Widget _buildHotelSearchResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final hotels = result['hotels'] as List? ?? [];
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.hotel, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Found ${hotels.length} hotels',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                if (toolCall.navigationRoute != null)
                  TextButton(
                    onPressed: onNavigate,
                    child: const Text('View All'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            ...hotels.take(3).map((hotel) => _buildHotelItem(context, theme, hotel)),
          ],
        ),
      ),
    );
  }

  Widget _buildHotelItem(BuildContext context, ThemeData theme, Map<String, dynamic> hotel) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.hotel,
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  hotel['name'] ?? 'Hotel',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hotel['distance'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '${hotel['rating']}',
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${hotel['price']}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              Text(
                'per night',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPurchaseHistoryResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final purchases = result['purchases'] as List? ?? [];
    final totalSpent = result['totalSpent'] ?? 0;
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Purchase History',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Text(
                  'Total: \$$totalSpent',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...purchases.take(3).map((purchase) => _buildPurchaseItem(context, theme, purchase)),
            if (purchases.length > 3)
              Center(
                child: TextButton(
                  onPressed: onNavigate,
                  child: Text('View all ${purchases.length} purchases'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPurchaseItem(BuildContext context, ThemeData theme, Map<String, dynamic> purchase) {
    final statusColor = purchase['status'] == 'Completed' ? Colors.green : Colors.orange;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: statusColor,
            width: 3,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  purchase['name'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${purchase['type']} • ${purchase['date']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '\$${purchase['amount']}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  purchase['status'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: statusColor,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrayerTimeResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final times = result['times'] as Map<String, dynamic>? ?? {};
    final nextPrayer = result['nextPrayer'] ?? '';
    final timeUntilNext = result['timeUntilNext'] ?? '';
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.mosque, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Prayer Times',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onNavigate,
                  child: const Text('Open'),
                ),
              ],
            ),
            if (nextPrayer.isNotEmpty) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next: $nextPrayer',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          'in $timeUntilNext',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onPrimaryContainer.withOpacity(0.8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: times.entries.map((entry) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        entry.value,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.currency_exchange, color: theme.colorScheme.primary, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${result['amount']} ${result['from']}',
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.arrow_forward, size: 16, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${(result['converted'] as num).toStringAsFixed(2)} ${result['to']}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Rate: 1 ${result['from']} = ${(result['rate'] as num).toStringAsFixed(4)} ${result['to']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.open_in_new),
              onPressed: onNavigate,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final itinerary = result['itinerary'] as List? ?? [];
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.map, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  '${result['days']}-Day Itinerary for ${result['destination']}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onNavigate,
                  child: const Text('Edit'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.attach_money, size: 16, color: theme.colorScheme.primary),
                  const SizedBox(width: 4),
                  Text(
                    'Estimated Budget: \$${result['estimatedBudget']}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            ...itinerary.take(2).map((day) => _buildItineraryDay(context, theme, day)),
            if (itinerary.length > 2)
              Center(
                child: TextButton(
                  onPressed: onNavigate,
                  child: const Text('View Full Itinerary'),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItineraryDay(BuildContext context, ThemeData theme, Map<String, dynamic> day) {
    final activities = day['activities'] as List? ?? [];
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Day ${day['day']}',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ...activities.take(2).map((activity) {
            return Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activity['time'] ?? '',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activity['activity'] ?? '',
                      style: theme.textTheme.bodySmall,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPlaceSearchResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final places = result['places'] as List? ?? [];
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.place, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Found ${places.length} places',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onNavigate,
                  child: const Text('View Map'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...places.take(3).map((place) => _buildPlaceItem(context, theme, place)),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceItem(BuildContext context, ThemeData theme, Map<String, dynamic> place) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withOpacity(0.5),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _getPlaceIcon(place['category'] ?? ''),
              color: theme.colorScheme.onPrimaryContainer,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place['name'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 14),
                    const SizedBox(width: 2),
                    Text(
                      '${place['rating']}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                    const SizedBox(width: 2),
                    Text(
                      place['distance'] ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getPlaceIcon(String category) {
    switch (category) {
      case 'mosque':
        return Icons.mosque;
      case 'restaurant':
        return Icons.restaurant;
      case 'attraction':
        return Icons.attractions;
      case 'shopping':
        return Icons.shopping_bag;
      default:
        return Icons.place;
    }
  }

  Widget _buildWeatherResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final weather = result['weather'] as Map<String, dynamic>? ?? {};
    final current = weather['current'] as Map<String, dynamic>? ?? {};
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.wb_sunny, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Text(
                  result['location'] ?? 'Weather',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onNavigate,
                  child: const Text('Details'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text(
                  current['icon'] ?? '☀️',
                  style: const TextStyle(fontSize: 48),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${current['temperature']}°C',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      current['condition'] ?? '',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.water_drop, size: 16, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${current['humidity']}%',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(Icons.air, size: 16, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 4),
                        Text(
                          '${current['windSpeed']} km/h',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    final vouchers = result['vouchers'] as List? ?? [];
    
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_offer, color: theme.colorScheme.primary, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Found ${vouchers.length} vouchers',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onNavigate,
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...vouchers.take(3).map((voucher) => _buildVoucherItem(context, theme, voucher)),
          ],
        ),
      ),
    );
  }

  Widget _buildVoucherItem(BuildContext context, ThemeData theme, Map<String, dynamic> voucher) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primaryContainer,
            theme.colorScheme.primaryContainer.withOpacity(0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${voucher['discount']}%',
              style: TextStyle(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher['code'] ?? '',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  voucher['description'] ?? '',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Valid until ${voucher['validUntil']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenericResult(BuildContext context, ThemeData theme, Map<String, dynamic> result) {
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: theme.colorScheme.primary, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Task completed successfully',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (toolCall.navigationRoute != null)
                  IconButton(
                    icon: const Icon(Icons.open_in_new),
                    onPressed: onNavigate,
                  ),
              ],
            ),
            if (result['message'] != null) ...[
              const SizedBox(height: 8),
              Text(
                result['message'],
                style: theme.textTheme.bodyMedium,
              ),
            ],
          ],
        ),
      ),
    );
  }
} 