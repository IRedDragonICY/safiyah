import '../../../core/services/storage_service.dart';

class LocalStorage {
  // User methods
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final userData = StorageService.getUser<Map<String, dynamic>>('current_user');
    return userData;
  }

  Future<void> saveCurrentUser(Map<String, dynamic> userData) async {
    await StorageService.saveUser('current_user', userData);
  }

  Future<void> clearCurrentUser() async {
    await StorageService.removeUser('current_user');
  }

  // Itinerary methods
  Future<List<Map<String, dynamic>>> getItineraries() async {
    final itineraries = StorageService.getAllItineraries();
    return itineraries.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getItineraryById(String id) async {
    final itinerary = StorageService.getItinerary<Map<String, dynamic>>(id);
    return itinerary;
  }

  Future<void> saveItinerary(Map<String, dynamic> itineraryData) async {
    final id = itineraryData['id'] as String;
    await StorageService.saveItinerary(id, itineraryData);
  }

  Future<void> updateItinerary(Map<String, dynamic> itineraryData) async {
    final id = itineraryData['id'] as String;
    await StorageService.saveItinerary(id, itineraryData);
  }

  Future<void> deleteItinerary(String id) async {
    await StorageService.removeItinerary(id);
  }

  // Events methods
  Future<List<Map<String, dynamic>>> getEvents() async {
    final events = StorageService.getAllEvents();
    return events.cast<Map<String, dynamic>>();
  }

  Future<Map<String, dynamic>?> getEventById(String id) async {
    final event = StorageService.getEvent<Map<String, dynamic>>(id);
    return event;
  }

  Future<void> saveEvent(Map<String, dynamic> eventData) async {
    final id = eventData['id'] as String;
    await StorageService.saveEvent(id, eventData);
  }

  Future<void> updateEvent(Map<String, dynamic> eventData) async {
    final id = eventData['id'] as String;
    await StorageService.saveEvent(id, eventData);
  }

  Future<void> deleteEvent(String id) async {
    await StorageService.removeEvent(id);
  }

  // Settings methods
  Future<void> savePrayerSettings(Map<String, dynamic> settings) async {
    await StorageService.saveSetting('prayer_settings', settings);
  }

  Future<Map<String, dynamic>?> getPrayerSettings() async {
    return StorageService.getSetting<Map<String, dynamic>>('prayer_settings');
  }
}
