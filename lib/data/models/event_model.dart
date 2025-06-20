import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final String detailedDescription;
  final EventType type;
  final EventCategory category;
  final DateTime startDate;
  final DateTime endDate;
  final String venue;
  final String address;
  final double? latitude;
  final double? longitude;
  final List<String> imageUrls;
  final String? websiteUrl;
  final String? ticketUrl;
  final PriceInfo priceInfo;
  final bool requiresTicket;
  final bool isRecurring;
  final RecurrencePattern? recurrencePattern;
  final List<String> tags;
  final double rating;
  final int attendeeCount;
  final EventStatus status;
  final EventAccessibility accessibility;
  final List<EventSchedule> schedule;
  final ContactInfo? contactInfo;
  final List<String> highlights;
  final WeatherDependency weatherDependency;
  final AgeRestriction? ageRestriction;
  final List<String> languages;
  final TransportationInfo? transportationInfo;

  const EventModel({
    required this.id,
    required this.name,
    required this.description,
    required this.detailedDescription,
    required this.type,
    required this.category,
    required this.startDate,
    required this.endDate,
    required this.venue,
    required this.address,
    this.latitude,
    this.longitude,
    required this.imageUrls,
    this.websiteUrl,
    this.ticketUrl,
    required this.priceInfo,
    required this.requiresTicket,
    required this.isRecurring,
    this.recurrencePattern,
    required this.tags,
    required this.rating,
    required this.attendeeCount,
    required this.status,
    required this.accessibility,
    required this.schedule,
    this.contactInfo,
    required this.highlights,
    required this.weatherDependency,
    this.ageRestriction,
    required this.languages,
    this.transportationInfo,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) => 
      _$EventModelFromJson(json);

  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  bool get isHappeningNow {
    final now = DateTime.now();
    return now.isAfter(startDate) && now.isBefore(endDate);
  }

  bool get isUpcoming {
    final now = DateTime.now();
    return now.isBefore(startDate);
  }

  bool get isPast {
    final now = DateTime.now();
    return now.isAfter(endDate);
  }

  Duration get timeUntilStart {
    return startDate.difference(DateTime.now());
  }

  String get durationText {
    final duration = endDate.difference(startDate);
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      return '${duration.inHours} hour${duration.inHours > 1 ? 's' : ''}';
    } else {
      return '${duration.inMinutes} minute${duration.inMinutes > 1 ? 's' : ''}';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        detailedDescription,
        type,
        category,
        startDate,
        endDate,
        venue,
        address,
        latitude,
        longitude,
        imageUrls,
        websiteUrl,
        ticketUrl,
        priceInfo,
        requiresTicket,
        isRecurring,
        recurrencePattern,
        tags,
        rating,
        attendeeCount,
        status,
        accessibility,
        schedule,
        contactInfo,
        highlights,
        weatherDependency,
        ageRestriction,
        languages,
        transportationInfo,
      ];
}

@JsonSerializable()
class PriceInfo extends Equatable {
  final bool isFree;
  final double? minPrice;
  final double? maxPrice;
  final String currency;
  final List<TicketTier>? ticketTiers;
  final String? priceNote;

  const PriceInfo({
    required this.isFree,
    this.minPrice,
    this.maxPrice,
    required this.currency,
    this.ticketTiers,
    this.priceNote,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) => 
      _$PriceInfoFromJson(json);

  Map<String, dynamic> toJson() => _$PriceInfoToJson(this);

  String get displayPrice {
    if (isFree) return 'Free';
    if (minPrice != null && maxPrice != null) {
      if (minPrice == maxPrice) {
        return '¥${minPrice!.toInt()}';
      }
      return '¥${minPrice!.toInt()} - ¥${maxPrice!.toInt()}';
    }
    if (minPrice != null) return 'From ¥${minPrice!.toInt()}';
    if (maxPrice != null) return 'Up to ¥${maxPrice!.toInt()}';
    return 'Price varies';
  }

  @override
  List<Object?> get props => [isFree, minPrice, maxPrice, currency, ticketTiers, priceNote];
}

@JsonSerializable()
class TicketTier extends Equatable {
  final String name;
  final double price;
  final String description;
  final bool isAvailable;
  final int? remainingTickets;

  const TicketTier({
    required this.name,
    required this.price,
    required this.description,
    required this.isAvailable,
    this.remainingTickets,
  });

  factory TicketTier.fromJson(Map<String, dynamic> json) => 
      _$TicketTierFromJson(json);

  Map<String, dynamic> toJson() => _$TicketTierToJson(this);

  @override
  List<Object?> get props => [name, price, description, isAvailable, remainingTickets];
}

@JsonSerializable()
class RecurrencePattern extends Equatable {
  final RecurrenceType type;
  final int interval;
  final List<int>? daysOfWeek;
  final int? dayOfMonth;
  final int? weekOfMonth;

  const RecurrencePattern({
    required this.type,
    required this.interval,
    this.daysOfWeek,
    this.dayOfMonth,
    this.weekOfMonth,
  });

  factory RecurrencePattern.fromJson(Map<String, dynamic> json) => 
      _$RecurrencePatternFromJson(json);

  Map<String, dynamic> toJson() => _$RecurrencePatternToJson(this);

  @override
  List<Object?> get props => [type, interval, daysOfWeek, dayOfMonth, weekOfMonth];
}

@JsonSerializable()
class EventAccessibility extends Equatable {
  final bool wheelchairAccessible;
  final bool hasSignLanguage;
  final bool hasAudioDescription;
  final bool hasBraille;
  final List<String> accessibilityFeatures;

  const EventAccessibility({
    required this.wheelchairAccessible,
    required this.hasSignLanguage,
    required this.hasAudioDescription,
    required this.hasBraille,
    required this.accessibilityFeatures,
  });

