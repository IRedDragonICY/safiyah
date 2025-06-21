import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/flight_model.dart';
import '../models/train_model.dart';
import '../models/transport_model.dart';

class TransportationRepository {
  static final TransportationRepository _instance = TransportationRepository._internal();
  factory TransportationRepository() => _instance;
  TransportationRepository._internal();

  final Random _random = Random();

  // Mock data for Japanese transportation
  Future<List<FlightModel>> getFlights({
    required String from,
    required String to,
    required DateTime date,
    int passengers = 1,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return [
      FlightModel(
        id: 'FL001',
        airline: 'Japan Airlines (JAL)',
        flightNumber: 'JL123',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 8)),
        arrivalTime: date.add(const Duration(hours: 10, minutes: 30)),
        price: 35000,
        currency: 'JPY',
        aircraftType: 'Boeing 787',
        isHalalCertified: true,
        halalFeatures: HalalFeatures(
          halalMeals: true,
          prayerScheduleNotification: true,
          qiblaDirection: true,
          noPetPolicy: true,
          alcoholFreeService: true,
          separateSeatingAvailable: true,
          mealOptions: ['Halal Asian', 'Halal Western', 'Vegetarian'],
          wuduFacilities: false,
        ),
        availableClasses: ['Economy', 'Business', 'First'],
        bookingUrl: 'https://www.jal.co.jp',
        rating: 4.5,
        totalReviews: 1250,
      ),
      FlightModel(
        id: 'FL002',
        airline: 'All Nippon Airways (ANA)',
        flightNumber: 'NH456',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 14)),
        arrivalTime: date.add(const Duration(hours: 16, minutes: 15)),
        price: 32000,
        currency: 'JPY',
        aircraftType: 'Airbus A320',
        isHalalCertified: true,
        halalFeatures: HalalFeatures(
          halalMeals: true,
          prayerScheduleNotification: false,
          qiblaDirection: true,
          noPetPolicy: true,
          alcoholFreeService: false,
          separateSeatingAvailable: false,
          mealOptions: ['Halal Meal', 'Vegetarian'],
          wuduFacilities: false,
        ),
        availableClasses: ['Economy', 'Business'],
        bookingUrl: 'https://www.ana.co.jp',
        rating: 4.3,
        totalReviews: 980,
      ),
      FlightModel(
        id: 'FL003',
        airline: 'Jetstar Japan',
        flightNumber: 'GK789',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 18)),
        arrivalTime: date.add(const Duration(hours: 20, minutes: 45)),
        price: 18000,
        currency: 'JPY',
        aircraftType: 'Airbus A320',
        isHalalCertified: false,
        halalFeatures: HalalFeatures(
          halalMeals: false,
          prayerScheduleNotification: false,
          qiblaDirection: false,
          noPetPolicy: false,
          alcoholFreeService: false,
          separateSeatingAvailable: false,
          mealOptions: [],
          wuduFacilities: false,
        ),
        availableClasses: ['Economy'],
        bookingUrl: 'https://www.jetstar.com',
        rating: 3.8,
        totalReviews: 567,
      ),
    ];
  }

  Future<List<TrainModel>> getTrains({
    required String from,
    required String to,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    return [
      TrainModel(
        id: 'TR001',
        trainLine: 'Tokaido Shinkansen',
        trainNumber: 'Hikari 123',
        trainType: 'Shinkansen',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 6)),
        arrivalTime: date.add(const Duration(hours: 8, minutes: 15)),
        price: 13320,
        currency: 'JPY',
        availableClasses: ['Non-reserved', 'Reserved', 'Green Car'],
        stops: [
          TrainStop(
            stationName: 'Shinagawa',
            arrivalTime: date.add(const Duration(hours: 6, minutes: 15)),
            departureTime: date.add(const Duration(hours: 6, minutes: 17)),
            stopDuration: 2,
            platform: '12',
          ),
          TrainStop(
            stationName: 'Shin-Yokohama',
            arrivalTime: date.add(const Duration(hours: 6, minutes: 30)),
            departureTime: date.add(const Duration(hours: 6, minutes: 32)),
            stopDuration: 2,
            platform: '11',
          ),
        ],
        isReserved: false,
        halalFriendly: true,
        features: TrainFeatures(
          wifiAvailable: true,
          powerOutlets: true,
          quietCar: true,
          baggageStorage: true,
          wheelchair: true,
          nfcPayment: true,
          icCardSupported: true,
          supportedPayments: ['Suica', 'Pasmo', 'ICOCA', 'Credit Card'],
        ),
        platform: '14',
        operator: 'JR Central',
      ),
      TrainModel(
        id: 'TR002',
        trainLine: 'JR Yamanote Line',
        trainNumber: 'Local 456',
        trainType: 'Local',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 7)),
        arrivalTime: date.add(const Duration(hours: 7, minutes: 45)),
        price: 200,
        currency: 'JPY',
        availableClasses: ['Standard'],
        stops: _generateYamanoteStops(date.add(const Duration(hours: 7))),
        isReserved: false,
        halalFriendly: true,
        features: TrainFeatures(
          wifiAvailable: false,
          powerOutlets: false,
          quietCar: false,
          baggageStorage: false,
          wheelchair: true,
          nfcPayment: true,
          icCardSupported: true,
          supportedPayments: ['Suica', 'Pasmo', 'Cash'],
        ),
        platform: '3',
        operator: 'JR East',
      ),
    ];
  }

  Future<List<BusModel>> getBuses({
    required String from,
    required String to,
    required DateTime date,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    return [
      BusModel(
        id: 'BUS001',
        name: 'Airport Express Bus',
        company: 'Tokyo Airport Transport',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 6)),
        arrivalTime: date.add(const Duration(hours: 7, minutes: 30)),
        price: 1000,
        currency: 'JPY',
        features: TransportFeatures(
          wifiAvailable: true,
          acAvailable: true,
          wheelchair: true,
          nfcPayment: true,
          gpsTracking: true,
          realtimeUpdates: true,
          halalFriendly: true,
          supportedPayments: ['IC Card', 'Cash', 'Mobile Payment'],
          amenities: ['WiFi', 'AC', 'Luggage Storage'],
        ),
        imageUrl: 'https://example.com/bus.jpg',
        rating: 4.2,
        totalReviews: 234,
        bookingUrl: 'https://www.tokyoairport.co.jp',
        isAvailable: true,
      ),
      BusModel(
        id: 'BUS002',
        name: 'Highway Bus',
        company: 'JR Bus',
        departure: from,
        arrival: to,
        departureTime: date.add(const Duration(hours: 8)),
        arrivalTime: date.add(const Duration(hours: 11, minutes: 15)),
        price: 2500,
        currency: 'JPY',
        features: TransportFeatures(
          wifiAvailable: true,
          acAvailable: true,
          wheelchair: false,
          nfcPayment: true,
          gpsTracking: true,
          realtimeUpdates: true,
          halalFriendly: true,
          supportedPayments: ['IC Card', 'Cash', 'Credit Card'],
          amenities: ['WiFi', 'AC', 'Reclining Seats', 'Toilet'],
        ),
        imageUrl: 'https://example.com/highway-bus.jpg',
        rating: 4.0,
        totalReviews: 156,
        bookingUrl: 'https://www.jrbus.co.jp',
        isAvailable: true,
      ),
    ];
  }

  Future<List<TransportModel>> getRideHailing({
    required String from,
    required String to,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    return [
      TransportModel(
        id: 'RH001',
        name: 'GO Premium',
        type: TransportType.ridehailing,
        company: 'GO (JapanTaxi)',
        departure: from,
        arrival: to,
        price: 1200,
        currency: 'JPY',
        features: TransportFeatures(
          wifiAvailable: false,
          acAvailable: true,
          wheelchair: false,
          nfcPayment: true,
          gpsTracking: true,
          realtimeUpdates: true,
          halalFriendly: true,
          supportedPayments: ['Credit Card', 'IC Card', 'Cash'],
          amenities: ['AC', 'GPS Tracking'],
        ),
        imageUrl: 'https://example.com/go-taxi.jpg',
        rating: 4.3,
        totalReviews: 1543,
        bookingUrl: 'https://go.mo-t.com',
        isAvailable: true,
      ),
      TransportModel(
        id: 'RH002',
        name: 'DiDi Standard',
        type: TransportType.ridehailing,
        company: 'DiDi',
        departure: from,
        arrival: to,
        price: 980,
        currency: 'JPY',
        features: TransportFeatures(
          wifiAvailable: false,
          acAvailable: true,
          wheelchair: false,
          nfcPayment: true,
          gpsTracking: true,
          realtimeUpdates: true,
          halalFriendly: true,
          supportedPayments: ['Credit Card', 'PayPay', 'Cash'],
          amenities: ['AC', 'GPS Tracking', 'Driver Rating'],
        ),
        imageUrl: 'https://example.com/didi.jpg',
        rating: 4.1,
        totalReviews: 892,
        bookingUrl: 'https://www.didiglobal.com',
        isAvailable: true,
      ),
    ];
  }

  Future<List<RentalModel>> getRentals({
    required String location,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));
    
    return [
      RentalModel(
        id: 'RN001',
        name: 'Toyota Prius Hybrid',
        company: 'Toyota Rent a Car',
        departure: location,
        arrival: location,
        price: 8000,
        currency: 'JPY',
        features: TransportFeatures(
          wifiAvailable: true,
          acAvailable: true,
          wheelchair: false,
          nfcPayment: true,
          gpsTracking: true,
          realtimeUpdates: false,
          halalFriendly: true,
          supportedPayments: ['Credit Card', 'Cash'],
          amenities: ['GPS', 'AC', 'Bluetooth', 'ETC Card'],
        ),
        imageUrl: 'https://example.com/prius.jpg',
        rating: 4.5,
        totalReviews: 567,
        bookingUrl: 'https://rent.toyota.co.jp',
        isAvailable: true,
        vehicleType: 'Car',
        transmission: 'Automatic',
        seats: 5,
        fuelType: 'Hybrid',
        insurance: true,
        minAge: 21,
        requirements: ['International Driving Permit', 'Credit Card'],
        pricing: RentalPricing(
          hourly: 1200,
          daily: 8000,
          weekly: 45000,
          monthly: 150000,
          deposit: 20000,
          insurance: 1500,
        ),
      ),
      RentalModel(
        id: 'RN002',
        name: 'Yamaha Electric Bike',
        company: 'Docomo Bike Share',
        departure: location,
        arrival: location,
        price: 200,
        currency: 'JPY',
        features: TransportFeatures(
          wifiAvailable: false,
          acAvailable: false,
          wheelchair: false,
          nfcPayment: true,
          gpsTracking: true,
          realtimeUpdates: true,
          halalFriendly: true,
          supportedPayments: ['IC Card', 'Credit Card', 'Mobile App'],
          amenities: ['GPS', 'Electric Assist', 'Basket'],
        ),
        imageUrl: 'https://example.com/electric-bike.jpg',
        rating: 4.2,
        totalReviews: 234,
        bookingUrl: 'https://docomo-cycle.jp',
        isAvailable: true,
        vehicleType: 'Bike',
        transmission: 'N/A',
        seats: 1,
        fuelType: 'Electric',
        insurance: false,
        minAge: 16,
        requirements: ['Mobile App Registration'],
        pricing: RentalPricing(
          hourly: 200,
          daily: 1500,
          weekly: 8000,
          monthly: 25000,
          deposit: 0,
          insurance: 0,
        ),
      ),
    ];
  }

  List<TrainStop> _generateYamanoteStops(DateTime startTime) {
    final stations = [
      'Shimbashi', 'Yurakucho', 'Tokyo', 'Kanda', 'Akihabara',
      'Okachimachi', 'Ueno', 'Uguisudani', 'Nippori', 'Nishi-Nippori'
    ];
    
    final stops = <TrainStop>[];
    var currentTime = startTime;
    
    for (int i = 0; i < stations.length; i++) {
      currentTime = currentTime.add(const Duration(minutes: 4));
      stops.add(TrainStop(
        stationName: stations[i],
        arrivalTime: currentTime,
        departureTime: currentTime.add(const Duration(minutes: 1)),
        stopDuration: 1,
        platform: '${i % 4 + 1}',
      ));
    }
    
    return stops;
  }

  Future<List<TransportModel>> searchTransportation({
    required String from,
    required String to,
    DateTime? date,
    List<TransportType>? types,
  }) async {
    final results = <TransportModel>[];
    
    if (types == null || types.contains(TransportType.bus)) {
      final buses = await getBuses(
        from: from,
        to: to,
        date: date ?? DateTime.now(),
      );
      results.addAll(buses.cast<TransportModel>());
    }
    
    if (types == null || types.contains(TransportType.ridehailing)) {
      final ridehailing = await getRideHailing(from: from, to: to);
      results.addAll(ridehailing);
    }
    
    return results;
  }
} 