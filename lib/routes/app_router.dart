import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/prayer/prayer_times_page.dart';
import '../presentation/pages/prayer/qibla_page.dart';
import '../presentation/pages/places/places_map_page.dart';
import '../presentation/pages/places/place_detail_page.dart';
import '../presentation/pages/itinerary/itinerary_list_page.dart';
import '../presentation/pages/itinerary/create_itinerary_page.dart';
import '../presentation/pages/itinerary/itinerary_detail_page.dart';
import '../presentation/pages/ar/ar_navigation_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../data/models/place_model.dart';
import 'route_names.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const MainNavigationWrapper(),
      ),
      GoRoute(
        path: RouteNames.prayer,
        name: 'prayer',
        builder: (context, state) => const PrayerTimesPage(),
      ),
      GoRoute(
        path: RouteNames.qibla,
        name: 'qibla',
        builder: (context, state) => const QiblaPage(),
      ),
      GoRoute(
        path: RouteNames.places,
        name: 'places',
        builder: (context, state) {
          final typeParam = state.uri.queryParameters['type'];
          PlaceType? filterType;

          if (typeParam != null) {
            try {
              filterType = PlaceType.values.firstWhere(
                (type) => type.name == typeParam,
              );
            } catch (e) {
              filterType = null;
            }
          }

          return PlacesMapPage(filterType: filterType);
        },
      ),
      GoRoute(
        path: '/places/detail/:id',
        name: 'place_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PlaceDetailPage(placeId: id);
        },
      ),
      GoRoute(
        path: RouteNames.itinerary,
        name: 'itinerary',
        builder: (context, state) => const ItineraryListPage(),
      ),
      GoRoute(
        path: RouteNames.createItinerary,
        name: 'create_itinerary',
        builder: (context, state) => const CreateItineraryPage(),
      ),
      GoRoute(
        path: '/itinerary/detail/:id',
        name: 'itinerary_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ItineraryDetailPage(itineraryId: id);
        },
      ),
      GoRoute(
        path: '/itinerary/edit/:id',
        name: 'edit_itinerary',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateItineraryPage(itineraryId: id);
        },
      ),
      GoRoute(
        path: RouteNames.arNavigation,
        name: 'ar_navigation',
        builder: (context, state) => const ARNavigationPage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Page Not Found',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'The page you are looking for does not exist.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
}

class MainNavigationWrapper extends StatefulWidget {
  const MainNavigationWrapper({super.key});

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const PrayerTimesPage(),
    const PlacesMapPage(),
    const ItineraryListPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule_outlined),
            activeIcon: Icon(Icons.schedule),
            label: 'Prayer',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Places',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt_outlined),
            activeIcon: Icon(Icons.list_alt),
            label: 'Itinerary',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}