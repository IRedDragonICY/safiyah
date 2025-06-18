import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safiyah/data/repositories/chatbot_repository.dart';
import 'package:safiyah/presentation/bloc/chatbot/chatbot_bloc.dart';
import 'package:safiyah/presentation/bloc/home/home_event.dart';
import 'package:safiyah/presentation/bloc/onboarding/onboarding_bloc.dart';
import 'package:safiyah/presentation/bloc/onboarding/onboarding_event.dart';
import 'package:timezone/data/latest.dart' as tz;

import 'app.dart';
import 'core/services/location_service.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/itinerary_repository.dart';
import 'data/repositories/place_repository.dart';
import 'data/repositories/prayer_repository.dart';
import 'presentation/bloc/auth/auth_bloc.dart';
import 'presentation/bloc/home/home_bloc.dart';
import 'presentation/bloc/itinerary/itinerary_bloc.dart';
import 'presentation/bloc/places/places_bloc.dart';
import 'presentation/bloc/prayer/prayer_bloc.dart';
import 'presentation/bloc/settings/settings_bloc.dart';
import 'presentation/bloc/settings/settings_event.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  tz.initializeTimeZones();

  await Hive.initFlutter();

  await _initializeServices();

  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  runApp(const SafiyahApp());
}

Future<void> _initializeServices() async {
  await StorageService.initialize();
  if (!kIsWeb) {
    await NotificationService.initialize();
    await LocationService.initialize();
  }
}

class SafiyahApp extends StatelessWidget {
  const SafiyahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        ),
        RepositoryProvider<PrayerRepository>(
          create: (context) => PrayerRepository(),
        ),
        RepositoryProvider<PlaceRepository>(
          create: (context) => PlaceRepository(),
        ),
        RepositoryProvider<ItineraryRepository>(
          create: (context) => ItineraryRepository(),
        ),
        RepositoryProvider<ChatbotRepository>(
          create: (context) => ChatbotRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<OnboardingBloc>(
            create: (context) => OnboardingBloc()..add(CheckOnboardingStatus()),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<SettingsBloc>(
            create: (context) => SettingsBloc(
              authRepository: context.read<AuthRepository>(),
              authBloc: context.read<AuthBloc>(),
            )..add(const LoadSettings()),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              prayerRepository: context.read<PrayerRepository>(),
            )..add(const LoadHomeData()),
          ),
          BlocProvider<PrayerBloc>(
            create: (context) => PrayerBloc(
              prayerRepository: context.read<PrayerRepository>(),
            ),
          ),
          BlocProvider<PlacesBloc>(
            create: (context) => PlacesBloc(
              placeRepository: context.read<PlaceRepository>(),
            ),
          ),
          BlocProvider<ItineraryBloc>(
            create: (context) => ItineraryBloc(
              itineraryRepository: context.read<ItineraryRepository>(),
            ),
          ),
          BlocProvider<ChatbotBloc>(
            create: (context) => ChatbotBloc(
              chatbotRepository: context.read<ChatbotRepository>(),
            ),
          ),
        ],
        child: SafiyahMaterialApp(),
      ),
    );
  }
}