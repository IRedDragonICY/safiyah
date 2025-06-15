// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'itinerary_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItineraryModel _$ItineraryModelFromJson(Map<String, dynamic> json) =>
    ItineraryModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      destination: json['destination'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      days: (json['days'] as List<dynamic>)
          .map((e) => ItineraryDay.fromJson(e as Map<String, dynamic>))
          .toList(),
      userId: json['userId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      estimatedBudget: (json['estimatedBudget'] as num).toDouble(),
      currency: json['currency'] as String,
      isPublic: json['isPublic'] as bool,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$ItineraryModelToJson(ItineraryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'destination': instance.destination,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'days': instance.days,
      'userId': instance.userId,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'imageUrls': instance.imageUrls,
      'estimatedBudget': instance.estimatedBudget,
      'currency': instance.currency,
      'isPublic': instance.isPublic,
      'tags': instance.tags,
    };

ItineraryDay _$ItineraryDayFromJson(Map<String, dynamic> json) => ItineraryDay(
      date: DateTime.parse(json['date'] as String),
      title: json['title'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => ItineraryActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ItineraryDayToJson(ItineraryDay instance) =>
    <String, dynamic>{
      'date': instance.date.toIso8601String(),
      'title': instance.title,
      'activities': instance.activities,
      'notes': instance.notes,
    };

ItineraryActivity _$ItineraryActivityFromJson(Map<String, dynamic> json) =>
    ItineraryActivity(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      location: json['location'] as String?,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      type: $enumDecode(_$ActivityTypeEnumMap, json['type']),
      estimatedCost: (json['estimatedCost'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      isCompleted: json['isCompleted'] as bool,
      placeId: json['placeId'] as String?,
    );

Map<String, dynamic> _$ItineraryActivityToJson(ItineraryActivity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'location': instance.location,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'type': _$ActivityTypeEnumMap[instance.type]!,
      'estimatedCost': instance.estimatedCost,
      'notes': instance.notes,
      'imageUrls': instance.imageUrls,
      'isCompleted': instance.isCompleted,
      'placeId': instance.placeId,
    };

const _$ActivityTypeEnumMap = {
  ActivityType.sightseeing: 'sightseeing',
  ActivityType.dining: 'dining',
  ActivityType.shopping: 'shopping',
  ActivityType.transportation: 'transportation',
  ActivityType.accommodation: 'accommodation',
  ActivityType.prayer: 'prayer',
  ActivityType.entertainment: 'entertainment',
  ActivityType.business: 'business',
  ActivityType.other: 'other',
};
