import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final NotificationPriority priority;
  final DateTime createdAt;
  final DateTime? scheduledTime;
  final bool isRead;
  final Map<String, dynamic>? actionData;
  final String? imageUrl;
  final String? deepLink;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.priority,
    required this.createdAt,
    this.scheduledTime,
    this.isRead = false,
    this.actionData,
    this.imageUrl,
    this.deepLink,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    NotificationPriority? priority,
    DateTime? createdAt,
    DateTime? scheduledTime,
    bool? isRead,
    Map<String, dynamic>? actionData,
    String? imageUrl,
    String? deepLink,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      createdAt: createdAt ?? this.createdAt,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      isRead: isRead ?? this.isRead,
      actionData: actionData ?? this.actionData,
      imageUrl: imageUrl ?? this.imageUrl,
      deepLink: deepLink ?? this.deepLink,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        type,
        priority,
        createdAt,
        scheduledTime,
        isRead,
        actionData,
        imageUrl,
        deepLink,
      ];
}

enum NotificationType {
  @JsonValue('voucher')
  voucher,
  @JsonValue('transportation')
  transportation,
  @JsonValue('accommodation')
  accommodation,
  @JsonValue('prayer')
  prayer,
  @JsonValue('itinerary')
  itinerary,
  @JsonValue('general')
  general,
  @JsonValue('emergency')
  emergency,
}

enum NotificationPriority {
  @JsonValue('low')
  low,
  @JsonValue('normal')
  normal,
  @JsonValue('high')
  high,
  @JsonValue('urgent')
  urgent,
}

extension NotificationTypeExtension on NotificationType {
  String get displayName {
    switch (this) {
      case NotificationType.voucher:
        return 'Voucher';
      case NotificationType.transportation:
        return 'Transportation';
      case NotificationType.accommodation:
        return 'Accommodation';
      case NotificationType.prayer:
        return 'Prayer';
      case NotificationType.itinerary:
        return 'Itinerary';
      case NotificationType.general:
        return 'General';
      case NotificationType.emergency:
        return 'Emergency';
    }
  }

  String get icon {
    switch (this) {
      case NotificationType.voucher:
        return '🎫';
      case NotificationType.transportation:
        return '✈️';
      case NotificationType.accommodation:
        return '🏨';
      case NotificationType.prayer:
        return '🕌';
      case NotificationType.itinerary:
        return '📋';
      case NotificationType.general:
        return '📢';
      case NotificationType.emergency:
        return '🚨';
    }
  }
}

extension NotificationPriorityExtension on NotificationPriority {
  String get displayName {
    switch (this) {
      case NotificationPriority.low:
        return 'Low';
      case NotificationPriority.normal:
        return 'Normal';
      case NotificationPriority.high:
        return 'High';
      case NotificationPriority.urgent:
        return 'Urgent';
    }
  }
} 