import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/train_model.dart';
import '../../../data/repositories/transportation_repository.dart';
import '../../widgets/common/loading_widget.dart';

class TrainDetailPage extends StatefulWidget {
  final String trainId;
  
  const TrainDetailPage({
    super.key,
    required this.trainId,
  });

  @override
  State<TrainDetailPage> createState() => _TrainDetailPageState();
}

class _TrainDetailPageState extends State<TrainDetailPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TransportationRepository _repository = TransportationRepository();
  TrainModel? _train;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTrainDetails();
  }

  Future<void> _loadTrainDetails() async {
    try {
      final trains = await _repository.getTrains(
        from: 'Tokyo',
        to: 'Osaka',
        date: DateTime.now(),
      );
      
      setState(() {
        _train = trains.isNotEmpty ? trains.first : null;
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

    if (_train == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Train Details'),
        ),
        body: const Center(
          child: Text('Train not found'),
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
                background: _buildTrainHeader(),
              ),
              bottom: TabBar(
                controller: _tabController,
                indicatorColor: AppColors.secondary,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: const [
                  Tab(text: 'Route'),
                  Tab(text: 'Amenities'),
                  Tab(text: 'Info'),
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
            _buildInfoTab(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBookingBottomBar(),
    );
  }

  Widget _buildTrainHeader() {
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
                      Icons.train,
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
                          _train!.trainLine,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_train!.trainType} • ${_train!.trainNumber}',
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
                      color: _train!.trainType == 'Shinkansen' 
                          ? AppColors.secondary 
                          : AppColors.success,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      _train!.trainType.toUpperCase(),
                      style: const TextStyle(
                        color: Colors.black,
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
                          DateFormat('HH:mm').format(_train!.departureTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _train!.departure,
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
                      Icon(Icons.train, color: Colors.white, size: 20),
                      const SizedBox(height: 4),
                      Text(
                        _train!.formattedDuration,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          DateFormat('HH:mm').format(_train!.arrivalTime),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _train!.arrival,
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Route Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
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
                children: _train!.stops.asMap().entries.map((entry) {
                  final index = entry.key;
                  final stop = entry.value;
                  final isFirst = index == 0;
                  final isLast = index == _train!.stops.length - 1;
                  
                  return _buildStopItem(stop, isFirst, isLast);
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Journey Details',
            [
              _buildInfoRow('Total Distance', '515 km'),
              _buildInfoRow('Number of Stops', '${_train!.stops.length}'),
              _buildInfoRow('Maximum Speed', _train!.trainType == 'Shinkansen' ? '320 km/h' : '130 km/h'),
              _buildInfoRow('Platform', _train!.platform),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStopItem(TrainStop stop, bool isFirst, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              if (!isFirst)
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.primary,
                ),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: isFirst || isLast ? AppColors.primary : Colors.grey[400],
                  shape: BoxShape.circle,
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 20,
                  color: AppColors.primary,
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.stationName,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        'Arr: ${DateFormat('HH:mm').format(stop.arrivalTime)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Text(
                        'Dep: ${DateFormat('HH:mm').format(stop.departureTime)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  if (stop.stopDuration > 0) ...[
                    const SizedBox(height: 2),
                    Text(
                      'Stop: ${stop.stopDuration} min',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
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
            'Train Features',
            [
              _buildAmenityItem(Icons.wifi, 'Free WiFi', _train!.features.wifiAvailable),
              _buildAmenityItem(Icons.power, 'Power Outlets', _train!.features.powerOutlets),
              _buildAmenityItem(Icons.airline_seat_recline_extra, 'Reclining Seats', true),
              _buildAmenityItem(Icons.restaurant, 'Food Service', _train!.trainType == 'Shinkansen'),
              _buildAmenityItem(Icons.luggage, 'Luggage Storage', _train!.features.baggageStorage),
              _buildAmenityItem(Icons.accessible, 'Wheelchair Access', _train!.features.wheelchair),
            ],
          ),
          const SizedBox(height: 16),
          _buildSectionCard(
            'Comfort & Services',
            [
              _buildAmenityItem(Icons.ac_unit, 'Air Conditioning', true),
              _buildAmenityItem(Icons.volume_off, 'Quiet Cars Available', _train!.trainType == 'Shinkansen'),
              _buildAmenityItem(Icons.local_cafe, 'Vending Machines', true),
              _buildAmenityItem(Icons.wc, 'Clean Restrooms', true),
              _buildAmenityItem(Icons.smoking_rooms, 'Smoking Car', _train!.trainType == 'Local'),
              _buildAmenityItem(Icons.baby_changing_station, 'Baby Changing', _train!.trainType == 'Shinkansen'),
            ],
          ),
          if (_train!.trainType == 'Shinkansen') ...[
            const SizedBox(height: 16),
            _buildSectionCard(
              'Shinkansen Exclusive',
              [
                _buildAmenityItem(Icons.speed, 'High Speed (320 km/h)', true),
                _buildAmenityItem(Icons.restaurant_menu, 'Bento Box Service', true),
                _buildAmenityItem(Icons.business, 'Green Car (First Class)', true),
                _buildAmenityItem(Icons.schedule, 'Punctuality Guarantee', true),
                _buildAmenityItem(Icons.phone, 'Phone Booths', true),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionCard(
            'Booking Information',
            [
              _buildInfoRow('Advance Booking', 'Up to 1 month ahead'),
              _buildInfoRow('Seat Reservation', _train!.trainType == 'Shinkansen' ? 'Recommended' : 'Not required'),
              _buildInfoRow('IC Card Accepted', 'Suica, Pasmo, ICOCA'),
              _buildInfoRow('JR Pass Valid', _train!.trainType != 'Private' ? 'Yes' : 'No'),
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Ticketing Policies',
            Icons.confirmation_number,
            [
              'Reserved seat tickets can be changed once free of charge',
              'Unreserved seats available on most trains',
              'Children (6-11 years) pay half fare',
              'Infants (under 6) travel free when accompanied',
              'IC cards offer small discount over paper tickets',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Luggage Guidelines',
            Icons.luggage,
            [
              'Each passenger allowed 2 pieces of carry-on luggage',
              'Maximum size: 250cm total dimensions',
              'Weight limit: 30kg per piece',
              'Oversized luggage requires advance reservation',
              'Dangerous items and strong-smelling food prohibited',
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyCard(
            'Travel Tips',
            Icons.tips_and_updates,
            [
              'Arrive at platform 5-10 minutes before departure',
              'Cars stop at designated positions marked on platform',
              'Keep tickets until exit - needed for fare adjustment',
              'Avoid rush hours (7-9 AM, 5-7 PM) when possible',
              'Download train apps for real-time updates',
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
                  '¥${NumberFormat('#,###').format(_train!.price)}',
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