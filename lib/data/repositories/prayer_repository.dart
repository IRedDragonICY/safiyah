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
      if (latitude == null || longitude == null) {
        final position = await LocationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      final targetDate = date ?? DateTime.now();

      final coordinates = Coordinates(latitude, longitude);
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;

      final prayerTimes = PrayerTimes.today(coordinates, params);

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
      return 293.0;
    }
  }

  Future<String> _getLocationName(double latitude, double longitude) async {
    try {
      if (latitude >= 35.5 && latitude <= 35.8 && longitude >= 139.5 && longitude <= 139.9) {
        return 'Tokyo, Japan';
      } else if (latitude >= 34.9 && latitude <= 35.1 && longitude >= 135.7 && longitude <= 135.9) {
        return 'Kyoto, Japan';
      } else if (latitude >= 34.6 && latitude <= 34.8 && longitude >= 135.4 && longitude <= 135.6) {
        return 'Osaka, Japan';
      } else if (latitude >= 21.3 && latitude <= 21.5 && longitude >= 39.7 && longitude <= 40.0) {
        return 'Mecca, Saudi Arabia';
      } else if (latitude >= 3.0 && latitude <= 3.3 && longitude >= 101.5 && longitude <= 101.8) {
        return 'Kuala Lumpur, Malaysia';
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
      fajr: today.add(const Duration(hours: 4, minutes: 30)),
      sunrise: today.add(const Duration(hours: 5, minutes: 55)),
      dhuhr: today.add(const Duration(hours: 12, minutes: 15)),
      asr: today.add(const Duration(hours: 15, minutes: 45)),
      maghrib: today.add(const Duration(hours: 18, minutes: 25)),
      isha: today.add(const Duration(hours: 19, minutes: 45)),
      latitude: 35.6895,
      longitude: 139.6917,
      locationName: 'Tokyo, Japan',
      qiblaDirection: 295.0,
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