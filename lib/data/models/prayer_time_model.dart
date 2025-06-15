import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'prayer_time_model.g.dart';

@JsonSerializable()
class PrayerTimeModel extends Equatable {
  final DateTime date;
  final DateTime fajr;
  final DateTime sunrise;
  final DateTime dhuhr;
  final DateTime asr;
  final DateTime maghrib;
  final DateTime isha;
  final double latitude;
  final double longitude;
  final String locationName;
  final double qiblaDirection;

  const PrayerTimeModel({
    required this.date,
    required this.fajr,
    required this.sunrise,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.latitude,
    required this.longitude,
    required this.locationName,
    required this.qiblaDirection,
  });

  factory PrayerTimeModel.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimeModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimeModelToJson(this);

  List<PrayerTime> get prayersList {
    return [
      PrayerTime(name: 'Fajr', time: fajr),
      PrayerTime(name: 'Sunrise', time: sunrise),
      PrayerTime(name: 'Dhuhr', time: dhuhr),
      PrayerTime(name: 'Asr', time: asr),
      PrayerTime(name: 'Maghrib', time: maghrib),
      PrayerTime(name: 'Isha', time: isha),
    ];
  }

  int get durationInDays {
    return 1; // Single day prayer times
  }

  PrayerTime? getNextPrayer() {
    final now = DateTime.now();
    final prayers = prayersList;

    for (final prayer in prayers) {
      if (prayer.time.isAfter(now) && prayer.name != 'Sunrise') {
        return prayer;
      }
    }

    // If no prayer found today, return tomorrow's Fajr
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return PrayerTime(
      name: 'Fajr',
      time: DateTime(tomorrow.year, tomorrow.month, tomorrow.day, fajr.hour, fajr.minute),
    );
  }

  PrayerTime? getCurrentPrayer() {
    final now = DateTime.now();
    final prayers = prayersList.where((p) => p.name != 'Sunrise').toList();

    PrayerTime? currentPrayer;

    for (int i = 0; i < prayers.length; i++) {
      final prayer = prayers[i];

      if (now.isAfter(prayer.time)) {
        currentPrayer = prayer;
      } else {
        break;
      }
    }

    // If before Fajr, consider it as previous day's Isha
    if (currentPrayer == null && now.isBefore(fajr)) {
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      return PrayerTime(
        name: 'Isha',
        time: DateTime(yesterday.year, yesterday.month, yesterday.day, isha.hour, isha.minute),
      );
    }

    return currentPrayer;
  }

  bool isPrayerTime(String prayerName, {int toleranceMinutes = 5}) {
    final now = DateTime.now();
    final prayer = prayersList.firstWhere(
      (p) => p.name.toLowerCase() == prayerName.toLowerCase(),
      orElse: () => PrayerTime(name: '', time: DateTime.now()),
    );

    if (prayer.name.isEmpty) return false;

    final difference = now.difference(prayer.time).inMinutes.abs();
    return difference <= toleranceMinutes;
  }

  Duration? getTimeUntilPrayer(String prayerName) {
    final prayer = prayersList.firstWhere(
      (p) => p.name.toLowerCase() == prayerName.toLowerCase(),
      orElse: () => PrayerTime(name: '', time: DateTime.now()),
    );

    if (prayer.name.isEmpty) return null;

    final now = DateTime.now();
    if (prayer.time.isAfter(now)) {
      return prayer.time.difference(now);
    } else {
      // Next day prayer
      final tomorrow = DateTime(now.year, now.month, now.day + 1);
      final nextDayPrayer = DateTime(
        tomorrow.year,
        tomorrow.month,
        tomorrow.day,
        prayer.time.hour,
        prayer.time.minute,
      );
      return nextDayPrayer.difference(now);
    }
  }

  String getFormattedTime(String prayerName) {
    final prayer = prayersList.firstWhere(
      (p) => p.name.toLowerCase() == prayerName.toLowerCase(),
      orElse: () => PrayerTime(name: '', time: DateTime.now()),
    );

    if (prayer.name.isEmpty) return '';

    final hour = prayer.time.hour.toString().padLeft(2, '0');
    final minute = prayer.time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  List<PrayerTime> getRemainingPrayers() {
    final now = DateTime.now();
    return prayersList.where((prayer) =>
      prayer.time.isAfter(now) && prayer.name != 'Sunrise'
    ).toList();
  }

  List<PrayerTime> getPassedPrayers() {
    final now = DateTime.now();
    return prayersList.where((prayer) =>
      prayer.time.isBefore(now)
    ).toList();
  }

  bool get isValidDay {
    final now = DateTime.now();
    return date.year == now.year &&
           date.month == now.month &&
           date.day == now.day;
  }

  Map<String, String> get formattedTimes {
    return {
      'fajr': getFormattedTime('Fajr'),
      'sunrise': getFormattedTime('Sunrise'),
      'dhuhr': getFormattedTime('Dhuhr'),
      'asr': getFormattedTime('Asr'),
      'maghrib': getFormattedTime('Maghrib'),
      'isha': getFormattedTime('Isha'),
    };
  }

  @override
  List<Object?> get props => [
        date,
        fajr,
        sunrise,
        dhuhr,
        asr,
        maghrib,
        isha,
        latitude,
        longitude,
        locationName,
        qiblaDirection,
      ];
}

@JsonSerializable()
class PrayerTime extends Equatable {
  final String name;
  final DateTime time;

  const PrayerTime({
    required this.name,
    required this.time,
  });

  factory PrayerTime.fromJson(Map<String, dynamic> json) =>
      _$PrayerTimeFromJson(json);

  Map<String, dynamic> toJson() => _$PrayerTimeToJson(this);

  String get formattedTime {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get twelveHourFormat {
    final hour = time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final amPm = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $amPm';
  }

  bool get isToday {
    final now = DateTime.now();
    return time.year == now.year &&
           time.month == now.month &&
           time.day == now.day;
  }

  bool get isPassed {
    return time.isBefore(DateTime.now());
  }

  bool get isUpcoming {
    return time.isAfter(DateTime.now());
  }

  Duration get timeRemaining {
    final now = DateTime.now();
    if (time.isAfter(now)) {
      return time.difference(now);
    } else {
      return Duration.zero;
    }
  }

  @override
  List<Object?> get props => [name, time];
}