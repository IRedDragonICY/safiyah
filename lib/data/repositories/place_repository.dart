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
      // Get location if not provided
      if (latitude == null || longitude == null) {
        final position = await LocationService.getCurrentPosition();
        latitude = position.latitude;
        longitude = position.longitude;
      }

      // In real app, make API call to get nearby places
      return _getDummyPlaces(latitude, longitude, type);
    } catch (e) {
      return _getDummyPlaces(3.1390, 101.6869, type); // KL coordinates
    }
  }

  Future<List<PlaceModel>> searchPlaces(String query) async {
    try {
      // In real app, make API call to search places
      final allPlaces = _getDummyPlaces(3.1390, 101.6869, null);
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
      final allPlaces = _getDummyPlaces(3.1390, 101.6869, null);
      return allPlaces.firstWhere((place) => place.id == id);
    } catch (e) {
      return null;
    }
  }

  List<PlaceModel> _getDummyPlaces(double userLat, double userLng, PlaceType? filterType) {
    final allPlaces = [
      // Mosques
      PlaceModel(
        id: 'mosque1',
        name: 'Masjid Negara',
        description: 'National Mosque of Malaysia with beautiful architecture',
        type: PlaceType.mosque,
        latitude: 3.1428,
        longitude: 101.6914,
        address: 'Jalan Perdana, Tasik Perdana, 50480 Kuala Lumpur',
        phoneNumber: '+603-2693-7784',
        website: 'https://www.masjidnegara.gov.my',
        rating: 4.8,
        reviewCount: 2500,
        imageUrls: [
          'https://example.com/masjid-negara1.jpg',
          'https://example.com/masjid-negara2.jpg',
        ],
        openingHours: OpeningHours(hours: {
          'monday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'tuesday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'wednesday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'thursday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'friday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'saturday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'sunday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
        }),
        amenities: ['Prayer Hall', 'Ablution Area', 'Library', 'Parking'],
        isHalalCertified: true,
        halalCertification: 'JAKIM',
        distanceFromUser: _calculateDistance(userLat, userLng, 3.1428, 101.6914),
      ),
      PlaceModel(
        id: 'mosque2',
        name: 'KLCC Mosque',
        description: 'Modern mosque located in the heart of KL city center',
        type: PlaceType.mosque,
        latitude: 3.1581,
        longitude: 101.7117,
        address: 'Suria KLCC, Kuala Lumpur City Centre',
        phoneNumber: '+603-2382-2828',
        rating: 4.6,
        reviewCount: 1200,
        imageUrls: [
          'https://example.com/klcc-mosque1.jpg',
        ],
        openingHours: OpeningHours(hours: {
          'monday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'tuesday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'wednesday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'thursday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'friday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'saturday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
          'sunday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 5, minute: 0),
            close: TimeOfDay(hour: 22, minute: 0),
          ),
        }),
        amenities: ['Prayer Hall', 'Ablution Area', 'Air Conditioning'],
        isHalalCertified: true,
        halalCertification: 'JAKIM',
        distanceFromUser: _calculateDistance(userLat, userLng, 3.1581, 101.7117),
      ),
      
      // Restaurants
      PlaceModel(
        id: 'restaurant1',
        name: 'Hadramout Restaurant',
        description: 'Authentic Middle Eastern cuisine with JAKIM halal certification',
        type: PlaceType.restaurant,
        latitude: 3.1478,
        longitude: 101.6953,
        address: 'No. 88, Jalan Bukit Bintang, 55100 Kuala Lumpur',
        phoneNumber: '+603-2145-1191',
        website: 'https://hadramout.com.my',
        rating: 4.7,
        reviewCount: 1800,
        imageUrls: [
          'https://example.com/hadramout1.jpg',
          'https://example.com/hadramout2.jpg',
        ],
        openingHours: OpeningHours(hours: {
          'monday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
          'tuesday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
          'wednesday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
          'thursday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
          'friday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
          'saturday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
          'sunday': DayHours(
            isClosed: false, 
            open: TimeOfDay(hour: 11, minute: 0),
            close: TimeOfDay(hour: 23, minute: 0),
          ),
        }),
        amenities: ['Halal Certified', 'Family Friendly', 'Parking', 'WiFi'],
        isHalalCertified: true,
        halalCertification: 'JAKIM',
        distanceFromUser: _calculateDistance(userLat, userLng, 3.1478, 101.6953),
      ),
      
      // Hotels
      PlaceModel(
        id: 'hotel1',
        name: 'Mandarin Oriental Kuala Lumpur',
        description: 'Luxury hotel with halal dining options and prayer facilities',
        type: PlaceType.hotel,
        latitude: 3.1492,
        longitude: 101.7074,
        address: 'Kuala Lumpur City Centre, 50088 Kuala Lumpur',
        phoneNumber: '+603-2380-8888',
        website: 'https://www.mandarinoriental.com/kuala-lumpur',
        rating: 4.9,
        reviewCount: 3200,
        imageUrls: [
          'https://example.com/mandarin1.jpg',
        ],
        amenities: ['Prayer Room', 'Halal Dining', 'Spa', 'Pool', 'Concierge'],
        isHalalCertified: false,
        distanceFromUser: _calculateDistance(userLat, userLng, 3.1492, 101.7074),
      ),
    ];

    if (filterType != null) {
      return allPlaces.where((place) => place.type == filterType).toList();
    }
    
    return allPlaces;
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    // Simple distance calculation (in meters)
    // In real app, use proper geospatial calculation
    const double earthRadius = 6371000; // meters
    double dLat = (lat2 - lat1) * (3.14159 / 180);
    double dLng = (lng2 - lng1) * (3.14159 / 180);
    
    double a = (dLat / 2) * (dLat / 2) +
        (lat1 * 3.14159 / 180) * (lat2 * 3.14159 / 180) * (dLng / 2) * (dLng / 2);
    double c = 2 * (a < 1 ? (a < 0 ? 0 : a) : 1);
    
    return earthRadius * c;
  }
}