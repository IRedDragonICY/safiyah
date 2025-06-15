import 'package:equatable/equatable.dart';

import '../../../data/models/prayer_time_model.dart';
import '../../../data/models/weather_model.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final PrayerTimeModel prayerTimes;
  final WeatherModel weather;

  const HomeLoaded({
    required this.prayerTimes,
    required this.weather,
  });

  @override
  List<Object?> get props => [prayerTimes, weather];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object?> get props => [message];
}