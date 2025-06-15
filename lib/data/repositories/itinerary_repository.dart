import '../models/itinerary_model.dart';
import '../datasources/local/local_storage.dart';
import '../../core/services/storage_service.dart';

class ItineraryRepository {
  final LocalStorage _localStorage = LocalStorage();

  Future<List<ItineraryModel>> getAllItineraries() async {
    try {
      final itinerariesData = await _localStorage.getItineraries();
      return itinerariesData.map((data) => ItineraryModel.fromJson(data)).toList();
    } catch (e) {
      // Return dummy data for prototype
      return _getDummyItineraries();
    }
  }

  Future<ItineraryModel?> getItineraryById(String id) async {
    try {
      final itineraryData = await _localStorage.getItineraryById(id);
      if (itineraryData != null) {
        return ItineraryModel.fromJson(itineraryData);
      }
      return null;
    } catch (e) {
      // Return dummy data for prototype
      final dummyItineraries = _getDummyItineraries();
      return dummyItineraries.firstWhere(
        (itinerary) => itinerary.id == id,
        orElse: () => dummyItineraries.first,
      );
    }
  }

  Future<void> createItinerary(ItineraryModel itinerary) async {
    try {
      await _localStorage.saveItinerary(itinerary.toJson());
    } catch (e) {
      throw Exception('Failed to create itinerary: $e');
    }
  }

  Future<void> updateItinerary(ItineraryModel itinerary) async {
    try {
      await _localStorage.updateItinerary(itinerary.toJson());
    } catch (e) {
      throw Exception('Failed to update itinerary: $e');
    }
  }

  Future<void> deleteItinerary(String id) async {
    try {
      await _localStorage.deleteItinerary(id);
    } catch (e) {
      throw Exception('Failed to delete itinerary: $e');
    }
  }

  List<ItineraryModel> _getDummyItineraries() {
    return [
      ItineraryModel(
        id: '1',
        title: 'Istanbul Heritage Tour',
        description: 'Exploring the Islamic heritage of Istanbul',
        destination: 'Istanbul, Turkey',
        startDate: DateTime.now().add(const Duration(days: 7)),
        endDate: DateTime.now().add(const Duration(days: 14)),
        days: [
          ItineraryDay(
            date: DateTime.now().add(const Duration(days: 7)),
            title: 'Day 1 - Arrival & Blue Mosque',
            activities: [
              ItineraryActivity(
                id: 'a1',
                title: 'Airport Pickup',
                description: 'Arrive at Istanbul Airport',
                startTime: DateTime.now().add(const Duration(days: 7, hours: 10)),
                endTime: DateTime.now().add(const Duration(days: 7, hours: 11)),
                type: ActivityType.transportation,
                imageUrls: [],
                isCompleted: false,
              ),
              ItineraryActivity(
                id: 'a2',
                title: 'Blue Mosque Visit',
                description: 'Visit the famous Blue Mosque',
                startTime: DateTime.now().add(const Duration(days: 7, hours: 14)),
                endTime: DateTime.now().add(const Duration(days: 7, hours: 16)),
                location: 'Blue Mosque, Istanbul',
                latitude: 41.0055,
                longitude: 28.9769,
                type: ActivityType.sightseeing,
                estimatedCost: 0,
                imageUrls: [],
                isCompleted: false,
              ),
            ],
          ),
          ItineraryDay(
            date: DateTime.now().add(const Duration(days: 8)),
            title: 'Day 2 - Hagia Sophia & Grand Bazaar',
            activities: [
              ItineraryActivity(
                id: 'a3',
                title: 'Hagia Sophia',
                description: 'Explore the historic Hagia Sophia',
                startTime: DateTime.now().add(const Duration(days: 8, hours: 9)),
                endTime: DateTime.now().add(const Duration(days: 8, hours: 11)),
                location: 'Hagia Sophia, Istanbul',
                latitude: 41.0086,
                longitude: 28.9802,
                type: ActivityType.sightseeing,
                estimatedCost: 25,
                imageUrls: [],
                isCompleted: false,
              ),
              ItineraryActivity(
                id: 'a4',
                title: 'Grand Bazaar Shopping',
                description: 'Shopping at the historic Grand Bazaar',
                startTime: DateTime.now().add(const Duration(days: 8, hours: 14)),
                endTime: DateTime.now().add(const Duration(days: 8, hours: 17)),
                location: 'Grand Bazaar, Istanbul',
                latitude: 41.0106,
                longitude: 28.9681,
                type: ActivityType.shopping,
                estimatedCost: 100,
                imageUrls: [],
                isCompleted: false,
              ),
            ],
          ),
        ],
        userId: 'user123',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now().subtract(const Duration(days: 5)),
        imageUrls: [
          'https://example.com/istanbul1.jpg',
          'https://example.com/istanbul2.jpg',
        ],
        estimatedBudget: 1500,
        currency: 'USD',
        isPublic: true,
        tags: ['heritage', 'mosque', 'culture', 'shopping'],
      ),
      ItineraryModel(
        id: '2',
        title: 'Kuala Lumpur Food & Prayer',
        description: 'Halal food tour and mosque visits in KL',
        destination: 'Kuala Lumpur, Malaysia',
        startDate: DateTime.now().add(const Duration(days: 21)),
        endDate: DateTime.now().add(const Duration(days: 25)),
        days: [
          ItineraryDay(
            date: DateTime.now().add(const Duration(days: 21)),
            title: 'Day 1 - Arrival & KLCC',
            activities: [
              ItineraryActivity(
                id: 'a5',
                title: 'KLCC Mosque Visit',
                description: 'Visit the beautiful mosque at KLCC',
                startTime: DateTime.now().add(const Duration(days: 21, hours: 15)),
                endTime: DateTime.now().add(const Duration(days: 21, hours: 16)),
                location: 'KLCC Mosque',
                latitude: 3.1581,
                longitude: 101.7117,
                type: ActivityType.prayer,
                estimatedCost: 0,
                imageUrls: [],
                isCompleted: false,
              ),
            ],
          ),
        ],
        userId: 'user123',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 2)),
        imageUrls: [
          'https://example.com/kl1.jpg',
        ],
        estimatedBudget: 800,
        currency: 'USD',
        isPublic: false,
        tags: ['food', 'halal', 'mosque', 'malaysia'],
      ),
    ];
  }
}