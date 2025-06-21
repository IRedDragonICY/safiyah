import 'package:json_annotation/json_annotation.dart';

part 'hajj_umroh_model.g.dart';

@JsonSerializable()
class HajjUmrohPackageModel {
  final String id;
  final String title;
  final String type; // hajj, umroh
  final String description;
  final double price;
  final String duration;
  final DateTime departureDate;
  final DateTime returnDate;
  final int maxParticipants;
  final int currentBookings;
  final List<String> images;
  final HajjUmrohItinerary itinerary;
  final List<HajjUmrohInclusion> inclusions;
  final List<HajjUmrohExclusion> exclusions;
  final HajjUmrohAccommodation makkahAccommodation;
  final HajjUmrohAccommodation madinahAccommodation;
  final HajjUmrohTransportation transportation;
  final List<HajjUmrohGuide> guides;
  final HajjUmrohVisaService visaService;
  final double rating;
  final int reviewCount;
  final String provider;
  final bool isMinistryApproved;
  final String approvalNumber;
  final List<String> certificates;
  final Map<String, dynamic> bookingTerms;

  const HajjUmrohPackageModel({
    required this.id,
    required this.title,
    required this.type,
    required this.description,
    required this.price,
    required this.duration,
    required this.departureDate,
    required this.returnDate,
    required this.maxParticipants,
    required this.currentBookings,
    required this.images,
    required this.itinerary,
    required this.inclusions,
    required this.exclusions,
    required this.makkahAccommodation,
    required this.madinahAccommodation,
    required this.transportation,
    required this.guides,
    required this.visaService,
    required this.rating,
    required this.reviewCount,
    required this.provider,
    required this.isMinistryApproved,
    required this.approvalNumber,
    required this.certificates,
    required this.bookingTerms,
  });

  factory HajjUmrohPackageModel.fromJson(Map<String, dynamic> json) => _$HajjUmrohPackageModelFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohPackageModelToJson(this);
}

@JsonSerializable()
class HajjUmrohItinerary {
  final List<HajjUmrohDayPlan> dayPlans;
  final List<RitualActivity> rituals;
  final String overview;
  final List<String> importantNotes;

  const HajjUmrohItinerary({
    required this.dayPlans,
    required this.rituals,
    required this.overview,
    required this.importantNotes,
  });

  factory HajjUmrohItinerary.fromJson(Map<String, dynamic> json) => _$HajjUmrohItineraryFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohItineraryToJson(this);
}

@JsonSerializable()
class HajjUmrohDayPlan {
  final int day;
  final String date;
  final String location; // makkah, madinah, etc.
  final String title;
  final String description;
  final List<RitualActivity> activities;
  final List<String> prayerTimes;
  final String accommodation;
  final List<String> meals;
  final List<String> tips;

  const HajjUmrohDayPlan({
    required this.day,
    required this.date,
    required this.location,
    required this.title,
    required this.description,
    required this.activities,
    required this.prayerTimes,
    required this.accommodation,
    required this.meals,
    required this.tips,
  });

  factory HajjUmrohDayPlan.fromJson(Map<String, dynamic> json) => _$HajjUmrohDayPlanFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohDayPlanToJson(this);
}

@JsonSerializable()
class RitualActivity {
  final String name;
  final String arabicName;
  final String time;
  final String location;
  final String description;
  final String guidance;
  final List<String> dua;
  final bool isCompulsory;
  final String type; // ihram, tawaf, sai, wukuf, etc.

  const RitualActivity({
    required this.name,
    required this.arabicName,
    required this.time,
    required this.location,
    required this.description,
    required this.guidance,
    required this.dua,
    required this.isCompulsory,
    required this.type,
  });

  factory RitualActivity.fromJson(Map<String, dynamic> json) => _$RitualActivityFromJson(json);

  Map<String, dynamic> toJson() => _$RitualActivityToJson(this);
}

@JsonSerializable()
class HajjUmrohInclusion {
  final String title;
  final String description;
  final String icon;
  final bool isImportant;

  const HajjUmrohInclusion({
    required this.title,
    required this.description,
    required this.icon,
    this.isImportant = false,
  });

  factory HajjUmrohInclusion.fromJson(Map<String, dynamic> json) => _$HajjUmrohInclusionFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohInclusionToJson(this);
}

@JsonSerializable()
class HajjUmrohExclusion {
  final String title;
  final String description;

