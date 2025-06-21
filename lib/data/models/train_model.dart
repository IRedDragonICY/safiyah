class TrainModel {
  final String id;
  final String trainLine;
  final String trainNumber;
  final String trainType; // Shinkansen, Express, Local
  final String departure;
  final String arrival;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final double price;
  final String currency;
  final List<String> availableClasses;
  final List<TrainStop> stops;
  final bool isReserved;
  final bool halalFriendly;
  final TrainFeatures features;
  final String platform;
  final String operator;

  // Getter for trainName (combination of trainLine and trainNumber)
  String get trainName => '$trainLine $trainNumber';

  TrainModel({
    required this.id,
    required this.trainLine,
    required this.trainNumber,
    required this.trainType,
    required this.departure,
    required this.arrival,
    required this.departureTime,
    required this.arrivalTime,
    required this.price,
    required this.currency,
    required this.availableClasses,
    required this.stops,
    required this.isReserved,
    required this.halalFriendly,
    required this.features,
    required this.platform,
    required this.operator,
  });

  factory TrainModel.fromJson(Map<String, dynamic> json) {
    return TrainModel(
      id: json['id'] ?? '',
      trainLine: json['trainLine'] ?? '',
      trainNumber: json['trainNumber'] ?? '',
      trainType: json['trainType'] ?? '',
      departure: json['departure'] ?? '',
      arrival: json['arrival'] ?? '',
      departureTime: DateTime.parse(json['departureTime']),
      arrivalTime: DateTime.parse(json['arrivalTime']),
      price: (json['price'] ?? 0).toDouble(),
      currency: json['currency'] ?? 'JPY',
      availableClasses: List<String>.from(json['availableClasses'] ?? []),
      stops: (json['stops'] as List? ?? [])
          .map((stop) => TrainStop.fromJson(stop))
          .toList(),
      isReserved: json['isReserved'] ?? false,
      halalFriendly: json['halalFriendly'] ?? false,
      features: TrainFeatures.fromJson(json['features'] ?? {}),
      platform: json['platform'] ?? '',
      operator: json['operator'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trainLine': trainLine,
      'trainNumber': trainNumber,
      'trainType': trainType,
      'departure': departure,
      'arrival': arrival,
      'departureTime': departureTime.toIso8601String(),
      'arrivalTime': arrivalTime.toIso8601String(),
      'price': price,
      'currency': currency,
      'availableClasses': availableClasses,
      'stops': stops.map((stop) => stop.toJson()).toList(),
      'isReserved': isReserved,
      'halalFriendly': halalFriendly,
      'features': features.toJson(),
      'platform': platform,
      'operator': operator,
    };
  }

  Duration get travelTime {
    return arrivalTime.difference(departureTime);
  }

  String get formattedDuration {
    final duration = travelTime;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class TrainStop {
  final String stationName;
  final DateTime arrivalTime;
  final DateTime departureTime;
  final int stopDuration; // in minutes
  final String platform;

  TrainStop({
    required this.stationName,
    required this.arrivalTime,
    required this.departureTime,
    required this.stopDuration,
    required this.platform,
  });

  // Getter for waitTime (alias for stopDuration)
  int get waitTime => stopDuration;

  factory TrainStop.fromJson(Map<String, dynamic> json) {
    return TrainStop(
      stationName: json['stationName'] ?? '',
      arrivalTime: DateTime.parse(json['arrivalTime']),
      departureTime: DateTime.parse(json['departureTime']),
      stopDuration: json['stopDuration'] ?? 0,
      platform: json['platform'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'stationName': stationName,
      'arrivalTime': arrivalTime.toIso8601String(),
      'departureTime': departureTime.toIso8601String(),
      'stopDuration': stopDuration,
      'platform': platform,
    };
  }
}

class TrainFeatures {
  final bool wifiAvailable;
  final bool powerOutlets;
  final bool quietCar;
  final bool baggageStorage;
  final bool wheelchair;
  final bool nfcPayment;
  final bool icCardSupported;
  final List<String> supportedPayments;

  TrainFeatures({
    required this.wifiAvailable,
    required this.powerOutlets,
    required this.quietCar,
    required this.baggageStorage,
    required this.wheelchair,
    required this.nfcPayment,
    required this.icCardSupported,
    required this.supportedPayments,
  });

  // Getters for backward compatibility with detail page
  bool get hasWifi => wifiAvailable;
  bool get hasPowerOutlets => powerOutlets;
  bool get hasReclinableSeats => quietCar;
  bool get hasFoodService => false; // Default for this model
  bool get hasLuggageStorage => baggageStorage;
  bool get isWheelchairAccessible => wheelchair;

  factory TrainFeatures.fromJson(Map<String, dynamic> json) {
    return TrainFeatures(
      wifiAvailable: json['wifiAvailable'] ?? false,
      powerOutlets: json['powerOutlets'] ?? false,
      quietCar: json['quietCar'] ?? false,
      baggageStorage: json['baggageStorage'] ?? false,
      wheelchair: json['wheelchair'] ?? false,
      nfcPayment: json['nfcPayment'] ?? false,
      icCardSupported: json['icCardSupported'] ?? false,
      supportedPayments: List<String>.from(json['supportedPayments'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'wifiAvailable': wifiAvailable,
      'powerOutlets': powerOutlets,
      'quietCar': quietCar,
      'baggageStorage': baggageStorage,
      'wheelchair': wheelchair,
      'nfcPayment': nfcPayment,
      'icCardSupported': icCardSupported,
      'supportedPayments': supportedPayments,
    };
  }
} 