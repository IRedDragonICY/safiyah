import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'itinerary_model.g.dart';

@JsonSerializable()
class ItineraryModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String destination;
  final DateTime startDate;
  final DateTime endDate;
  final List<ItineraryDay> days;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> imageUrls;
  final double estimatedBudget;
  final String currency;
  final bool isPublic;
  final List<String> tags;

  const ItineraryModel({
    required this.id,
    required this.title,
    required this.description,
    required this.destination,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.imageUrls,
    required this.estimatedBudget,
    required this.currency,
    required this.isPublic,
    required this.tags,
  });

  factory ItineraryModel.fromJson(Map<String, dynamic> json) => 
      _$ItineraryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryModelToJson(this);

  int get durationInDays => endDate.difference(startDate).inDays + 1;

  int get totalActivities => days.fold(0, (sum, day) => sum + day.activities.length);

  ItineraryModel copyWith({
    String? id,
    String? title,
    String? description,
    String? destination,
    DateTime? startDate,
    DateTime? endDate,
    List<ItineraryDay>? days,
    String? userId,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? imageUrls,
    double? estimatedBudget,
    String? currency,
    bool? isPublic,
    List<String>? tags,
  }) {
    return ItineraryModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      destination: destination ?? this.destination,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      userId: userId ?? this.userId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      imageUrls: imageUrls ?? this.imageUrls,
      estimatedBudget: estimatedBudget ?? this.estimatedBudget,
      currency: currency ?? this.currency,
      isPublic: isPublic ?? this.isPublic,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        destination,
        startDate,
        endDate,
        days,
        userId,
        createdAt,
        updatedAt,
        imageUrls,
        estimatedBudget,
        currency,
        isPublic,
        tags,
      ];
}

@JsonSerializable()
class ItineraryDay extends Equatable {
  final DateTime date;
  final String title;
  final List<ItineraryActivity> activities;
  final String? notes;

  const ItineraryDay({
    required this.date,
    required this.title,
    required this.activities,
    this.notes,
  });

  factory ItineraryDay.fromJson(Map<String, dynamic> json) => 
      _$ItineraryDayFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryDayToJson(this);

  ItineraryDay copyWith({
    DateTime? date,
    String? title,
    List<ItineraryActivity>? activities,
    String? notes,
  }) {
    return ItineraryDay(
      date: date ?? this.date,
      title: title ?? this.title,
      activities: activities ?? this.activities,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [date, title, activities, notes];
}

@JsonSerializable()
class ItineraryActivity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String? location;
  final double? latitude;
  final double? longitude;
  final ActivityType type;
  final double? estimatedCost;
  final String? notes;
  final List<String> imageUrls;
  final bool isCompleted;
  final String? placeId; // Reference to PlaceModel

  const ItineraryActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    this.location,
    this.latitude,
    this.longitude,
    required this.type,
    this.estimatedCost,
    this.notes,
    required this.imageUrls,
    required this.isCompleted,
    this.placeId,
  });

  factory ItineraryActivity.fromJson(Map<String, dynamic> json) => 
      _$ItineraryActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ItineraryActivityToJson(this);

  Duration get duration => endTime.difference(startTime);

  ItineraryActivity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    String? location,
    double? latitude,
    double? longitude,
    ActivityType? type,
    double? estimatedCost,
    String? notes,
    List<String>? imageUrls,
    bool? isCompleted,
    String? placeId,
  }) {
    return ItineraryActivity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      type: type ?? this.type,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      notes: notes ?? this.notes,
      imageUrls: imageUrls ?? this.imageUrls,
      isCompleted: isCompleted ?? this.isCompleted,
      placeId: placeId ?? this.placeId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        startTime,
        endTime,
        location,
        latitude,
        longitude,
        type,
        estimatedCost,
        notes,
        imageUrls,
        isCompleted,
        placeId,
      ];
}

enum ActivityType {
  @JsonValue('sightseeing')
  sightseeing,
  @JsonValue('dining')
  dining,
  @JsonValue('shopping')
  shopping,
  @JsonValue('transportation')
  transportation,
  @JsonValue('accommodation')
  accommodation,
  @JsonValue('prayer')
  prayer,
  @JsonValue('entertainment')
  entertainment,
  @JsonValue('business')
  business,
  @JsonValue('other')
  other,
}

extension ActivityTypeExtension on ActivityType {
  String get displayName {
    switch (this) {
      case ActivityType.sightseeing:
        return 'Sightseeing';
      case ActivityType.dining:
        return 'Dining';
      case ActivityType.shopping:
        return 'Shopping';
      case ActivityType.transportation:
        return 'Transportation';
      case ActivityType.accommodation:
        return 'Accommodation';
      case ActivityType.prayer:
        return 'Prayer';
      case ActivityType.entertainment:
        return 'Entertainment';
      case ActivityType.business:
        return 'Business';
      case ActivityType.other:
        return 'Other';
    }
  }

  String get iconPath {
    switch (this) {
      case ActivityType.sightseeing:
        return 'assets/icons/sightseeing.svg';
      case ActivityType.dining:
        return 'assets/icons/dining.svg';
      case ActivityType.shopping:
        return 'assets/icons/shopping.svg';
      case ActivityType.transportation:
        return 'assets/icons/transportation.svg';
      case ActivityType.accommodation:
        return 'assets/icons/accommodation.svg';
      case ActivityType.prayer:
        return 'assets/icons/prayer.svg';
      case ActivityType.entertainment:
        return 'assets/icons/entertainment.svg';
      case ActivityType.business:
        return 'assets/icons/business.svg';
      case ActivityType.other:
        return 'assets/icons/other.svg';
    }
  }
}