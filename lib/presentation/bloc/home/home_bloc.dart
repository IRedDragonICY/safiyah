import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/prayer_repository.dart';
import '../../../data/models/weather_model.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final PrayerRepository _prayerRepository;

  HomeBloc({
    required PrayerRepository prayerRepository,
  })  : _prayerRepository = prayerRepository,
        super(const HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
    on<UpdateLocation>(_onUpdateLocation);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(const HomeLoading());

      final prayerTimes = await _prayerRepository.getPrayerTimes();

      final weather = _getDummyWeather();

      emit(HomeLoaded(
        prayerTimes: prayerTimes,
        weather: weather,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  Future<void> _onRefreshHomeData(
    RefreshHomeData event,
    Emitter<HomeState> emit,
  ) async {
    await _onLoadHomeData(const LoadHomeData(), emit);
  }

  Future<void> _onUpdateLocation(
    UpdateLocation event,
    Emitter<HomeState> emit,
  ) async {
    try {
      final prayerTimes = await _prayerRepository.getPrayerTimes(
        latitude: event.latitude,
        longitude: event.longitude,
      );

      final weather = _getDummyWeather();

      emit(HomeLoaded(
        prayerTimes: prayerTimes,
        weather: weather,
      ));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }

  WeatherModel _getDummyWeather() {
    return const WeatherModel(
      temperature: 18.0,
      condition: 'Partly Cloudy',
      humidity: 60,
      windSpeed: 15.0,
      location: 'Tokyo, Japan',
    );
  }
}