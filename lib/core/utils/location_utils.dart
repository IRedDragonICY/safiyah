import 'dart:math' as math;

class LocationUtils {
  /// Calculate distance between two points using Haversine formula
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371000; // Earth radius in meters

    final double dLat = _toRadians(lat2 - lat1);
    final double dLon = _toRadians(lon2 - lon1);

    final double a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  /// Calculate bearing between two points
  static double calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final double dLon = _toRadians(lon2 - lon1);
    final double lat1Rad = _toRadians(lat1);
    final double lat2Rad = _toRadians(lat2);

    final double y = math.sin(dLon) * math.cos(lat2Rad);
    final double x = math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(dLon);

    final double bearing = math.atan2(y, x);
    return (_toDegrees(bearing) + 360) % 360;
  }

  /// Calculate destination point given distance and bearing
  static Map<String, double> calculateDestination(
    double lat1,
    double lon1,
    double distance,
    double bearing,
  ) {
    const double earthRadius = 6371000; // Earth radius in meters

    final double lat1Rad = _toRadians(lat1);
    final double lon1Rad = _toRadians(lon1);
    final double bearingRad = _toRadians(bearing);

    final double lat2Rad = math.asin(
      math.sin(lat1Rad) * math.cos(distance / earthRadius) +
          math.cos(lat1Rad) * math.sin(distance / earthRadius) * math.cos(bearingRad),
    );

    final double lon2Rad = lon1Rad +
        math.atan2(
          math.sin(bearingRad) * math.sin(distance / earthRadius) * math.cos(lat1Rad),
          math.cos(distance / earthRadius) - math.sin(lat1Rad) * math.sin(lat2Rad),
        );

    return {
      'latitude': _toDegrees(lat2Rad),
      'longitude': _toDegrees(lon2Rad),
    };
  }

  /// Format distance for display
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else if (distanceInMeters < 10000) {
      return '${(distanceInMeters / 1000).toStringAsFixed(1)}km';
    } else {
      return '${(distanceInMeters / 1000).round()}km';
    }
  }

  /// Get cardinal direction from bearing
  static String getCardinalDirection(double bearing) {
    const directions = [
      'N', 'NNE', 'NE', 'ENE', 'E', 'ESE', 'SE', 'SSE',
      'S', 'SSW', 'SW', 'WSW', 'W', 'WNW', 'NW', 'NNW'
    ];

    final index = ((bearing / 22.5) + 0.5).floor() % 16;
    return directions[index];
  }

  /// Check if point is within radius of center
  static bool isWithinRadius(
    double centerLat,
    double centerLon,
    double pointLat,
    double pointLon,
    double radiusInMeters,
  ) {
    final distance = calculateDistance(centerLat, centerLon, pointLat, pointLon);
    return distance <= radiusInMeters;
  }

  /// Get bounding box for given center and radius
  static Map<String, double> getBoundingBox(
    double centerLat,
    double centerLon,
    double radiusInMeters,
  ) {
    const double earthRadius = 6371000; // Earth radius in meters

    final double latRange = radiusInMeters / earthRadius;
    final double lonRange = radiusInMeters /
        (earthRadius * math.cos(_toRadians(centerLat)));

    return {
      'minLat': centerLat - _toDegrees(latRange),
      'maxLat': centerLat + _toDegrees(latRange),
      'minLon': centerLon - _toDegrees(lonRange),
      'maxLon': centerLon + _toDegrees(lonRange),
    };
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) {
    return degrees * (math.pi / 180);
  }

  /// Convert radians to degrees
  static double _toDegrees(double radians) {
    return radians * (180 / math.pi);
  }

  /// Validate coordinates
  static bool isValidCoordinate(double latitude, double longitude) {
    return latitude >= -90 &&
           latitude <= 90 &&
           longitude >= -180 &&
           longitude <= 180;
  }

  /// Get approximate address from coordinates (dummy implementation)
  static String getApproximateAddress(double latitude, double longitude) {
    // In real app, use geocoding service
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
    }
    return 'Unknown Location';
  }

  /// Get country code from coordinates (dummy implementation)
  static String getCountryCode(double latitude, double longitude) {
    // In real app, use geocoding service
    if (latitude >= 1.0 && latitude <= 7.0 && longitude >= 99.0 && longitude <= 120.0) {
      return 'MY'; // Malaysia
    } else if (latitude >= 1.0 && latitude <= 2.0 && longitude >= 103.0 && longitude <= 104.0) {
      return 'SG'; // Singapore
    } else if (latitude >= -11.0 && latitude <= 6.0 && longitude >= 95.0 && longitude <= 141.0) {
      return 'ID'; // Indonesia
    } else if (latitude >= 16.0 && latitude <= 32.0 && longitude >= 34.0 && longitude <= 56.0) {
      return 'SA'; // Saudi Arabia
    } else if (latitude >= 22.0 && latitude <= 26.0 && longitude >= 51.0 && longitude <= 56.0) {
      return 'AE'; // UAE
    }
    return 'XX'; // Unknown
  }

  /// Get timezone from coordinates (simplified)
  static String getTimezone(double latitude, double longitude) {
    // Simplified timezone calculation based on longitude
    final timezoneOffset = (longitude / 15).round();
    if (timezoneOffset >= 0) {
      return 'UTC+$timezoneOffset';
    } else {
      return 'UTC$timezoneOffset';
    }
  }

  /// Calculate midpoint between two coordinates
  static Map<String, double> calculateMidpoint(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);
    final dLon = _toRadians(lon2 - lon1);

    final bx = math.cos(lat2Rad) * math.cos(dLon);
    final by = math.cos(lat2Rad) * math.sin(dLon);

    final lat3 = math.atan2(
      math.sin(lat1Rad) + math.sin(lat2Rad),
      math.sqrt((math.cos(lat1Rad) + bx) * (math.cos(lat1Rad) + bx) + by * by),
    );

    final lon3 = _toRadians(lon1) + math.atan2(by, math.cos(lat1Rad) + bx);

    return {
      'latitude': _toDegrees(lat3),
      'longitude': (_toDegrees(lon3) + 540) % 360 - 180,
    };
  }

  /// Generate random coordinates within radius
  static Map<String, double> generateRandomCoordinate(
    double centerLat,
    double centerLon,
    double radiusInMeters,
  ) {
    final random = math.Random();

    // Generate random distance and bearing
    final distance = math.sqrt(random.nextDouble()) * radiusInMeters;
    final bearing = random.nextDouble() * 360;

    return calculateDestination(centerLat, centerLon, distance, bearing);
  }

  /// Check if coordinates are in water (simplified)
  static bool isInWater(double latitude, double longitude) {
    // Simplified check - in real app use proper geocoding
    // Check if in major water bodies
    if (latitude >= -90 && latitude <= 90 && longitude >= -180 && longitude <= 180) {
      // Simple checks for major oceans
      if (latitude > 70 || latitude < -60) return true; // Polar regions
      if (longitude >= -180 && longitude <= -30 && latitude >= 20 && latitude <= 70) {
        return true; // Atlantic
      }
      // Add more sophisticated water detection logic
    }
    return false;
  }

  /// Get elevation estimate (dummy implementation)
  static double getElevationEstimate(double latitude, double longitude) {
    // In real app, use elevation API
    // Simple estimation based on known geographical features
    if (latitude >= 21.3 && latitude <= 21.5 && longitude >= 39.7 && longitude <= 40.0) {
      return 277; // Mecca elevation
    } else if (latitude >= 3.0 && latitude <= 3.3 && longitude >= 101.5 && longitude <= 101.8) {
      return 56; // KL elevation
    }
    return 0; // Sea level default
  }

  /// Calculate area of polygon (in square meters)
  static double calculatePolygonArea(List<Map<String, double>> coordinates) {
    if (coordinates.length < 3) return 0;

    double area = 0;
    const double earthRadius = 6371000; // Earth radius in meters

    for (int i = 0; i < coordinates.length; i++) {
      final j = (i + 1) % coordinates.length;
      final lat1 = _toRadians(coordinates[i]['latitude']!);
      final lat2 = _toRadians(coordinates[j]['latitude']!);
      final dLon = _toRadians(coordinates[j]['longitude']! - coordinates[i]['longitude']!);

      area += dLon * (2 + math.sin(lat1) + math.sin(lat2));
    }

    area = area.abs() * earthRadius * earthRadius / 2;
    return area;
  }

  /// Check if point is inside polygon
  static bool isPointInPolygon(
    double latitude,
    double longitude,
    List<Map<String, double>> polygon,
  ) {
    bool inside = false;

    for (int i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
      final xi = polygon[i]['longitude']!;
      final yi = polygon[i]['latitude']!;
      final xj = polygon[j]['longitude']!;
      final yj = polygon[j]['latitude']!;

      if (((yi > latitude) != (yj > latitude)) &&
          (longitude < (xj - xi) * (latitude - yi) / (yj - yi) + xi)) {
        inside = !inside;
      }
    }

    return inside;
  }

  /// Simplify coordinates array (Douglas-Peucker algorithm)
  static List<Map<String, double>> simplifyCoordinates(
    List<Map<String, double>> coordinates,
    double tolerance,
  ) {
    if (coordinates.length <= 2) return coordinates;

    // Simplified implementation
    final List<Map<String, double>> simplified = [coordinates.first];

    for (int i = 1; i < coordinates.length - 1; i++) {
      final distance = calculateDistance(
        simplified.last['latitude']!,
        simplified.last['longitude']!,
        coordinates[i]['latitude']!,
        coordinates[i]['longitude']!,
      );

      if (distance > tolerance) {
        simplified.add(coordinates[i]);
      }
    }

    simplified.add(coordinates.last);
    return simplified;
  }
}