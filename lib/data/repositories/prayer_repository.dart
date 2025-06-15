import 'package:adhan/adhan.dart';
import '../models/prayer_time_model.dart';
import '../../core/utils/prayer_time_calculator.dart';
import '../../core/services/location_service.dart';

class PrayerRepository {
  final PrayerTimeCalculator _calculator = PrayerTimeCalculator();

  Future<PrayerTimeModel> getPrayerTimes({
    double? latitude,
    double? longitude,
    DateTime? date,
  }) async {
    try {
      // Get location if not provided
      if (latitude == null || longitude == null) {
        final position = await LocationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      final targetDate = date ?? DateTime.now();

      // Calculate prayer times using Adhan library
      final coordinates = Coordinates(latitude, longitude);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;

      final prayerTimes = PrayerTimes.today(coordinates, params);

      // Calculate Qibla direction
      final qiblaDirection = Qibla(coordinates).direction;

      return PrayerTimeModel(
        date: targetDate,
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        latitude: latitude,
        longitude: longitude,
        locationName: await _getLocationName(latitude, longitude),
        qiblaDirection: qiblaDirection,
      );
    } catch (e) {
      // Return dummy data for prototype
      return _getDummyPrayerTimes();
    }
  }

  Future<List<PrayerTimeModel>> getPrayerTimesForWeek({
    double? latitude,
    double? longitude,
    DateTime? startDate,
  }) async {
    final List<PrayerTimeModel> weeklyPrayerTimes = [];
    final start = startDate ?? DateTime.now();

    for (int i = 0; i < 7; i++) {
      final date = start.add(Duration(days: i));
      final prayerTime = await getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );
      weeklyPrayerTimes.add(prayerTime);
    }

    return weeklyPrayerTimes;
  }

  Future<List<PrayerTimeModel>> getPrayerTimesForMonth({
    double? latitude,
    double? longitude,
    DateTime? month,
  }) async {
    final List<PrayerTimeModel> monthlyPrayerTimes = [];
    final targetMonth = month ?? DateTime.now();
    final firstDay = DateTime(targetMonth.year, targetMonth.month, 1);
    final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0);

