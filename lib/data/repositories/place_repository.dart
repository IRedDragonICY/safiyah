import '../models/place_model.dart';
import '../../core/services/location_service.dart';

class PlaceRepository {
  Future<List<PlaceModel>> getNearbyPlaces({
    double? latitude,
    double? longitude,
    PlaceType? type,
    int radius = 5000,
  }) async {
    try {
      if (latitude == null || longitude == null) {
        final position = await LocationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      return _getDummyPlaces(latitude, longitude, type);
    } catch (e) {
      return _getDummyPlaces(35.6895, 139.6917, type);
    }
  }

  Future<List<PlaceModel>> searchPlaces(String query) async {
    try {
      final allPlaces = _getDummyPlaces(35.6895, 139.6917, null);
      return allPlaces.where((place) {
        return place.name.toLowerCase().contains(query.toLowerCase()) ||
               place.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<PlaceModel?> getPlaceById(String id) async {
    try {
      final allPlaces = _getDummyPlaces(35.6895, 139.6917, null);
      return allPlaces.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }

  List<PlaceModel> _getDummyPlaces(double userLat, double userLng, PlaceType? filterType) {
    final allPlaces = [
      PlaceModel(
        id: 'mosque_jp_1',
        name: 'Tokyo Camii & Diyanet Turkish Culture Center',
        description: 'The largest mosque in Japan, known for its beautiful Ottoman architecture.',
        type: PlaceType.mosque,
        latitude: 35.6685,
        longitude: 139.6800,
        address: '1-19 Oyama-cho, Shibuya-ku, Tokyo',
        phoneNumber: '+81-3-5790-0760',
        website: 'https://tokyocamii.org/',
        rating: 4.9,
        reviewCount: 3500,
        imageUrls: [
          'https://images.unsplash.com/photo-1594225293932-a513554b2955?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1974&q=80',
        ],
        openingHours: OpeningHours(hours: {
          'monday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
          'tuesday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
          'wednesday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
          'thursday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
          'friday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
          'saturday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
          'sunday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 10, minute: 0),
            close: TimeOfDay(hour: 18, minute: 0),
          ),
        }),
        amenities: ['Prayer Hall', 'Ablution Area', 'Cultural Center', 'Library'],
        isHalalCertified: true,
        halalCertification: 'Mosque',
        distanceFromUser: _calculateDistance(userLat, userLng, 35.6685, 139.6800),
      ),
      PlaceModel(
        id: 'restaurant_jp_1',
        name: 'Halal Ramen Ouka',
        description: 'Famous for its rich and flavorful vegan and chicken halal ramen.',
        type: PlaceType.restaurant,
        latitude: 35.6882,
        longitude: 139.7107,
        address: '1-11-7 Shinjuku, Shinjuku-ku, Tokyo',
        phoneNumber: '+81-3-5925-8426',
        website: 'https://www.facebook.com/shinjukugyoenramenouka/',
        rating: 4.8,
        reviewCount: 2100,
        imageUrls: [
          'https://images.unsplash.com/photo-1552611052-33e04de081de?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1964&q=80',
        ],
        openingHours: OpeningHours(hours: {
          'monday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 12, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'tuesday': DayHours(isClosed: true, open: TimeOfDay(hour: 0, minute: 0), close: TimeOfDay(hour: 0, minute: 0)),
          'wednesday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 12, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'thursday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 12, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'friday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 12, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'saturday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 12, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'sunday': DayHours(
            isClosed: false,
            open: TimeOfDay(hour: 12, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
        }),
        amenities: ['Halal Certified', 'Family Friendly', 'Vegan Options'],
        isHalalCertified: true,
        halalCertification: 'Self-Certified',
        distanceFromUser: _calculateDistance(userLat, userLng, 35.6882, 139.7107),
      ),
      PlaceModel(
        id: 'hotel_jp_1',
        name: 'Shinjuku Prince Hotel',
        description: 'Modern hotel with easy access to transport and some halal breakfast options upon request.',
        type: PlaceType.hotel,
        latitude: 35.6946,
        longitude: 139.7001,
        address: '1-30-1 Kabukicho, Shinjuku-ku, Tokyo',
        phoneNumber: '+81-3-3205-1111',
        website: 'https://www.princehotels.com/shinjuku/',
        rating: 4.5,
        reviewCount: 4200,
        imageUrls: [
          'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
        ],
        amenities: ['Concierge', 'WiFi', 'Nearby Halal Food'],
        isHalalCertified: false,
        distanceFromUser: _calculateDistance(userLat, userLng, 35.6946, 139.7001),
      ),
    ];

    if (filterType != null) {
      return allPlaces.where((place) => place.type == filterType).toList();
    }

    return allPlaces;
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371000;
    double dLat = (lat2 - lat1) * (3.14159 / 180);
    double dLng = (lng2 - lng1) * (3.14159 / 180);
    
    double a = (dLat / 2) * (dLat / 2) +
        (lat1 * 3.14159 / 180) * (lat2 * 3.14159 / 180) * (dLng / 2) * (dLng / 2);
    double c = 2 * (a < 1 ? (a < 0 ? 0 : a) : 1);
    
    return earthRadius * c;
  }
}