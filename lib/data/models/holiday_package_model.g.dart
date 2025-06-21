// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holiday_package_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HolidayPackageModel _$HolidayPackageModelFromJson(Map<String, dynamic> json) =>
    HolidayPackageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      destination: json['destination'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      originalPrice: (json['originalPrice'] as num).toDouble(),
      duration: json['duration'] as String,
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentBookings: (json['currentBookings'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      highlights: (json['highlights'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      itinerary:
          HolidayItinerary.fromJson(json['itinerary'] as Map<String, dynamic>),
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => HolidayInclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>)
          .map((e) => HolidayExclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
      accommodation: HolidayAccommodation.fromJson(
          json['accommodation'] as Map<String, dynamic>),
      transportation: HolidayTransportation.fromJson(
          json['transportation'] as Map<String, dynamic>),
      meals: (json['meals'] as List<dynamic>)
          .map((e) => HolidayMeal.fromJson(e as Map<String, dynamic>))
          .toList(),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => HolidayActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      category: json['category'] as String,
      isHalalCertified: json['isHalalCertified'] as bool? ?? true,
      prayerFacilities: (json['prayerFacilities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isPopular: json['isPopular'] as bool? ?? false,
      difficultyLevel: json['difficultyLevel'] as String,
      bookingTerms: json['bookingTerms'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$HolidayPackageModelToJson(
        HolidayPackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'destination': instance.destination,
      'description': instance.description,
      'price': instance.price,
      'originalPrice': instance.originalPrice,
      'duration': instance.duration,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'currentBookings': instance.currentBookings,
      'images': instance.images,
      'highlights': instance.highlights,
      'itinerary': instance.itinerary,
      'inclusions': instance.inclusions,
      'exclusions': instance.exclusions,
      'accommodation': instance.accommodation,
      'transportation': instance.transportation,
      'meals': instance.meals,
      'activities': instance.activities,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'category': instance.category,
      'isHalalCertified': instance.isHalalCertified,
      'prayerFacilities': instance.prayerFacilities,
      'isPopular': instance.isPopular,
      'difficultyLevel': instance.difficultyLevel,
      'bookingTerms': instance.bookingTerms,
    };

HolidayItinerary _$HolidayItineraryFromJson(Map<String, dynamic> json) =>
    HolidayItinerary(
      dayPlans: (json['dayPlans'] as List<dynamic>)
          .map((e) => DayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      overview: json['overview'] as String,
    );

Map<String, dynamic> _$HolidayItineraryToJson(HolidayItinerary instance) =>
    <String, dynamic>{
      'dayPlans': instance.dayPlans,
      'overview': instance.overview,
    };

DayPlan _$DayPlanFromJson(Map<String, dynamic> json) => DayPlan(
      day: (json['day'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
      prayerTimes: (json['prayerTimes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      accommodation: json['accommodation'] as String,
      meals: (json['meals'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$DayPlanToJson(DayPlan instance) => <String, dynamic>{
      'day': instance.day,
      'title': instance.title,
      'description': instance.description,
      'activities': instance.activities,
      'prayerTimes': instance.prayerTimes,
      'accommodation': instance.accommodation,
      'meals': instance.meals,
    };

Activity _$ActivityFromJson(Map<String, dynamic> json) => Activity(
      name: json['name'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      isOptional: json['isOptional'] as bool? ?? false,
    );

Map<String, dynamic> _$ActivityToJson(Activity instance) => <String, dynamic>{
      'name': instance.name,
      'time': instance.time,
      'location': instance.location,
      'description': instance.description,
      'isOptional': instance.isOptional,
    };

HolidayInclusion _$HolidayInclusionFromJson(Map<String, dynamic> json) =>
    HolidayInclusion(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
    );

Map<String, dynamic> _$HolidayInclusionToJson(HolidayInclusion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
    };

HolidayExclusion _$HolidayExclusionFromJson(Map<String, dynamic> json) =>
    HolidayExclusion(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$HolidayExclusionToJson(HolidayExclusion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

HolidayAccommodation _$HolidayAccommodationFromJson(
        Map<String, dynamic> json) =>
    HolidayAccommodation(
      name: json['name'] as String,
      type: json['type'] as String,
      stars: (json['stars'] as num).toInt(),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      isHalalCertified: json['isHalalCertified'] as bool? ?? true,
    );

Map<String, dynamic> _$HolidayAccommodationToJson(
        HolidayAccommodation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'stars': instance.stars,
      'amenities': instance.amenities,
      'description': instance.description,
      'images': instance.images,
      'isHalalCertified': instance.isHalalCertified,
    };

HolidayTransportation _$HolidayTransportationFromJson(
        Map<String, dynamic> json) =>
    HolidayTransportation(
      type: json['type'] as String,
      details: json['details'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      isIncluded: json['isIncluded'] as bool,
    );

Map<String, dynamic> _$HolidayTransportationToJson(
        HolidayTransportation instance) =>
    <String, dynamic>{
      'type': instance.type,
      'details': instance.details,
      'features': instance.features,
      'isIncluded': instance.isIncluded,
    };

HolidayMeal _$HolidayMealFromJson(Map<String, dynamic> json) => HolidayMeal(
      type: json['type'] as String,
      description: json['description'] as String,
      isHalal: json['isHalal'] as bool? ?? true,
      isIncluded: json['isIncluded'] as bool,
    );

Map<String, dynamic> _$HolidayMealToJson(HolidayMeal instance) =>
    <String, dynamic>{
      'type': instance.type,
      'description': instance.description,
      'isHalal': instance.isHalal,
      'isIncluded': instance.isIncluded,
    };

HolidayActivity _$HolidayActivityFromJson(Map<String, dynamic> json) =>
    HolidayActivity(
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      isIncluded: json['isIncluded'] as bool,
      isOptional: json['isOptional'] as bool? ?? false,
      duration: json['duration'] as String,
    );

Map<String, dynamic> _$HolidayActivityToJson(HolidayActivity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'price': instance.price,
      'isIncluded': instance.isIncluded,
      'isOptional': instance.isOptional,
      'duration': instance.duration,
    };

HolidayBookingModel _$HolidayBookingModelFromJson(Map<String, dynamic> json) =>
    HolidayBookingModel(
      id: json['id'] as String,
      packageId: json['packageId'] as String,
      userId: json['userId'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      travelDate: DateTime.parse(json['travelDate'] as String),
      participants: (json['participants'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      travelerDetails: json['travelerDetails'] as Map<String, dynamic>,
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>,
      specialRequests: (json['specialRequests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HolidayBookingModelToJson(
        HolidayBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageId': instance.packageId,
      'userId': instance.userId,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'travelDate': instance.travelDate.toIso8601String(),
      'participants': instance.participants,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'travelerDetails': instance.travelerDetails,
      'paymentDetails': instance.paymentDetails,
      'specialRequests': instance.specialRequests,
    };
