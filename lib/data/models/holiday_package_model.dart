import 'package:json_annotation/json_annotation.dart';

part 'holiday_package_model.g.dart';

@JsonSerializable()
class HolidayPackageModel {
  final String id;
  final String title;
  final String destination;
  final String description;
  final double price;
  final double originalPrice;
  final String duration;
  final DateTime startDate;
  final DateTime endDate;
  final int maxParticipants;
  final int currentBookings;
  final List<String> images;
  final List<String> highlights;
  final HolidayItinerary itinerary;
  final List<HolidayInclusion> inclusions;
  final List<HolidayExclusion> exclusions;
  final HolidayAccommodation accommodation;
  final HolidayTransportation transportation;
  final List<HolidayMeal> meals;
  final List<HolidayActivity> activities;
  final double rating;
  final int reviewCount;
  final String category; // family, honeymoon, adventure, cultural, religious
  final bool isHalalCertified;
  final List<String> prayerFacilities;
  final bool isPopular;
  final String difficultyLevel;
  final Map<String, dynamic> bookingTerms;

  const HolidayPackageModel({
    required this.id,
    required this.title,
    required this.destination,
    required this.description,
    required this.price,
    required this.originalPrice,
    required this.duration,
    required this.startDate,
    required this.endDate,
    required this.maxParticipants,
    required this.currentBookings,
    required this.images,
    required this.highlights,
    required this.itinerary,
    required this.inclusions,
    required this.exclusions,
    required this.accommodation,
    required this.transportation,
    required this.meals,
    required this.activities,
    required this.rating,
    required this.reviewCount,
    required this.category,
    this.isHalalCertified = true,
    required this.prayerFacilities,
    this.isPopular = false,
    required this.difficultyLevel,
    required this.bookingTerms,
  });

  factory HolidayPackageModel.fromJson(Map<String, dynamic> json) => _$HolidayPackageModelFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayPackageModelToJson(this);
}

@JsonSerializable()
class HolidayItinerary {
  final List<DayPlan> dayPlans;
  final String overview;

  const HolidayItinerary({
    required this.dayPlans,
    required this.overview,
  });

  factory HolidayItinerary.fromJson(Map<String, dynamic> json) => _$HolidayItineraryFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayItineraryToJson(this);
}

@JsonSerializable()
class DayPlan {
  final int day;
  final String title;
  final String description;
  final List<Activity> activities;
  final List<String> prayerTimes;
  final String accommodation;
  final List<String> meals;

  const DayPlan({
    required this.day,
    required this.title,
    required this.description,
    required this.activities,
    required this.prayerTimes,
    required this.accommodation,
    required this.meals,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) => _$DayPlanFromJson(json);

  Map<String, dynamic> toJson() => _$DayPlanToJson(this);
}

@JsonSerializable()
class Activity {
  final String name;
  final String time;
  final String location;
  final String description;
  final bool isOptional;

  const Activity({
    required this.name,
    required this.time,
    required this.location,
    required this.description,
    this.isOptional = false,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityToJson(this);
}

@JsonSerializable()
class HolidayInclusion {
  final String title;
  final String description;
  final String icon;

  const HolidayInclusion({
    required this.title,
    required this.description,
    required this.icon,
  });

  factory HolidayInclusion.fromJson(Map<String, dynamic> json) => _$HolidayInclusionFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayInclusionToJson(this);
}

@JsonSerializable()
class HolidayExclusion {
  final String title;
  final String description;

  const HolidayExclusion({
    required this.title,
    required this.description,
  });

  factory HolidayExclusion.fromJson(Map<String, dynamic> json) => _$HolidayExclusionFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayExclusionToJson(this);
}

@JsonSerializable()
class HolidayAccommodation {
  final String name;
  final String type;
  final int stars;
  final List<String> amenities;
  final String description;
  final List<String> images;
  final bool isHalalCertified;

  const HolidayAccommodation({
    required this.name,
    required this.type,
    required this.stars,
    required this.amenities,
    required this.description,
    required this.images,
    this.isHalalCertified = true,
  });

  factory HolidayAccommodation.fromJson(Map<String, dynamic> json) => _$HolidayAccommodationFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayAccommodationToJson(this);
}

@JsonSerializable()
class HolidayTransportation {
  final String type; // flight, bus, train, car rental
  final String details;
  final List<String> features;
  final bool isIncluded;

  const HolidayTransportation({
    required this.type,
    required this.details,
    required this.features,
    required this.isIncluded,
  });

  factory HolidayTransportation.fromJson(Map<String, dynamic> json) => _$HolidayTransportationFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayTransportationToJson(this);
}

@JsonSerializable()
class HolidayMeal {
  final String type; // breakfast, lunch, dinner
  final String description;
  final bool isHalal;
  final bool isIncluded;

  const HolidayMeal({
    required this.type,
    required this.description,
    this.isHalal = true,
    required this.isIncluded,
  });

  factory HolidayMeal.fromJson(Map<String, dynamic> json) => _$HolidayMealFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayMealToJson(this);
}

@JsonSerializable()
class HolidayActivity {
  final String name;
  final String type;
  final String description;
  final double price;
  final bool isIncluded;
  final bool isOptional;
  final String duration;

  const HolidayActivity({
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.isIncluded,
    this.isOptional = false,
    required this.duration,
  });

  factory HolidayActivity.fromJson(Map<String, dynamic> json) => _$HolidayActivityFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayActivityToJson(this);
}

@JsonSerializable()
class HolidayBookingModel {
  final String id;
  final String packageId;
  final String userId;
  final DateTime bookingDate;
  final DateTime travelDate;
  final int participants;
  final double totalPrice;
  final String status; // pending, confirmed, cancelled
  final Map<String, dynamic> travelerDetails;
  final Map<String, dynamic> paymentDetails;
  final List<String> specialRequests;

  const HolidayBookingModel({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.bookingDate,
    required this.travelDate,
    required this.participants,
    required this.totalPrice,
    required this.status,
    required this.travelerDetails,
    required this.paymentDetails,
    required this.specialRequests,
  });

  factory HolidayBookingModel.fromJson(Map<String, dynamic> json) => _$HolidayBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$HolidayBookingModelToJson(this);
} 