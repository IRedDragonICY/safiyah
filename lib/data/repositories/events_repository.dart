import '../models/event_model.dart';
import '../datasources/local/local_storage.dart';

class EventsRepository {
  final LocalStorage _localStorage = LocalStorage();

  Future<List<EventModel>> getAllEvents() async {
    try {
      final eventsData = await _localStorage.getEvents();
      if (eventsData.isNotEmpty) {
        return eventsData.map((data) => EventModel.fromJson(data)).toList();
      } else {
        // If storage is empty, populate it with dummy data and return
        final dummyEvents = _getDummyEvents();
        await _populateStorageWithDummyEvents(dummyEvents);
        return dummyEvents;
      }
    } catch (e) {
      // If storage fails, still return dummy events
      final dummyEvents = _getDummyEvents();
      return dummyEvents;
    }
  }

  Future<void> _populateStorageWithDummyEvents(List<EventModel> events) async {
    try {
      for (final event in events) {
        await _localStorage.saveEvent(event.toJson());
      }
    } catch (e) {
      // Ignore storage errors for now
    }
  }

  Future<EventModel?> getEventById(String id) async {
    try {
      final eventData = await _localStorage.getEventById(id);
      if (eventData != null) {
        return EventModel.fromJson(eventData);
      }
      // If not found in storage, check dummy events
      final dummyEvents = _getDummyEvents();
      try {
        return dummyEvents.firstWhere((event) => event.id == id);
      } catch (e) {
        return null;
      }
    } catch (e) {
      final dummyEvents = _getDummyEvents();
      try {
        return dummyEvents.firstWhere((event) => event.id == id);
      } catch (e) {
        return null;
      }
    }
  }

  Future<List<EventModel>> getEventsByCategory(EventCategory category) async {
    final events = await getAllEvents();
    return events.where((event) => event.category == category).toList();
  }

  Future<List<EventModel>> getEventsByType(EventType type) async {
    final events = await getAllEvents();
    return events.where((event) => event.type == type).toList();
  }

  Future<List<EventModel>> getUpcomingEvents() async {
    final events = await getAllEvents();
    final now = DateTime.now();
    return events
        .where((event) => event.startDate.isAfter(now))
        .toList()
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
  }

  Future<List<EventModel>> getOngoingEvents() async {
    final events = await getAllEvents();
    return events.where((event) => event.isHappeningNow).toList();
  }

  Future<List<EventModel>> searchEvents(String query) async {
    final events = await getAllEvents();
    final lowerQuery = query.toLowerCase();
    
    return events.where((event) {
      return event.name.toLowerCase().contains(lowerQuery) ||
             event.description.toLowerCase().contains(lowerQuery) ||
             event.venue.toLowerCase().contains(lowerQuery) ||
             event.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
    }).toList();
  }

  Future<List<EventModel>> getFreeEvents() async {
    final events = await getAllEvents();
    return events.where((event) => event.priceInfo.isFree).toList();
  }

  Future<List<EventModel>> getEventsByMonth(int month) async {
    final events = await getAllEvents();
    return events.where((event) => event.startDate.month == month).toList();
  }

  List<EventModel> _getDummyEvents() {
    final now = DateTime.now();
    return [
      // Cherry Blossom Festival - April
      EventModel(
        id: 'sakura-matsuri-2024',
        name: 'Tokyo Cherry Blossom Festival',
        description: 'Experience the breathtaking beauty of cherry blossoms in full bloom across Tokyo\'s most scenic locations.',
        detailedDescription: 'The Tokyo Cherry Blossom Festival is one of Japan\'s most beloved annual celebrations. Join millions of visitors in hanami (flower viewing) parties under thousands of blooming sakura trees. This festival features traditional performances, food stalls, illuminations, and guided tours through Ueno Park, Shinjuku Gyoen, and Chidorigafuchi.',
        type: EventType.festival,
        category: EventCategory.traditional,
        startDate: DateTime(now.year, 4, 1),
        endDate: DateTime(now.year, 4, 30),
        venue: 'Multiple Locations (Ueno Park, Shinjuku Gyoen, Chidorigafuchi)',
        address: 'Various locations across Tokyo',
        latitude: 35.6762,
        longitude: 139.6503,
        imageUrls: [
          'https://images.unsplash.com/photo-1490375988624-9b1f3c04d32b?w=800&q=80',
          'https://images.unsplash.com/photo-1522383225653-ed111181a951?w=800&q=80',
          'https://images.unsplash.com/photo-1524413840807-0c3cb6fa808d?w=800&q=80',
        ],
        websiteUrl: 'https://hanami.tokyo-park.or.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free entry to all parks. Food and drinks sold separately.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['sakura', 'hanami', 'spring', 'traditional', 'family-friendly'],
        rating: 4.8,
        attendeeCount: 2500000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: true,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible paths', 'Sign language interpretation available'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 4, 1, 6, 0),
            endTime: DateTime(now.year, 4, 1, 22, 0),
            title: 'Daily Park Hours',
            description: 'Parks open for hanami viewing',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 4, 5, 18, 0),
            endTime: DateTime(now.year, 4, 5, 21, 0),
            title: 'Evening Illumination',
            description: 'Special cherry blossom illumination event',
            location: 'Chidorigafuchi',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3828-5644',
          email: 'info@hanami-tokyo.jp',
          website: 'https://hanami.tokyo-park.or.jp',
        ),
        highlights: [
          'Over 1,000 cherry blossom trees in bloom',
          'Traditional tea ceremony demonstrations',
          'Food stalls with seasonal delicacies',
          'Boat rides in Chidorigafuchi moat',
          'Evening illuminations',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Ueno Station', 'Shinjuku Station', 'Kudanshita Station'],
          directions: {
            'From Ueno Station': 'Walk 2 minutes to Ueno Park',
            'From Shinjuku Station': 'Walk 10 minutes to Shinjuku Gyoen',
            'From Kudanshita Station': 'Walk 5 minutes to Chidorigafuchi',
          },
          hasParkingAvailable: false,
          parkingInfo: 'Limited parking available. Public transportation recommended.',
        ),
      ),

