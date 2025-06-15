import 'package:equatable/equatable.dart';

import '../../../data/models/place_model.dart';

abstract class PlacesState extends Equatable {
  const PlacesState();

  @override
  List<Object?> get props => [];
}

class PlacesInitial extends PlacesState {
  const PlacesInitial();
}

class PlacesLoading extends PlacesState {
  const PlacesLoading();
}

class PlacesLoaded extends PlacesState {
  final List<PlaceModel> places;
  final PlaceType? filter;
  final String? searchQuery;

  const PlacesLoaded({
    required this.places,
    this.filter,
    this.searchQuery,
  });

  @override
  List<Object?> get props => [places, filter, searchQuery];
}

class PlaceDetailLoaded extends PlacesState {
  final PlaceModel place;

  const PlaceDetailLoaded({required this.place});

  @override
  List<Object?> get props => [place];
}

class PlacesError extends PlacesState {
  final String message;

  const PlacesError({required this.message});

  @override
  List<Object?> get props => [message];
}