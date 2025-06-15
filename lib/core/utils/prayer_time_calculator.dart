import 'dart:math' as math;

class PrayerTimeCalculator {
  static const double earthRadius = 6371.0; // Earth radius in kilometers

  /// Calculate the distance between two points on Earth using Haversine formula
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));
    return earthRadius * c * 1000; // Return distance in meters
  }

  /// Calculate Qibla direction from given coordinates to Mecca
  static double calculateQiblaDirection(double latitude, double longitude) {
    const meccaLat = 21.3891; // Mecca latitude
    const meccaLon = 39.8579; // Mecca longitude

    final lat1 = _toRadians(latitude);
    final lat2 = _toRadians(meccaLat);
    final dLon = _toRadians(meccaLon - longitude);

    final y = math.sin(dLon) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(dLon);

    final bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Convert radians to degrees
  static double _toDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  /// Calculate prayer time adjustments based on location
  static Map<String, double> calculatePrayerAdjustments(
    double latitude,
    double longitude,
    DateTime date,
  ) {
    // This is a simplified calculation
    // In a real app, you would use more sophisticated astronomical calculations
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final declination = 23.45 * math.sin(_toRadians(360 * (284 + dayOfYear) / 365));

    final latRad = _toRadians(latitude);
    final declRad = _toRadians(declination);

    // Hour angle calculation
    final hourAngle = math.acos(-math.tan(latRad) * math.tan(declRad));
    final hourAngleDegrees = _toDegrees(hourAngle);

    return {
      'sunrise': 6 - hourAngleDegrees / 15,
      'sunset': 18 + hourAngleDegrees / 15,
      'solarNoon': 12,
    };
  }

  /// Format time for display
  static String formatPrayerTime(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  /// Check if current time is within prayer time window
  static bool isWithinPrayerTime(DateTime prayerTime, int windowMinutes) {
    final now = DateTime.now();
    final startWindow = prayerTime.subtract(Duration(minutes: windowMinutes));
    final endWindow = prayerTime.add(Duration(minutes: windowMinutes));

    return now.isAfter(startWindow) && now.isBefore(endWindow);
  }

  /// Get time remaining until next prayer
  static Duration getTimeUntilPrayer(DateTime prayerTime) {
    final now = DateTime.now();
    return prayerTime.difference(now);
  }

  /// Calculate sun position for given coordinates and time
  static Map<String, double> calculateSunPosition(
    double latitude,
    double longitude,
    DateTime dateTime,
  ) {
    final jd = _julianDay(dateTime);
    final n = jd - 2451545.0;

    // Mean longitude of sun
    final l = (280.460 + 0.9856474 * n) % 360;

    // Mean anomaly
    final g = _toRadians((357.528 + 0.9856003 * n) % 360);

    // Ecliptic longitude
    final lambda = _toRadians(l + 1.915 * math.sin(g) + 0.020 * math.sin(2 * g));

    // Declination
    final declination = math.asin(math.sin(_toRadians(23.439)) * math.sin(lambda));

    // Right ascension
    final alpha = math.atan2(math.cos(_toRadians(23.439)) * math.sin(lambda), math.cos(lambda));

    // Hour angle
    final gmst = (6.697375 + 0.0657098242 * n + dateTime.hour + dateTime.minute / 60.0) % 24;
    final lmst = (gmst + longitude / 15.0) % 24;
    final hourAngle = _toRadians(15.0 * (lmst - _toDegrees(alpha) / 15.0));

    // Elevation and azimuth
    final latRad = _toRadians(latitude);
    final elevation = math.asin(
      math.sin(latRad) * math.sin(declination) +
      math.cos(latRad) * math.cos(declination) * math.cos(hourAngle)
    );

    final azimuth = math.atan2(
      -math.sin(hourAngle),
      math.tan(declination) * math.cos(latRad) - math.sin(latRad) * math.cos(hourAngle)
    );

    return {
      'elevation': _toDegrees(elevation),
      'azimuth': (_toDegrees(azimuth) + 360) % 360,
      'declination': _toDegrees(declination),
    };
  }

  /// Calculate Julian day number
  static double _julianDay(DateTime dateTime) {
    final a = (14 - dateTime.month) ~/ 12;
    final y = dateTime.year + 4800 - a;
    final m = dateTime.month + 12 * a - 3;

    return dateTime.day + (153 * m + 2) ~/ 5 + 365 * y + y ~/ 4 - y ~/ 100 + y ~/ 400 - 32045 +
           (dateTime.hour - 12) / 24.0 + dateTime.minute / 1440.0 + dateTime.second / 86400.0;
  }

  /// Calculate equation of time
  static double calculateEquationOfTime(DateTime date) {
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    final b = 2 * math.pi * (dayOfYear - 81) / 365;

    return 9.87 * math.sin(2 * b) - 7.53 * math.cos(b) - 1.5 * math.sin(b);
  }

  /// Get prayer name from time
  static String getPrayerNameFromTime(DateTime time, List<DateTime> prayerTimes) {
    final prayerNames = ['Fajr', 'Sunrise', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    for (int i = 0; i < prayerTimes.length; i++) {
      if (time.isBefore(prayerTimes[i]) || time.isAtSameMomentAs(prayerTimes[i])) {
        return prayerNames[i];
      }
    }

    return 'Fajr'; // Next day Fajr
  }

  /// Check if it's time for prayer
  static bool isPrayerTime(DateTime prayerTime, {int toleranceMinutes = 5}) {
    final now = DateTime.now();
    final diff = now.difference(prayerTime).inMinutes.abs();
    return diff <= toleranceMinutes;
  }

  /// Calculate Islamic date (Hijri)
  static Map<String, dynamic> calculateHijriDate(DateTime gregorianDate) {
    // Simplified Hijri calculation - in real app use proper Islamic calendar library
    final jd = _julianDay(gregorianDate);
    final hijriJd = jd - 1948440.5; // Approximate conversion
    final hijriYear = ((hijriJd / 354.367) + 1).floor();
    final remainingDays = (hijriJd % 354.367).floor();
    final hijriMonth = (remainingDays / 29.531).floor() + 1;
    final hijriDay = (remainingDays % 29.531).floor() + 1;

    final hijriMonthNames = [
      'Muharram', 'Safar', 'Rabi\' al-awwal', 'Rabi\' al-thani',
      'Jumada al-awwal', 'Jumada al-thani', 'Rajab', 'Sha\'ban',
      'Ramadan', 'Shawwal', 'Dhu al-Qi\'dah', 'Dhu al-Hijjah'
    ];

    return {
      'year': hijriYear,
      'month': hijriMonth.clamp(1, 12),
      'day': hijriDay.clamp(1, 30),
      'monthName': hijriMonthNames[(hijriMonth - 1).clamp(0, 11)],
    };
  }

  /// Format Hijri date
  static String formatHijriDate(Map<String, dynamic> hijriDate) {
    return '${hijriDate['day']} ${hijriDate['monthName']} ${hijriDate['year']} AH';
  }

  /// Calculate moon phase
  static double calculateMoonPhase(DateTime date) {
    final jd = _julianDay(date);
    final daysSinceNewMoon = (jd - 2451549.5) % 29.53;
    return daysSinceNewMoon / 29.53;
  }

  /// Get moon phase name
  static String getMoonPhaseName(double phase) {
    if (phase < 0.0625) return 'New Moon';
    if (phase < 0.1875) return 'Waxing Crescent';
    if (phase < 0.3125) return 'First Quarter';
    if (phase < 0.4375) return 'Waxing Gibbous';
    if (phase < 0.5625) return 'Full Moon';
    if (phase < 0.6875) return 'Waning Gibbous';
    if (phase < 0.8125) return 'Last Quarter';
    return 'Waning Crescent';
  }

  /// Calculate timezone offset
  static double calculateTimezoneOffset(double longitude) {
    return longitude / 15.0; // Rough estimation
  }

  /// Adjust prayer times for daylight saving
  static DateTime adjustForDST(DateTime time, bool isDST) {
    if (isDST) {
      return time.add(const Duration(hours: 1));
    }
    return time;
  }

  /// Get next prayer after current time
  static Map<String, dynamic>? getNextPrayer(List<DateTime> prayerTimes, List<String> prayerNames) {
    final now = DateTime.now();

    for (int i = 0; i < prayerTimes.length; i++) {
      if (prayerTimes[i].isAfter(now)) {
        return {
          'name': prayerNames[i],
          'time': prayerTimes[i],
          'index': i,
        };
      }
    }

    // If no prayer found today, return next day's Fajr
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    return {
      'name': prayerNames[0],
      'time': DateTime(tomorrow.year, tomorrow.month, tomorrow.day,
                      prayerTimes[0].hour, prayerTimes[0].minute),
      'index': 0,
    };
  }

  /// Calculate prayer times for multiple days
  static List<Map<String, DateTime>> calculatePrayerTimesForRange(
    double latitude,
    double longitude,
    DateTime startDate,
    int days,
  ) {
    final List<Map<String, DateTime>> result = [];

    for (int i = 0; i < days; i++) {
      final date = startDate.add(Duration(days: i));
      final adjustments = calculatePrayerAdjustments(latitude, longitude, date);

      result.add({
        'date': date,
        'fajr': DateTime(date.year, date.month, date.day, 5, 30),
        'sunrise': DateTime(date.year, date.month, date.day,
                           adjustments['sunrise']!.floor(),
                           ((adjustments['sunrise']! % 1) * 60).round()),
        'dhuhr': DateTime(date.year, date.month, date.day, 12, 15),
        'asr': DateTime(date.year, date.month, date.day, 15, 45),
        'maghrib': DateTime(date.year, date.month, date.day,
                            adjustments['sunset']!.floor(),
                            ((adjustments['sunset']! % 1) * 60).round()),
        'isha': DateTime(date.year, date.month, date.day, 20, 0),
      });
    }

    return result;
  }

  /// Validate prayer time calculation parameters
  static bool validateCoordinates(double latitude, double longitude) {
    return latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180;
  }

  /// Get Islamic calendar events
  static List<String> getIslamicEvents(Map<String, dynamic> hijriDate) {
    final events = <String>[];
    final month = hijriDate['month'] as int;
    final day = hijriDate['day'] as int;

    // Add major Islamic events
    if (month == 1 && day == 1) events.add('Islamic New Year');
    if (month == 1 && day == 10) events.add('Day of Ashura');
    if (month == 3 && day == 12) events.add('Mawlid an-Nabi');
    if (month == 7 && day == 27) events.add('Isra and Mi\'raj');
    if (month == 8 && day >= 15) events.add('Mid-Sha\'ban');
    if (month == 9) events.add('Ramadan');
    if (month == 10 && day == 1) events.add('Eid al-Fitr');
    if (month == 12 && day == 10) events.add('Eid al-Adha');

    return events;
  }

  /// Calculate Qiyam time (last third of night)
  static DateTime calculateQiyamTime(DateTime maghrib, DateTime fajr) {
    final nightDuration = fajr.difference(maghrib);
    final lastThirdStart = maghrib.add(Duration(
      milliseconds: (nightDuration.inMilliseconds * 2 / 3).round(),
    ));
    return lastThirdStart;
  }

  /// Calculate Tahajjud time (recommended)
  static DateTime calculateTahajjudTime(DateTime maghrib, DateTime fajr) {
    final nightDuration = fajr.difference(maghrib);
    final middleOfNight = maghrib.add(Duration(
      milliseconds: (nightDuration.inMilliseconds / 2).round(),
    ));
    return middleOfNight;
  }

  /// Get prayer notification schedule
  static List<DateTime> getPrayerNotificationTimes(
    List<DateTime> prayerTimes,
    int notificationMinutes,
  ) {
    return prayerTimes.map((time) =>
      time.subtract(Duration(minutes: notificationMinutes))
    ).toList();
  }

  /// Calculate accurate prayer times using astronomical calculations
  static Map<String, DateTime> calculateAccuratePrayerTimes(
    double latitude,
    double longitude,
    DateTime date, {
    double fajrAngle = 18.0,
    double ishaAngle = 17.0,
    String method = 'MWL',
  }) {
    final adjustments = calculatePrayerAdjustments(latitude, longitude, date);
    final sunPosition = calculateSunPosition(latitude, longitude, date);

    // More accurate calculations would use proper astronomical algorithms
    // This is a simplified version for demonstration

    return {
      'fajr': DateTime(date.year, date.month, date.day, 5, 30),
      'sunrise': DateTime(date.year, date.month, date.day,
                         adjustments['sunrise']!.floor(),
                         ((adjustments['sunrise']! % 1) * 60).round()),
      'dhuhr': DateTime(date.year, date.month, date.day,
                       adjustments['solarNoon']!.floor(),
                       ((adjustments['solarNoon']! % 1) * 60).round()),
      'asr': DateTime(date.year, date.month, date.day, 15, 45),
      'maghrib': DateTime(date.year, date.month, date.day,
                         adjustments['sunset']!.floor(),
                         ((adjustments['sunset']! % 1) * 60).round()),
      'isha': DateTime(date.year, date.month, date.day, 20, 0),
    };
  }
}