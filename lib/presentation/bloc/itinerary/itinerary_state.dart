import 'package:equatable/equatable.dart';

import '../../../data/models/itinerary_model.dart';

abstract class ItineraryState extends Equatable {
  const ItineraryState();

  @override
  List<Object?> get props => [];
}

class ItineraryInitial extends ItineraryState {
  const ItineraryInitial();
}

class ItineraryLoading extends ItineraryState {
  const ItineraryLoading();
}

class ItineraryLoaded extends ItineraryState {
  final List<ItineraryModel> itineraries;
  final ItineraryModel? selectedItinerary;
  final String? searchQuery;
  final Map<String, dynamic>? filters;

  const ItineraryLoaded({
    required this.itineraries,
    this.selectedItinerary,
    this.searchQuery,
    this.filters,
  });

  ItineraryLoaded copyWith({
    List<ItineraryModel>? itineraries,
    ItineraryModel? selectedItinerary,
    String? searchQuery,
    Map<String, dynamic>? filters,
  }) {
    return ItineraryLoaded(
      itineraries: itineraries ?? this.itineraries,
      selectedItinerary: selectedItinerary ?? this.selectedItinerary,
      searchQuery: searchQuery ?? this.searchQuery,
      filters: filters ?? this.filters,
    );
  }

  @override
  List<Object?> get props => [itineraries, selectedItinerary, searchQuery, filters];
}

class ItineraryError extends ItineraryState {
  final String message;

  const ItineraryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ItineraryOperationLoading extends ItineraryState {
  final String operation;

  const ItineraryOperationLoading({required this.operation});

  @override
  List<Object?> get props => [operation];
}

class ItineraryOperationSuccess extends ItineraryState {
  final String message;
  final ItineraryModel? itinerary;

  const ItineraryOperationSuccess({
    required this.message,
    this.itinerary,
  });

  @override
  List<Object?> get props => [message, itinerary];
}

class ItineraryOperationError extends ItineraryState {
  final String message;

  const ItineraryOperationError({required this.message});

  @override
  List<Object?> get props => [message];
}