import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../data/models/itinerary_model.dart';
import '../../../data/repositories/itinerary_repository.dart';
import 'itinerary_event.dart';
import 'itinerary_state.dart';

class ItineraryBloc extends Bloc<ItineraryEvent, ItineraryState> {
  final ItineraryRepository _itineraryRepository;
  final Uuid _uuid = const Uuid();

  ItineraryBloc({
    required ItineraryRepository itineraryRepository,
  })  : _itineraryRepository = itineraryRepository,
        super(const ItineraryInitial()) {
    on<LoadItineraries>(_onLoadItineraries);
    on<CreateItinerary>(_onCreateItinerary);
    on<UpdateItinerary>(_onUpdateItinerary);
    on<DeleteItinerary>(_onDeleteItinerary);
    on<LoadItineraryById>(_onLoadItineraryById);
    on<AddActivityToItinerary>(_onAddActivityToItinerary);
    on<UpdateActivity>(_onUpdateActivity);
    on<DeleteActivity>(_onDeleteActivity);
    on<MarkActivityCompleted>(_onMarkActivityCompleted);
    on<SearchItineraries>(_onSearchItineraries);
    on<FilterItineraries>(_onFilterItineraries);
  }

  Future<void> _onLoadItineraries(
    LoadItineraries event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryLoading());
      
      final itineraries = await _itineraryRepository.getAllItineraries();
      
