import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';

class StorageService {
  static late Box _userBox;
  static late Box _settingsBox;
  static late Box _itineraryBox;
  static late Box _placesBox;

  static Future<void> initialize() async {
    await Hive.initFlutter();
    
    _userBox = await Hive.openBox(AppConstants.userBox);
    _settingsBox = await Hive.openBox(AppConstants.settingsBox);
    _itineraryBox = await Hive.openBox(AppConstants.itineraryBox);
    _placesBox = await Hive.openBox(AppConstants.placesBox);
  }

  // User data methods
  static Future<void> saveUser(String key, dynamic value) async {
    await _userBox.put(key, value);
  }

  static T? getUser<T>(String key) {
    return _userBox.get(key);
  }

  static Future<void> removeUser(String key) async {
    await _userBox.delete(key);
  }

  // Settings methods
  static Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }

  static T? getSetting<T>(String key) {
    return _settingsBox.get(key);
  }

  // Itinerary methods
  static Future<void> saveItinerary(String key, dynamic value) async {
    await _itineraryBox.put(key, value);
  }

  static T? getItinerary<T>(String key) {
    return _itineraryBox.get(key);
  }

  static List<dynamic> getAllItineraries() {
    return _itineraryBox.values.toList();
  }

  static Future<void> removeItinerary(String key) async {
    await _itineraryBox.delete(key);
  }

  // Places methods
  static Future<void> savePlace(String key, dynamic value) async {
    await _placesBox.put(key, value);
  }

  static T? getPlace<T>(String key) {
    return _placesBox.get(key);
  }

  static List<dynamic> getAllPlaces() {
    return _placesBox.values.toList();
  }

  // Clear all data
  static Future<void> clearAll() async {
    await _userBox.clear();
    await _settingsBox.clear();
    await _itineraryBox.clear();
    await _placesBox.clear();
  }
}