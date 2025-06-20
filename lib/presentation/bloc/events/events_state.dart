import 'package:equatable/equatable.dart';

import '../../../data/models/event_model.dart';
import 'events_event.dart';

abstract class EventsState extends Equatable {
  const EventsState();

  @override
  List<Object?> get props => [];
}

class EventsInitial extends EventsState {
  const EventsInitial();
}

class EventsLoading extends EventsState {
  const EventsLoading();
}

class EventsLoaded extends EventsState {
  final List<EventModel> events;
  final EventType? typeFilter;
  final EventCategory? categoryFilter;
  final String? searchQuery;
  final bool? isFreeFilter;
  final bool? requiresTicketFilter;
  final DateTime? startDateFilter;
  final DateTime? endDateFilter;
  final EventSortType? sortType;

  const EventsLoaded({
    required this.events,
    this.typeFilter,
    this.categoryFilter,
    this.searchQuery,
    this.isFreeFilter,
    this.requiresTicketFilter,
    this.startDateFilter,
    this.endDateFilter,
    this.sortType,
  });

  EventsLoaded copyWith({
    List<EventModel>? events,
    EventType? typeFilter,
    EventCategory? categoryFilter,
    String? searchQuery,
    bool? isFreeFilter,
    bool? requiresTicketFilter,
    DateTime? startDateFilter,
    DateTime? endDateFilter,
    EventSortType? sortType,
    bool clearFilters = false,
  }) {
    if (clearFilters) {
      return EventsLoaded(
        events: events ?? this.events,
        typeFilter: null,
        categoryFilter: null,
        searchQuery: null,
        isFreeFilter: null,
        requiresTicketFilter: null,
        startDateFilter: null,
        endDateFilter: null,
        sortType: null,
      );
    }
    
    return EventsLoaded(
      events: events ?? this.events,
      typeFilter: typeFilter ?? this.typeFilter,
      categoryFilter: categoryFilter ?? this.categoryFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      isFreeFilter: isFreeFilter ?? this.isFreeFilter,
      requiresTicketFilter: requiresTicketFilter ?? this.requiresTicketFilter,
      startDateFilter: startDateFilter ?? this.startDateFilter,
      endDateFilter: endDateFilter ?? this.endDateFilter,
      sortType: sortType ?? this.sortType,
    );
  }

  bool get hasActiveFilters {
    return typeFilter != null ||
           categoryFilter != null ||
           searchQuery != null ||
           isFreeFilter != null ||
           requiresTicketFilter != null ||
           startDateFilter != null ||
           endDateFilter != null;
  }

  @override
  List<Object?> get props => [
        events,
        typeFilter,
        categoryFilter,
        searchQuery,
        isFreeFilter,
        requiresTicketFilter,
        startDateFilter,
        endDateFilter,
        sortType,
      ];
}

class EventDetailLoaded extends EventsState {
  final EventModel event;

  const EventDetailLoaded({required this.event});

  @override
  List<Object?> get props => [event];
}

class EventsError extends EventsState {
  final String message;

  const EventsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class EventsEmpty extends EventsState {
  final String message;

  const EventsEmpty({
    this.message = 'No events found',
  });

  @override
  List<Object?> get props => [message];
} 
