// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hajj_umroh_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HajjUmrohPackageModel _$HajjUmrohPackageModelFromJson(
        Map<String, dynamic> json) =>
    HajjUmrohPackageModel(
      id: json['id'] as String,
      title: json['title'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String,
      departureDate: DateTime.parse(json['departureDate'] as String),
      returnDate: DateTime.parse(json['returnDate'] as String),
      maxParticipants: (json['maxParticipants'] as num).toInt(),
      currentBookings: (json['currentBookings'] as num).toInt(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      itinerary: HajjUmrohItinerary.fromJson(
          json['itinerary'] as Map<String, dynamic>),
      inclusions: (json['inclusions'] as List<dynamic>)
          .map((e) => HajjUmrohInclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
      exclusions: (json['exclusions'] as List<dynamic>)
          .map((e) => HajjUmrohExclusion.fromJson(e as Map<String, dynamic>))
          .toList(),
      makkahAccommodation: HajjUmrohAccommodation.fromJson(
          json['makkahAccommodation'] as Map<String, dynamic>),
      madinahAccommodation: HajjUmrohAccommodation.fromJson(
          json['madinahAccommodation'] as Map<String, dynamic>),
      transportation: HajjUmrohTransportation.fromJson(
          json['transportation'] as Map<String, dynamic>),
      guides: (json['guides'] as List<dynamic>)
          .map((e) => HajjUmrohGuide.fromJson(e as Map<String, dynamic>))
          .toList(),
      visaService: HajjUmrohVisaService.fromJson(
          json['visaService'] as Map<String, dynamic>),
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      provider: json['provider'] as String,
      isMinistryApproved: json['isMinistryApproved'] as bool,
      approvalNumber: json['approvalNumber'] as String,
      certificates: (json['certificates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      bookingTerms: json['bookingTerms'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$HajjUmrohPackageModelToJson(
        HajjUmrohPackageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'type': instance.type,
      'description': instance.description,
      'price': instance.price,
      'duration': instance.duration,
      'departureDate': instance.departureDate.toIso8601String(),
      'returnDate': instance.returnDate.toIso8601String(),
      'maxParticipants': instance.maxParticipants,
      'currentBookings': instance.currentBookings,
      'images': instance.images,
      'itinerary': instance.itinerary,
      'inclusions': instance.inclusions,
      'exclusions': instance.exclusions,
      'makkahAccommodation': instance.makkahAccommodation,
      'madinahAccommodation': instance.madinahAccommodation,
      'transportation': instance.transportation,
      'guides': instance.guides,
      'visaService': instance.visaService,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'provider': instance.provider,
      'isMinistryApproved': instance.isMinistryApproved,
      'approvalNumber': instance.approvalNumber,
      'certificates': instance.certificates,
      'bookingTerms': instance.bookingTerms,
    };

HajjUmrohItinerary _$HajjUmrohItineraryFromJson(Map<String, dynamic> json) =>
    HajjUmrohItinerary(
      dayPlans: (json['dayPlans'] as List<dynamic>)
          .map((e) => HajjUmrohDayPlan.fromJson(e as Map<String, dynamic>))
          .toList(),
      rituals: (json['rituals'] as List<dynamic>)
          .map((e) => RitualActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      overview: json['overview'] as String,
      importantNotes: (json['importantNotes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HajjUmrohItineraryToJson(HajjUmrohItinerary instance) =>
    <String, dynamic>{
      'dayPlans': instance.dayPlans,
      'rituals': instance.rituals,
      'overview': instance.overview,
      'importantNotes': instance.importantNotes,
    };

HajjUmrohDayPlan _$HajjUmrohDayPlanFromJson(Map<String, dynamic> json) =>
    HajjUmrohDayPlan(
      day: (json['day'] as num).toInt(),
      date: json['date'] as String,
      location: json['location'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      activities: (json['activities'] as List<dynamic>)
          .map((e) => RitualActivity.fromJson(e as Map<String, dynamic>))
          .toList(),
      prayerTimes: (json['prayerTimes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      accommodation: json['accommodation'] as String,
      meals: (json['meals'] as List<dynamic>).map((e) => e as String).toList(),
      tips: (json['tips'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$HajjUmrohDayPlanToJson(HajjUmrohDayPlan instance) =>
    <String, dynamic>{
      'day': instance.day,
      'date': instance.date,
      'location': instance.location,
      'title': instance.title,
      'description': instance.description,
      'activities': instance.activities,
      'prayerTimes': instance.prayerTimes,
      'accommodation': instance.accommodation,
      'meals': instance.meals,
      'tips': instance.tips,
    };

RitualActivity _$RitualActivityFromJson(Map<String, dynamic> json) =>
    RitualActivity(
      name: json['name'] as String,
      arabicName: json['arabicName'] as String,
      time: json['time'] as String,
      location: json['location'] as String,
      description: json['description'] as String,
      guidance: json['guidance'] as String,
      dua: (json['dua'] as List<dynamic>).map((e) => e as String).toList(),
      isCompulsory: json['isCompulsory'] as bool,
      type: json['type'] as String,
    );

Map<String, dynamic> _$RitualActivityToJson(RitualActivity instance) =>
    <String, dynamic>{
      'name': instance.name,
      'arabicName': instance.arabicName,
      'time': instance.time,
      'location': instance.location,
      'description': instance.description,
      'guidance': instance.guidance,
      'dua': instance.dua,
      'isCompulsory': instance.isCompulsory,
      'type': instance.type,
    };

HajjUmrohInclusion _$HajjUmrohInclusionFromJson(Map<String, dynamic> json) =>
    HajjUmrohInclusion(
      title: json['title'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      isImportant: json['isImportant'] as bool? ?? false,
    );

Map<String, dynamic> _$HajjUmrohInclusionToJson(HajjUmrohInclusion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'icon': instance.icon,
      'isImportant': instance.isImportant,
    };

HajjUmrohExclusion _$HajjUmrohExclusionFromJson(Map<String, dynamic> json) =>
    HajjUmrohExclusion(
      title: json['title'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$HajjUmrohExclusionToJson(HajjUmrohExclusion instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
    };

HajjUmrohAccommodation _$HajjUmrohAccommodationFromJson(
        Map<String, dynamic> json) =>
    HajjUmrohAccommodation(
      name: json['name'] as String,
      type: json['type'] as String,
      stars: (json['stars'] as num).toInt(),
      distanceToHaram: (json['distanceToHaram'] as num).toDouble(),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      description: json['description'] as String,
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      roomType: json['roomType'] as String,
      personsPerRoom: (json['personsPerRoom'] as num).toInt(),
    );

Map<String, dynamic> _$HajjUmrohAccommodationToJson(
        HajjUmrohAccommodation instance) =>
    <String, dynamic>{
      'name': instance.name,
      'type': instance.type,
      'stars': instance.stars,
      'distanceToHaram': instance.distanceToHaram,
      'amenities': instance.amenities,
      'description': instance.description,
      'images': instance.images,
      'roomType': instance.roomType,
      'personsPerRoom': instance.personsPerRoom,
    };

HajjUmrohTransportation _$HajjUmrohTransportationFromJson(
        Map<String, dynamic> json) =>
    HajjUmrohTransportation(
      flightClass: json['flightClass'] as String,
      airline: json['airline'] as String,
      features:
          (json['features'] as List<dynamic>).map((e) => e as String).toList(),
      busType: json['busType'] as String,
      isACBus: json['isACBus'] as bool,
      hasMakkahMadinahTransport: json['hasMakkahMadinahTransport'] as bool,
    );

Map<String, dynamic> _$HajjUmrohTransportationToJson(
        HajjUmrohTransportation instance) =>
    <String, dynamic>{
      'flightClass': instance.flightClass,
      'airline': instance.airline,
      'features': instance.features,
      'busType': instance.busType,
      'isACBus': instance.isACBus,
      'hasMakkahMadinahTransport': instance.hasMakkahMadinahTransport,
    };

HajjUmrohGuide _$HajjUmrohGuideFromJson(Map<String, dynamic> json) =>
    HajjUmrohGuide(
      id: json['id'] as String,
      name: json['name'] as String,
      photo: json['photo'] as String,
      languages:
          (json['languages'] as List<dynamic>).map((e) => e as String).toList(),
      experience: (json['experience'] as num).toInt(),
      rating: (json['rating'] as num).toDouble(),
      specialization: json['specialization'] as String,
      certificates: (json['certificates'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HajjUmrohGuideToJson(HajjUmrohGuide instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photo': instance.photo,
      'languages': instance.languages,
      'experience': instance.experience,
      'rating': instance.rating,
      'specialization': instance.specialization,
      'certificates': instance.certificates,
    };

HajjUmrohVisaService _$HajjUmrohVisaServiceFromJson(
        Map<String, dynamic> json) =>
    HajjUmrohVisaService(
      isIncluded: json['isIncluded'] as bool,
      type: json['type'] as String,
      requiredDocuments: (json['requiredDocuments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      processingTime: json['processingTime'] as String,
      additionalFee: (json['additionalFee'] as num).toDouble(),
      supportedCountries: (json['supportedCountries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HajjUmrohVisaServiceToJson(
        HajjUmrohVisaService instance) =>
    <String, dynamic>{
      'isIncluded': instance.isIncluded,
      'type': instance.type,
      'requiredDocuments': instance.requiredDocuments,
      'processingTime': instance.processingTime,
      'additionalFee': instance.additionalFee,
      'supportedCountries': instance.supportedCountries,
    };

HajjUmrohGuideModel _$HajjUmrohGuideModelFromJson(Map<String, dynamic> json) =>
    HajjUmrohGuideModel(
      id: json['id'] as String,
      title: json['title'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      steps: (json['steps'] as List<dynamic>).map((e) => e as String).toList(),
      dua: (json['dua'] as List<dynamic>).map((e) => e as String).toList(),
      images:
          (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      audioUrl: json['audioUrl'] as String,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );

Map<String, dynamic> _$HajjUmrohGuideModelToJson(
        HajjUmrohGuideModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'category': instance.category,
      'steps': instance.steps,
      'dua': instance.dua,
      'images': instance.images,
      'audioUrl': instance.audioUrl,
      'isBookmarked': instance.isBookmarked,
    };

HajjUmrohBookingModel _$HajjUmrohBookingModelFromJson(
        Map<String, dynamic> json) =>
    HajjUmrohBookingModel(
      id: json['id'] as String,
      packageId: json['packageId'] as String,
      userId: json['userId'] as String,
      bookingDate: DateTime.parse(json['bookingDate'] as String),
      departureDate: DateTime.parse(json['departureDate'] as String),
      participants: (json['participants'] as num).toInt(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      pilgrims: json['pilgrims'] as Map<String, dynamic>,
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>,
      documents:
          (json['documents'] as List<dynamic>).map((e) => e as String).toList(),
      visaStatus: json['visaStatus'] as String,
      specialRequests: (json['specialRequests'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$HajjUmrohBookingModelToJson(
        HajjUmrohBookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'packageId': instance.packageId,
      'userId': instance.userId,
      'bookingDate': instance.bookingDate.toIso8601String(),
      'departureDate': instance.departureDate.toIso8601String(),
      'participants': instance.participants,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
      'pilgrims': instance.pilgrims,
      'paymentDetails': instance.paymentDetails,
      'documents': instance.documents,
      'visaStatus': instance.visaStatus,
      'specialRequests': instance.specialRequests,
    };