  factory EventAccessibility.fromJson(Map<String, dynamic> json) => 
      _$EventAccessibilityFromJson(json);

  Map<String, dynamic> toJson() => _$EventAccessibilityToJson(this);

  @override
  List<Object?> get props => [
        wheelchairAccessible,
        hasSignLanguage,
        hasAudioDescription,
        hasBraille,
        accessibilityFeatures,
      ];
}

@JsonSerializable()
class EventSchedule extends Equatable {
  final DateTime startTime;
  final DateTime endTime;
  final String title;
  final String? description;
  final String? location;

  const EventSchedule({
    required this.startTime,
    required this.endTime,
    required this.title,
    this.description,
    this.location,
  });

  factory EventSchedule.fromJson(Map<String, dynamic> json) => 
      _$EventScheduleFromJson(json);

  Map<String, dynamic> toJson() => _$EventScheduleToJson(this);

  @override
  List<Object?> get props => [startTime, endTime, title, description, location];
}

@JsonSerializable()
class ContactInfo extends Equatable {
  final String? phoneNumber;
  final String? email;
  final String? website;
  final Map<String, String>? socialMedia;

  const ContactInfo({
    this.phoneNumber,
    this.email,
    this.website,
    this.socialMedia,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) => 
      _$ContactInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactInfoToJson(this);

  @override
  List<Object?> get props => [phoneNumber, email, website, socialMedia];
}

@JsonSerializable()
class AgeRestriction extends Equatable {
  final int? minAge;
  final int? maxAge;
  final String? note;

  const AgeRestriction({
    this.minAge,
    this.maxAge,
    this.note,
  });

  factory AgeRestriction.fromJson(Map<String, dynamic> json) => 
      _$AgeRestrictionFromJson(json);

  Map<String, dynamic> toJson() => _$AgeRestrictionToJson(this);

  @override
  List<Object?> get props => [minAge, maxAge, note];
}

@JsonSerializable()
class TransportationInfo extends Equatable {
  final List<String> nearestStations;
  final Map<String, String> directions;
  final bool hasParkingAvailable;
  final String? parkingInfo;

  const TransportationInfo({
    required this.nearestStations,
    required this.directions,
    required this.hasParkingAvailable,
    this.parkingInfo,
  });

  factory TransportationInfo.fromJson(Map<String, dynamic> json) => 
      _$TransportationInfoFromJson(json);

  Map<String, dynamic> toJson() => _$TransportationInfoToJson(this);

  @override
  List<Object?> get props => [nearestStations, directions, hasParkingAvailable, parkingInfo];
}

enum EventType {
  @JsonValue('cultural')
  cultural,
  @JsonValue('festival')
  festival,
  @JsonValue('exhibition')
  exhibition,
  @JsonValue('performance')
  performance,
  @JsonValue('workshop')
  workshop,
  @JsonValue('conference')
  conference,
  @JsonValue('seasonal')
  seasonal,
  @JsonValue('religious')
  religious,
  @JsonValue('sports')
  sports,
  @JsonValue('food')
  food,
  @JsonValue('art')
  art,
  @JsonValue('music')
  music,
  @JsonValue('technology')
  technology,
}

enum EventCategory {
  @JsonValue('traditional')
  traditional,
  @JsonValue('modern')
  modern,
  @JsonValue('anime')
  anime,
  @JsonValue('pop_culture')
  popCulture,
  @JsonValue('nature')
  nature,
  @JsonValue('history')
  history,
  @JsonValue('food_and_drink')
  foodAndDrink,
  @JsonValue('entertainment')
  entertainment,
  @JsonValue('education')
  education,
  @JsonValue('shopping')
  shopping,
}

enum EventStatus {
  @JsonValue('upcoming')
  upcoming,
  @JsonValue('ongoing')
  ongoing,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('postponed')
  postponed,
}

enum RecurrenceType {
  @JsonValue('daily')
  daily,
  @JsonValue('weekly')
  weekly,
  @JsonValue('monthly')
  monthly,
  @JsonValue('yearly')
  yearly,
}

enum WeatherDependency {
  @JsonValue('none')
  none,
  @JsonValue('indoor')
  indoor,
  @JsonValue('outdoor')
  outdoor,
  @JsonValue('weather_dependent')
  weatherDependent,
}

extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.cultural:
        return 'Cultural';
      case EventType.festival:
        return 'Festival';
      case EventType.exhibition:
        return 'Exhibition';
      case EventType.performance:
        return 'Performance';
      case EventType.workshop:
        return 'Workshop';
      case EventType.conference:
        return 'Conference';
      case EventType.seasonal:
        return 'Seasonal';
      case EventType.religious:
        return 'Religious';
      case EventType.sports:
        return 'Sports';
      case EventType.food:
        return 'Food';
      case EventType.art:
        return 'Art';
      case EventType.music:
        return 'Music';
      case EventType.technology:
        return 'Technology';
    }
  }
}

extension EventCategoryExtension on EventCategory {
  String get displayName {
    switch (this) {
      case EventCategory.traditional:
        return 'Traditional';
      case EventCategory.modern:
        return 'Modern';
      case EventCategory.anime:
        return 'Anime';
      case EventCategory.popCulture:
        return 'Pop Culture';
      case EventCategory.nature:
        return 'Nature';
      case EventCategory.history:
        return 'History';
      case EventCategory.foodAndDrink:
        return 'Food & Drink';
      case EventCategory.entertainment:
        return 'Entertainment';
      case EventCategory.education:
        return 'Education';
      case EventCategory.shopping:
        return 'Shopping';
    }
  }
} 