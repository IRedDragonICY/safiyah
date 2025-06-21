import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/transport_model.dart';
import '../../../data/repositories/transportation_repository.dart';
import '../../widgets/common/loading_widget.dart';

class BusDetailPage extends StatefulWidget {
  final String busId;
  
  const BusDetailPage({
    super.key,
    required this.busId,
  });

  @override
  State<BusDetailPage> createState() => _BusDetailPageState();
}

class _BusDetailPageState extends State<BusDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TransportationRepository _repository = TransportationRepository();
  BusModel? _bus;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadBusDetails();
  }

  Future<void> _loadBusDetails() async {
    try {
      final buses = await _repository.getBuses(
        from: 'Tokyo',
        to: 'Osaka',
        date: DateTime.now(),
      );
      
      setState(() {
        _bus = buses.isNotEmpty ? buses.first : null;
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

    if (_bus == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Bus Details'),
        ),
        body: const Center(
          child: Text('Bus not found'),
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
                background: _buildBusHeader(),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.secondary,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Route'),
                  Tab(text: 'Amenities'),
                  Tab(text: 'Policies'),
                ],
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildRouteTab(),
            _buildAmenitiesTab(),
            _buildPoliciesTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingBottomBar(),
    );
  }

  Widget _buildBusHeader() {
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
                      Icons.directions_bus,
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
                          _bus!.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Highway Express Bus',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'EXPRESS',
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
                          DateFormat('HH:mm').format(_bus!.departureTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _bus!.departure,
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
                      Icon(Icons.directions_bus, color: Colors.white, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        _bus!.formattedDuration,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(_bus!.arrivalTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _bus!.arrival,
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

  Widget _buildRouteTab() {
    final stops = [
      {'name': 'Tokyo Station', 'time': '08:00', 'type': 'departure'},
      {'name': 'Ebisu SA', 'time': '09:15', 'type': 'rest'},
      {'name': 'Komagane IC', 'time': '10:45', 'type': 'rest'},
      {'name': 'Nagoya Station', 'time': '12:30', 'type': 'stop'},
      {'name': 'Kusatsu PA', 'time': '14:00', 'type': 'rest'},
      {'name': 'Osaka Station', 'time': '15:30', 'type': 'arrival'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Route Information',
            [
              _buildInfoRow('Total Distance', '515 km'),
              _buildInfoRow('Estimated Travel Time', '7h 30m'),
              _buildInfoRow('Number of Stops', '6'),
              _buildInfoRow('Rest Stops', '3'),
            ],
          ),
          const SizedBox(height: 16),
          Card(
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
                    'Stops Schedule',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...stops.map((stop) => _buildStopItem(stop)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStopItem(Map<String, String> stop) {
    IconData icon;
    Color color;
    
    switch (stop['type']) {
      case 'departure':
        icon = Icons.departure_board;
        color = AppColors.primary;
        break;
      case 'arrival':
        icon = Icons.location_on;
        color = AppColors.primary;
        break;
      case 'stop':
        icon = Icons.stop_circle;
        color = AppColors.secondary;
        break;
      default:
        icon = Icons.local_gas_station;
        color = Colors.grey[600]!;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              stop['name']!,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Text(
            stop['time']!,
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
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
          _buildSectionCard(
            'Comfort Features',
            [
              _buildAmenityItem(Icons.airline_seat_recline_extra, 'Reclining Seats', true),
              _buildAmenityItem(Icons.ac_unit, 'Air Conditioning', true),
              _buildAmenityItem(Icons.power, 'USB Charging Ports', true),
              _buildAmenityItem(Icons.wifi, 'Free WiFi', true),
              _buildAmenityItem(Icons.luggage, 'Luggage Compartment', true),
              _buildAmenityItem(Icons.wc, 'Onboard Restroom', true),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Entertainment & Services',
            [
              _buildAmenityItem(Icons.tv, 'Personal TV Screens', false),
              _buildAmenityItem(Icons.local_cafe, 'Refreshment Service', false),
              _buildAmenityItem(Icons.headphones, 'Audio System', true),
              _buildAmenityItem(Icons.bed, 'Blankets Available', true),
              _buildAmenityItem(Icons.accessible, 'Wheelchair Accessible', true),
              _buildAmenityItem(Icons.child_care, 'Baby Seat Available', true),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Safety Features',
            [
              _buildAmenityItem(Icons.security, 'GPS Tracking', true),
              _buildAmenityItem(Icons.health_and_safety, 'Emergency Equipment', true),
              _buildAmenityItem(Icons.local_fire_department, 'Fire Extinguisher', true),
              _buildAmenityItem(Icons.medical_services, 'First Aid Kit', true),
              _buildAmenityItem(Icons.warning, 'Safety Briefing', true),
              _buildAmenityItem(Icons.phone, 'Emergency Communication', true),
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
            'Booking Policy',
            Icons.confirmation_number,
            [
              'Advance booking recommended, especially for peak times',
              'Tickets can be purchased online or at the terminal',
              'Seat selection available for premium seats',
              'Group discounts available for 10+ passengers',
              'Student and senior discounts with valid ID',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Cancellation & Changes',
            Icons.cancel,
            [
              'Free cancellation up to 2 hours before departure',
              'Cancellation fee: ¥500 within 2 hours',
              'Date changes: ¥200 fee + fare difference',
              'No refund for no-shows',
              'Weather-related cancellations: full refund',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Luggage Policy',
            Icons.luggage,
            [
              'Each passenger: 1 large bag + 1 carry-on',
              'Maximum weight: 20kg per bag',
              'Oversized luggage: additional ¥500',
              'Valuable items: keep with you',
              'Prohibited items: flammable, dangerous goods',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Travel Guidelines',
            Icons.info,
            [
              'Arrive at terminal 15 minutes before departure',
              'Have ticket and ID ready for boarding',
              'Smoking is prohibited on all buses',
              'Eating and drinking allowed (no alcohol)',
              'Keep noise levels down for other passengers',
              'Follow crew instructions at all times',
            ],
          ),
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
                  '¥${NumberFormat('#,###').format(_bus!.price)}',
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
              'Book Ticket',
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