import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:safiyah/presentation/pages/chatbot/chatbot_page.dart';
import 'package:safiyah/presentation/pages/chatbot/chat_history_page.dart';
import 'package:safiyah/presentation/pages/chatbot/realtime_chatbot_page.dart';
import 'package:safiyah/presentation/pages/onboarding/onboarding_page.dart';
import 'package:safiyah/presentation/pages/guide_tour/guide_tour_page.dart';
import 'package:safiyah/presentation/pages/guide_tour/guide_tour_detail_page.dart';
import 'package:safiyah/presentation/pages/weather/weather_detail_page.dart';
import 'package:safiyah/presentation/pages/insurance/insurance_page.dart';
import 'package:safiyah/presentation/pages/holiday_package/holiday_package_page.dart';
import 'package:safiyah/presentation/pages/hajj_umroh/hajj_umroh_page.dart';
import 'package:safiyah/presentation/pages/hajj_umroh/hajj_umroh_detail_page.dart';
import 'package:safiyah/presentation/pages/hajj_umroh/hajj_umroh_booking_page.dart';
import 'package:safiyah/presentation/pages/hajj_umroh/hajj_umroh_booking_detail_page.dart';
import 'package:safiyah/presentation/pages/hajj_umroh/hajj_umroh_guide_detail_page.dart';
import 'package:safiyah/presentation/pages/insurance/insurance_detail_page.dart';
import 'package:safiyah/presentation/pages/holiday_package/holiday_package_detail_page.dart';
import 'package:safiyah/presentation/pages/insurance/insurance_comparison_page.dart';
import 'package:safiyah/presentation/pages/hotel/hotel_search_page.dart';
import 'package:safiyah/presentation/pages/purchase/purchase_history_page.dart';
import 'package:safiyah/presentation/pages/transportation/transportation_page.dart';
import 'package:safiyah/presentation/pages/transportation/transportation_guide_page.dart';
import 'package:safiyah/presentation/pages/transportation/flight_detail_page.dart';
import 'package:safiyah/presentation/pages/transportation/train_detail_page.dart';
import 'package:safiyah/presentation/pages/transportation/bus_detail_page.dart';

import '../presentation/pages/home/home_page.dart';
import '../presentation/pages/settings/settings_page.dart';
import '../presentation/pages/settings/currency_selection_page.dart';
import '../presentation/pages/settings/about_page.dart';
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
import '../presentation/pages/prayer/quran_page.dart';
import '../presentation/pages/prayer/surah_info_page.dart';
import '../presentation/pages/prayer/hadith_page.dart';
import '../presentation/pages/prayer/dhikr_page.dart';
import '../presentation/pages/prayer/islamic_books_page.dart';
import '../presentation/pages/places/places_map_page.dart';
import '../presentation/pages/places/place_detail_page.dart';
import '../presentation/pages/itinerary/itinerary_list_page.dart';
import '../presentation/pages/itinerary/create_itinerary_page.dart';
import '../presentation/pages/itinerary/itinerary_detail_page.dart';
import '../presentation/pages/voucher/voucher_page.dart';
import '../presentation/pages/voucher/voucher_history_page.dart';
import '../presentation/pages/events/events_page.dart';
import '../presentation/pages/events/event_detail_page.dart';
import '../presentation/pages/notifications/notifications_page.dart';
import '../presentation/bloc/notifications/notifications_bloc.dart';

import 'route_names.dart';

// Transaction imports
import '../presentation/pages/transaction/transaction_history_page.dart';
import '../presentation/pages/transaction/transaction_detail_page.dart';
import '../presentation/pages/transaction/refund_detail_page.dart';
import '../presentation/pages/transaction/transaction_statistics_page.dart';

// Help Center imports
import '../presentation/pages/help/help_center_page.dart';
import '../presentation/pages/help/help_category_page.dart';
import '../presentation/pages/help/help_article_page.dart';
import '../presentation/pages/help/report_issue_page.dart';

// Payment imports
import '../presentation/pages/payment/payment_page.dart';
import '../presentation/pages/payment/payment_success_page.dart';
import '../data/models/transaction_model.dart';
import '../data/models/quran_model.dart';

