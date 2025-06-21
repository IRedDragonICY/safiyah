class FlightModel {
  final String id;
  final String airline;
  final String flightNumber;
  final String departure;
  final String arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String currency;
  final String aircraftType;
  final bool isHalalCertified;
  final HalalFeatures halalFeatures;
  final List<String> availableClasses;
  final String bookingUrl;
  final double rating;
  final int totalReviews;

  FlightModel({
    required this.id,
    required this.airline,
    required this.flightNumber,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.currency,
    required this.aircraftType,
    required this.isHalalCertified,
    required this.halalFeatures,
    required this.availableClasses,
    required this.bookingUrl,
    required this.rating,
    required this.totalReviews,
  });

  factory FlightModel.fromJson(Map<String, dynamic> json) {
    return FlightModel(
      id: json['id'] ?? '',
      airline: json['airline'] ?? '',
      flightNumber: json['flightNumber'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'JPY',
      aircraftType: json['aircraftType'] ?? '',
      isHalalCertified: json['isHalalCertified'] ?? false,
      halalFeatures: HalalFeatures.fromJson(json['halalFeatures'] ?? {}),
      availableClasses: List<String>.from(json['availableClasses'] ?? []),
      bookingUrl: json['bookingUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'airline': airline,
      'flightNumber': flightNumber,
      'departure': departure,
      'arrival': arrival,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'currency': currency,
      'aircraftType': aircraftType,
      'isHalalCertified': isHalalCertified,
      'halalFeatures': halalFeatures.toJson(),
      'availableClasses': availableClasses,
      'bookingUrl': bookingUrl,
      'rating': rating,
      'totalReviews': totalReviews,
    };
  }

  Duration get flightDuration {
    return arrivalTime.difference(departureTime);
  }

  String get formattedDuration {
    final duration = flightDuration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class HalalFeatures {
  final bool halalMeals;
  final bool prayerScheduleNotification;
  final bool qiblaDirection;
  final bool noPetPolicy;
  final bool alcoholFreeService;
  final bool separateSeatingAvailable;
  final List<String> mealOptions;
  final bool wuduFacilities;

  HalalFeatures({
    required this.halalMeals,
    required this.prayerScheduleNotification,
    required this.qiblaDirection,
    required this.noPetPolicy,
    required this.alcoholFreeService,
    required this.separateSeatingAvailable,
    required this.mealOptions,
    required this.wuduFacilities,
  });

  factory HalalFeatures.fromJson(Map<String, dynamic> json) {
    return HalalFeatures(
      halalMeals: json['halalMeals'] ?? false,
      prayerScheduleNotification: json['prayerScheduleNotification'] ?? false,
      qiblaDirection: json['qiblaDirection'] ?? false,
      noPetPolicy: json['noPetPolicy'] ?? false,
      alcoholFreeService: json['alcoholFreeService'] ?? false,
      separateSeatingAvailable: json['separateSeatingAvailable'] ?? false,
      mealOptions: List<String>.from(json['mealOptions'] ?? []),
      wuduFacilities: json['wuduFacilities'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'halalMeals': halalMeals,
      'prayerScheduleNotification': prayerScheduleNotification,
      'qiblaDirection': qiblaDirection,
      'noPetPolicy': noPetPolicy,
      'alcoholFreeService': alcoholFreeService,
      'separateSeatingAvailable': separateSeatingAvailable,
      'mealOptions': mealOptions,
      'wuduFacilities': wuduFacilities,
    };
  }
} 