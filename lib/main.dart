import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:safiyah/presentation/bloc/home/home_event.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize timezone data
  tz.initializeTimeZones();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Initialize services
  await _initializeServices();
  
  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  runApp(SafiyahApp());
}

Future<void> _initializeServices() async {
  await StorageService.initialize();
  await NotificationService.initialize();
  await LocationService.initialize();
}

class SafiyahApp extends StatelessWidget {
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
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<HomeBloc>(
            create: (context) => HomeBloc(
              prayerRepository: context.read<PrayerRepository>(),
            )..add(LoadHomeData()),
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
        ],
        child: SafiyahMaterialApp(),
      ),
    );
  }
}