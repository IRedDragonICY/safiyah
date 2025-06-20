// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      detailedDescription: json['detailedDescription'] as String,
      type: $enumDecode(_$EventTypeEnumMap, json['type']),
      category: $enumDecode(_$EventCategoryEnumMap, json['category']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      venue: json['venue'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      websiteUrl: json['websiteUrl'] as String?,
      ticketUrl: json['ticketUrl'] as String?,
      priceInfo: PriceInfo.fromJson(json['priceInfo'] as Map<String, dynamic>),
      requiresTicket: json['requiresTicket'] as bool,
      isRecurring: json['isRecurring'] as bool,
      recurrencePattern: json['recurrencePattern'] == null
          ? null
          : RecurrencePattern.fromJson(
              json['recurrencePattern'] as Map<String, dynamic>),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num).toDouble(),
      attendeeCount: (json['attendeeCount'] as num).toInt(),
      status: $enumDecode(_$EventStatusEnumMap, json['status']),
      accessibility: EventAccessibility.fromJson(
          json['accessibility'] as Map<String, dynamic>),
      schedule: (json['schedule'] as List<dynamic>)
          .map((e) => EventSchedule.fromJson(e as Map<String, dynamic>))
          .toList(),
      contactInfo: json['contactInfo'] == null
          ? null
          : ContactInfo.fromJson(json['contactInfo'] as Map<String, dynamic>),
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      weatherDependency:
          $enumDecode(_$WeatherDependencyEnumMap, json['weatherDependency']),
      ageRestriction: json['ageRestriction'] == null
          ? null
          : AgeRestriction.fromJson(
              json['ageRestriction'] as Map<String, dynamic>),
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      transportationInfo: json['transportationInfo'] == null
          ? null
          : TransportationInfo.fromJson(
              json['transportationInfo'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'detailedDescription': instance.detailedDescription,
      'type': _$EventTypeEnumMap[instance.type]!,
      'category': _$EventCategoryEnumMap[instance.category]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'venue': instance.venue,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'imageUrls': instance.imageUrls,
      'websiteUrl': instance.websiteUrl,
      'ticketUrl': instance.ticketUrl,
      'priceInfo': instance.priceInfo,
      'requiresTicket': instance.requiresTicket,
      'isRecurring': instance.isRecurring,
      'recurrencePattern': instance.recurrencePattern,
      'tags': instance.tags,
      'rating': instance.rating,
      'attendeeCount': instance.attendeeCount,
      'status': _$EventStatusEnumMap[instance.status]!,
      'accessibility': instance.accessibility,
      'schedule': instance.schedule,
      'contactInfo': instance.contactInfo,
      'highlights': instance.highlights,
      'weatherDependency':
          _$WeatherDependencyEnumMap[instance.weatherDependency]!,
      'ageRestriction': instance.ageRestriction,
      'languages': instance.languages,
      'transportationInfo': instance.transportationInfo,
    };

const _$EventTypeEnumMap = {
  EventType.cultural: 'cultural',
  EventType.festival: 'festival',
  EventType.exhibition: 'exhibition',
  EventType.performance: 'performance',
  EventType.workshop: 'workshop',
  EventType.conference: 'conference',
  EventType.seasonal: 'seasonal',
  EventType.religious: 'religious',
  EventType.sports: 'sports',
  EventType.food: 'food',
  EventType.art: 'art',
  EventType.music: 'music',
  EventType.technology: 'technology',
};

const _$EventCategoryEnumMap = {
  EventCategory.traditional: 'traditional',
  EventCategory.modern: 'modern',
  EventCategory.anime: 'anime',
  EventCategory.popCulture: 'pop_culture',
  EventCategory.nature: 'nature',
  EventCategory.history: 'history',
  EventCategory.foodAndDrink: 'food_and_drink',
  EventCategory.entertainment: 'entertainment',
  EventCategory.education: 'education',
  EventCategory.shopping: 'shopping',
};

const _$EventStatusEnumMap = {
  EventStatus.upcoming: 'upcoming',
  EventStatus.ongoing: 'ongoing',
  EventStatus.completed: 'completed',
  EventStatus.cancelled: 'cancelled',
  EventStatus.postponed: 'postponed',
};

const _$WeatherDependencyEnumMap = {
  WeatherDependency.none: 'none',
  WeatherDependency.indoor: 'indoor',
  WeatherDependency.outdoor: 'outdoor',
  WeatherDependency.weatherDependent: 'weather_dependent',
};

PriceInfo _$PriceInfoFromJson(Map<String, dynamic> json) => PriceInfo(
      isFree: json['isFree'] as bool,
      minPrice: (json['minPrice'] as num?)?.toDouble(),
      maxPrice: (json['maxPrice'] as num?)?.toDouble(),
      currency: json['currency'] as String,
      ticketTiers: (json['ticketTiers'] as List<dynamic>?)
          ?.map((e) => TicketTier.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceNote: json['priceNote'] as String?,
    );

Map<String, dynamic> _$PriceInfoToJson(PriceInfo instance) => <String, dynamic>{
      'isFree': instance.isFree,
      'minPrice': instance.minPrice,
      'maxPrice': instance.maxPrice,
      'currency': instance.currency,
      'ticketTiers': instance.ticketTiers,
      'priceNote': instance.priceNote,
    };

TicketTier _$TicketTierFromJson(Map<String, dynamic> json) => TicketTier(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String,
      isAvailable: json['isAvailable'] as bool,
      remainingTickets: (json['remainingTickets'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TicketTierToJson(TicketTier instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'description': instance.description,
      'isAvailable': instance.isAvailable,
      'remainingTickets': instance.remainingTickets,
    };

RecurrencePattern _$RecurrencePatternFromJson(Map<String, dynamic> json) =>
    RecurrencePattern(
      type: $enumDecode(_$RecurrenceTypeEnumMap, json['type']),
      interval: (json['interval'] as num).toInt(),
      daysOfWeek: (json['daysOfWeek'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      dayOfMonth: (json['dayOfMonth'] as num?)?.toInt(),
      weekOfMonth: (json['weekOfMonth'] as num?)?.toInt(),
    );

Map<String, dynamic> _$RecurrencePatternToJson(RecurrencePattern instance) =>
    <String, dynamic>{
      'type': _$RecurrenceTypeEnumMap[instance.type]!,
      'interval': instance.interval,
      'daysOfWeek': instance.daysOfWeek,
      'dayOfMonth': instance.dayOfMonth,
      'weekOfMonth': instance.weekOfMonth,
    };

const _$RecurrenceTypeEnumMap = {
  RecurrenceType.daily: 'daily',
  RecurrenceType.weekly: 'weekly',
  RecurrenceType.monthly: 'monthly',
  RecurrenceType.yearly: 'yearly',
};

EventAccessibility _$EventAccessibilityFromJson(Map<String, dynamic> json) =>
    EventAccessibility(
      wheelchairAccessible: json['wheelchairAccessible'] as bool,
      hasSignLanguage: json['hasSignLanguage'] as bool,
      hasAudioDescription: json['hasAudioDescription'] as bool,
      hasBraille: json['hasBraille'] as bool,
      accessibilityFeatures: (json['accessibilityFeatures'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$EventAccessibilityToJson(EventAccessibility instance) =>
    <String, dynamic>{
      'wheelchairAccessible': instance.wheelchairAccessible,
      'hasSignLanguage': instance.hasSignLanguage,
      'hasAudioDescription': instance.hasAudioDescription,
      'hasBraille': instance.hasBraille,
      'accessibilityFeatures': instance.accessibilityFeatures,
    };

EventSchedule _$EventScheduleFromJson(Map<String, dynamic> json) =>
    EventSchedule(
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      title: json['title'] as String,
      description: json['description'] as String?,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$EventScheduleToJson(EventSchedule instance) =>
    <String, dynamic>{
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime.toIso8601String(),
      'title': instance.title,
      'description': instance.description,
      'location': instance.location,
    };

ContactInfo _$ContactInfoFromJson(Map<String, dynamic> json) => ContactInfo(
      phoneNumber: json['phoneNumber'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      socialMedia: (json['socialMedia'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$ContactInfoToJson(ContactInfo instance) =>
    <String, dynamic>{
      'phoneNumber': instance.phoneNumber,
      'email': instance.email,
      'website': instance.website,
      'socialMedia': instance.socialMedia,
    };

AgeRestriction _$AgeRestrictionFromJson(Map<String, dynamic> json) =>
    AgeRestriction(
      minAge: (json['minAge'] as num?)?.toInt(),
      maxAge: (json['maxAge'] as num?)?.toInt(),
      note: json['note'] as String?,
    );

Map<String, dynamic> _$AgeRestrictionToJson(AgeRestriction instance) =>
    <String, dynamic>{
      'minAge': instance.minAge,
      'maxAge': instance.maxAge,
      'note': instance.note,
    };

TransportationInfo _$TransportationInfoFromJson(Map<String, dynamic> json) =>
    TransportationInfo(
      nearestStations: (json['nearestStations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      directions: Map<String, String>.from(json['directions'] as Map),
      hasParkingAvailable: json['hasParkingAvailable'] as bool,
      parkingInfo: json['parkingInfo'] as String?,
    );

Map<String, dynamic> _$TransportationInfoToJson(TransportationInfo instance) =>
    <String, dynamic>{
      'nearestStations': instance.nearestStations,
      'directions': instance.directions,
      'hasParkingAvailable': instance.hasParkingAvailable,
      'parkingInfo': instance.parkingInfo,
    };
