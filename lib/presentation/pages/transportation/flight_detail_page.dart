import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/flight_model.dart';
import '../../../data/repositories/transportation_repository.dart';
import '../../widgets/common/loading_widget.dart';

class FlightDetailPage extends StatefulWidget {
  final String flightId;
  
  const FlightDetailPage({
    super.key,
    required this.flightId,
  });

  @override
  State<FlightDetailPage> createState() => _FlightDetailPageState();
}

class _FlightDetailPageState extends State<FlightDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TransportationRepository _repository = TransportationRepository();
  FlightModel? _flight;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadFlightDetails();
  }

  Future<void> _loadFlightDetails() async {
    try {
      final flights = await _repository.getFlights(
        from: 'Tokyo',
        to: 'Osaka',
        date: DateTime.now(),
      );
      
      setState(() {
        _flight = flights.isNotEmpty ? flights.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: LoadingWidget()),
      );
    }

    if (_flight == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Flight Details'),
        ),
        body: const Center(
          child: Text('Flight not found'),
        ),
      );
    }

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 280,
              floating: false,
              pinned: true,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                background: _buildFlightHeader(),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.secondary,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Details'),
                  Tab(text: 'Amenities'),
                  Tab(text: 'Policies'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildDetailsTab(),
            _buildAmenitiesTab(),
            _buildPoliciesTab(),
            _buildReviewsTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingBottomBar(),
    );
  }

  Widget _buildFlightHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.primaryGradient,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.flight_takeoff,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _flight!.airline,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _flight!.flightNumber,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_flight!.isHalalCertified)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Text(
                        'HALAL CERTIFIED',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(_flight!.departureTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _flight!.departure,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.flight_takeoff, color: Colors.white, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        _flight!.formattedDuration,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(_flight!.arrivalTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _flight!.arrival,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Flight Information',
            [
              _buildInfoRow('Aircraft', _flight!.aircraftType),
              _buildInfoRow('Flight Duration', _flight!.formattedDuration),
              _buildInfoRow('Distance', '500 km'),
              _buildInfoRow('On-time Performance', '95%'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Schedule Details',
            [
              _buildInfoRow('Departure Date', DateFormat('MMM dd, yyyy').format(_flight!.departureTime)),
              _buildInfoRow('Departure Time', DateFormat('HH:mm').format(_flight!.departureTime)),
              _buildInfoRow('Arrival Time', DateFormat('HH:mm').format(_flight!.arrivalTime)),
              _buildInfoRow('Terminal', 'Terminal 1'),
              _buildInfoRow('Gate', 'A12'),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Available Classes',
            _flight!.availableClasses.map((cls) => 
              _buildClassCard(cls)
            ).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_flight!.isHalalCertified) ...[
            _buildSectionCard(
              'Halal Services',
              [
                _buildAmenityItem(Icons.restaurant_menu, 'Halal Meals Available', _flight!.halalFeatures.halalMeals),
                _buildAmenityItem(Icons.explore, 'Qibla Direction', _flight!.halalFeatures.qiblaDirection),
                _buildAmenityItem(Icons.schedule, 'Prayer Time Notifications', _flight!.halalFeatures.prayerScheduleNotification),
                _buildAmenityItem(Icons.no_drinks, 'Alcohol-free Service', _flight!.halalFeatures.alcoholFreeService),
                _buildAmenityItem(Icons.pets, 'No-Pet Policy', _flight!.halalFeatures.noPetPolicy),
              ],
            ),
            const SizedBox(height: 16),
          ],
          _buildSectionCard(
            'In-Flight Entertainment',
            [
              _buildAmenityItem(Icons.tv, 'Personal Entertainment System', true),
              _buildAmenityItem(Icons.wifi, 'WiFi Available', true),
              _buildAmenityItem(Icons.power, 'Power Outlets', true),
              _buildAmenityItem(Icons.headphones, 'Noise-Canceling Headphones', false),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Comfort & Services',
            [
              _buildAmenityItem(Icons.airline_seat_recline_extra, 'Reclining Seats', true),
              _buildAmenityItem(Icons.local_cafe, 'Complimentary Beverages', true),
              _buildAmenityItem(Icons.luggage, 'Checked Baggage (23kg)', true),
              _buildAmenityItem(Icons.accessible, 'Wheelchair Accessible', true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPoliciesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPolicyCard(
            'Baggage Policy',
            Icons.luggage,
            [
              'Carry-on: 7kg, 55x40x20cm',
              'Checked: 23kg included',
              'Additional bags: ¥5,000 each',
              'Oversized items: ¥8,000',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Cancellation Policy',
            Icons.cancel,
            [
              'Free cancellation up to 24h before departure',
              'Cancellation fee: ¥5,000 within 24h',
              'No refund for no-shows',
              'Travel insurance recommended',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Change Policy',
            Icons.edit,
            [
              'Date change: ¥3,000 fee + fare difference',
              'Name change: ¥5,000 fee',
              'Route change: Subject to availability',
              'Changes must be made 2h before departure',
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${_flight!.rating}',
                style: const TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < _flight!.rating.floor() ? Icons.star : Icons.star_border,
                          color: AppColors.secondary,
                          size: 20,
                        );
                      }),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_flight!.totalReviews} reviews',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildReviewBreakdown(),
          const SizedBox(height: 24),
          Text(
            'Recent Reviews',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ..._buildReviewsList(),
        ],
      ),
    );
  }

  Widget _buildSectionCard(String title, List<Widget> children) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClassCard(String className) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.event_seat, color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            className,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String title, bool available) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(
            icon,
            color: available ? AppColors.success : Colors.grey[400],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: available ? Colors.black87 : Colors.grey[600],
                fontWeight: available ? FontWeight.w500 : FontWeight.normal,
              ),
            ),
          ),
          Icon(
            available ? Icons.check_circle : Icons.cancel,
            color: available ? AppColors.success : Colors.grey[400],
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyCard(String title, IconData icon, List<String> policies) {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: AppColors.primary),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...policies.map((policy) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8, right: 8),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      policy,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewBreakdown() {
    final categories = [
      {'name': 'Service', 'rating': 4.5},
      {'name': 'Comfort', 'rating': 4.2},
      {'name': 'Food', 'rating': 4.7},
      {'name': 'Entertainment', 'rating': 4.1},
      {'name': 'Value', 'rating': 4.3},
    ];

    return Column(
      children: categories.map((category) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  category['name'] as String,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: LinearProgressIndicator(
                  value: (category['rating'] as double) / 5,
                  backgroundColor: Colors.grey[300],
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.secondary),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${category['rating']}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildReviewsList() {
    final reviews = [
      {
        'name': 'Ahmad Rahman',
        'rating': 5,
        'date': '2 days ago',
        'comment': 'Excellent halal service! The meals were delicious and prayer times were announced. Very comfortable flight.',
      },
      {
        'name': 'Sarah Johnson',
        'rating': 4,
        'date': '1 week ago',
        'comment': 'Good service overall. The entertainment system was great and staff was helpful.',
      },
      {
        'name': 'Yuki Tanaka',
        'rating': 5,
        'date': '2 weeks ago',
        'comment': 'Perfect flight experience. On time, clean aircraft, and professional crew.',
      },
    ];

    return reviews.map((review) {
      return Card(
        margin: const EdgeInsets.only(bottom: 12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: Text(
                      (review['name'] as String)[0],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          review['name'] as String,
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < (review['rating'] as int) ? Icons.star : Icons.star_border,
                                  color: AppColors.secondary,
                                  size: 16,
                                );
                              }),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              review['date'] as String,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                review['comment'] as String,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  Widget _buildBookingBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Starting from',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                Text(
                  '¥${NumberFormat('#,###').format(_flight!.price)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          ElevatedButton(
            onPressed: () {
              // Navigate to booking page
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking feature coming soon!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Book Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 