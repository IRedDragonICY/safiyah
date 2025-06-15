import 'package:equatable/equatable.dart';

import '../../../data/models/prayer_time_model.dart';

abstract class PrayerState extends Equatable {
  const PrayerState();

  @override
  List<Object?> get props => [];
}

class PrayerInitial extends PrayerState {
  const PrayerInitial();
}

class PrayerLoading extends PrayerState {
  const PrayerLoading();
}

class PrayerLoaded extends PrayerState {
  final PrayerTimeModel prayerTimes;

  const PrayerLoaded({required this.prayerTimes});

  @override
  List<Object?> get props => [prayerTimes];
}

class PrayerError extends PrayerState {
  final String message;

  const PrayerError({required this.message});

  @override
  List<Object?> get props => [message];
}