import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/repositories/place_repository.dart';
import 'places_event.dart';
import 'places_state.dart';

class PlacesBloc extends Bloc<PlacesEvent, PlacesState> {
  final PlaceRepository _placeRepository;

  PlacesBloc({
    required PlaceRepository placeRepository,
  })  : _placeRepository = placeRepository,
        super(const PlacesInitial()) {
    on<LoadNearbyPlaces>(_onLoadNearbyPlaces);
    on<SearchPlaces>(_onSearchPlaces);
    on<LoadPlaceById>(_onLoadPlaceById);
    on<FilterPlaces>(_onFilterPlaces);
  }

  Future<void> _onLoadNearbyPlaces(
    LoadNearbyPlaces event,
    Emitter<PlacesState> emit,
  ) async {
    try {
      emit(const PlacesLoading());
      
      final places = await _placeRepository.getNearbyPlaces(
        latitude: event.latitude,
        longitude: event.longitude,
        type: event.type,
        radius: event.radius,
      );
      
      emit(PlacesLoaded(
        places: places,
        filter: event.type,
      ));
    } catch (e) {
      emit(PlacesError(message: e.toString()));
    }
  }

  Future<void> _onSearchPlaces(
    SearchPlaces event,
    Emitter<PlacesState> emit,
  ) async {
    try {
      emit(const PlacesLoading());
      
      final places = await _placeRepository.searchPlaces(event.query);
      
      emit(PlacesLoaded(
        places: places,
        searchQuery: event.query,
      ));
    } catch (e) {
      emit(PlacesError(message: e.toString()));
    }
  }

  Future<void> _onLoadPlaceById(
    LoadPlaceById event,
    Emitter<PlacesState> emit,
  ) async {
    try {
      emit(const PlacesLoading());
      
      final place = await _placeRepository.getPlaceById(event.id);
      
      if (place != null) {
        emit(PlaceDetailLoaded(place: place));
      } else {
        emit(const PlacesError(message: 'Place not found'));
      }
    } catch (e) {
      emit(PlacesError(message: e.toString()));
    }
  }

  Future<void> _onFilterPlaces(
    FilterPlaces event,
    Emitter<PlacesState> emit,
  ) async {
    try {
      emit(const PlacesLoading());
      
      final places = await _placeRepository.getNearbyPlaces(
        type: event.type,
      );
      
      // Apply additional filters
      var filteredPlaces = places;
      
      if (event.isHalalCertified != null) {
        filteredPlaces = filteredPlaces
            .where((place) => place.isHalalCertified == event.isHalalCertified)
            .toList();
      }
      
      if (event.minRating != null) {
        filteredPlaces = filteredPlaces
            .where((place) => place.rating >= event.minRating!)
            .toList();
      }
      
      emit(PlacesLoaded(
        places: filteredPlaces,
        filter: event.type,
      ));
    } catch (e) {
      emit(PlacesError(message: e.toString()));
    }
  }
}
