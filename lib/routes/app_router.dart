import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/presentation/pages/chatbot/chatbot_page.dart';
import 'package:safiyah/presentation/pages/chatbot/chat_history_page.dart';
import 'package:safiyah/presentation/pages/chatbot/realtime_chatbot_page.dart';
import 'package:safiyah/presentation/pages/onboarding/onboarding_page.dart';

import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/subscription/subscription_page.dart';
import '../presentation/pages/splash/splash_page.dart';
import '../presentation/pages/auth/login_page.dart';
import '../presentation/pages/auth/register_page.dart';
import '../presentation/pages/auth/personalization_page.dart';
import '../presentation/pages/legal/terms_of_service_page.dart';
import '../presentation/pages/boycott/boycott_page.dart';
import '../presentation/pages/currency/currency_page.dart';
import '../presentation/pages/main_navigation_wrapper.dart';
import '../presentation/pages/prayer/prayer_times_page.dart';
import '../presentation/pages/prayer/qibla_page.dart';
import '../presentation/pages/places/places_map_page.dart';
import '../presentation/pages/places/place_detail_page.dart';
import '../presentation/pages/itinerary/itinerary_list_page.dart';
import '../presentation/pages/itinerary/create_itinerary_page.dart';
import '../presentation/pages/itinerary/itinerary_detail_page.dart';

import 'route_names.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingPage(),
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
        path: RouteNames.personalization,
        name: 'personalization',
        builder: (context, state) => const PersonalizationPage(),
      ),
      GoRoute(
        path: RouteNames.termsOfService,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'terms_of_service',
        builder: (context, state) => const TermsOfServicePage(),
      ),
      GoRoute(
        path: RouteNames.boycott,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'boycott',
        builder: (context, state) => const BoycottPage(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.home,
                name: 'home',
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.prayer,
                name: 'prayer',
                builder: (context, state) => const PrayerTimesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.itinerary,
                name: 'itinerary',
                builder: (context, state) => const ItineraryListPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: RouteNames.places,
                name: 'places',
                builder: (context, state) => const PlacesMapPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.settings,
        name: 'settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: RouteNames.subscription,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'subscription',
        builder: (context, state) => const SubscriptionPage(),
      ),
      GoRoute(
        path: RouteNames.qibla,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'qibla',
        builder: (context, state) => const QiblaPage(),
      ),
      GoRoute(
        path: '/places/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'place_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return PlaceDetailPage(placeId: id);
        },
      ),
      GoRoute(
        path: RouteNames.createItinerary,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'create_itinerary',
        builder: (context, state) => const CreateItineraryPage(),
      ),
      GoRoute(
        path: '/itinerary/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'itinerary_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ItineraryDetailPage(itineraryId: id);
        },
      ),
      GoRoute(
        path: '/itinerary/edit/:id',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'edit_itinerary',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return CreateItineraryPage(itineraryId: id);
        },
      ),

      GoRoute(
        path: RouteNames.chatbot,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'chatbot',
        builder: (context, state) => const ChatbotPage(),
      ),
      GoRoute(
        path: RouteNames.chatHistory,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'chat_history',
        builder: (context, state) => const ChatHistoryPage(),
      ),
      GoRoute(
        path: RouteNames.realtimeChatbot,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'realtime_chatbot',
        builder: (context, state) => const RealtimeChatbotPage(),
      ),
      GoRoute(
        path: RouteNames.currency,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'currency',
        builder: (context, state) => const CurrencyPage(),
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
