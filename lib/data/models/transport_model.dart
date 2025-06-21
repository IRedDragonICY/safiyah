import 'flight_model.dart';
import 'train_model.dart';

class BusModel extends TransportModel {
  @override
  final DateTime departureTime;
  @override
  final DateTime arrivalTime;

  BusModel({
    required super.id,
    required super.name,
    required super.company,
    required super.departure,
    required super.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required super.price,
    required super.currency,
    required super.features,
    required super.imageUrl,
    required super.rating,
    required super.totalReviews,
    required super.bookingUrl,
    required super.isAvailable,
  }) : super(
          type: TransportType.bus,
          departureTime: null,
          arrivalTime: null,
        );

  factory BusModel.fromJson(Map<String, dynamic> json) {
    return BusModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'JPY',
      features: TransportFeatures.fromJson(json['features'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      bookingUrl: json['bookingUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['departureTime'] = departureTime.toIso8601String();
    json['arrivalTime'] = arrivalTime.toIso8601String();
    return json;
  }

  @override
  Duration get travelTime => arrivalTime.difference(departureTime);
}

enum TransportType {
  bus,
  ridehailing,
  rental,
  taxi,
  metro,
  ferry
}

class TransportModel {
  final String id;
  final String name;
  final TransportType type;
  final String company;
  final String departure;
  final String arrival;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final double price;
  final String currency;
  final TransportFeatures features;
  final String imageUrl;
  final double rating;
  final int totalReviews;
  final String bookingUrl;
  final bool isAvailable;

  TransportModel({
    required this.id,
    required this.name,
    required this.type,
    required this.company,
    required this.departure,
    required this.arrival,
    this.departureTime,
    this.arrivalTime,
    required this.price,
    required this.currency,
    required this.features,
    required this.imageUrl,
    required this.rating,
    required this.totalReviews,
    required this.bookingUrl,
    required this.isAvailable,
  });

  factory TransportModel.fromJson(Map<String, dynamic> json) {
    return TransportModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      type: TransportType.values.firstWhere(
        (t) => t.toString().split('.').last == json['type'],
        orElse: () => TransportType.bus,
      ),
      company: json['company'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      departureTime: json['departureTime'] != null 
          ? DateTime.parse(json['departureTime'])
          : null,
      arrivalTime: json['arrivalTime'] != null
          ? DateTime.parse(json['arrivalTime'])
          : null,
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'JPY',
      features: TransportFeatures.fromJson(json['features'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      bookingUrl: json['bookingUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.toString().split('.').last,
      'company': company,
      'departure': departure,
      'arrival': arrival,
      'departureTime': departureTime?.toIso8601String(),
      'arrivalTime': arrivalTime?.toIso8601String(),
      'price': price,
      'currency': currency,
      'features': features.toJson(),
      'imageUrl': imageUrl,
      'rating': rating,
      'totalReviews': totalReviews,
      'bookingUrl': bookingUrl,
      'isAvailable': isAvailable,
    };
  }

  Duration? get travelTime {
    if (departureTime != null && arrivalTime != null) {
      return arrivalTime!.difference(departureTime!);
    }
    return null;
  }

  String get formattedDuration {
    final duration = travelTime;
    if (duration == null) return 'N/A';
    
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }

  String get typeDisplayName {
    switch (type) {
      case TransportType.bus:
        return 'Bus';
      case TransportType.ridehailing:
        return 'Ride-hailing';
      case TransportType.rental:
        return 'Rental';
      case TransportType.taxi:
        return 'Taxi';
      case TransportType.metro:
        return 'Metro';
      case TransportType.ferry:
        return 'Ferry';
    }
  }
}

class TransportFeatures {
  final bool wifiAvailable;
  final bool acAvailable;
  final bool wheelchair;
  final bool nfcPayment;
  final bool gpsTracking;
  final bool realtimeUpdates;
  final bool halalFriendly;
  final List<String> supportedPayments;
  final List<String> amenities;

  TransportFeatures({
    required this.wifiAvailable,
    required this.acAvailable,
    required this.wheelchair,
    required this.nfcPayment,
    required this.gpsTracking,
    required this.realtimeUpdates,
    required this.halalFriendly,
    required this.supportedPayments,
    required this.amenities,
  });

  factory TransportFeatures.fromJson(Map<String, dynamic> json) {
    return TransportFeatures(
      wifiAvailable: json['wifiAvailable'] ?? false,
      acAvailable: json['acAvailable'] ?? false,
      wheelchair: json['wheelchair'] ?? false,
      nfcPayment: json['nfcPayment'] ?? false,
      gpsTracking: json['gpsTracking'] ?? false,
      realtimeUpdates: json['realtimeUpdates'] ?? false,
      halalFriendly: json['halalFriendly'] ?? false,
      supportedPayments: List<String>.from(json['supportedPayments'] ?? []),
      amenities: List<String>.from(json['amenities'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wifiAvailable': wifiAvailable,
      'acAvailable': acAvailable,
      'wheelchair': wheelchair,
      'nfcPayment': nfcPayment,
      'gpsTracking': gpsTracking,
      'realtimeUpdates': realtimeUpdates,
      'halalFriendly': halalFriendly,
      'supportedPayments': supportedPayments,
      'amenities': amenities,
    };
  }
}

class RentalModel extends TransportModel {
  final String vehicleType; // Car, Bike, Motorcycle, Scooter
  final String transmission; // Manual, Automatic
  final int seats;
  final String fuelType;
  final bool insurance;
  final int minAge;
  final List<String> requirements;
  final RentalPricing pricing;

  RentalModel({
    required super.id,
    required super.name,
    required super.company,
    required super.departure,
    required super.arrival,
    required super.price,
    required super.currency,
    required super.features,
    required super.imageUrl,
    required super.rating,
    required super.totalReviews,
    required super.bookingUrl,
    required super.isAvailable,
    required this.vehicleType,
    required this.transmission,
    required this.seats,
    required this.fuelType,
    required this.insurance,
    required this.minAge,
    required this.requirements,
    required this.pricing,
  }) : super(type: TransportType.rental);

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      company: json['company'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'JPY',
      features: TransportFeatures.fromJson(json['features'] ?? {}),
      imageUrl: json['imageUrl'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
      bookingUrl: json['bookingUrl'] ?? '',
      isAvailable: json['isAvailable'] ?? true,
      vehicleType: json['vehicleType'] ?? '',
      transmission: json['transmission'] ?? '',
      seats: json['seats'] ?? 0,
      fuelType: json['fuelType'] ?? '',
      insurance: json['insurance'] ?? false,
      minAge: json['minAge'] ?? 18,
      requirements: List<String>.from(json['requirements'] ?? []),
      pricing: RentalPricing.fromJson(json['pricing'] ?? {}),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'vehicleType': vehicleType,
      'transmission': transmission,
      'seats': seats,
      'fuelType': fuelType,
      'insurance': insurance,
      'minAge': minAge,
      'requirements': requirements,
      'pricing': pricing.toJson(),
    });
    return json;
  }
}

class RentalPricing {
  final double hourly;
  final double daily;
  final double weekly;
  final double monthly;
  final double deposit;
  final double insurance;

  RentalPricing({
    required this.hourly,
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.deposit,
    required this.insurance,
  });

  factory RentalPricing.fromJson(Map<String, dynamic> json) {
    return RentalPricing(
      hourly: (json['hourly'] ?? 0).toDouble(),
      daily: (json['daily'] ?? 0).toDouble(),
      weekly: (json['weekly'] ?? 0).toDouble(),
      monthly: (json['monthly'] ?? 0).toDouble(),
      deposit: (json['deposit'] ?? 0).toDouble(),
      insurance: (json['insurance'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hourly': hourly,
      'daily': daily,
      'weekly': weekly,
      'monthly': monthly,
      'deposit': deposit,
      'insurance': insurance,
    };
  }
} 