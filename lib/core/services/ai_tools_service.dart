import 'package:safiyah/data/models/chat_message_model.dart';
import 'package:safiyah/routes/route_names.dart';

class AIToolsService {
  static final AIToolsService _instance = AIToolsService._internal();
  factory AIToolsService() => _instance;
  AIToolsService._internal();

  Future<Map<String, dynamic>> executeTool(
    ToolType toolType,
    Map<String, dynamic> parameters,
  ) async {
    switch (toolType) {
      case ToolType.hotelSearch:
        return await _searchHotels(parameters);
      case ToolType.purchaseHistory:
        return await _getPurchaseHistory(parameters);
      case ToolType.navigation:
        return _getNavigationRoute(parameters);
      case ToolType.prayerTime:
        return await _getPrayerTimes(parameters);
      case ToolType.currencyConverter:
        return await _convertCurrency(parameters);
      case ToolType.itineraryCreator:
        return await _createItinerary(parameters);
      case ToolType.placeSearch:
        return await _searchPlaces(parameters);
      case ToolType.weatherCheck:
        return await _checkWeather(parameters);
      case ToolType.voucherSearch:
        return await _searchVouchers(parameters);
      default:
        return {'error': 'Unknown tool type'};
    }
  }

  Future<Map<String, dynamic>> _searchHotels(
    Map<String, dynamic> parameters,
  ) async {
    // Simulate hotel search with filters
    await Future.delayed(const Duration(seconds: 1));
    
    final location = parameters['location'] ?? 'Unknown';
    final budget = parameters['budget'] ?? 'any';
    final checkIn = parameters['checkIn'];
    final checkOut = parameters['checkOut'];
    
    // Mock hotel data
    final hotels = [
      {
        'name': 'Budget Inn Makkah',
        'price': 250,
        'rating': 4.2,
        'distance': '500m from Haram',
        'amenities': ['Free WiFi', 'Prayer Room', 'Halal Food'],
        'image': 'https://example.com/hotel1.jpg',
      },
      {
        'name': 'Comfort Suites Makkah',
        'price': 450,
        'rating': 4.5,
        'distance': '300m from Haram',
        'amenities': ['Free WiFi', 'Prayer Room', 'Shuttle Service'],
        'image': 'https://example.com/hotel2.jpg',
      },
      {
        'name': 'Luxury Tower Makkah',
        'price': 800,
        'rating': 4.8,
        'distance': '100m from Haram',
        'amenities': ['Free WiFi', 'Prayer Room', 'Spa', 'Restaurant'],
        'image': 'https://example.com/hotel3.jpg',
      },
    ];
    
    // Filter by budget if specified
    final filteredHotels = budget == 'any' 
        ? hotels 
        : hotels.where((h) => h['price'] as int <= (parameters['maxPrice'] ?? 1000)).toList();
    
    return {
      'success': true,
      'hotels': filteredHotels,
      'totalFound': filteredHotels.length,
      'navigationRoute': RouteNames.hotelSearch,
      'filters': {
        'location': location,
        'checkIn': checkIn,
        'checkOut': checkOut,
        'budget': budget,
      }
    };
  }

  Future<Map<String, dynamic>> _getPurchaseHistory(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final category = parameters['category'] ?? 'all';
    
    // Mock purchase history
    final purchases = [
      {
        'id': '1',
        'type': 'Hotel Booking',
        'name': 'Hilton Makkah',
        'date': '2024-01-15',
        'amount': 2500,
        'status': 'Completed',
      },
      {
        'id': '2',
        'type': 'Hajj Package',
        'name': 'Premium Hajj Package 2024',
        'date': '2024-01-10',
        'amount': 15000,
        'status': 'Active',
      },
      {
        'id': '3',
        'type': 'Flight',
        'name': 'KUL-JED Return',
        'date': '2024-01-05',
        'amount': 3200,
        'status': 'Completed',
      },
    ];
    
    final filtered = category == 'all' 
        ? purchases 
        : purchases.where((p) => (p['type'] as String).toLowerCase().contains(category.toLowerCase())).toList();
    
    return {
      'success': true,
      'purchases': filtered,
      'totalSpent': filtered.fold(0, (sum, p) => sum + (p['amount'] as int)),
      'navigationRoute': RouteNames.purchaseHistory,
    };
  }

