import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/prayer_repository.dart';
import 'prayer_event.dart';
import 'prayer_state.dart';

class PrayerBloc extends Bloc<PrayerEvent, PrayerState> {
  final PrayerRepository _prayerRepository;

  PrayerBloc({
    required PrayerRepository prayerRepository,
  })  : _prayerRepository = prayerRepository,
        super(const PrayerInitial()) {
    on<LoadPrayerTimes>(_onLoadPrayerTimes);
    on<RefreshPrayerTimes>(_onRefreshPrayerTimes);
    on<UpdatePrayerSettings>(_onUpdatePrayerSettings);
  }

  Future<void> _onLoadPrayerTimes(
    LoadPrayerTimes event,
    Emitter<PrayerState> emit,
  ) async {
    try {
      emit(const PrayerLoading());
      
      final prayerTimes = await _prayerRepository.getPrayerTimes(
        latitude: event.latitude,
        longitude: event.longitude,
        date: event.date,
      );
      
      emit(PrayerLoaded(prayerTimes: prayerTimes));
    } catch (e) {
      emit(PrayerError(message: e.toString()));
    }
  }

  Future<void> _onRefreshPrayerTimes(
    RefreshPrayerTimes event,
    Emitter<PrayerState> emit,
  ) async {
    await _onLoadPrayerTimes(const LoadPrayerTimes(), emit);
  }

  Future<void> _onUpdatePrayerSettings(
    UpdatePrayerSettings event,
    Emitter<PrayerState> emit,
  ) async {
    // Update settings and reload prayer times
    await _onLoadPrayerTimes(const LoadPrayerTimes(), emit);
  }
}