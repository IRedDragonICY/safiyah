// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      message: json['message'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      priority: $enumDecode(_$NotificationPriorityEnumMap, json['priority']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      scheduledTime: json['scheduledTime'] == null
          ? null
          : DateTime.parse(json['scheduledTime'] as String),
      isRead: json['isRead'] as bool? ?? false,
      actionData: json['actionData'] as Map<String, dynamic>?,
      imageUrl: json['imageUrl'] as String?,
      deepLink: json['deepLink'] as String?,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'message': instance.message,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'priority': _$NotificationPriorityEnumMap[instance.priority]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'scheduledTime': instance.scheduledTime?.toIso8601String(),
      'isRead': instance.isRead,
      'actionData': instance.actionData,
      'imageUrl': instance.imageUrl,
      'deepLink': instance.deepLink,
    };

const _$NotificationTypeEnumMap = {
  NotificationType.voucher: 'voucher',
  NotificationType.transportation: 'transportation',
  NotificationType.accommodation: 'accommodation',
  NotificationType.prayer: 'prayer',
  NotificationType.itinerary: 'itinerary',
  NotificationType.general: 'general',
  NotificationType.emergency: 'emergency',
};

const _$NotificationPriorityEnumMap = {
  NotificationPriority.low: 'low',
  NotificationPriority.normal: 'normal',
  NotificationPriority.high: 'high',
  NotificationPriority.urgent: 'urgent',
};