  Map<String, dynamic> _getNavigationRoute(Map<String, dynamic> parameters) {
    final destination = parameters['destination'] ?? '';
    
    final routeMap = {
      'hajj': RouteNames.hajjUmroh,
      'umrah': RouteNames.hajjUmroh,
      'hotel': RouteNames.hotelSearch,
      'prayer': RouteNames.prayerTimes,
      'qibla': RouteNames.qibla,
      'currency': RouteNames.currency,
      'weather': RouteNames.weather,
      'places': RouteNames.places,
      'events': RouteNames.events,
      'insurance': RouteNames.insurance,
      'voucher': RouteNames.voucher,
      'itinerary': RouteNames.itinerary,
      'settings': RouteNames.settings,
    };
    
    final route = routeMap[destination.toLowerCase()] ?? RouteNames.home;
    
    return {
      'success': true,
      'route': route,
      'parameters': parameters['routeParams'] ?? {},
    };
  }

  Future<Map<String, dynamic>> _getPrayerTimes(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final location = parameters['location'] ?? 'Current Location';
    final date = parameters['date'] ?? DateTime.now();
    
    // Mock prayer times
    final prayerTimes = {
      'fajr': '05:15',
      'sunrise': '06:30',
      'dhuhr': '12:30',
      'asr': '15:45',
      'maghrib': '18:30',
      'isha': '19:45',
    };
    
    // Calculate next prayer
    String nextPrayer = 'Fajr';
    String timeUntilNext = '5 hours 30 minutes';
    
    return {
      'success': true,
      'location': location,
      'date': date.toString(),
      'times': prayerTimes,
      'nextPrayer': nextPrayer,
      'timeUntilNext': timeUntilNext,
      'navigationRoute': RouteNames.prayerTimes,
    };
  }