      emit(ItineraryLoaded(itineraries: itineraries));
    } catch (e) {
      emit(ItineraryError(message: e.toString()));
    }
  }

  Future<void> _onCreateItinerary(
    CreateItinerary event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryOperationLoading(operation: 'Creating itinerary...'));
      
      final newItinerary = event.itinerary.copyWith(
        id: _uuid.v4(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      
      await _itineraryRepository.createItinerary(newItinerary);
      
      emit(ItineraryOperationSuccess(
        message: 'Itinerary created successfully',
        itinerary: newItinerary,
      ));
      
      // Reload itineraries
      add(const LoadItineraries());
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onUpdateItinerary(
    UpdateItinerary event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryOperationLoading(operation: 'Updating itinerary...'));
      
      final updatedItinerary = event.itinerary.copyWith(
        updatedAt: DateTime.now(),
      );
      
      await _itineraryRepository.updateItinerary(updatedItinerary);
      
      emit(ItineraryOperationSuccess(
        message: 'Itinerary updated successfully',
        itinerary: updatedItinerary,
      ));
      
      // Reload itineraries
      add(const LoadItineraries());
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onDeleteItinerary(
    DeleteItinerary event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryOperationLoading(operation: 'Deleting itinerary...'));
      
      await _itineraryRepository.deleteItinerary(event.itineraryId);
      
      emit(const ItineraryOperationSuccess(
        message: 'Itinerary deleted successfully',
      ));
      
      // Reload itineraries
      add(const LoadItineraries());
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onLoadItineraryById(
    LoadItineraryById event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryLoading());
      
      final itinerary = await _itineraryRepository.getItineraryById(event.itineraryId);
      
      if (state is ItineraryLoaded) {
        emit((state as ItineraryLoaded).copyWith(selectedItinerary: itinerary));
      } else {
        emit(ItineraryLoaded(itineraries: const [], selectedItinerary: itinerary));
      }
    } catch (e) {
      emit(ItineraryError(message: e.toString()));
    }
  }

  Future<void> _onAddActivityToItinerary(
    AddActivityToItinerary event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryOperationLoading(operation: 'Adding activity...'));
      
      final itinerary = await _itineraryRepository.getItineraryById(event.itineraryId);
      
      if (itinerary == null) {
        emit(const ItineraryOperationError(message: 'Itinerary not found'));
        return;
      }
      
      final updatedDays = List<ItineraryDay>.from(itinerary.days);
      final dayIndex = updatedDays.indexWhere(
        (day) => _isSameDay(day.date, event.date),
      );
      
      if (dayIndex != -1) {
        // Day exists, add activity to it
        final existingDay = updatedDays[dayIndex];
        final updatedActivities = List<ItineraryActivity>.from(existingDay.activities)
          ..add(event.activity.copyWith(id: _uuid.v4()));
        
        updatedDays[dayIndex] = existingDay.copyWith(activities: updatedActivities);
      } else {
        // Day doesn't exist, create new day
        final newDay = ItineraryDay(
          date: event.date,
          title: 'Day ${updatedDays.length + 1}',
          activities: [event.activity.copyWith(id: _uuid.v4())],
        );
        updatedDays.add(newDay);
        updatedDays.sort((a, b) => a.date.compareTo(b.date));
      }
      
      final updatedItinerary = itinerary.copyWith(
        days: updatedDays,
        updatedAt: DateTime.now(),
      );
      
      await _itineraryRepository.updateItinerary(updatedItinerary);
      
      emit(ItineraryOperationSuccess(
        message: 'Activity added successfully',
        itinerary: updatedItinerary,
      ));
      
      // Reload itineraries
      add(const LoadItineraries());
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onUpdateActivity(
    UpdateActivity event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryOperationLoading(operation: 'Updating activity...'));
      
      final itinerary = await _itineraryRepository.getItineraryById(event.itineraryId);
      
      if (itinerary == null) {
        emit(const ItineraryOperationError(message: 'Itinerary not found'));
        return;
      }
      
      final updatedDays = List<ItineraryDay>.from(itinerary.days);
      final dayIndex = updatedDays.indexWhere(
        (day) => _isSameDay(day.date, event.date),
      );
      
      if (dayIndex != -1) {
        final existingDay = updatedDays[dayIndex];
        final updatedActivities = existingDay.activities.map((activity) {
          return activity.id == event.activity.id ? event.activity : activity;
        }).toList();
        
        updatedDays[dayIndex] = existingDay.copyWith(activities: updatedActivities);
        
        final updatedItinerary = itinerary.copyWith(
          days: updatedDays,
          updatedAt: DateTime.now(),
        );
        
        await _itineraryRepository.updateItinerary(updatedItinerary);
        
        emit(ItineraryOperationSuccess(
          message: 'Activity updated successfully',
          itinerary: updatedItinerary,
        ));
        
        // Reload itineraries
        add(const LoadItineraries());
      } else {
        emit(const ItineraryOperationError(message: 'Day not found'));
      }
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onDeleteActivity(
    DeleteActivity event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      emit(const ItineraryOperationLoading(operation: 'Deleting activity...'));
      
      final itinerary = await _itineraryRepository.getItineraryById(event.itineraryId);
      
      if (itinerary == null) {
        emit(const ItineraryOperationError(message: 'Itinerary not found'));
        return;
      }
      
      final updatedDays = List<ItineraryDay>.from(itinerary.days);
      final dayIndex = updatedDays.indexWhere(
        (day) => _isSameDay(day.date, event.date),
      );
      
      if (dayIndex != -1) {
        final existingDay = updatedDays[dayIndex];
        final updatedActivities = existingDay.activities
            .where((activity) => activity.id != event.activityId)
            .toList();
        
        updatedDays[dayIndex] = existingDay.copyWith(activities: updatedActivities);
        
        final updatedItinerary = itinerary.copyWith(
          days: updatedDays,
          updatedAt: DateTime.now(),
        );
        
        await _itineraryRepository.updateItinerary(updatedItinerary);
        
        emit(ItineraryOperationSuccess(
          message: 'Activity deleted successfully',
          itinerary: updatedItinerary,
        ));
        
        // Reload itineraries
        add(const LoadItineraries());
      } else {
        emit(const ItineraryOperationError(message: 'Day not found'));
      }
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onMarkActivityCompleted(
    MarkActivityCompleted event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      final itinerary = await _itineraryRepository.getItineraryById(event.itineraryId);
      
      if (itinerary == null) {
        emit(const ItineraryOperationError(message: 'Itinerary not found'));
        return;
      }
      
      final updatedDays = List<ItineraryDay>.from(itinerary.days);
      final dayIndex = updatedDays.indexWhere(
        (day) => _isSameDay(day.date, event.date),
      );
      
      if (dayIndex != -1) {
        final existingDay = updatedDays[dayIndex];
        final updatedActivities = existingDay.activities.map((activity) {
          return activity.id == event.activityId
              ? activity.copyWith(isCompleted: event.isCompleted)
              : activity;
        }).toList();
        
        updatedDays[dayIndex] = existingDay.copyWith(activities: updatedActivities);
        
        final updatedItinerary = itinerary.copyWith(
          days: updatedDays,
          updatedAt: DateTime.now(),
        );
        
        await _itineraryRepository.updateItinerary(updatedItinerary);
        
        if (state is ItineraryLoaded) {
          final currentState = state as ItineraryLoaded;
          final updatedItineraries = currentState.itineraries.map((it) {
            return it.id == updatedItinerary.id ? updatedItinerary : it;
          }).toList();
          
          emit(currentState.copyWith(
            itineraries: updatedItineraries,
            selectedItinerary: updatedItinerary,
          ));
        }
      }
    } catch (e) {
      emit(ItineraryOperationError(message: e.toString()));
    }
  }

  Future<void> _onSearchItineraries(
    SearchItineraries event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      final allItineraries = await _itineraryRepository.getAllItineraries();
      
      final filteredItineraries = allItineraries.where((itinerary) {
        final query = event.query.toLowerCase();
        return itinerary.title.toLowerCase().contains(query) ||
               itinerary.description.toLowerCase().contains(query) ||
               itinerary.destination.toLowerCase().contains(query) ||
               itinerary.tags.any((tag) => tag.toLowerCase().contains(query));
      }).toList();
      
      if (state is ItineraryLoaded) {
        emit((state as ItineraryLoaded).copyWith(
          itineraries: filteredItineraries,
          searchQuery: event.query,
        ));
      } else {
        emit(ItineraryLoaded(
          itineraries: filteredItineraries,
          searchQuery: event.query,
        ));
      }
    } catch (e) {
      emit(ItineraryError(message: e.toString()));
    }
  }

  Future<void> _onFilterItineraries(
    FilterItineraries event,
    Emitter<ItineraryState> emit,
  ) async {
    try {
      final allItineraries = await _itineraryRepository.getAllItineraries();
      
      final filteredItineraries = allItineraries.where((itinerary) {
        bool matches = true;
        
        if (event.destination != null && event.destination!.isNotEmpty) {
          matches = matches && 
                  itinerary.destination.toLowerCase().contains(
                    event.destination!.toLowerCase(),
                  );
        }
        
        if (event.startDate != null) {
          matches = matches && 
                  itinerary.startDate.isAfter(event.startDate!) ||
                  _isSameDay(itinerary.startDate, event.startDate!);
        }
        
        if (event.endDate != null) {
          matches = matches && 
                  itinerary.endDate.isBefore(event.endDate!) ||
                  _isSameDay(itinerary.endDate, event.endDate!);
        }
        
        if (event.tags != null && event.tags!.isNotEmpty) {
          matches = matches && 
                  event.tags!.any((tag) => itinerary.tags.contains(tag));
        }
        
        return matches;
      }).toList();
      
      final filters = <String, dynamic>{
        if (event.destination != null) 'destination': event.destination,
        if (event.startDate != null) 'startDate': event.startDate,
        if (event.endDate != null) 'endDate': event.endDate,
        if (event.tags != null) 'tags': event.tags,
      };
      
      if (state is ItineraryLoaded) {
        emit((state as ItineraryLoaded).copyWith(
          itineraries: filteredItineraries,
          filters: filters,
        ));
      } else {
        emit(ItineraryLoaded(
          itineraries: filteredItineraries,
          filters: filters,
        ));
      }
    } catch (e) {
      emit(ItineraryError(message: e.toString()));
    }
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
           date1.month == date2.month &&
           date1.day == date2.day;
  }
}
