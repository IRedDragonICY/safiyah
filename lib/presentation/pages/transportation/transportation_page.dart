import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/services/transportation_service.dart';
import '../../../data/repositories/transportation_repository.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/transportation/transport_card.dart';
import '../../widgets/transportation/transport_filter_chips.dart';
import '../../widgets/transportation/transport_search_bar.dart';

class TransportationPage extends StatefulWidget {
  final int? initialTabIndex;
  
  const TransportationPage({
    super.key,
    this.initialTabIndex,
  });

  @override
  State<TransportationPage> createState() => _TransportationPageState();
}

class _TransportationPageState extends State<TransportationPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TransportationRepository _repository = TransportationRepository();
  final TransportationService _service = TransportationService();
  
  final TextEditingController _fromController = TextEditingController(text: 'Tokyo (HND)');
  final TextEditingController _toController = TextEditingController(text: 'Osaka (KIX)');
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _returnDate;
  bool _isRoundTrip = false;
  
  bool _isLoading = false;
  bool _isNFCEnabled = false;
  
  final List<String> _transportTypes = [
    'Flights',
    'Trains', 
    'Buses',
    'Ride-hailing',
    'Rentals'
  ];

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialTabIndex ?? 0;
    _tabController = TabController(
      length: _transportTypes.length, 
      vsync: this,
      initialIndex: initialIndex.clamp(0, _transportTypes.length - 1),
    );
    _initializeNFC();
    _loadInitialData();
  }

  Future<void> _initializeNFC() async {
    await _service.initialize();
    if (mounted) {
      setState(() {
        _isNFCEnabled = _service.isNFCEnabled;
      });
    }

    _service.nfcStatusStream.listen((enabled) {
      if (mounted) {
        setState(() {
          _isNFCEnabled = enabled;
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text('Transportation'),
              floating: true,
              pinned: true,
              elevation: 0,
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              actions: [
                IconButton(
                  icon: Icon(
                    _isNFCEnabled ? Icons.nfc : Icons.nfc_outlined,
                    color: _isNFCEnabled ? AppColors.secondary : Colors.white70,
                  ),
                  onPressed: _toggleNFC,
                  tooltip: _isNFCEnabled ? 'NFC Enabled' : 'Enable NFC',
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () => _showFilterDialog(context),
                ),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(140),
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TransportSearchBar(
                        fromController: _fromController,
                        toController: _toController,
                        selectedDate: _selectedDate,
                        returnDate: _returnDate,
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });
                          _searchFlights();
                        },
                        onReturnDateSelected: (date) {
                          setState(() {
                            _returnDate = date;
                          });
                          _searchFlights();
                        },
                        onSearch: _searchFlights,
                        isRoundTrip: _isRoundTrip,
                        onTripTypeChanged: (isRoundTrip) {
                          setState(() {
                            _isRoundTrip = isRoundTrip;
                            if (!isRoundTrip) {
                              _returnDate = null;
                            } else if (_returnDate == null) {
                              _returnDate = _selectedDate.add(const Duration(days: 7));
                            }
                          });
                          _searchFlights();
                        },
                      ),
                      const SizedBox(height: 12),
                      TabBar(
                        controller: _tabController,
                        isScrollable: true,
                        indicatorColor: AppColors.secondary,
                        labelColor: Colors.white,
                        unselectedLabelColor: Colors.white70,
                        tabs: _transportTypes
                            .map((type) => Tab(text: type))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildFlightsTab(),
            _buildTrainsTab(),
            _buildBusesTab(),
            _buildRideHailingTab(),
            _buildRentalsTab(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/transportation/guide'),
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.black,
        icon: const Icon(Icons.help_outline),
        label: const Text('Transport Guide'),
      ),
    );
  }

  Widget _buildFlightsTab() {
    return FutureBuilder(
      future: _repository.getFlights(
        from: _fromController.text.isEmpty ? 'Tokyo' : _fromController.text,
        to: _toController.text.isEmpty ? 'Osaka' : _toController.text,
        date: _selectedDate,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final flights = snapshot.data ?? [];
        
        if (flights.isEmpty) {
          return _buildEmptyWidget('No flights found');
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: flights.length,
          itemBuilder: (context, index) {
            final flight = flights[index];
            return Card(
              elevation: AppConstants.cardElevation,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: InkWell(
                onTap: () => _showFlightDetails(context, flight),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: flight.isHalalCertified
                                  ? AppColors.success.withValues(alpha: 0.1)
                                  : AppColors.warning.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.flight,
                              color: flight.isHalalCertified
                                  ? AppColors.success
                                  : AppColors.warning,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  flight.airline,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  flight.flightNumber,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          if (flight.isHalalCertified)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.success,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'HALAL',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(flight.departureTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  flight.departure,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Icon(Icons.flight_takeoff, 
                                   color: AppColors.primary, size: 16),
                              Text(
                                flight.formattedDuration,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  DateFormat('HH:mm').format(flight.arrivalTime),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  flight.arrival,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '¥${NumberFormat('#,###').format(flight.price)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.star, 
                                   color: AppColors.secondary, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${flight.rating} (${flight.totalReviews})',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildTrainsTab() {
    return FutureBuilder(
      future: _repository.getTrains(
        from: _fromController.text.isEmpty ? 'Tokyo' : _fromController.text,
        to: _toController.text.isEmpty ? 'Osaka' : _toController.text,
        date: _selectedDate,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final trains = snapshot.data ?? [];
        
        if (trains.isEmpty) {
          return _buildEmptyWidget('No trains found');
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: trains.length,
          itemBuilder: (context, index) {
            final train = trains[index];
            return TransportCard(
              title: '${train.trainLine} - ${train.trainNumber}',
              subtitle: train.trainType,
              departure: train.departure,
              arrival: train.arrival,
              departureTime: train.departureTime,
              arrivalTime: train.arrivalTime,
              price: train.price,
              currency: train.currency,
              duration: train.formattedDuration,
              features: train.features.nfcPayment ? ['NFC Payment'] : [],
              isHalalFriendly: train.halalFriendly,
              onTap: () => _showTrainDetails(context, train),
            );
          },
        );
      },
    );
  }

  Widget _buildBusesTab() {
    return FutureBuilder(
      future: _repository.getBuses(
        from: _fromController.text.isEmpty ? 'Tokyo' : _fromController.text,
        to: _toController.text.isEmpty ? 'Osaka' : _toController.text,
        date: _selectedDate,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final buses = snapshot.data ?? [];
        
        if (buses.isEmpty) {
          return _buildEmptyWidget('No buses found');
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: buses.length,
          itemBuilder: (context, index) {
            final bus = buses[index];
            return TransportCard(
              title: bus.name,
              subtitle: bus.company,
              departure: bus.departure,
              arrival: bus.arrival,
              departureTime: bus.departureTime,
              arrivalTime: bus.arrivalTime,
              price: bus.price,
              currency: bus.currency,
              duration: bus.formattedDuration,
              features: bus.features.amenities,
              isHalalFriendly: bus.features.halalFriendly,
              rating: bus.rating,
              onTap: () => _showBusDetails(context, bus),
            );
          },
        );
      },
    );
  }

  Widget _buildRideHailingTab() {
    return FutureBuilder(
      future: _repository.getRideHailing(
        from: _fromController.text.isEmpty ? 'Tokyo Station' : _fromController.text,
        to: _toController.text.isEmpty ? 'Shibuya' : _toController.text,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final rides = snapshot.data ?? [];
        
        if (rides.isEmpty) {
          return _buildEmptyWidget('No ride-hailing options found');
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: rides.length,
          itemBuilder: (context, index) {
            final ride = rides[index];
            return TransportCard(
              title: ride.name,
              subtitle: ride.company,
              departure: ride.departure,
              arrival: ride.arrival,
              price: ride.price,
              currency: ride.currency,
              features: ride.features.amenities,
              isHalalFriendly: ride.features.halalFriendly,
              rating: ride.rating,
              onTap: () => _bookRide(context, ride),
            );
          },
        );
      },
    );
  }

  Widget _buildRentalsTab() {
    return FutureBuilder(
      future: _repository.getRentals(
        location: _fromController.text.isEmpty ? 'Tokyo' : _fromController.text,
        startDate: _selectedDate,
        endDate: _selectedDate.add(const Duration(days: 1)),
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: LoadingWidget());
        }

        if (snapshot.hasError) {
          return _buildErrorWidget(snapshot.error.toString());
        }

        final rentals = snapshot.data ?? [];
        
        if (rentals.isEmpty) {
          return _buildEmptyWidget('No rentals found');
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
          itemCount: rentals.length,
          itemBuilder: (context, index) {
            final rental = rentals[index];
            return TransportCard(
              title: rental.name,
              subtitle: '${rental.company} • ${rental.vehicleType}',
              departure: rental.departure,
              arrival: rental.arrival,
              price: rental.price,
              currency: rental.currency,
              features: rental.features.amenities,
              isHalalFriendly: rental.features.halalFriendly,
              rating: rental.rating,
              additionalInfo: 'From ¥${rental.pricing.hourly}/hour',
              onTap: () => _showRentalDetails(context, rental),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => setState(() {}),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleNFC() async {
    try {
      if (_isNFCEnabled) {
        await _service.disableNFC();
      } else {
        await _service.enableNFC();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('NFC Error: $e')),
        );
      }
    }
  }

  void _searchFlights() {
    setState(() {
      _isLoading = true;
    });
    // Trigger rebuild to refresh data
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  void _performSearch() {
    _searchFlights();
  }

  void _loadInitialData() {
    _searchFlights();
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const TransportFilterChips(),
    );
  }

  void _showFlightDetails(BuildContext context, flight) {
    context.push('/transportation/flight/${flight.id}');
  }

  void _showTrainDetails(BuildContext context, train) {
    context.push('/transportation/train/${train.id}');
  }

  void _showBusDetails(BuildContext context, bus) {
    context.push('/transportation/bus/${bus.id}');
  }

  void _bookRide(BuildContext context, ride) {
    context.push('/transportation/ride/${ride.id}');
  }

  void _showRentalDetails(BuildContext context, rental) {
    context.push('/transportation/rental/${rental.id}');
  }
} 