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
        id: '3',
        title: 'Spiritual Journey in Japan',
        description: 'Exploring the rich culture and serene mosques of Tokyo.',
        destination: 'Tokyo, Japan',
        startDate: DateTime.now().add(const Duration(days: 10)),
        endDate: DateTime.now().add(const Duration(days: 17)),
        days: [
          ItineraryDay(
            date: DateTime.now().add(const Duration(days: 10)),
            title: 'Day 1 - Arrival & Shibuya',
            activities: [
              ItineraryActivity(
                id: 'j1',
                title: 'Arrival at Narita Airport',
                description: 'Arrive and take Limousine Bus to hotel',
                startTime: DateTime.now().add(const Duration(days: 10, hours: 14)),
                endTime: DateTime.now().add(const Duration(days: 10, hours: 16)),
                type: ActivityType.transportation,
                imageUrls: [],
                isCompleted: false,
              ),
              ItineraryActivity(
                id: 'j2',
                title: 'Dinner at Halal Ramen Ouka',
                description: 'Enjoy authentic halal ramen in Shinjuku.',
                startTime: DateTime.now().add(const Duration(days: 10, hours: 19)),
                endTime: DateTime.now().add(const Duration(days: 10, hours: 20)),
                location: 'Shinjuku Gyoen Ramen Ouka',
                latitude: 35.6882,
                longitude: 139.7107,
                type: ActivityType.dining,
                estimatedCost: 20,
                imageUrls: [],
                isCompleted: false,
              ),
            ],
          ),
          ItineraryDay(
            date: DateTime.now().add(const Duration(days: 11)),
            title: 'Day 2 - Mosques and Culture',
            activities: [
              ItineraryActivity(
                id: 'j3',
                title: 'Visit Tokyo Camii',
                description: 'Explore the largest mosque in Japan.',
                startTime: DateTime.now().add(const Duration(days: 11, hours: 10)),
                endTime: DateTime.now().add(const Duration(days: 11, hours: 12)),
                location: 'Tokyo Camii',
                latitude: 35.6685,
                longitude: 139.6800,
                type: ActivityType.sightseeing,
                estimatedCost: 0,
                imageUrls: [],
                isCompleted: false,
              ),
              ItineraryActivity(
                id: 'j4',
                title: 'Asakusa Temple & Shopping',
                description: 'Visit Senso-ji Temple and Nakamise-dori Street',
                startTime: DateTime.now().add(const Duration(days: 11, hours: 14)),
                endTime: DateTime.now().add(const Duration(days: 11, hours: 17)),
                location: 'Asakusa, Tokyo',
                latitude: 35.7148,
                longitude: 139.7967,
                type: ActivityType.shopping,
                estimatedCost: 50,
                imageUrls: [],
                isCompleted: false,
              ),
            ],
          ),
        ],
        userId: 'user123',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 3)),
        imageUrls: [
          'https://images.unsplash.com/photo-1542051841857-5f90071e7989?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        ],
        estimatedBudget: 2000,
        currency: 'USD',
        isPublic: true,
        tags: ['japan', 'tokyo', 'culture', 'halal'],
      ),
      ItineraryModel(
        id: '4',
        title: 'Kyoto & Osaka Tour',
        description: 'Discovering the historic temples and halal food scenes in Kansai.',
        destination: 'Kyoto, Japan',
        startDate: DateTime.now().add(const Duration(days: 25)),
        endDate: DateTime.now().add(const Duration(days: 30)),
        days: [],
        userId: 'user123',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        updatedAt: DateTime.now().subtract(const Duration(days: 1)),
        imageUrls: [
          'https://images.unsplash.com/photo-1524413840807-0c36798313a1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        ],
        estimatedBudget: 1800,
        currency: 'USD',
        isPublic: false,
        tags: ['kyoto', 'osaka', 'food', 'temple'],
      ),
    ];
  }
}