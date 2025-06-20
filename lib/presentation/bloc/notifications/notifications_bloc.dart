import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/services/notification_service.dart';
import '../../../data/models/notification_model.dart';

// Events
abstract class NotificationsEvent extends Equatable {
  const NotificationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadNotifications extends NotificationsEvent {
  const LoadNotifications();
}

class MarkNotificationAsRead extends NotificationsEvent {
  final String notificationId;

  const MarkNotificationAsRead(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class MarkAllNotificationsAsRead extends NotificationsEvent {
  const MarkAllNotificationsAsRead();
}

class DeleteNotification extends NotificationsEvent {
  final String notificationId;

  const DeleteNotification(this.notificationId);

  @override
  List<Object> get props => [notificationId];
}

class FilterNotificationsByType extends NotificationsEvent {
  final NotificationType? filterType;

  const FilterNotificationsByType(this.filterType);

  @override
  List<Object?> get props => [filterType];
}

class NotificationsUpdated extends NotificationsEvent {
  final List<NotificationModel> notifications;

  const NotificationsUpdated(this.notifications);

  @override
  List<Object> get props => [notifications];
}

// States
abstract class NotificationsState extends Equatable {
  const NotificationsState();

  @override
  List<Object?> get props => [];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  final List<NotificationModel> notifications;
  final List<NotificationModel> filteredNotifications;
  final NotificationType? currentFilter;
  final int unreadCount;

  const NotificationsLoaded({
    required this.notifications,
    required this.filteredNotifications,
    this.currentFilter,
    required this.unreadCount,
  });

  @override
  List<Object?> get props => [
        notifications,
        filteredNotifications,
        currentFilter,
        unreadCount,
      ];

  NotificationsLoaded copyWith({
    List<NotificationModel>? notifications,
    List<NotificationModel>? filteredNotifications,
    NotificationType? currentFilter,
    int? unreadCount,
  }) {
    return NotificationsLoaded(
      notifications: notifications ?? this.notifications,
      filteredNotifications: filteredNotifications ?? this.filteredNotifications,
      currentFilter: currentFilter ?? this.currentFilter,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class NotificationsError extends NotificationsState {
  final String message;

  const NotificationsError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class NotificationsBloc extends Bloc<NotificationsEvent, NotificationsState> {
  final NotificationService _notificationService;
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;

  NotificationsBloc({
    NotificationService? notificationService,
  })  : _notificationService = notificationService ?? NotificationService(),
        super(NotificationsInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
    on<MarkAllNotificationsAsRead>(_onMarkAllNotificationsAsRead);
    on<DeleteNotification>(_onDeleteNotification);
    on<FilterNotificationsByType>(_onFilterNotificationsByType);
    on<NotificationsUpdated>(_onNotificationsUpdated);

    // Listen to notifications stream
    _notificationsSubscription = _notificationService.notificationsStream.listen(
      (notifications) => add(NotificationsUpdated(notifications)),
    );
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationsState> emit,
  ) async {
    emit(NotificationsLoading());
    try {
      await _notificationService.initializeData();
      final notifications = _notificationService.notifications;
      final unreadCount = _notificationService.unreadCount;

      emit(NotificationsLoaded(
        notifications: notifications,
        filteredNotifications: notifications,
        unreadCount: unreadCount,
      ));
    } catch (e) {
      emit(NotificationsError('Failed to load notifications: $e'));
    }
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationService.markAsRead(event.notificationId);
    } catch (e) {
      emit(NotificationsError('Failed to mark notification as read: $e'));
    }
  }

  Future<void> _onMarkAllNotificationsAsRead(
    MarkAllNotificationsAsRead event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationService.markAllAsRead();
    } catch (e) {
      emit(NotificationsError('Failed to mark all notifications as read: $e'));
    }
  }

  Future<void> _onDeleteNotification(
    DeleteNotification event,
    Emitter<NotificationsState> emit,
  ) async {
    try {
      await _notificationService.deleteNotification(event.notificationId);
    } catch (e) {
      emit(NotificationsError('Failed to delete notification: $e'));
    }
  }

  Future<void> _onFilterNotificationsByType(
    FilterNotificationsByType event,
    Emitter<NotificationsState> emit,
  ) async {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final filteredNotifications = event.filterType == null
          ? currentState.notifications
          : currentState.notifications
              .where((n) => n.type == event.filterType)
              .toList();

      emit(currentState.copyWith(
        filteredNotifications: filteredNotifications,
        currentFilter: event.filterType,
      ));
    }
  }

  void _onNotificationsUpdated(
    NotificationsUpdated event,
    Emitter<NotificationsState> emit,
  ) {
    if (state is NotificationsLoaded) {
      final currentState = state as NotificationsLoaded;
      final filteredNotifications = currentState.currentFilter == null
          ? event.notifications
          : event.notifications
              .where((n) => n.type == currentState.currentFilter)
              .toList();

      final unreadCount = event.notifications.where((n) => !n.isRead).length;

      emit(currentState.copyWith(
        notifications: event.notifications,
        filteredNotifications: filteredNotifications,
        unreadCount: unreadCount,
      ));
    } else {
      final unreadCount = event.notifications.where((n) => !n.isRead).length;
      emit(NotificationsLoaded(
        notifications: event.notifications,
        filteredNotifications: event.notifications,
        unreadCount: unreadCount,
      ));
    }
  }

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }
} 
