class AppConstants {
  // App Info
  static const String appName = 'Safiyah';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Ultimate Muslim Traveler Super-App';
  
  // API
  static const String baseUrl = 'https://api.safiyah.com';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  
  // Storage Keys
  static const String userBox = 'user_box';
  static const String settingsBox = 'settings_box';
  static const String itineraryBox = 'itinerary_box';
  static const String placesBox = 'places_box';
  
  // Location
  static const double defaultLatitude = 21.3891; // Mecca
  static const double defaultLongitude = 39.8579; // Mecca
  
  // Prayer Times
  static const double defaultFajrAngle = 18.0;
  static const double defaultIshaAngle = 17.0;
  
  // Map
  static const double defaultZoom = 15.0;
  static const double maxZoom = 18.0;
  static const double minZoom = 3.0;
  
  // UI
  static const double borderRadius = 12.0;
  static const double cardElevation = 2.0;
  static const Duration animationDuration = Duration(milliseconds: 300);
  
  // Places
  static const int nearbyPlacesRadius = 5000; // 5km
  static const int maxPlacesPerRequest = 20;
  
  // Pagination
  static const int itemsPerPage = 10;
}