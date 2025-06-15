// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceModel _$PlaceModelFromJson(Map<String, dynamic> json) => PlaceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$PlaceTypeEnumMap, json['type']),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      website: json['website'] as String?,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      imageUrls:
          (json['imageUrls'] as List<dynamic>).map((e) => e as String).toList(),
      openingHours: json['openingHours'] == null
          ? null
          : OpeningHours.fromJson(json['openingHours'] as Map<String, dynamic>),
      amenities:
          (json['amenities'] as List<dynamic>).map((e) => e as String).toList(),
      isHalalCertified: json['isHalalCertified'] as bool,
      halalCertification: json['halalCertification'] as String?,
      distanceFromUser: (json['distanceFromUser'] as num).toDouble(),
    );

Map<String, dynamic> _$PlaceModelToJson(PlaceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$PlaceTypeEnumMap[instance.type]!,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'phoneNumber': instance.phoneNumber,
      'website': instance.website,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'imageUrls': instance.imageUrls,
      'openingHours': instance.openingHours,
      'amenities': instance.amenities,
      'isHalalCertified': instance.isHalalCertified,
      'halalCertification': instance.halalCertification,
      'distanceFromUser': instance.distanceFromUser,
    };

const _$PlaceTypeEnumMap = {
  PlaceType.mosque: 'mosque',
  PlaceType.restaurant: 'restaurant',
  PlaceType.hotel: 'hotel',
  PlaceType.store: 'store',
  PlaceType.attraction: 'attraction',
  PlaceType.airport: 'airport',
  PlaceType.hospital: 'hospital',
  PlaceType.bank: 'bank',
};

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) => OpeningHours(
      hours: (json['hours'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, DayHours.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$OpeningHoursToJson(OpeningHours instance) =>
    <String, dynamic>{
      'hours': instance.hours,
    };

DayHours _$DayHoursFromJson(Map<String, dynamic> json) => DayHours(
      isClosed: json['isClosed'] as bool,
      open: TimeOfDay.fromJson(json['open'] as Map<String, dynamic>),
      close: TimeOfDay.fromJson(json['close'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DayHoursToJson(DayHours instance) => <String, dynamic>{
      'isClosed': instance.isClosed,
      'open': instance.open,
      'close': instance.close,
    };