      // Anime Japan Convention
      EventModel(
        id: 'anime-japan-2024',
        name: 'AnimeJapan 2024',
        description: 'Japan\'s largest anime convention featuring the latest anime, manga, games, and exclusive merchandise.',
        detailedDescription: 'AnimeJapan is the premier anime convention in Japan, bringing together anime studios, voice actors, creators, and fans from around the world. Experience exclusive premieres, meet your favorite voice actors, participate in cosplay contests, and discover the latest anime and manga releases. This year features special exhibitions from Studio Ghibli, Toei Animation, and many more.',
        type: EventType.exhibition,
        category: EventCategory.anime,
        startDate: DateTime(now.year + 1, 3, 25),
        endDate: DateTime(now.year + 1, 3, 28),
        venue: 'Tokyo Big Sight',
        address: '3-11-1 Ariake, Koto City, Tokyo 135-0063',
        latitude: 35.6298,
        longitude: 139.7947,
        imageUrls: [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?w=800&q=80',
          'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=800&q=80',
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&q=80',
        ],
        websiteUrl: 'https://www.anime-japan.jp',
        ticketUrl: 'https://anime-japan.jp/tickets',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 1800,
          maxPrice: 5500,
          currency: 'JPY',
          ticketTiers: [
            TicketTier(
              name: 'General Admission',
              price: 1800,
              description: 'Basic entry to exhibition halls',
              isAvailable: true,
            ),
            TicketTier(
              name: 'VIP Pass',
              price: 5500,
              description: 'Priority access, exclusive events, and merchandise',
              isAvailable: true,
              remainingTickets: 500,
            ),
          ],
          priceNote: 'Children under 12 free with adult supervision',
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['anime', 'manga', 'cosplay', 'voice-actors', 'gaming', 'otaku'],
        rating: 4.7,
        attendeeCount: 350000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: true,
          hasAudioDescription: true,
          hasBraille: true,
          accessibilityFeatures: [
            'Wheelchair rental available',
            'Sign language interpretation for main events',
            'Audio guides available',
            'Quiet spaces for sensory breaks',
          ],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year + 1, 3, 25, 10, 0),
            endTime: DateTime(now.year + 1, 3, 25, 17, 0),
            title: 'Day 1 - Studio Showcase',
            description: 'Major anime studios present their upcoming releases',
          ),
          EventSchedule(
            startTime: DateTime(now.year + 1, 3, 26, 10, 0),
            endTime: DateTime(now.year + 1, 3, 26, 17, 0),
            title: 'Day 2 - Voice Actor Meet & Greet',
            description: 'Meet famous voice actors and get autographs',
          ),
          EventSchedule(
            startTime: DateTime(now.year + 1, 3, 27, 10, 0),
            endTime: DateTime(now.year + 1, 3, 27, 17, 0),
            title: 'Day 3 - Cosplay Championship',
            description: 'International cosplay competition finals',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-5530-1151',
          email: 'info@anime-japan.jp',
          website: 'https://www.anime-japan.jp',
          socialMedia: {
            'twitter': '@animejapan_aj',
            'instagram': 'animejapan_official',
          },
        ),
        highlights: [
          'Exclusive anime premieres and trailers',
          'Voice actor meet and greets',
          'International cosplay competition',
          'Limited edition merchandise',
          'Interactive VR anime experiences',
        ],
        weatherDependency: WeatherDependency.indoor,
        ageRestriction: const AgeRestriction(
          note: 'Some content may not be suitable for children under 13',
        ),
        languages: ['Japanese', 'English', 'Chinese', 'Korean'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Kokusai-tenjijo Station', 'Ariake Station'],
          directions: {
            'From Kokusai-tenjijo Station': 'Walk 7 minutes via Yurikamome Line',
            'From Ariake Station': 'Walk 3 minutes via Yurikamome Line',
          },
          hasParkingAvailable: true,
          parkingInfo: 'Paid parking available at ¥500/hour. Limited spaces.',
        ),
      ),

      // Summer Tanabata Festival
      EventModel(
        id: 'tanabata-matsuri-2024',
        name: 'Sendai Tanabata Festival',
        description: 'One of Japan\'s three great festivals featuring spectacular bamboo decorations throughout the city.',
        detailedDescription: 'The Sendai Tanabata Festival is a celebration of the legendary meeting of Orihime and Hikoboshi (represented by the stars Vega and Altair). The entire city is decorated with thousands of colorful streamers and bamboo decorations. Enjoy traditional performances, local food, and make wishes on tanzaku paper strips.',
        type: EventType.festival,
        category: EventCategory.traditional,
        startDate: DateTime(now.year, 8, 6),
        endDate: DateTime(now.year, 8, 8),
        venue: 'Central Sendai (Chuo-dori, Ichibancho)',
        address: 'Central Sendai, Miyagi Prefecture',
        latitude: 38.2682,
        longitude: 140.8694,
        imageUrls: [
          'https://images.unsplash.com/photo-1533094602577-198d3beab8ea?w=800&q=80',
          'https://images.unsplash.com/photo-1528164344705-47542687000d?w=800&q=80',
        ],
        websiteUrl: 'https://www.sendaitanabata.com',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free to view decorations. Food and activities sold separately.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['tanabata', 'summer', 'traditional', 'festival', 'decorations'],
        rating: 4.6,
        attendeeCount: 2000000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible viewing areas'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 8, 6, 10, 0),
            endTime: DateTime(now.year, 8, 6, 22, 0),
            title: 'Opening Day Ceremony',
            description: 'Traditional opening ceremony with local dignitaries',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 8, 7, 18, 0),
            endTime: DateTime(now.year, 8, 7, 21, 0),
            title: 'Evening Fireworks',
            description: 'Special fireworks display over the city',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-22-265-8185',
          website: 'https://www.sendaitanabata.com',
        ),
        highlights: [
          'Thousands of colorful bamboo decorations',
          'Traditional Japanese performances',
          'Local Sendai specialty foods',
          'Wish-writing activities',
          'Historical exhibits',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Sendai Station'],
          directions: {
            'From Sendai Station': 'Walk 10 minutes to central shopping district',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No event parking. Use public transportation.',
        ),
      ),

      // Tokyo Game Show
      EventModel(
        id: 'tokyo-game-show-2024',
        name: 'Tokyo Game Show 2024',
        description: 'Asia\'s premier video game exhibition showcasing the latest games, technology, and gaming culture.',
        detailedDescription: 'Tokyo Game Show is one of the world\'s largest video game trade shows, featuring the latest console games, mobile games, VR experiences, and gaming hardware. Major publishers like Nintendo, Sony, Capcom, and Square Enix showcase their upcoming releases. Experience hands-on demos, esports tournaments, and exclusive announcements.',
        type: EventType.exhibition,
        category: EventCategory.modern,
        startDate: DateTime(now.year, 9, 21),
        endDate: DateTime(now.year, 9, 24),
        venue: 'Makuhari Messe',
        address: '2-1 Nakase, Mihama Ward, Chiba City, Chiba 261-8550',
        latitude: 35.6479,
        longitude: 140.0341,
        imageUrls: [
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?w=800&q=80',
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80',
        ],
        websiteUrl: 'https://tgs.cesa.or.jp',
        ticketUrl: 'https://tgs.cesa.or.jp/tickets',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 1500,
          maxPrice: 2500,
          currency: 'JPY',
          ticketTiers: [
            TicketTier(
              name: 'Business Day Pass',
              price: 2500,
              description: 'For industry professionals (first 2 days)',
              isAvailable: true,
            ),
            TicketTier(
              name: 'Public Day Pass',
              price: 1500,
              description: 'General admission for last 2 days',
              isAvailable: true,
            ),
          ],
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['gaming', 'technology', 'esports', 'VR', 'anime-games'],
        rating: 4.5,
        attendeeCount: 250000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: true,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: [
            'Wheelchair accessible throughout',
            'Sign language interpretation for main events',
            'Priority seating for disabled visitors',
          ],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 9, 21, 10, 0),
            endTime: DateTime(now.year, 9, 22, 17, 0),
            title: 'Business Days',
            description: 'Industry professionals and media only',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 9, 23, 10, 0),
            endTime: DateTime(now.year, 9, 24, 17, 0),
            title: 'Public Days',
            description: 'Open to general public',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3214-6775',
          email: 'info@tgs.cesa.or.jp',
          website: 'https://tgs.cesa.or.jp',
        ),
        highlights: [
          'Exclusive game demos and previews',
          'Esports tournaments',
          'VR and AR experiences',
          'Developer presentations',
          'Limited edition merchandise',
        ],
        weatherDependency: WeatherDependency.indoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Kaihin-Makuhari Station'],
          directions: {
            'From Kaihin-Makuhari Station': 'Walk 5 minutes via JR Keiyo Line',
          },
          hasParkingAvailable: true,
          parkingInfo: 'Paid parking ¥1000/day. Limited spaces available.',
        ),
      ),

      // Autumn Illumination Festival
      EventModel(
        id: 'winter-illumination-2024',
        name: 'Tokyo Winter Illumination Festival',
        description: 'Spectacular winter light displays across Tokyo\'s most beautiful locations.',
        detailedDescription: 'Transform your winter evenings with millions of LED lights creating magical displays across Tokyo. From the romantic Roppongi Hills to the futuristic Tokyo Station, experience the city\'s most stunning illuminations. Special themed areas include Christmas markets, projection mapping shows, and interactive light installations.',
        type: EventType.seasonal,
        category: EventCategory.modern,
        startDate: DateTime(now.year, 11, 15),
        endDate: DateTime(now.year + 1, 2, 14),
        venue: 'Multiple Locations (Roppongi Hills, Tokyo Station, Shibuya)',
        address: 'Various locations across Tokyo',
        latitude: 35.6762,
        longitude: 139.6503,
        imageUrls: [
          'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1482329833197-916d32bdae74?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://tokyo-illumination.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free viewing. Some special areas may charge admission.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['illumination', 'winter', 'lights', 'romantic', 'photography'],
        rating: 4.7,
        attendeeCount: 5000000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible viewing areas at all locations'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 11, 15, 17, 0),
            endTime: DateTime(now.year, 11, 15, 23, 0),
            title: 'Daily Illumination Hours',
            description: 'Main illumination display times',
          ),
        ],
        contactInfo: const ContactInfo(
          website: 'https://tokyo-illumination.jp',
        ),
        highlights: [
          'Over 8 million LED lights',
          'Projection mapping shows',
          'Interactive light installations',
          'Christmas market atmosphere',
          'Perfect for romantic dates',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Roppongi Station', 'Tokyo Station', 'Shibuya Station'],
          directions: {
            'Multiple locations': 'Each location accessible by major train lines',
          },
          hasParkingAvailable: false,
          parkingInfo: 'Limited parking. Public transportation strongly recommended.',
        ),
      ),

      // Traditional Tea Ceremony Workshop
      EventModel(
        id: 'tea-ceremony-workshop-monthly',
        name: 'Traditional Japanese Tea Ceremony Workshop',
        description: 'Learn the ancient art of Japanese tea ceremony in an authentic setting.',
        detailedDescription: 'Immerse yourself in the tranquil world of sado (tea ceremony) with experienced tea masters. Learn the proper techniques, etiquette, and philosophy behind this centuries-old practice. The workshop includes hands-on practice, tasting of traditional sweets, and understanding of tea ceremony\'s spiritual aspects.',
        type: EventType.workshop,
        category: EventCategory.traditional,
        startDate: DateTime(now.year, now.month, 15, 14, 0),
        endDate: DateTime(now.year, now.month, 15, 16, 30),
        venue: 'Urasenke Foundation Tokyo',
        address: '1-7-15 Nihonbashi, Chuo City, Tokyo 103-0027',
        latitude: 35.6837,
        longitude: 139.7737,
        imageUrls: [
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.urasenke.or.jp',
        ticketUrl: 'https://tea-ceremony-tokyo.jp/bookings',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 8000,
          maxPrice: 8000,
          currency: 'JPY',
          priceNote: 'Includes tea, sweets, and certificate of participation',
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.monthly,
          interval: 1,
          dayOfMonth: 15,
        ),
        tags: ['tea-ceremony', 'traditional', 'culture', 'meditation', 'workshop'],
        rating: 4.9,
        attendeeCount: 25,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: false,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Traditional tatami seating required'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, now.month, 15, 14, 0),
            endTime: DateTime(now.year, now.month, 15, 14, 30),
            title: 'Introduction and History',
            description: 'Learn about tea ceremony origins and philosophy',
          ),
          EventSchedule(
            startTime: DateTime(now.year, now.month, 15, 14, 30),
            endTime: DateTime(now.year, now.month, 15, 16, 0),
            title: 'Hands-on Practice',
            description: 'Practice tea preparation and serving',
          ),
          EventSchedule(
            startTime: DateTime(now.year, now.month, 15, 16, 0),
            endTime: DateTime(now.year, now.month, 15, 16, 30),
            title: 'Reflection and Q&A',
            description: 'Discussion and certificate presentation',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3668-2525',
          email: 'workshop@urasenke.or.jp',
          website: 'https://www.urasenke.or.jp',
        ),
        highlights: [
          'Authentic traditional setting',
          'Experienced tea masters',
          'Hands-on practice',
          'Traditional sweets included',
          'Certificate of participation',
        ],
        weatherDependency: WeatherDependency.indoor,
        ageRestriction: const AgeRestriction(
          minAge: 12,
          note: 'Children under 12 must be accompanied by adult',
        ),
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Nihonbashi Station'],
          directions: {
            'From Nihonbashi Station': 'Walk 3 minutes via Exit B1',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No parking available. Please use public transportation.',
        ),
      ),

      // Ramen Festival
      EventModel(
        id: 'tokyo-ramen-festival-2024',
        name: 'Tokyo Ramen Festival',
        description: 'The ultimate celebration of Japan\'s most beloved noodle dish with over 100 ramen shops.',
        detailedDescription: 'Discover the incredible diversity of ramen at Tokyo\'s largest ramen festival. Sample signature bowls from famous ramen shops across Japan, learn about regional variations, and watch live cooking demonstrations. From tonkotsu to miso, shoyu to tantanmen, experience every style of this iconic dish.',
        type: EventType.food,
        category: EventCategory.foodAndDrink,
        startDate: DateTime(now.year, 10, 10),
        endDate: DateTime(now.year, 10, 15),
        venue: 'Odaiba Seaside Park',
        address: '1-4 Daiba, Minato City, Tokyo 135-0091',
        latitude: 35.6264,
        longitude: 139.7734,
        imageUrls: [
          'https://images.unsplash.com/photo-1557872943-16a5ac26437e?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://tokyo-ramen-fest.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free entry. Ramen bowls sold individually ¥500-1500 each.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['ramen', 'food', 'festival', 'japanese-cuisine', 'street-food'],
        rating: 4.4,
        attendeeCount: 800000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible areas', 'Accessible restrooms'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 10, 10, 11, 0),
            endTime: DateTime(now.year, 10, 15, 21, 0),
            title: 'Daily Festival Hours',
            description: 'Ramen stalls and activities open',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 10, 12, 15, 0),
            endTime: DateTime(now.year, 10, 12, 16, 0),
            title: 'Ramen Making Workshop',
            description: 'Learn to make ramen from scratch',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-5500-1234',
          website: 'https://tokyo-ramen-fest.jp',
        ),
        highlights: [
          'Over 100 different ramen shops',
          'Regional ramen specialties',
          'Live cooking demonstrations',
          'Ramen eating competitions',
          'Special halal ramen options',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Shimbashi Station', 'Toyosu Station'],
          directions: {
            'From Shimbashi Station': 'Take Yurikamome Line to Odaiba-Kaihinkoen Station (13 min)',
            'From Toyosu Station': 'Take Yurikamome Line to Odaiba-Kaihinkoen Station (8 min)',
          },
          hasParkingAvailable: true,
          parkingInfo: 'Event parking ¥500/hour. Alternative parking at nearby malls.',
        ),
      ),

      // Gion Matsuri - Kyoto's Famous Festival
      EventModel(
        id: 'gion-matsuri-2024',
        name: 'Gion Matsuri - Kyoto Festival',
        description: 'Japan\'s most famous festival featuring spectacular yamaboko floats and traditional ceremonies.',
        detailedDescription: 'Gion Matsuri is one of Japan\'s three most beautiful festivals, held throughout July in Kyoto. The highlight is the grand procession of yamaboko (decorated floats) through the historic streets. Experience traditional music, dance, and enjoy street food while witnessing this UNESCO-recognized cultural treasure that has been celebrated for over 1,000 years.',
        type: EventType.festival,
        category: EventCategory.traditional,
        startDate: DateTime(now.year, 7, 1),
        endDate: DateTime(now.year, 7, 31),
        venue: 'Kyoto City Center (Kawaramachi, Gion District)',
        address: 'Kyoto, Kyoto Prefecture, Japan',
        latitude: 35.0116,
        longitude: 135.7681,
        imageUrls: [
          'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.gionmatsuri.or.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free to watch. Premium viewing seats available for ¥3000-5000.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['gion-matsuri', 'kyoto', 'traditional', 'unesco', 'float-parade'],
        rating: 4.9,
        attendeeCount: 3000000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible viewing areas along parade route'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 7, 17, 9, 0),
            endTime: DateTime(now.year, 7, 17, 12, 0),
            title: 'Yamaboko Junko - Main Parade',
            description: 'Grand procession of decorated floats',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 7, 24, 9, 30),
            endTime: DateTime(now.year, 7, 24, 12, 0),
            title: 'Ato Matsuri Parade',
            description: 'Second procession with different floats',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-75-752-7070',
          website: 'https://www.gionmatsuri.or.jp',
        ),
        highlights: [
          'UNESCO Intangible Cultural Heritage',
          '1000+ years of history',
          'Spectacular yamaboko floats',
          'Traditional music and performances',
          'Historic Kyoto setting',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Kawaramachi Station', 'Gion-Shijo Station'],
          directions: {
            'From Kyoto Station': 'Take Keihan Main Line to Gion-Shijo Station (15 min)',
            'From Kawaramachi Station': 'Walking distance to parade route',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No event parking. Public transportation strongly recommended.',
        ),
      ),

      // Comiket - World's Largest Comic Convention
      EventModel(
        id: 'comiket-summer-2024',
        name: 'Comic Market (Comiket) Summer 2024',
        description: 'The world\'s largest comic convention featuring doujinshi, cosplay, and otaku culture.',
        detailedDescription: 'Comiket is the ultimate destination for manga, anime, and game enthusiasts. With over 500,000 attendees, this massive convention features thousands of independent artists selling doujinshi (self-published works), incredible cosplay, and exclusive merchandise. Experience the heart of Japanese otaku culture and discover amazing fan-created content.',
        type: EventType.exhibition,
        category: EventCategory.anime,
        startDate: DateTime(now.year, 8, 11),
        endDate: DateTime(now.year, 8, 13),
        venue: 'Tokyo Big Sight',
        address: '3-11-1 Ariake, Koto City, Tokyo 135-0063',
        latitude: 35.6298,
        longitude: 139.7947,
        imageUrls: [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1560472354-b33ff0c44a43?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.comiket.co.jp',
        ticketUrl: 'https://www.comiket.co.jp/info-c/WhatIsECatalog.html',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 2500,
          maxPrice: 2500,
          currency: 'JPY',
          priceNote: 'Catalog purchase required for entry. Available online and at venue.',
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['comiket', 'manga', 'doujinshi', 'cosplay', 'otaku', 'independent-artists'],
        rating: 4.8,
        attendeeCount: 500000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible', 'Priority entry for disabled visitors'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 8, 11, 10, 0),
            endTime: DateTime(now.year, 8, 11, 16, 0),
            title: 'Day 1 - Corporate Booths',
            description: 'Major publishers and game companies',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 8, 12, 10, 0),
            endTime: DateTime(now.year, 8, 13, 16, 0),
            title: 'Day 2-3 - Circle Booths',
            description: 'Independent artists and doujinshi creators',
          ),
        ],
        contactInfo: const ContactInfo(
          website: 'https://www.comiket.co.jp',
          email: 'staff@comiket.co.jp',
        ),
        highlights: [
          'World\'s largest comic convention',
          'Exclusive doujinshi and fan works',
          'Amazing cosplay competitions',
          'Meet famous manga artists',
          'Limited edition merchandise',
        ],
        weatherDependency: WeatherDependency.indoor,
        ageRestriction: const AgeRestriction(
          note: 'Some adult content areas restricted to 18+',
        ),
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Kokusai-tenjijo Station'],
          directions: {
            'From Tokyo Station': 'Take JR Keihin-Tohoku Line to Shimbashi, then Yurikamome Line (45 min)',
          },
          hasParkingAvailable: true,
          parkingInfo: 'Limited parking ¥1000/day. Early arrival recommended.',
        ),
      ),

      // Robot Restaurant Show
      EventModel(
        id: 'robot-restaurant-show',
        name: 'Robot Restaurant Spectacular Show',
        description: 'Japan\'s most outrageous entertainment experience with giant robots, lasers, and music.',
        detailedDescription: 'Enter a neon-lit wonderland of giant robots, bikini-clad dancers, flashing lights, and pounding music. This isn\'t really about robots or restaurants - it\'s a sensory overload extravaganza that epitomizes Tokyo\'s quirky entertainment culture. Expect loud music, colorful costumes, and an unforgettable experience that\'s uniquely Japanese.',
        type: EventType.performance,
        category: EventCategory.entertainment,
        startDate: DateTime(now.year, now.month, now.day, 16, 0),
        endDate: DateTime(now.year, now.month, now.day, 17, 30),
        venue: 'Robot Restaurant, Shinjuku',
        address: '1-7-1 Kabukicho, Shinjuku City, Tokyo 160-0021',
        latitude: 35.6938,
        longitude: 139.7034,
        imageUrls: [
          'https://images.unsplash.com/photo-1518709268805-4e9042af2176?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1542751371-adc38448a05e?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.robotrestaurant.com',
        ticketUrl: 'https://www.robotrestaurant.com/pc/system/ticket/',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 8000,
          maxPrice: 10000,
          currency: 'JPY',
          ticketTiers: [
            TicketTier(
              name: 'Standard Seat',
              price: 8000,
              description: 'Regular seating with bento box option',
              isAvailable: true,
            ),
            TicketTier(
              name: 'Premium Seat',
              price: 10000,
              description: 'Front row seating with premium bento',
              isAvailable: true,
              remainingTickets: 20,
            ),
          ],
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.daily,
          interval: 1,
        ),
        tags: ['robot-show', 'entertainment', 'shinjuku', 'quirky', 'neon'],
        rating: 4.3,
        attendeeCount: 200,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: false,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Basement venue with stairs only'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, now.month, now.day, 16, 0),
            endTime: DateTime(now.year, now.month, now.day, 17, 30),
            title: 'Robot Show Spectacular',
            description: 'Full robot entertainment experience with dinner',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3200-5500',
          website: 'https://www.robotrestaurant.com',
        ),
        highlights: [
          'Giant robot battles',
          'LED light extravaganza',
          'Energetic dance performances',
          'Unique Tokyo experience',
          'Photo opportunities with robots',
        ],
        weatherDependency: WeatherDependency.indoor,
        ageRestriction: const AgeRestriction(
          note: 'Not recommended for children under 6 due to loud music and flashing lights',
        ),
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Shinjuku Station', 'Kabukicho'],
          directions: {
            'From Shinjuku Station': 'Walk 5 minutes to Kabukicho area',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No parking available. Use public transportation.',
        ),
      ),

      // Grand Sumo Tournament
      EventModel(
        id: 'autumn-sumo-tournament-2024',
        name: 'Autumn Grand Sumo Tournament',
        description: 'Experience Japan\'s national sport at the historic Ryogoku Kokugikan arena.',
        detailedDescription: 'Witness the power and tradition of sumo wrestling at one of six annual grand tournaments. See Japan\'s greatest wrestlers compete for the coveted championship trophy in this 1,500-year-old sport. The tournament features multiple divisions, ceremonial rituals, and the excitement of traditional Japanese athletic competition.',
        type: EventType.sports,
        category: EventCategory.traditional,
        startDate: DateTime(now.year, 9, 10),
        endDate: DateTime(now.year, 9, 24),
        venue: 'Ryogoku Kokugikan',
        address: '1-3-28 Yokoami, Sumida City, Tokyo 130-0015',
        latitude: 35.6966,
        longitude: 139.7933,
        imageUrls: [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.sumo.or.jp',
        ticketUrl: 'https://sumo.pia.jp',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 2100,
          maxPrice: 14800,
          currency: 'JPY',
          ticketTiers: [
            TicketTier(
              name: 'Arena Seat (Unreserved)',
              price: 2100,
              description: 'Standing area behind arena seating',
              isAvailable: true,
            ),
            TicketTier(
              name: 'Box Seat (4 people)',
              price: 14800,
              description: 'Traditional tatami mat seating for 4',
              isAvailable: true,
              remainingTickets: 150,
            ),
          ],
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['sumo', 'traditional-sport', 'tournament', 'ryogoku', 'wrestling'],
        rating: 4.6,
        attendeeCount: 11000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible seating available', 'Elevator access'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 9, 10, 8, 30),
            endTime: DateTime(now.year, 9, 24, 18, 0),
            title: '15-Day Tournament',
            description: 'Daily matches from lower to top divisions',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 9, 24, 15, 0),
            endTime: DateTime(now.year, 9, 24, 18, 0),
            title: 'Championship Final Day',
            description: 'Top division matches and award ceremony',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3623-5111',
          website: 'https://www.sumo.or.jp',
        ),
        highlights: [
          'Japan\'s national sport',
          'Traditional ceremonies and rituals',
          'World-class wrestlers',
          'Historic Ryogoku venue',
          'Cultural dining experiences',
        ],
        weatherDependency: WeatherDependency.indoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Ryogoku Station'],
          directions: {
            'From Ryogoku Station': 'Walk 2 minutes from JR Ryogoku Station',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No parking available. Public transportation recommended.',
        ),
      ),

      // Mount Fuji Climbing Season
      EventModel(
        id: 'mount-fuji-climbing-2024',
        name: 'Mount Fuji Climbing Season',
        description: 'Climb Japan\'s sacred mountain during the official climbing season.',
        detailedDescription: 'Experience the spiritual journey of climbing Mount Fuji, Japan\'s highest peak and sacred symbol. The official climbing season offers the safest conditions with mountain huts, guides, and emergency services available. Watch the sunrise from the summit and earn your climbing certificate from this UNESCO World Heritage site.',
        type: EventType.sports,
        category: EventCategory.nature,
        startDate: DateTime(now.year, 7, 1),
        endDate: DateTime(now.year, 9, 10),
        venue: 'Mount Fuji (Multiple Trail Entrances)',
        address: 'Mount Fuji, Honshu, Japan',
        latitude: 35.3606,
        longitude: 138.7274,
        imageUrls: [
          'https://images.unsplash.com/photo-1490375988624-9b1f3c04d32b?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.fujisan-climb.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 1000,
          maxPrice: 15000,
          currency: 'JPY',
          priceNote: 'Trail access fee ¥1000. Mountain huts ¥5000-15000 per night.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['mount-fuji', 'climbing', 'hiking', 'unesco', 'sunrise', 'spiritual'],
        rating: 4.7,
        attendeeCount: 300000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: false,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Challenging mountain climbing - good physical condition required'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 7, 1, 0, 0),
            endTime: DateTime(now.year, 9, 10, 23, 59),
            title: 'Official Climbing Season',
            description: 'Mountain huts and facilities open',
          ),
        ],
        contactInfo: const ContactInfo(
          website: 'https://www.fujisan-climb.jp',
          phoneNumber: '+81-555-72-1111',
        ),
        highlights: [
          'UNESCO World Heritage site',
          'Japan\'s highest peak (3,776m)',
          'Spectacular sunrise views',
          'Spiritual climbing experience',
          'Mountain hut accommodations',
        ],
        weatherDependency: WeatherDependency.outdoor,
        ageRestriction: const AgeRestriction(
          minAge: 10,
          note: 'Challenging climb requiring good physical condition',
        ),
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Kawaguchiko Station', 'Gotemba Station'],
          directions: {
            'Yoshida Trail': 'Bus from Kawaguchiko Station to 5th Station (50 min)',
            'Subashiri Trail': 'Bus from Kozu Station to Subashiri 5th Station (35 min)',
          },
          hasParkingAvailable: true,
          parkingInfo: 'Parking available at 5th Station ¥1000/day.',
        ),
      ),

      // Sapporo Snow Festival
      EventModel(
        id: 'sapporo-snow-festival-2024',
        name: 'Sapporo Snow Festival',
        description: 'Hokkaido\'s winter wonderland featuring massive snow and ice sculptures.',
        detailedDescription: 'One of Japan\'s most spectacular winter events, featuring enormous snow and ice sculptures created by teams from around the world. The festival transforms Sapporo into a winter wonderland with illuminated sculptures, ice slides, and winter activities. Enjoy hot local food and witness incredible artistic creations made entirely from snow and ice.',
        type: EventType.festival,
        category: EventCategory.nature,
        startDate: DateTime(now.year + 1, 2, 4),
        endDate: DateTime(now.year + 1, 2, 11),
        venue: 'Odori Park, Susukino, Tsudome',
        address: 'Sapporo, Hokkaido, Japan',
        latitude: 43.0642,
        longitude: 141.3469,
        imageUrls: [
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1513475382585-d06e58bcb0e0?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.snowfes.com',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free entry to all sites. Food and activities sold separately.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['snow-festival', 'winter', 'sculptures', 'hokkaido', 'illumination'],
        rating: 4.8,
        attendeeCount: 2000000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible paths', 'Heated rest areas'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year + 1, 2, 4, 0, 0),
            endTime: DateTime(now.year + 1, 2, 11, 22, 0),
            title: 'Snow Sculpture Display',
            description: 'Main sculptures illuminated until 22:00 daily',
          ),
          EventSchedule(
            startTime: DateTime(now.year + 1, 2, 6, 19, 0),
            endTime: DateTime(now.year + 1, 2, 6, 20, 0),
            title: 'Opening Ceremony',
            description: 'Official festival opening with performances',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-11-281-6400',
          website: 'https://www.snowfes.com',
        ),
        highlights: [
          'Massive snow and ice sculptures',
          'International sculpture competition',
          'Evening illuminations',
          'Winter food stalls',
          'Ice slide activities',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Sapporo Station', 'Odori Station'],
          directions: {
            'To Odori Park': 'Walk 5 minutes from Odori Station',
            'To Susukino': 'Walk 10 minutes from Susukino Station',
          },
          hasParkingAvailable: false,
          parkingInfo: 'Limited parking. Public transportation recommended.',
        ),
      ),

      // Tokyo Fashion Week
      EventModel(
        id: 'tokyo-fashion-week-2024',
        name: 'Amazon Fashion Week Tokyo',
        description: 'Japan\'s premier fashion event showcasing cutting-edge Japanese and international designers.',
        detailedDescription: 'Experience the forefront of Japanese fashion at Tokyo Fashion Week, where established and emerging designers showcase their latest collections. From avant-garde streetwear to luxury fashion, witness the creativity that makes Tokyo a global fashion capital. Attend runway shows, exhibitions, and exclusive fashion events.',
        type: EventType.exhibition,
        category: EventCategory.modern,
        startDate: DateTime(now.year + 1, 3, 15),
        endDate: DateTime(now.year + 1, 3, 22),
        venue: 'Shibuya Hikarie, Various Tokyo Venues',
        address: 'Shibuya, Tokyo, Japan',
        latitude: 35.6590,
        longitude: 139.7016,
        imageUrls: [
          'https://images.unsplash.com/photo-1558769132-cb1aea458c5e?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1445205170230-053b83016050?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.fashion-week.tokyo',
        ticketUrl: 'https://tokyo-fashion-week.eventbrite.com',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 3000,
          maxPrice: 25000,
          currency: 'JPY',
          ticketTiers: [
            TicketTier(
              name: 'Exhibition Access',
              price: 3000,
              description: 'Access to fashion exhibitions and pop-up shops',
              isAvailable: true,
            ),
            TicketTier(
              name: 'Runway Show Pass',
              price: 15000,
              description: 'Access to selected runway shows',
              isAvailable: true,
              remainingTickets: 100,
            ),
            TicketTier(
              name: 'VIP Fashion Week Pass',
              price: 25000,
              description: 'All access including exclusive designer meet & greets',
              isAvailable: true,
              remainingTickets: 50,
            ),
          ],
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['fashion', 'runway', 'designers', 'tokyo-style', 'luxury', 'streetwear'],
        rating: 4.5,
        attendeeCount: 50000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: true,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible venues', 'Sign language interpretation for main shows'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year + 1, 3, 15, 10, 0),
            endTime: DateTime(now.year + 1, 3, 15, 18, 0),
            title: 'Opening Day - Emerging Designers',
            description: 'Showcase of new and upcoming fashion talent',
          ),
          EventSchedule(
            startTime: DateTime(now.year + 1, 3, 18, 19, 0),
            endTime: DateTime(now.year + 1, 3, 18, 22, 0),
            title: 'Tokyo Fashion Awards Gala',
            description: 'Awards ceremony and exclusive after-party',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-6434-1515',
          email: 'info@fashion-week.tokyo',
          website: 'https://www.fashion-week.tokyo',
        ),
        highlights: [
          'International and Japanese designers',
          'Avant-garde fashion shows',
          'Fashion industry networking',
          'Pop-up designer boutiques',
          'Fashion photography exhibitions',
        ],
        weatherDependency: WeatherDependency.indoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Shibuya Station'],
          directions: {
            'To Shibuya Hikarie': 'Direct connection from Shibuya Station',
          },
          hasParkingAvailable: true,
          parkingInfo: 'Limited parking ¥400/30min. Public transportation preferred.',
        ),
      ),

      // Kanda Matsuri
      EventModel(
        id: 'kanda-matsuri-2024',
        name: 'Kanda Matsuri',
        description: 'One of Tokyo\'s three great festivals featuring spectacular mikoshi parades.',
        detailedDescription: 'Kanda Matsuri is one of the three great festivals of Tokyo, held every odd-numbered year. Experience the energy of hundreds of portable shrines (mikoshi) being carried through Tokyo\'s streets by enthusiastic participants. The festival celebrates the Kanda Myojin shrine and features traditional music, dance, and the famous blessing ceremony for businesses in the area.',
        type: EventType.festival,
        category: EventCategory.traditional,
        startDate: DateTime(now.year + 1, 5, 10),
        endDate: DateTime(now.year + 1, 5, 18),
        venue: 'Kanda Myojin Shrine & Surrounding Areas',
        address: 'Kanda, Chiyoda City, Tokyo, Japan',
        latitude: 35.7021,
        longitude: 139.7677,
        imageUrls: [
          'https://images.unsplash.com/photo-1545569341-9eb8b30979d9?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.kandamyoujin.or.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: true,
          currency: 'JPY',
          priceNote: 'Free to watch. Food and souvenirs sold separately.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 2,
        ),
        tags: ['kanda-matsuri', 'mikoshi', 'traditional', 'shrine', 'tokyo-festival'],
        rating: 4.7,
        attendeeCount: 1500000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: true,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Wheelchair accessible viewing areas'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year + 1, 5, 11, 8, 0),
            endTime: DateTime(now.year + 1, 5, 11, 17, 0),
            title: 'Mikoshi Parade',
            description: 'Main portable shrine procession through Tokyo',
          ),
          EventSchedule(
            startTime: DateTime(now.year + 1, 5, 17, 10, 0),
            endTime: DateTime(now.year + 1, 5, 17, 16, 0),
            title: 'Business Blessing Ceremony',
            description: 'Traditional blessing for local businesses',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3254-0753',
          website: 'https://www.kandamyoujin.or.jp',
        ),
        highlights: [
          'One of Tokyo\'s three great festivals',
          'Spectacular mikoshi parades',
          'Traditional music and dance',
          'Historical shrine setting',
          'Business district celebrations',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Ochanomizu Station', 'Shin-Ochanomizu Station'],
          directions: {
            'From Ochanomizu Station': 'Walk 5 minutes to Kanda Myojin Shrine',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No parking during festival. Public transportation only.',
        ),
      ),

      // Autumn Leaves Festival
      EventModel(
        id: 'autumn-leaves-kyoto-2024',
        name: 'Kyoto Autumn Leaves Festival',
        description: 'Experience Japan\'s stunning autumn colors in Kyoto\'s historic temples and gardens.',
        detailedDescription: 'Witness the breathtaking transformation of Kyoto\'s temples and gardens during peak autumn colors. This season-long celebration features special night illuminations, traditional tea ceremonies in maple gardens, and guided tours of the most scenic spots. Experience the Japanese appreciation of seasonal beauty through momiji (maple) viewing.',
        type: EventType.seasonal,
        category: EventCategory.nature,
        startDate: DateTime(now.year, 11, 15),
        endDate: DateTime(now.year, 12, 10),
        venue: 'Kiyomizu-dera, Fushimi Inari, Arashiyama',
        address: 'Various temples and gardens in Kyoto',
        latitude: 35.0116,
        longitude: 135.7681,
        imageUrls: [
          'https://images.unsplash.com/photo-1490375988624-9b1f3c04d32b?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1522383225653-ed111181a951?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://kyoto-autumn.jp',
        ticketUrl: null,
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 300,
          maxPrice: 600,
          currency: 'JPY',
          priceNote: 'Temple entry fees ¥300-600. Special illumination events may charge extra.',
        ),
        requiresTicket: false,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.yearly,
          interval: 1,
        ),
        tags: ['autumn-leaves', 'momiji', 'temples', 'gardens', 'illumination', 'kyoto'],
        rating: 4.9,
        attendeeCount: 5000000,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: false,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Some temples have stairs and uneven paths'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, 11, 15, 17, 30),
            endTime: DateTime(now.year, 12, 10, 21, 30),
            title: 'Evening Illuminations',
            description: 'Special lighting of autumn colors at major temples',
          ),
          EventSchedule(
            startTime: DateTime(now.year, 11, 23, 10, 0),
            endTime: DateTime(now.year, 11, 23, 16, 0),
            title: 'Traditional Tea Ceremony',
            description: 'Outdoor tea ceremony in maple gardens',
          ),
        ],
        contactInfo: const ContactInfo(
          website: 'https://kyoto-autumn.jp',
          phoneNumber: '+81-75-343-0548',
        ),
        highlights: [
          'Peak autumn color viewing',
          'Historic temple settings',
          'Evening illuminations',
          'Traditional tea ceremonies',
          'Photography opportunities',
        ],
        weatherDependency: WeatherDependency.outdoor,
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Kyoto Station', 'Gion-Shijo Station'],
          directions: {
            'Multiple temple locations': 'Bus day passes available for temple hopping',
          },
          hasParkingAvailable: false,
          parkingInfo: 'Limited parking at temples. Public transportation recommended.',
        ),
      ),

      // Ninja Experience
      EventModel(
        id: 'ninja-experience-daily',
        name: 'Traditional Ninja Experience Workshop',
        description: 'Learn authentic ninja techniques in a traditional Japanese setting.',
        detailedDescription: 'Step into the shadowy world of ancient Japanese ninjas with this immersive experience. Learn real ninja techniques including stealth movement, shuriken throwing, sword fighting, and ancient martial arts. Dress in traditional ninja attire and train in an authentic dojo setting with experienced martial arts masters.',
        type: EventType.workshop,
        category: EventCategory.traditional,
        startDate: DateTime(now.year, now.month, now.day + 1, 10, 0),
        endDate: DateTime(now.year, now.month, now.day + 1, 12, 0),
        venue: 'Ninja Academy Tokyo',
        address: 'Asakusa, Taito City, Tokyo, Japan',
        latitude: 35.7148,
        longitude: 139.7967,
        imageUrls: [
          'https://images.unsplash.com/photo-1544787219-7f47ccb76574?ixlib=rb-4.0.3',
          'https://images.unsplash.com/photo-1578662996442-48f60103fc96?ixlib=rb-4.0.3',
        ],
        websiteUrl: 'https://www.ninja-experience.jp',
        ticketUrl: 'https://www.ninja-experience.jp/booking',
        priceInfo: const PriceInfo(
          isFree: false,
          minPrice: 6500,
          maxPrice: 12000,
          currency: 'JPY',
          ticketTiers: [
            TicketTier(
              name: 'Basic Ninja Training',
              price: 6500,
              description: 'Basic ninja techniques and costume',
              isAvailable: true,
            ),
            TicketTier(
              name: 'Advanced Ninja Experience',
              price: 12000,
              description: 'Advanced training with weapons and certificate',
              isAvailable: true,
              remainingTickets: 15,
            ),
          ],
        ),
        requiresTicket: true,
        isRecurring: true,
        recurrencePattern: const RecurrencePattern(
          type: RecurrenceType.daily,
          interval: 1,
        ),
        tags: ['ninja', 'martial-arts', 'traditional', 'workshop', 'samurai', 'training'],
        rating: 4.4,
        attendeeCount: 20,
        status: EventStatus.upcoming,
        accessibility: const EventAccessibility(
          wheelchairAccessible: false,
          hasSignLanguage: false,
          hasAudioDescription: false,
          hasBraille: false,
          accessibilityFeatures: ['Physical activity required - good mobility needed'],
        ),
        schedule: [
          EventSchedule(
            startTime: DateTime(now.year, now.month, now.day + 1, 10, 0),
            endTime: DateTime(now.year, now.month, now.day + 1, 10, 30),
            title: 'Ninja History & Costume',
            description: 'Learn ninja history and dress in traditional attire',
          ),
          EventSchedule(
            startTime: DateTime(now.year, now.month, now.day + 1, 10, 30),
            endTime: DateTime(now.year, now.month, now.day + 1, 11, 30),
            title: 'Combat Training',
            description: 'Shuriken throwing and sword techniques',
          ),
          EventSchedule(
            startTime: DateTime(now.year, now.month, now.day + 1, 11, 30),
            endTime: DateTime(now.year, now.month, now.day + 1, 12, 0),
            title: 'Graduation Ceremony',
            description: 'Certificate presentation and photos',
          ),
        ],
        contactInfo: const ContactInfo(
          phoneNumber: '+81-3-3842-0181',
          email: 'info@ninja-experience.jp',
          website: 'https://www.ninja-experience.jp',
        ),
        highlights: [
          'Authentic ninja techniques',
          'Traditional costume included',
          'Professional instruction',
          'Shuriken throwing practice',
          'Ninja graduation certificate',
        ],
        weatherDependency: WeatherDependency.indoor,
        ageRestriction: const AgeRestriction(
          minAge: 8,
          note: 'Children must be accompanied by adults',
        ),
        languages: ['Japanese', 'English'],
        transportationInfo: const TransportationInfo(
          nearestStations: ['Asakusa Station'],
          directions: {
            'From Asakusa Station': 'Walk 5 minutes to traditional district',
          },
          hasParkingAvailable: false,
          parkingInfo: 'No parking available. Public transportation recommended.',
        ),
      ),
    ];
  }
} 
