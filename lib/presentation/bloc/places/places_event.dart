import 'package:equatable/equatable.dart';

import '../../../data/models/place_model.dart';

abstract class PlacesEvent extends Equatable {
  const PlacesEvent();

  @override
  List<Object?> get props => [];
}

class LoadNearbyPlaces extends PlacesEvent {
  final double? latitude;
  final double? longitude;
  final PlaceType? type;
  final int radius;

  const LoadNearbyPlaces({
    this.latitude,
    this.longitude,
    this.type,
    this.radius = 5000,
  });

  @override
  List<Object?> get props => [latitude, longitude, type, radius];
}

class SearchPlaces extends PlacesEvent {
  final String query;

  const SearchPlaces({required this.query});

  @override
  List<Object?> get props => [query];
}

class LoadPlaceById extends PlacesEvent {
  final String id;

  const LoadPlaceById({required this.id});

  @override
  List<Object?> get props => [id];
}

class FilterPlaces extends PlacesEvent {
  final PlaceType? type;
  final bool? isHalalCertified;
  final double? minRating;

  const FilterPlaces({
    this.type,
    this.isHalalCertified,
    this.minRating,
  });

  @override
  List<Object?> get props => [type, isHalalCertified, minRating];
}