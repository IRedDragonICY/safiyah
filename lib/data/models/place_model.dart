import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'place_model.g.dart';

@JsonSerializable()
class PlaceModel extends Equatable {
  final String id;
  final String name;
  final String description;
  final PlaceType type;
  final double latitude;
  final double longitude;
  final String address;
  final String? phoneNumber;
  final String? website;
  final double rating;
  final int reviewCount;
  final List<String> imageUrls;
  final OpeningHours? openingHours;
  final List<String> amenities;
  final bool isHalalCertified;
  final String? halalCertification;
  final double distanceFromUser;

  const PlaceModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.phoneNumber,
    this.website,
    required this.rating,
    required this.reviewCount,
    required this.imageUrls,
    this.openingHours,
    required this.amenities,
    required this.isHalalCertified,
    this.halalCertification,
    required this.distanceFromUser,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> json) => 
      _$PlaceModelFromJson(json);

  Map<String, dynamic> toJson() => _$PlaceModelToJson(this);

  String get distanceText {
    if (distanceFromUser < 1000) {
      return '${distanceFromUser.round()}m';
    } else {
      return '${(distanceFromUser / 1000).toStringAsFixed(1)}km';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        type,
        latitude,
        longitude,
        address,
        phoneNumber,
        website,
        rating,
        reviewCount,
        imageUrls,
        openingHours,
        amenities,
        isHalalCertified,
        halalCertification,
        distanceFromUser,
      ];
}

@JsonSerializable()
class OpeningHours extends Equatable {
  final Map<String, DayHours> hours;

  const OpeningHours({required this.hours});

  factory OpeningHours.fromJson(Map<String, dynamic> json) => 
      _$OpeningHoursFromJson(json);

  Map<String, dynamic> toJson() => _$OpeningHoursToJson(this);

  bool get isOpenNow {
    final now = DateTime.now();
    final weekday = now.weekday;
    final dayNames = [
      'monday',
      'tuesday', 
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    
    final todayHours = hours[dayNames[weekday - 1]];
    if (todayHours == null || todayHours.isClosed) return false;
    
    final currentTime = TimeOfDay.fromDateTime(now);
    return _isTimeBetween(currentTime, todayHours.open, todayHours.close);
  }

  bool _isTimeBetween(TimeOfDay current, TimeOfDay start, TimeOfDay end) {
    final currentMinutes = current.hour * 60 + current.minute;
    final startMinutes = start.hour * 60 + start.minute;
    final endMinutes = end.hour * 60 + end.minute;
    
    if (startMinutes <= endMinutes) {
      return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
    } else {
      // Crosses midnight
      return currentMinutes >= startMinutes || currentMinutes <= endMinutes;
    }
  }

  @override
  List<Object?> get props => [hours];
}

@JsonSerializable()
class DayHours extends Equatable {
  final bool isClosed;
  final TimeOfDay open;
  final TimeOfDay close;

  const DayHours({
    required this.isClosed,
    required this.open,
    required this.close,
  });

  factory DayHours.fromJson(Map<String, dynamic> json) => 
      _$DayHoursFromJson(json);

  Map<String, dynamic> toJson() => _$DayHoursToJson(this);

  @override
  List<Object?> get props => [isClosed, open, close];
}

enum PlaceType {
  @JsonValue('mosque')
  mosque,
  @JsonValue('restaurant')
  restaurant,
  @JsonValue('hotel')
  hotel,
  @JsonValue('store')
  store,
  @JsonValue('attraction')
  attraction,
  @JsonValue('airport')
  airport,
  @JsonValue('hospital')
  hospital,
  @JsonValue('bank')
  bank,
}

extension PlaceTypeExtension on PlaceType {
  String get displayName {
    switch (this) {
      case PlaceType.mosque:
        return 'Mosque';
      case PlaceType.restaurant:
        return 'Restaurant';
      case PlaceType.hotel:
        return 'Hotel';
      case PlaceType.store:
        return 'Store';
      case PlaceType.attraction:
        return 'Attraction';
      case PlaceType.airport:
        return 'Airport';
      case PlaceType.hospital:
        return 'Hospital';
      case PlaceType.bank:
        return 'Bank';
    }
  }

  String get iconPath {
    switch (this) {
      case PlaceType.mosque:
        return 'assets/icons/mosque.svg';
      case PlaceType.restaurant:
        return 'assets/icons/restaurant.svg';
      case PlaceType.hotel:
        return 'assets/icons/hotel.svg';
      case PlaceType.store:
        return 'assets/icons/store.svg';
      case PlaceType.attraction:
        return 'assets/icons/attraction.svg';
      case PlaceType.airport:
        return 'assets/icons/airport.svg';
      case PlaceType.hospital:
        return 'assets/icons/hospital.svg';
      case PlaceType.bank:
        return 'assets/icons/bank.svg';
    }
  }
}

// Custom TimeOfDay serialization
class TimeOfDay {
  final int hour;
  final int minute;

  const TimeOfDay({required this.hour, required this.minute});

  factory TimeOfDay.fromDateTime(DateTime dateTime) {
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
  }

  factory TimeOfDay.fromJson(Map<String, dynamic> json) {
    return TimeOfDay(
      hour: json['hour'] as int,
      minute: json['minute'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hour': hour,
      'minute': minute,
    };
  }

  @override
  String toString() {
    final hourStr = hour.toString().padLeft(2, '0');
    final minuteStr = minute.toString().padLeft(2, '0');
    return '$hourStr:$minuteStr';
  }
}
