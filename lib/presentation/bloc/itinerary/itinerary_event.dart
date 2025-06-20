import 'package:equatable/equatable.dart';

import '../../../data/models/itinerary_model.dart';

abstract class ItineraryEvent extends Equatable {
  const ItineraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadItineraries extends ItineraryEvent {
  const LoadItineraries();
}

class CreateItinerary extends ItineraryEvent {
  final ItineraryModel itinerary;

  const CreateItinerary({required this.itinerary});

  @override
  List<Object?> get props => [itinerary];
}

class UpdateItinerary extends ItineraryEvent {
  final ItineraryModel itinerary;

  const UpdateItinerary({required this.itinerary});

  @override
  List<Object?> get props => [itinerary];
}

class DeleteItinerary extends ItineraryEvent {
  final String itineraryId;

  const DeleteItinerary({required this.itineraryId});

  @override
  List<Object?> get props => [itineraryId];
}

class LoadItineraryById extends ItineraryEvent {
  final String itineraryId;

  const LoadItineraryById({required this.itineraryId});

  @override
  List<Object?> get props => [itineraryId];
}

class AddActivityToItinerary extends ItineraryEvent {
  final String itineraryId;
  final DateTime date;
  final ItineraryActivity activity;

  const AddActivityToItinerary({
    required this.itineraryId,
    required this.date,
    required this.activity,
  });

  @override
  List<Object?> get props => [itineraryId, date, activity];
}

class UpdateActivity extends ItineraryEvent {
  final String itineraryId;
  final DateTime date;
  final ItineraryActivity activity;

  const UpdateActivity({
    required this.itineraryId,
    required this.date,
    required this.activity,
  });

  @override
  List<Object?> get props => [itineraryId, date, activity];
}

class DeleteActivity extends ItineraryEvent {
  final String itineraryId;
  final DateTime date;
  final String activityId;

  const DeleteActivity({
    required this.itineraryId,
    required this.date,
    required this.activityId,
  });

  @override
  List<Object?> get props => [itineraryId, date, activityId];
}

class MarkActivityCompleted extends ItineraryEvent {
  final String itineraryId;
  final DateTime date;
  final String activityId;
  final bool isCompleted;

  const MarkActivityCompleted({
    required this.itineraryId,
    required this.date,
    required this.activityId,
    required this.isCompleted,
  });

  @override
  List<Object?> get props => [itineraryId, date, activityId, isCompleted];
}

class SearchItineraries extends ItineraryEvent {
  final String query;

  const SearchItineraries({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterItineraries extends ItineraryEvent {
  final String? destination;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? tags;

  const FilterItineraries({
    this.destination,
    this.startDate,
    this.endDate,
    this.tags,
  });

  @override
  List<Object?> get props => [destination, startDate, endDate, tags];
}
