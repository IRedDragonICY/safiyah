import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:safiyah/routes/route_names.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/ai_accessibility_service.dart';
import '../../bloc/home/home_bloc.dart';
import '../../bloc/home/home_event.dart';
import '../../bloc/home/home_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/ai_accessibility_widget.dart';
import '../../widgets/home/quick_actions_widget.dart';
import '../../widgets/home/currency_widget.dart';
import '../../widgets/notifications/notification_badge.dart';
import '../../widgets/insurance/insurance_card.dart';
import '../../widgets/holiday_package/holiday_package_card.dart';
import '../../widgets/hajj_umroh/hajj_umroh_card.dart';
import '../../widgets/home/transportation_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AIAccessibilityService _aiService = AIAccessibilityService();

  @override
  void initState() {
    super.initState();
    // Demo: Enable AI features for demonstration
    _enableDemoAccessibilityFeatures();
  }

  void _enableDemoAccessibilityFeatures() {
    // For demo purposes, let's enable some accessibility features
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _aiService.enableEyeControl();
        _aiService.enableRealtimeAssistance();
        _aiService.enableVoiceCommands();
      }
    });
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'sunny':
      case 'clear':
        return Icons.wb_sunny_outlined;
      case 'partly cloudy':
      case 'cloudy':
      case 'overcast':
        return Icons.wb_cloudy_outlined;
      case 'rainy':
      case 'rain':
        return Icons.water_drop_outlined;
      case 'thunderstorm':
        return Icons.flash_on_outlined;
      case 'snowy':
      case 'snow':
        return Icons.ac_unit_outlined;
      default:
        return Icons.wb_sunny_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading) {
                return const Center(child: LoadingWidget());
              }

              if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        state.message,
                        style: Theme.of(context).textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              if (state is HomeLoaded) {
                // Announce content for screen reader
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _aiService.announceContent(
                    'Home page loaded. Next prayer: ${state.prayerTimes.getNextPrayer()?.name ?? 'None'}. '
                    'Weather: ${state.weather.temperature.round()} degrees, ${state.weather.condition}.'
                  );
                });

                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<HomeBloc>().add(const LoadHomeData());
                  },
                  child: CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: _buildHeroHeader(context, state),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16.0),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate([
                            const CurrencyWidget(),
                            const SizedBox(height: 16),
                            const QuickActionsWidget(),
                            const SizedBox(height: 24),
                            const TransportationWidget(),
                            const SizedBox(height: 24),
                            _buildNewServices(context),
                            const SizedBox(height: 24),
                            _buildRecentItineraries(context),
                            const SizedBox(height: 24),
                            _buildNearbyPlaces(context),
                            const SizedBox(height: 100),
                          ]),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
        // AI Accessibility Widget overlay
        const AIAccessibilityWidget(),
      ],
    );
  }

  Widget _buildHeroHeader(BuildContext context, HomeLoaded state) {
    final nextPrayer = state.prayerTimes.getNextPrayer();
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.all(16.0),
      height: 300,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28.0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                'https://images.unsplash.com/photo-1542051841857-5f90071e7989?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80',
                fit: BoxFit.cover,
                color: Colors.black.withValues(alpha: 0.3),
                colorBlendMode: BlendMode.darken,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.8)
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              bottom: 24,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (nextPrayer != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Next Prayer: ${nextPrayer.name}',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          timeFormat.format(nextPrayer.time),
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
            Positioned(
              right: 24,
              bottom: 24,
              child: InkWell(
                onTap: () => context.push('/weather'),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        _getWeatherIcon(state.weather.condition),
                        color: Colors.white,
                        size: 24,
                      ),
                      const SizedBox(width: 8),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${state.weather.temperature.round()}°',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              height: 1,
                            ),
                          ),
                          Text(
                            state.weather.condition,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.chevron_right,
                        color: Colors.white.withValues(alpha: 0.7),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.prayerTimes.locationName,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  Text(
                    'Japan',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w400,
                        ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(24)
                  ),
                  child: Row(
                    children: [
                       IconButton(
                        icon: const Icon(Icons.auto_awesome_outlined, color: Colors.white),
                        onPressed: () => context.push(RouteNames.chatbot),
                        tooltip: 'AI Assistant',
                      ),
                                             NotificationBadge(
                         child: IconButton(
                           icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                           onPressed: () => context.push(RouteNames.notifications),
                           tooltip: 'Notifications',
                         ),
                       ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, color: Colors.white),
                        onPressed: () => context.push(RouteNames.settings),
                        tooltip: 'Settings',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewServices(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Additional Services',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        const InsuranceCard(),
        const SizedBox(height: 16),
        const HolidayPackageCard(),
        const SizedBox(height: 16),
        const HajjUmrohCard(),
      ],
    );
  }

  Widget _buildRecentItineraries(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Itineraries',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.push('/itinerary'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 2,
            itemBuilder: (context, index) {
              final itineraries = [
                {
                  'title': 'Spiritual Journey',
                  'location': 'Tokyo, Japan',
                  'desc':
                      'Exploring the rich culture and serene mosques of Tokyo.',
                  'date': 'Apr 10 - Apr 17',
                  'status': 'Upcoming',
                  'id': '3'
                },
                {
                  'title': 'Kyoto & Osaka Tour',
                  'location': 'Kyoto, Japan',
                  'desc': 'Discovering the historic temples and halal food.',
                  'date': 'May 05 - May 12',
                  'status': 'Upcoming',
                  'id': '4'
                }
              ];
              final itinerary = itineraries[index];

              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                child: Card(
                  elevation: AppConstants.cardElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: InkWell(
                    onTap: () =>
                        context.push('/itinerary/detail/${itinerary['id']}'),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: AppColors.primary,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      itinerary['title'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      itinerary['location'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            itinerary['desc'] as String,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 14,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                itinerary['date'] as String,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.success.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  itinerary['status'] as String,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppColors.success,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNearbyPlaces(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Nearby Places',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            TextButton(
              onPressed: () => context.push('/places'),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 4,
            itemBuilder: (context, index) {
              final places = [
                {
                  'name': 'Tokyo Camii',
                  'type': 'Mosque',
                  'distance': '1.2 km',
                  'icon': Icons.mosque
                },
                {
                  'name': 'Halal Ramen',
                  'type': 'Restaurant',
                  'distance': '0.8 km',
                  'icon': Icons.restaurant
                },
                {
                  'name': 'Shinjuku Gyoen',
                  'type': 'Park',
                  'distance': '2.5 km',
                  'icon': Icons.park
                },
                {
                  'name': 'Gyomu Super',
                  'type': 'Store',
                  'distance': '0.5 km',
                  'icon': Icons.store
                },
              ];

              final place = places[index];

              return Container(
                width: 140,
                margin: const EdgeInsets.only(right: 12),
                child: Card(
                  elevation: AppConstants.cardElevation,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                  ),
                  child: InkWell(
                    onTap: () => context.push('/places/detail/mosque_jp_1'),
                    borderRadius:
                        BorderRadius.circular(AppConstants.borderRadius),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              place['icon'] as IconData,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            place['name'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            place['type'] as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  color: Colors.grey[600],
                                ),
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              place['distance'] as String,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppColors.secondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
