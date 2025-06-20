import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/models/event_model.dart';
import '../../../data/repositories/events_repository.dart';
import 'events_event.dart';
import 'events_state.dart';

class EventsBloc extends Bloc<EventsEvent, EventsState> {
  final EventsRepository _eventsRepository;

  EventsBloc({
    required EventsRepository eventsRepository,
  })  : _eventsRepository = eventsRepository,
        super(const EventsInitial()) {
    on<LoadEvents>(_onLoadEvents);
    on<LoadEventById>(_onLoadEventById);
    on<SearchEvents>(_onSearchEvents);
    on<FilterEventsByCategory>(_onFilterEventsByCategory);
    on<FilterEventsByType>(_onFilterEventsByType);
    on<LoadUpcomingEvents>(_onLoadUpcomingEvents);
    on<LoadOngoingEvents>(_onLoadOngoingEvents);
    on<LoadFreeEvents>(_onLoadFreeEvents);
    on<LoadEventsByMonth>(_onLoadEventsByMonth);
    on<RefreshEvents>(_onRefreshEvents);
    on<FilterEvents>(_onFilterEvents);
    on<ClearFilters>(_onClearFilters);
    on<SortEvents>(_onSortEvents);
  }

  Future<void> _onLoadEvents(
    LoadEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final events = await _eventsRepository.getAllEvents();
      
      if (events.isEmpty) {
        emit(const EventsEmpty());
      } else {
        emit(EventsLoaded(events: events));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadEventById(
    LoadEventById event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final eventModel = await _eventsRepository.getEventById(event.eventId);
      
      if (eventModel != null) {
        emit(EventDetailLoaded(event: eventModel));
      } else {
        emit(const EventsError(message: 'Event not found'));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onSearchEvents(
    SearchEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final events = await _eventsRepository.searchEvents(event.query);
      
      if (events.isEmpty) {
        emit(EventsEmpty(message: 'No events found for "${event.query}"'));
      } else {
        emit(EventsLoaded(
          events: events,
          searchQuery: event.query,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onFilterEventsByCategory(
    FilterEventsByCategory event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      if (event.category == null) {
        final events = await _eventsRepository.getAllEvents();
        emit(EventsLoaded(events: events));
      } else {
        final events = await _eventsRepository.getEventsByCategory(event.category!);
        
        if (events.isEmpty) {
          emit(EventsEmpty(message: 'No ${event.category!.displayName.toLowerCase()} events found'));
        } else {
          emit(EventsLoaded(
            events: events,
            categoryFilter: event.category,
          ));
        }
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onFilterEventsByType(
    FilterEventsByType event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      if (event.type == null) {
        final events = await _eventsRepository.getAllEvents();
        emit(EventsLoaded(events: events));
      } else {
        final events = await _eventsRepository.getEventsByType(event.type!);
        
        if (events.isEmpty) {
          emit(EventsEmpty(message: 'No ${event.type!.displayName.toLowerCase()} events found'));
        } else {
          emit(EventsLoaded(
            events: events,
            typeFilter: event.type,
          ));
        }
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadUpcomingEvents(
    LoadUpcomingEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final events = await _eventsRepository.getUpcomingEvents();
      
      if (events.isEmpty) {
        emit(const EventsEmpty(message: 'No upcoming events found'));
      } else {
        emit(EventsLoaded(events: events));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadOngoingEvents(
    LoadOngoingEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final events = await _eventsRepository.getOngoingEvents();
      
      if (events.isEmpty) {
        emit(const EventsEmpty(message: 'No ongoing events found'));
      } else {
        emit(EventsLoaded(events: events));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadFreeEvents(
    LoadFreeEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final events = await _eventsRepository.getFreeEvents();
      
      if (events.isEmpty) {
        emit(const EventsEmpty(message: 'No free events found'));
      } else {
        emit(EventsLoaded(
          events: events,
          isFreeFilter: true,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onLoadEventsByMonth(
    LoadEventsByMonth event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      final events = await _eventsRepository.getEventsByMonth(event.month);
      
      if (events.isEmpty) {
        emit(const EventsEmpty(message: 'No events found for the selected month'));
      } else {
        emit(EventsLoaded(events: events));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onRefreshEvents(
    RefreshEvents event,
    Emitter<EventsState> emit,
  ) async {
    await _onLoadEvents(const LoadEvents(), emit);
  }

  Future<void> _onFilterEvents(
    FilterEvents event,
    Emitter<EventsState> emit,
  ) async {
    try {
      emit(const EventsLoading());
      
      var events = await _eventsRepository.getAllEvents();
      
      // Apply filters
      if (event.type != null) {
        events = events.where((e) => e.type == event.type).toList();
      }
      
      if (event.category != null) {
        events = events.where((e) => e.category == event.category).toList();
      }
      
      if (event.isFree != null) {
        events = events.where((e) => e.priceInfo.isFree == event.isFree).toList();
      }
      
      if (event.requiresTicket != null) {
        events = events.where((e) => e.requiresTicket == event.requiresTicket).toList();
      }
      
      if (event.startDate != null) {
        events = events.where((e) => 
          e.startDate.isAfter(event.startDate!) || 
          e.startDate.isAtSameMomentAs(event.startDate!)
        ).toList();
      }
      
      if (event.endDate != null) {
        events = events.where((e) => 
          e.endDate.isBefore(event.endDate!) || 
          e.endDate.isAtSameMomentAs(event.endDate!)
        ).toList();
      }
      
      if (events.isEmpty) {
        emit(const EventsEmpty(message: 'No events match the selected filters'));
      } else {
        emit(EventsLoaded(
          events: events,
          typeFilter: event.type,
          categoryFilter: event.category,
          isFreeFilter: event.isFree,
          requiresTicketFilter: event.requiresTicket,
          startDateFilter: event.startDate,
          endDateFilter: event.endDate,
        ));
      }
    } catch (e) {
      emit(EventsError(message: e.toString()));
    }
  }

  Future<void> _onClearFilters(
    ClearFilters event,
    Emitter<EventsState> emit,
  ) async {
    if (state is EventsLoaded) {
      final currentState = state as EventsLoaded;
      final allEvents = await _eventsRepository.getAllEvents();
      
      emit(currentState.copyWith(
        events: allEvents,
        clearFilters: true,
      ));
    } else {
      await _onLoadEvents(const LoadEvents(), emit);
    }
  }

  Future<void> _onSortEvents(
    SortEvents event,
    Emitter<EventsState> emit,
  ) async {
    if (state is EventsLoaded) {
      final currentState = state as EventsLoaded;
      final sortedEvents = _sortEventsList(currentState.events, event.sortType);
      
      emit(currentState.copyWith(
        events: sortedEvents,
        sortType: event.sortType,
      ));
    }
  }

  List<EventModel> _sortEventsList(List<EventModel> events, EventSortType sortType) {
    final sortedEvents = List<EventModel>.from(events);
    
    switch (sortType) {
      case EventSortType.startDate:
        sortedEvents.sort((a, b) => a.startDate.compareTo(b.startDate));
        break;
      case EventSortType.name:
        sortedEvents.sort((a, b) => a.name.compareTo(b.name));
        break;
      case EventSortType.rating:
        sortedEvents.sort((a, b) => b.rating.compareTo(a.rating));
        break;
      case EventSortType.attendeeCount:
        sortedEvents.sort((a, b) => b.attendeeCount.compareTo(a.attendeeCount));
        break;
      case EventSortType.price:
        sortedEvents.sort((a, b) {
          if (a.priceInfo.isFree && !b.priceInfo.isFree) return -1;
          if (!a.priceInfo.isFree && b.priceInfo.isFree) return 1;
          if (a.priceInfo.isFree && b.priceInfo.isFree) return 0;
          
          final aPrice = a.priceInfo.minPrice ?? 0;
          final bPrice = b.priceInfo.minPrice ?? 0;
          return aPrice.compareTo(bPrice);
        });
        break;
    }
    
    return sortedEvents;
  }
} 
