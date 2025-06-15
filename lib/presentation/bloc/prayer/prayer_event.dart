import 'package:equatable/equatable.dart';

abstract class PrayerEvent extends Equatable {
  const PrayerEvent();

  @override
  List<Object?> get props => [];
}

class LoadPrayerTimes extends PrayerEvent {
  final double? latitude;
  final double? longitude;
  final DateTime? date;

  const LoadPrayerTimes({
    this.latitude,
    this.longitude,
    this.date,
  });

  @override
  List<Object?> get props => [latitude, longitude, date];
}

class RefreshPrayerTimes extends PrayerEvent {
  const RefreshPrayerTimes();
}

class UpdatePrayerSettings extends PrayerEvent {
  final String madhab;
  final String calculationMethod;

  const UpdatePrayerSettings({
    required this.madhab,
    required this.calculationMethod,
  });

  @override
  List<Object?> get props => [madhab, calculationMethod];
}