    for (int day = 1; day <= lastDay.day; day++) {
      final date = DateTime(targetMonth.year, targetMonth.month, day);
      final prayerTime = await getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );
      monthlyPrayerTimes.add(prayerTime);
    }

    return monthlyPrayerTimes;
  }

  Future<PrayerTimeModel> getPrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    CalculationMethod method = CalculationMethod.muslim_world_league,
    Madhab madhab = Madhab.shafi,
  }) async {
    try {
      final coordinates = Coordinates(latitude, longitude);
      final params = method.getParameters();
      params.madhab = madhab;

      final prayerTimes = PrayerTimes(coordinates, date as DateComponents, params);
      final qiblaDirection = Qibla(coordinates).direction;

      return PrayerTimeModel(
        date: date,
        fajr: prayerTimes.fajr,
        sunrise: prayerTimes.sunrise,
        dhuhr: prayerTimes.dhuhr,
        asr: prayerTimes.asr,
        maghrib: prayerTimes.maghrib,
        isha: prayerTimes.isha,
        latitude: latitude,
        longitude: longitude,
        locationName: await _getLocationName(latitude, longitude),
        qiblaDirection: qiblaDirection,
      );
    } catch (e) {
      return _getDummyPrayerTimes();
    }
  }

  Future<double> getQiblaDirection({
    double? latitude,
    double? longitude,
  }) async {
    try {
      if (latitude == null || longitude == null) {
        final position = await LocationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      final coordinates = Coordinates(latitude, longitude);
      return Qibla(coordinates).direction;
    } catch (e) {
      return 293.0; // Default direction to Mecca from KL
    }
  }

  Future<String> _getLocationName(double latitude, double longitude) async {
    try {
      // In real app, use geocoding service like Google Geocoding API
      // For now, return approximate location based on coordinates
      if (latitude >= 3.0 && latitude <= 3.3 && longitude >= 101.5 && longitude <= 101.8) {
        return 'Kuala Lumpur, Malaysia';
      } else if (latitude >= 1.2 && latitude <= 1.5 && longitude >= 103.6 && longitude <= 104.0) {
        return 'Singapore';
      } else if (latitude >= -6.3 && latitude <= -6.1 && longitude >= 106.7 && longitude <= 107.0) {
        return 'Jakarta, Indonesia';
      } else if (latitude >= 21.3 && latitude <= 21.5 && longitude >= 39.7 && longitude <= 40.0) {
        return 'Mecca, Saudi Arabia';
      } else if (latitude >= 24.4 && latitude <= 24.6 && longitude >= 39.5 && longitude <= 39.7) {
        return 'Medina, Saudi Arabia';
      } else if (latitude >= 25.0 && latitude <= 25.5 && longitude >= 55.0 && longitude <= 55.5) {
        return 'Dubai, UAE';
      } else if (latitude >= 30.0 && latitude <= 30.2 && longitude >= 31.0 && longitude <= 31.5) {
        return 'Cairo, Egypt';
      } else if (latitude >= 33.8 && latitude <= 34.0 && longitude >= 35.4 && longitude <= 35.6) {
        return 'Damascus, Syria';
      } else if (latitude >= 39.9 && latitude <= 40.0 && longitude >= 32.8 && longitude <= 33.0) {
        return 'Ankara, Turkey';
      } else if (latitude >= 35.6 && latitude <= 35.8 && longitude >= 51.3 && longitude <= 51.5) {
        return 'Tehran, Iran';
      }
      return 'Current Location';
    } catch (e) {
      return 'Unknown Location';
    }
  }

  PrayerTimeModel _getDummyPrayerTimes() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return PrayerTimeModel(
      date: today,
      fajr: today.add(const Duration(hours: 5, minutes: 30)),
      sunrise: today.add(const Duration(hours: 6, minutes: 45)),
      dhuhr: today.add(const Duration(hours: 12, minutes: 30)),
      asr: today.add(const Duration(hours: 15, minutes: 45)),
      maghrib: today.add(const Duration(hours: 18, minutes: 30)),
      isha: today.add(const Duration(hours: 20, minutes: 0)),
      latitude: 21.3891, // Mecca
      longitude: 39.8579, // Mecca
      locationName: 'Kuala Lumpur, Malaysia',
      qiblaDirection: 293.0, // Direction to Mecca from KL
    );
  }

  List<CalculationMethod> getSupportedCalculationMethods() {
    return [
      CalculationMethod.muslim_world_league,
      CalculationMethod.egyptian,
      CalculationMethod.karachi,
      CalculationMethod.umm_al_qura,
      CalculationMethod.dubai,
      CalculationMethod.moon_sighting_committee,
      CalculationMethod.north_america,
      CalculationMethod.kuwait,
      CalculationMethod.qatar,
      CalculationMethod.singapore,
      CalculationMethod.turkey,
      CalculationMethod.tehran,
    ];
  }

  String getCalculationMethodName(CalculationMethod method) {
    switch (method) {
      case CalculationMethod.muslim_world_league:
        return 'Muslim World League';
      case CalculationMethod.egyptian:
        return 'Egyptian General Authority of Survey';
      case CalculationMethod.karachi:
        return 'University of Islamic Sciences, Karachi';
      case CalculationMethod.umm_al_qura:
        return 'Umm al-Qura University, Makkah';
      case CalculationMethod.dubai:
        return 'The Gulf Region';
      case CalculationMethod.moon_sighting_committee:
        return 'Moon Sighting Committee';
      case CalculationMethod.north_america:
        return 'Islamic Society of North America (ISNA)';
      case CalculationMethod.kuwait:
        return 'Kuwait';
      case CalculationMethod.qatar:
        return 'Qatar';
      case CalculationMethod.singapore:
        return 'Singapore';
      case CalculationMethod.turkey:
        return 'Diyanet İşleri Başkanlığı, Turkey';
      case CalculationMethod.tehran:
        return 'Institute of Geophysics, University of Tehran';
      case CalculationMethod.other:
        return 'Other';
    }
  }

  Future<bool> isValidLocation(double latitude, double longitude) async {
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }

  Future<Map<String, dynamic>> getPrayerInfo({
    double? latitude,
    double? longitude,
    DateTime? date,
  }) async {
    try {
      final prayerTimes = await getPrayerTimes(
        latitude: latitude,
        longitude: longitude,
        date: date,
      );

      final now = DateTime.now();
      final nextPrayer = prayerTimes.getNextPrayer();
      final currentPrayer = prayerTimes.getCurrentPrayer();

      return {
        'prayerTimes': prayerTimes,
        'nextPrayer': nextPrayer,
        'currentPrayer': currentPrayer,
        'timeToNextPrayer': nextPrayer?.time.difference(now),
        'qiblaDirection': prayerTimes.qiblaDirection,
        'locationName': prayerTimes.locationName,
        'coordinates': {
          'latitude': prayerTimes.latitude,
          'longitude': prayerTimes.longitude,
        },
      };
    } catch (e) {
      throw Exception('Failed to get prayer information: $e');
    }
  }
}