// Zakat imports
import '../presentation/pages/zakat/zakat_page.dart';
import '../presentation/pages/zakat/zakat_calculator_page.dart';
import '../presentation/pages/zakat/zakat_reminder_page.dart';
import '../presentation/pages/zakat/zakat_recipients_page.dart';
import '../data/models/zakat_model.dart';

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
      GoRoute(
        path: '/zakat',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'zakat',
        builder: (context, state) => const ZakatPage(),
      ),
      GoRoute(
        path: '/zakat/calculator',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'zakat_calculator',
        builder: (context, state) {
          final zakatType = state.extra as ZakatType;
          return ZakatCalculatorPage(zakatType: zakatType);
        },
      ),
      GoRoute(
        path: '/zakat/reminder',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'zakat_reminder',
        builder: (context, state) => const ZakatReminderPage(),
      ),
      GoRoute(
        path: '/zakat/recipients',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'zakat_recipients',
        builder: (context, state) => const ZakatRecipientsPage(),
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
        path: RouteNames.currencySelection,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'currency_selection',
        builder: (context, state) => const CurrencySelectionPage(),
      ),
      GoRoute(
        path: RouteNames.about,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'about',
        builder: (context, state) => const AboutPage(),
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
      // Islamic Features Routes
      GoRoute(
        path: '/prayer/quran',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'quran',
        builder: (context, state) => const QuranPage(),
      ),
      GoRoute(
        path: '/prayer/hadith',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'hadith',
        builder: (context, state) => const HadithPage(),
      ),
      GoRoute(
        path: '/prayer/dhikr',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'dhikr',
        builder: (context, state) => const DhikrPage(),
      ),
      GoRoute(
        path: '/prayer/books',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'islamic_books',
        builder: (context, state) => const IslamicBooksPage(),
      ),
      GoRoute(
        path: '/prayer/surah/:number',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'surah_info',
        builder: (context, state) {
          final surahNumber = int.parse(state.pathParameters['number']!);
          final allSurahs = QuranData.getAllSurahs();
          final surahInfo = allSurahs.firstWhere(
            (s) => s.number == surahNumber,
            orElse: () => allSurahs[0],
          );
          return SurahInfoPage(surahInfo: surahInfo);
        },
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
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final initialMessage = extra?['initialMessage'] as String?;
          return ChatbotPage(initialMessage: initialMessage);
        },
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
      GoRoute(
        path: RouteNames.voucher,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'voucher',
        builder: (context, state) => const VoucherPage(),
      ),
      GoRoute(
        path: '/voucher/history',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'voucher_history',
        builder: (context, state) => const VoucherHistoryPage(),
      ),
      GoRoute(
        path: '/events/detail/:id',
        parentNavigatorKey: _rootNavigatorKey,
        name: 'event_detail',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return EventDetailPage(eventId: id);
        },
      ),
      GoRoute(
        path: RouteNames.notifications,
        builder: (context, state) => BlocProvider(
          create: (context) => NotificationsBloc(),
          child: const NotificationsPage(),
        ),
      ),
      GoRoute(
        path: RouteNames.events,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'events',
        builder: (context, state) => const EventsPage(),
      ),
      GoRoute(
        path: RouteNames.guideTour,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'guide_tour',
        builder: (context, state) => const GuideTourPage(),
      ),
      GoRoute(
        path: RouteNames.guideTourDetail,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'guide_tour_detail',
        builder: (context, state) {
          final country = state.uri.queryParameters['country'] ?? 'Japan';
          return GuideTourDetailPage(country: country);
        },
      ),
      GoRoute(
        path: RouteNames.weather,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'weather',
        builder: (context, state) => const WeatherDetailPage(),
      ),
      GoRoute(
        path: RouteNames.insurance,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'insurance',
        builder: (context, state) => const InsurancePage(),
      ),
      GoRoute(
        path: RouteNames.holidayPackage,
        parentNavigatorKey: _rootNavigatorKey,
        name: 'holiday_package',
        builder: (context, state) => const HolidayPackagePage(),
      ),
             GoRoute(
         path: RouteNames.hajjUmroh,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'hajj_umroh',
         builder: (context, state) => const HajjUmrohPage(),
       ),
       GoRoute(
         path: '/hajj-umroh/detail/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'hajj_umroh_detail',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return HajjUmrohDetailPage(packageId: id);
         },
       ),
       GoRoute(
         path: '/hajj-umroh/booking/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'hajj_umroh_booking',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return HajjUmrohBookingPage(packageId: id);
         },
       ),
       GoRoute(
         path: '/hajj-umroh/booking-detail/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'hajj_umroh_booking_detail',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return HajjUmrohBookingDetailPage(bookingId: id);
         },
       ),
       GoRoute(
         path: '/hajj-umroh/guide/:type',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'hajj_umroh_guide',
         builder: (context, state) {
           final type = state.pathParameters['type']!;
           return HajjUmrohGuideDetailPage(guideType: type);
         },
       ),
       GoRoute(
         path: '/insurance/detail/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'insurance_detail',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return InsuranceDetailPage(insuranceId: id);
         },
       ),
       GoRoute(
         path: '/holiday-package/detail/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'holiday_package_detail',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return HolidayPackageDetailPage(packageId: id);
         },
       ),
       GoRoute(
         path: '/insurance/comparison',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'insurance_comparison',
         builder: (context, state) => const InsuranceComparisonPage(),
       ),
       GoRoute(
         path: RouteNames.hotelSearch,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'hotel_search',
         builder: (context, state) {
           final filters = state.uri.queryParameters;
           return HotelSearchPage(filters: filters);
         },
       ),
       GoRoute(
         path: RouteNames.purchaseHistory,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'purchase_history',
         builder: (context, state) => const PurchaseHistoryPage(),
       ),
       // Transportation routes
       GoRoute(
         path: '/transportation',
         name: RouteNames.transportation,
         builder: (context, state) {
           final tabIndex = state.uri.queryParameters['tab'];
           return TransportationPage(
             initialTabIndex: tabIndex != null ? int.tryParse(tabIndex) : null,
           );
         },
       ),
       GoRoute(
         path: RouteNames.transportationGuide,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'transportation_guide',
         builder: (context, state) => const TransportationGuidePage(),
       ),
       
       // Transportation Detail routes
       GoRoute(
         path: '/transportation/flight/:flightId',
         name: 'flight-detail',
         builder: (context, state) => FlightDetailPage(
           flightId: state.pathParameters['flightId']!,
         ),
       ),
       GoRoute(
         path: '/transportation/train/:trainId',
         name: 'train-detail',
         builder: (context, state) => TrainDetailPage(
           trainId: state.pathParameters['trainId']!,
         ),
       ),
       GoRoute(
         path: '/transportation/bus/:busId',
         name: 'bus-detail',
         builder: (context, state) => BusDetailPage(
           busId: state.pathParameters['busId']!,
         ),
       ),
       GoRoute(
         path: '/transportation/ride/:rideId',
         name: 'ride-detail',
         builder: (context, state) => Scaffold(
           appBar: AppBar(title: const Text('Ride Details')),
           body: Center(
             child: Text('Ride service details for ID: ${state.pathParameters['rideId']}'),
           ),
         ),
       ),
       GoRoute(
         path: '/transportation/rental/:rentalId',
         name: 'rental-detail',
         builder: (context, state) => Scaffold(
           appBar: AppBar(title: const Text('Rental Details')),
           body: Center(
             child: Text('Rental details for ID: ${state.pathParameters['rentalId']}'),
           ),
         ),
       ),
       
       // Transaction routes
       GoRoute(
         path: RouteNames.transactionHistory,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'transaction_history',
         builder: (context, state) => const TransactionHistoryPage(),
       ),
       GoRoute(
         path: '/transaction/detail/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'transaction_detail',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return TransactionDetailPage(transactionId: id);
         },
       ),
       GoRoute(
         path: '/transaction/refund/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'transaction_refund',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return RefundDetailPage(transactionId: id);
         },
       ),
       GoRoute(
         path: RouteNames.transactionStatistics,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'transaction_statistics',
         builder: (context, state) => const TransactionStatisticsPage(),
       ),
       
       // Help Center routes
       GoRoute(
         path: RouteNames.helpCenter,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'help_center',
         builder: (context, state) => const HelpCenterPage(),
       ),
       GoRoute(
         path: '/help/category/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'help_category',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return HelpCategoryPage(categoryId: id);
         },
       ),
       GoRoute(
         path: '/help/article/:id',
         parentNavigatorKey: _rootNavigatorKey,
         name: 'help_article',
         builder: (context, state) {
           final id = state.pathParameters['id']!;
           return HelpArticlePage(articleId: id);
         },
       ),
       GoRoute(
         path: RouteNames.helpReportIssue,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'help_report_issue',
         builder: (context, state) => const ReportIssuePage(),
       ),
       
       // Payment routes
       GoRoute(
         path: RouteNames.payment,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'payment',
         builder: (context, state) {
           final extra = state.extra as Map<String, dynamic>;
           return PaymentPage(
             orderDetails: extra['orderDetails'] as Map<String, dynamic>,
             amount: extra['amount'] as double,
             currency: extra['currency'] as String,
             transactionType: extra['transactionType'] as TransactionType,
           );
         },
       ),
       GoRoute(
         path: RouteNames.paymentSuccess,
         parentNavigatorKey: _rootNavigatorKey,
         name: 'payment_success',
         builder: (context, state) {
           final extra = state.extra as Map<String, dynamic>?;
           return PaymentSuccessPage(
             transactionId: extra?['transactionId'] as String?,
             amount: extra?['amount'] as double?,
             paymentMethod: extra?['paymentMethod'] as PaymentMethod?,
             orderDetails: extra?['orderDetails'] as Map<String, dynamic>?,
           );
         },
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
