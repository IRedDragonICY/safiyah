import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/colors.dart';
import '../../../data/models/prayer_time_model.dart';

class PrayerTimesWidget extends StatelessWidget {
  final PrayerTimeModel? prayerTimes;

  const PrayerTimesWidget({
    super.key,
    this.prayerTimes,
  });

  @override
  Widget build(BuildContext context) {
    if (prayerTimes == null) return const SizedBox.shrink();

    final nextPrayer = prayerTimes!.getNextPrayer();
    final timeFormat = DateFormat('HH:mm');

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
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.schedule,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Prayer Times',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        prayerTimes!.locationName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                if (nextPrayer != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.prayerTime.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Next: ${nextPrayer.name}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.prayerTime,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildPrayerTimeItem(
                    context,
                    'Fajr',
                    timeFormat.format(prayerTimes!.fajr),
                    nextPrayer?.name == 'Fajr',
                  ),
                ),
                Expanded(
                  child: _buildPrayerTimeItem(
                    context,
                    'Dhuhr',
                    timeFormat.format(prayerTimes!.dhuhr),
                    nextPrayer?.name == 'Dhuhr',
                  ),
                ),
                Expanded(
                  child: _buildPrayerTimeItem(
                    context,
                    'Asr',
                    timeFormat.format(prayerTimes!.asr),
                    nextPrayer?.name == 'Asr',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildPrayerTimeItem(
                    context,
                    'Maghrib',
                    timeFormat.format(prayerTimes!.maghrib),
                    nextPrayer?.name == 'Maghrib',
                  ),
                ),
                Expanded(
                  child: _buildPrayerTimeItem(
                    context,
                    'Isha',
                    timeFormat.format(prayerTimes!.isha),
                    nextPrayer?.name == 'Isha',
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPrayerTimeItem(
    BuildContext context,
    String name,
    String time,
    bool isNext,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isNext 
                  ? AppColors.primary.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              name,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isNext ? AppColors.primary : Colors.grey[600],
                fontWeight: isNext ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isNext ? FontWeight.bold : FontWeight.w500,
              color: isNext ? AppColors.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}