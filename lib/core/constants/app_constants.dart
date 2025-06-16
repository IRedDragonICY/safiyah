// core/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Safiyah';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Ultimate Muslim Traveler Super-App';

  static const String baseUrl = 'https://api.safiyah.com';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String itineraryBox = 'itinerary_box';
  static const String placesBox = 'places_box';

  static const String onboardingCompletedKey = 'onboarding_completed';

  static const double defaultLatitude = 21.3891; // Mecca
  static const double defaultLongitude = 39.8579; // Mecca

  static const double defaultFajrAngle = 18.0;
  static const double defaultIshaAngle = 17.0;

  static const double defaultZoom = 15.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 3.0;

  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const Duration animationDuration = Duration(milliseconds: 300);

  static const int nearbyPlacesRadius = 5000; // 5km
  static const int maxPlacesPerRequest = 20;

  static const int itemsPerPage = 10;
}