  const HajjUmrohExclusion({
    required this.title,
    required this.description,
  });

  factory HajjUmrohExclusion.fromJson(Map<String, dynamic> json) => _$HajjUmrohExclusionFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohExclusionToJson(this);
}

@JsonSerializable()
class HajjUmrohAccommodation {
  final String name;
  final String type;
  final int stars;
  final double distanceToHaram; // in meters
  final List<String> amenities;
  final String description;
  final List<String> images;
  final String roomType;
  final int personsPerRoom;

  const HajjUmrohAccommodation({
    required this.name,
    required this.type,
    required this.stars,
    required this.distanceToHaram,
    required this.amenities,
    required this.description,
    required this.images,
    required this.roomType,
    required this.personsPerRoom,
  });

  factory HajjUmrohAccommodation.fromJson(Map<String, dynamic> json) => _$HajjUmrohAccommodationFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohAccommodationToJson(this);
}

@JsonSerializable()
class HajjUmrohTransportation {
  final String flightClass;
  final String airline;
  final List<String> features;
  final String busType;
  final bool isACBus;
  final bool hasMakkahMadinahTransport;

  const HajjUmrohTransportation({
    required this.flightClass,
    required this.airline,
    required this.features,
    required this.busType,
    required this.isACBus,
    required this.hasMakkahMadinahTransport,
  });

  factory HajjUmrohTransportation.fromJson(Map<String, dynamic> json) => _$HajjUmrohTransportationFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohTransportationToJson(this);
}

@JsonSerializable()
class HajjUmrohGuide {
  final String id;
  final String name;
  final String photo;
  final List<String> languages;
  final int experience;
  final double rating;
  final String specialization;
  final List<String> certificates;

  const HajjUmrohGuide({
    required this.id,
    required this.name,
    required this.photo,
    required this.languages,
    required this.experience,
    required this.rating,
    required this.specialization,
    required this.certificates,
  });

  factory HajjUmrohGuide.fromJson(Map<String, dynamic> json) => _$HajjUmrohGuideFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohGuideToJson(this);
}

@JsonSerializable()
class HajjUmrohVisaService {
  final bool isIncluded;
  final String type;
  final List<String> requiredDocuments;
  final String processingTime;
  final double additionalFee;
  final List<String> supportedCountries;

  const HajjUmrohVisaService({
    required this.isIncluded,
    required this.type,
    required this.requiredDocuments,
    required this.processingTime,
    required this.additionalFee,
    required this.supportedCountries,
  });

  factory HajjUmrohVisaService.fromJson(Map<String, dynamic> json) => _$HajjUmrohVisaServiceFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohVisaServiceToJson(this);
}

@JsonSerializable()
class HajjUmrohGuideModel {
  final String id;
  final String title;
  final String content;
  final String category; // preparation, rituals, dua, tips
  final List<String> steps;
  final List<String> dua;
  final List<String> images;
  final String audioUrl;
  final bool isBookmarked;

  const HajjUmrohGuideModel({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.steps,
    required this.dua,
    required this.images,
    required this.audioUrl,
    this.isBookmarked = false,
  });

  factory HajjUmrohGuideModel.fromJson(Map<String, dynamic> json) => _$HajjUmrohGuideModelFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohGuideModelToJson(this);
}

@JsonSerializable()
class HajjUmrohBookingModel {
  final String id;
  final String packageId;
  final String userId;
  final DateTime bookingDate;
  final DateTime departureDate;
  final int participants;
  final double totalPrice;
  final String status; // pending, confirmed, cancelled
  final Map<String, dynamic> pilgrims;
  final Map<String, dynamic> paymentDetails;
  final List<String> documents;
  final String visaStatus;
  final List<String> specialRequests;

  const HajjUmrohBookingModel({
    required this.id,
    required this.packageId,
    required this.userId,
    required this.bookingDate,
    required this.departureDate,
    required this.participants,
    required this.totalPrice,
    required this.status,
    required this.pilgrims,
    required this.paymentDetails,
    required this.documents,
    required this.visaStatus,
    required this.specialRequests,
  });

  factory HajjUmrohBookingModel.fromJson(Map<String, dynamic> json) => _$HajjUmrohBookingModelFromJson(json);

  Map<String, dynamic> toJson() => _$HajjUmrohBookingModelToJson(this);
} 