  Future<Map<String, dynamic>> _convertCurrency(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 200));
    
    final amount = parameters['amount'] ?? 100.0;
    final from = parameters['from'] ?? 'USD';
    final to = parameters['to'] ?? 'MYR';
    
    // Mock conversion rates
    final rates = {
      'USD_MYR': 4.47,
      'MYR_USD': 0.22,
      'USD_SAR': 3.75,
      'SAR_USD': 0.27,
      'MYR_SAR': 0.84,
      'SAR_MYR': 1.19,
    };
    
    final rateKey = '${from}_$to';
    final rate = rates[rateKey] ?? 1.0;
    final converted = amount * rate;
    
    return {
      'success': true,
      'from': from,
      'to': to,
      'amount': amount,
      'converted': converted,
      'rate': rate,
      'navigationRoute': RouteNames.currency,
    };
  }

  Future<Map<String, dynamic>> _createItinerary(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(seconds: 2));
    
    final destination = parameters['destination'] ?? 'Unknown';
    final days = parameters['days'] ?? 3;
    
    // Generate mock itinerary
    final itinerary = List.generate(days, (dayIndex) {
      return {
        'day': dayIndex + 1,
        'activities': [
          {
            'time': '08:00',
            'activity': 'Breakfast at local halal restaurant',
            'duration': '1 hour',
          },
          {
            'time': '09:30',
            'activity': dayIndex == 0 ? 'Visit Grand Mosque' : 'Explore local markets',
            'duration': '3 hours',
          },
          {
            'time': '13:00',
            'activity': 'Lunch and prayer break',
            'duration': '1.5 hours',
          },
          {
            'time': '15:00',
            'activity': dayIndex == 1 ? 'Museum tour' : 'Shopping',
            'duration': '2 hours',
          },
          {
            'time': '19:00',
            'activity': 'Dinner at recommended restaurant',
            'duration': '1.5 hours',
          },
        ],
      };
    });
    
    return {
      'success': true,
      'destination': destination,
      'days': days,
      'itinerary': itinerary,
      'estimatedBudget': days * 500,
      'navigationRoute': RouteNames.createItinerary,
      'routeParams': {
        'destination': destination,
        'days': days,
      },
    };
  }

  Future<Map<String, dynamic>> _searchPlaces(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    final query = parameters['query'] ?? '';
    final category = parameters['category'] ?? 'all';
    final location = parameters['location'] ?? 'nearby';
    
    // Mock places data
    final places = [
      {
        'name': 'Masjid Al-Haram',
        'category': 'mosque',
        'rating': 5.0,
        'distance': '0 km',
        'description': 'The Grand Mosque in Mecca',
        'image': 'https://example.com/haram.jpg',
      },
      {
        'name': 'Halal Kitchen',
        'category': 'restaurant',
        'rating': 4.5,
        'distance': '0.5 km',
        'description': 'Authentic halal cuisine',
        'image': 'https://example.com/restaurant.jpg',
      },
      {
        'name': 'Islamic Museum',
        'category': 'attraction',
        'rating': 4.3,
        'distance': '2 km',
        'description': 'Historical Islamic artifacts',
        'image': 'https://example.com/museum.jpg',
      },
    ];
    
    final filtered = category == 'all' 
        ? places 
        : places.where((p) => p['category'] == category).toList();
    
    return {
      'success': true,
      'places': filtered,
      'totalFound': filtered.length,
      'navigationRoute': RouteNames.places,
      'filters': {
        'query': query,
        'category': category,
        'location': location,
      },
    };
  }

  Future<Map<String, dynamic>> _checkWeather(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    final location = parameters['location'] ?? 'Current Location';
    final days = parameters['days'] ?? 1;
    
    // Mock weather data
    final weather = {
      'current': {
        'temperature': 32,
        'condition': 'Sunny',
        'humidity': 45,
        'windSpeed': 10,
        'icon': '☀️',
      },
      'forecast': List.generate(days, (index) {
        return {
          'day': index,
          'high': 35 - index,
          'low': 25 - index,
          'condition': index == 0 ? 'Sunny' : 'Partly Cloudy',
          'icon': index == 0 ? '☀️' : '⛅',
        };
      }),
    };
    
    return {
      'success': true,
      'location': location,
      'weather': weather,
      'navigationRoute': RouteNames.weather,
    };
  }

  Future<Map<String, dynamic>> _searchVouchers(
    Map<String, dynamic> parameters,
  ) async {
    await Future.delayed(const Duration(milliseconds: 400));
    
    final category = parameters['category'] ?? 'all';
    final minDiscount = parameters['minDiscount'] ?? 0;
    
    // Mock voucher data
    final vouchers = [
      {
        'code': 'HAJJ2024',
        'discount': 20,
        'category': 'hajj',
        'description': '20% off Hajj packages',
        'validUntil': '2024-12-31',
        'minPurchase': 10000,
      },
      {
        'code': 'HOTEL15',
        'discount': 15,
        'category': 'hotel',
        'description': '15% off hotel bookings',
        'validUntil': '2024-06-30',
        'minPurchase': 500,
      },
      {
        'code': 'FOOD10',
        'discount': 10,
        'category': 'restaurant',
        'description': '10% off at partner restaurants',
        'validUntil': '2024-03-31',
        'minPurchase': 100,
      },
    ];
    
    final filtered = vouchers.where((v) {
      final matchCategory = category == 'all' || v['category'] == category;
      final matchDiscount = (v['discount'] as int) >= minDiscount;
      return matchCategory && matchDiscount;
    }).toList();
    
    return {
      'success': true,
      'vouchers': filtered,
      'totalFound': filtered.length,
      'navigationRoute': RouteNames.voucher,
    };
  }

  String getToolDescription(ToolType toolType) {
    switch (toolType) {
      case ToolType.hotelSearch:
        return 'Searching for hotels...';
      case ToolType.purchaseHistory:
        return 'Retrieving your purchase history...';
      case ToolType.navigation:
        return 'Opening the requested page...';
      case ToolType.prayerTime:
        return 'Checking prayer times...';
      case ToolType.currencyConverter:
        return 'Converting currency...';
      case ToolType.itineraryCreator:
        return 'Creating your itinerary...';
      case ToolType.placeSearch:
        return 'Searching for places...';
      case ToolType.weatherCheck:
        return 'Checking weather...';
      case ToolType.voucherSearch:
        return 'Finding vouchers...';
      default:
        return 'Processing...';
    }
  }
} 