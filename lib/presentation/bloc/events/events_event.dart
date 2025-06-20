import 'package:equatable/equatable.dart';

import '../../../data/models/event_model.dart';

abstract class EventsEvent extends Equatable {
  const EventsEvent();

  @override
  List<Object?> get props => [];
}

class LoadEvents extends EventsEvent {
  const LoadEvents();
}

class LoadEventById extends EventsEvent {
  final String eventId;

  const LoadEventById({required this.eventId});

  @override
  List<Object?> get props => [eventId];
}

class SearchEvents extends EventsEvent {
  final String query;

  const SearchEvents({required this.query});

  @override
  List<Object?> get props => [query];
}

class FilterEventsByCategory extends EventsEvent {
  final EventCategory? category;

  const FilterEventsByCategory({this.category});

  @override
  List<Object?> get props => [category];
}

class FilterEventsByType extends EventsEvent {
  final EventType? type;

  const FilterEventsByType({this.type});

  @override
  List<Object?> get props => [type];
}

class LoadUpcomingEvents extends EventsEvent {
  const LoadUpcomingEvents();
}

class LoadOngoingEvents extends EventsEvent {
  const LoadOngoingEvents();
}

class LoadFreeEvents extends EventsEvent {
  const LoadFreeEvents();
}

class LoadEventsByMonth extends EventsEvent {
  final int month;

  const LoadEventsByMonth({required this.month});

  @override
  List<Object?> get props => [month];
}

class RefreshEvents extends EventsEvent {
  const RefreshEvents();
}

class FilterEvents extends EventsEvent {
  final EventType? type;
  final EventCategory? category;
  final bool? isFree;
  final bool? requiresTicket;
  final DateTime? startDate;
  final DateTime? endDate;

  const FilterEvents({
    this.type,
    this.category,
    this.isFree,
    this.requiresTicket,
    this.startDate,
    this.endDate,
  });

  @override
  List<Object?> get props => [
        type,
        category,
        isFree,
        requiresTicket,
        startDate,
        endDate,
      ];
}

class ClearFilters extends EventsEvent {
  const ClearFilters();
}

class SortEvents extends EventsEvent {
  final EventSortType sortType;

  const SortEvents({required this.sortType});

  @override
  List<Object?> get props => [sortType];
}

enum EventSortType {
  startDate,
  name,
  rating,
  attendeeCount,
  price,
} 