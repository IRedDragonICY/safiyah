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
import '../../widgets/transportation/route_map_widget.dart';

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
  
  final TextEditingController _fromController = TextEditingController(text: 'Tokyo');
  final TextEditingController _toController = TextEditingController(text: 'Osaka');
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

  void _loadInitialData() {
    _searchTransportation();
  }

  Future<void> _searchTransportation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Search logic will be handled by individual tab builders
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error searching transportation: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _toggleNFC() async {
    try {
      if (_isNFCEnabled) {
        await _service.disableNFC();
      } else {
        await _service.enableNFC();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('NFC operation failed: $e')),
        );
      }
    }
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
                preferredSize: const Size.fromHeight(400),
                child: Container(
                  color: AppColors.primary,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
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
                          _searchTransportation();
                        },
                        onReturnDateSelected: (date) {
                          setState(() {
                            _returnDate = date;
                          });
                          _searchTransportation();
                        },
                        onSearch: _searchTransportation,
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
                          _searchTransportation();
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

        return Column(
          children: [
            // Route Map Preview
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              child: RouteMapWidget(
                from: _fromController.text,
                to: _toController.text,
                transportType: 'flight',
                route: flights.isNotEmpty ? _generateFlightRoute(flights.first) : [],
              ),
            ),
            // Flight Results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
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
              ),
            ),
          ],
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

        return Column(
          children: [
            // Route Map Preview
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              child: RouteMapWidget(
                from: _fromController.text,
                to: _toController.text,
                transportType: 'train',
                route: trains.isNotEmpty ? _generateTrainRoute(trains.first) : [],
                stops: trains.isNotEmpty ? trains.first.stops : [],
              ),
            ),
            // Train Results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
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
              ),
            ),
          ],
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

        return Column(
          children: [
            // Route Map Preview
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              child: RouteMapWidget(
                from: _fromController.text,
                to: _toController.text,
                transportType: 'bus',
                route: _generateBusRoute(),
              ),
            ),
            // Bus Results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
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
              ),
            ),
          ],
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

        return Column(
          children: [
            // Route Map Preview
            Container(
              height: 200,
              margin: const EdgeInsets.all(16),
              child: RouteMapWidget(
                from: _fromController.text,
                to: _toController.text,
                transportType: 'ridehailing',
                route: _generateCarRoute(),
              ),
            ),
            // Round Trip Toggle for Ride Hailing
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text('Round Trip'),
                  Switch(
                    value: _isRoundTrip,
                    onChanged: (value) {
                      setState(() {
                        _isRoundTrip = value;
                        if (!value) {
                          _returnDate = null;
                        } else if (_returnDate == null) {
                          _returnDate = _selectedDate.add(const Duration(days: 1));
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
            // Ride Hailing Results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                itemCount: rides.length,
                itemBuilder: (context, index) {
                  final ride = rides[index];
                  final adjustedPrice = _isRoundTrip ? ride.price * 1.8 : ride.price;
                  
                  return TransportCard(
                    title: ride.name,
                    subtitle: ride.company,
                    departure: ride.departure,
                    arrival: ride.arrival,
                    price: adjustedPrice,
                    currency: ride.currency,
                    duration: '15-25 min',
                    features: ride.features.supportedPayments,
                    isHalalFriendly: ride.features.halalFriendly,
                    rating: ride.rating,
                    onTap: () => _showRideDetails(context, ride),
                    isRoundTrip: _isRoundTrip,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRentalsTab() {
    return FutureBuilder(
      future: _repository.getRentals(
        location: _fromController.text.isEmpty ? 'Tokyo' : _fromController.text,
        startDate: _selectedDate,
        endDate: _returnDate ?? _selectedDate.add(const Duration(days: 1)),
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
          return _buildEmptyWidget('No rental options found');
        }

        return Column(
          children: [
            // Rental Period Selection
            Container(
              margin: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Rental Period: ${DateFormat('MMM dd').format(_selectedDate)} - ${DateFormat('MMM dd').format(_returnDate ?? _selectedDate.add(const Duration(days: 1)))}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _selectRentalPeriod(),
                    child: const Text('Change'),
                  ),
                ],
              ),
            ),
            // Rental Results
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                itemCount: rentals.length,
                itemBuilder: (context, index) {
                  final rental = rentals[index];
                  final days = _returnDate?.difference(_selectedDate).inDays ?? 1;
                  final totalPrice = rental.pricing.daily * days;
                  
                  return Card(
                    elevation: AppConstants.cardElevation,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: InkWell(
                      onTap: () => _showRentalDetails(context, rental),
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
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    rental.vehicleType == 'Car' ? Icons.directions_car : Icons.two_wheeler,
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
                                        rental.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium
                                            ?.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        '${rental.company} • ${rental.vehicleType}',
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
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.people, color: Colors.grey[600], size: 16),
                                const SizedBox(width: 4),
                                Text('${rental.seats} seats'),
                                const SizedBox(width: 16),
                                Icon(Icons.local_gas_station, color: Colors.grey[600], size: 16),
                                const SizedBox(width: 4),
                                Text(rental.fuelType),
                                const SizedBox(width: 16),
                                Icon(Icons.settings, color: Colors.grey[600], size: 16),
                                const SizedBox(width: 4),
                                Text(rental.transmission),
                              ],
                            ),
                            const Divider(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '¥${NumberFormat('#,###').format(totalPrice)}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      'for $days day${days > 1 ? 's' : ''}',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.star, 
                                         color: AppColors.secondary, size: 16),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${rental.rating} (${rental.totalReviews})',
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
              ),
            ),
          ],
        );
      },
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Filter options coming soon!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFlightDetails(BuildContext context, dynamic flight) {
    context.push('/transportation/flight/${flight.id}');
  }

  void _showTrainDetails(BuildContext context, dynamic train) {
    context.push('/transportation/train/${train.id}');
  }

  void _showBusDetails(BuildContext context, dynamic bus) {
    context.push('/transportation/bus/${bus.id}');
  }

  void _showRideDetails(BuildContext context, dynamic ride) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ride.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Company: ${ride.company}'),
            Text('Price: ¥${NumberFormat('#,###').format(ride.price)}'),
            Text('Rating: ${ride.rating}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking feature coming soon!')),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  void _showRentalDetails(BuildContext context, dynamic rental) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(rental.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company: ${rental.company}'),
            Text('Vehicle Type: ${rental.vehicleType}'),
            Text('Seats: ${rental.seats}'),
            Text('Fuel Type: ${rental.fuelType}'),
            Text('Transmission: ${rental.transmission}'),
            Text('Daily Rate: ¥${NumberFormat('#,###').format(rental.pricing.daily)}'),
            Text('Deposit: ¥${NumberFormat('#,###').format(rental.pricing.deposit)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking feature coming soon!')),
              );
            },
            child: const Text('Book Now'),
          ),
        ],
      ),
    );
  }

  void _selectRentalPeriod() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      initialDateRange: DateTimeRange(
        start: _selectedDate,
        end: _returnDate ?? _selectedDate.add(const Duration(days: 1)),
      ),
    );
    
    if (picked != null) {
      setState(() {
        _selectedDate = picked.start;
        _returnDate = picked.end;
      });
    }
  }

  List<Map<String, dynamic>> _generateFlightRoute(dynamic flight) {
    // Real coordinates for major Japanese airports
    final airportCoords = {
      'Tokyo': {'lat': 35.7769, 'lng': 140.3928}, // Narita
      'Haneda': {'lat': 35.5533, 'lng': 139.7811}, // Haneda
      'Osaka': {'lat': 34.4348, 'lng': 135.2442}, // Kansai
      'Kyoto': {'lat': 34.4348, 'lng': 135.2442}, // Use Kansai for Kyoto
      'Nagoya': {'lat': 35.2553, 'lng': 136.9240}, // Chubu Centrair
      'Fukuoka': {'lat': 33.5859, 'lng': 130.4511}, // Fukuoka
      'Sapporo': {'lat': 43.0642, 'lng': 141.3469}, // New Chitose
    };

    final fromCoords = airportCoords[_fromController.text] ?? airportCoords['Tokyo']!;
    final toCoords = airportCoords[_toController.text] ?? airportCoords['Osaka']!;

    return [
      {
        'lat': fromCoords['lat'],
        'lng': fromCoords['lng'],
        'name': '${flight.departure} Airport',
        'type': 'departure'
      },
      {
        'lat': toCoords['lat'],
        'lng': toCoords['lng'],
        'name': '${flight.arrival} Airport',
        'type': 'arrival'
      },
    ];
  }

  List<Map<String, dynamic>> _generateTrainRoute(dynamic train) {
    final List<Map<String, dynamic>> route = [];
    
    // Real coordinates for major Japanese train stations
    final stationCoords = {
      'Tokyo': {'lat': 35.6762, 'lng': 139.6503},
      'Shinagawa': {'lat': 35.6284, 'lng': 139.7387},
      'Shin-Yokohama': {'lat': 35.5067, 'lng': 139.6180},
      'Atami': {'lat': 35.1042, 'lng': 139.0739},
      'Mishima': {'lat': 35.1233, 'lng': 138.9183},
      'Shin-Fuji': {'lat': 35.1447, 'lng': 138.6814},
      'Shizuoka': {'lat': 34.9756, 'lng': 138.3828},
      'Kakegawa': {'lat': 34.7701, 'lng': 137.9993},
      'Hamamatsu': {'lat': 34.7038, 'lng': 137.7344},
      'Toyohashi': {'lat': 34.7638, 'lng': 137.3914},
      'Mikawa-Anjo': {'lat': 34.9592, 'lng': 137.0814},
      'Nagoya': {'lat': 35.1706, 'lng': 136.8816},
      'Gifu-Hashima': {'lat': 35.3197, 'lng': 136.7014},
      'Maibara': {'lat': 35.3178, 'lng': 136.2658},
      'Kyoto': {'lat': 34.9858, 'lng': 135.7581},
      'Shin-Osaka': {'lat': 34.7326, 'lng': 135.5003},
      'Osaka': {'lat': 34.6937, 'lng': 135.5023},
    };

    final fromCoords = stationCoords[_fromController.text] ?? stationCoords['Tokyo']!;
    final toCoords = stationCoords[_toController.text] ?? stationCoords['Osaka']!;
    
    // Add departure
    route.add({
      'lat': fromCoords['lat'],
      'lng': fromCoords['lng'],
      'name': train.departure,
      'type': 'departure'
    });
    
    // Add actual train stops with real coordinates
    for (final stop in train.stops) {
      if (stationCoords.containsKey(stop.stationName)) {
        final coords = stationCoords[stop.stationName]!;
        route.add({
          'lat': coords['lat'],
          'lng': coords['lng'],
          'name': stop.stationName,
          'type': 'stop'
        });
      }
    }
    
    // Add arrival
    route.add({
      'lat': toCoords['lat'],
      'lng': toCoords['lng'],
      'name': train.arrival,
      'type': 'arrival'
    });
    
    return route;
  }

  List<Map<String, dynamic>> _generateBusRoute() {
    // Real coordinates for major highway bus stops/service areas
    final busStopCoords = {
      'Tokyo': {'lat': 35.6762, 'lng': 139.6503},
      'Ebisu SA': {'lat': 35.6230, 'lng': 138.6476},
      'Lake Kawaguchi': {'lat': 35.5033, 'lng': 138.7636},
      'Komagane IC': {'lat': 35.7280, 'lng': 137.9656},
      'Nagoya': {'lat': 35.1706, 'lng': 136.8816},
      'Kusatsu PA': {'lat': 35.0103, 'lng': 135.9590},
      'Osaka': {'lat': 34.6937, 'lng': 135.5023},
    };

    final fromCoords = busStopCoords[_fromController.text] ?? busStopCoords['Tokyo']!;
    final toCoords = busStopCoords[_toController.text] ?? busStopCoords['Osaka']!;

    return [
      {
        'lat': fromCoords['lat'],
        'lng': fromCoords['lng'],
        'name': _fromController.text,
        'type': 'departure'
      },
      {
        'lat': 35.6230,
        'lng': 138.6476,
        'name': 'Ebisu SA',
        'type': 'stop'
      },
      {
        'lat': 35.7280,
        'lng': 137.9656,
        'name': 'Komagane IC',
        'type': 'stop'
      },
      {
        'lat': 35.1706,
        'lng': 136.8816,
        'name': 'Nagoya Station',
        'type': 'stop'
      },
      {
        'lat': 35.0103,
        'lng': 135.9590,
        'name': 'Kusatsu PA',
        'type': 'stop'
      },
      {
        'lat': toCoords['lat'],
        'lng': toCoords['lng'],
        'name': _toController.text,
        'type': 'arrival'
      },
    ];
  }

  List<Map<String, dynamic>> _generateCarRoute() {
    // Real coordinates for Tokyo area ride routes
    final locationCoords = {
      'Tokyo': {'lat': 35.6762, 'lng': 139.6503},
      'Tokyo Station': {'lat': 35.6812, 'lng': 139.7671},
      'Shibuya': {'lat': 35.6595, 'lng': 139.7006},
      'Shinjuku': {'lat': 35.6896, 'lng': 139.6917},
      'Ginza': {'lat': 35.6719, 'lng': 139.7658},
      'Roppongi': {'lat': 35.6627, 'lng': 139.7314},
      'Akihabara': {'lat': 35.6984, 'lng': 139.7731},
      'Ueno': {'lat': 35.7139, 'lng': 139.7799},
    };

    final fromCoords = locationCoords[_fromController.text] ?? locationCoords['Tokyo Station']!;
    final toCoords = locationCoords[_toController.text] ?? locationCoords['Shibuya']!;

    // Add a waypoint in the middle for more realistic routing
    final midLat = (fromCoords['lat']! + toCoords['lat']!) / 2;
    final midLng = (fromCoords['lng']! + toCoords['lng']!) / 2;

    return [
      {
        'lat': fromCoords['lat'],
        'lng': fromCoords['lng'],
        'name': _fromController.text,
        'type': 'departure'
      },
      {
        'lat': midLat + 0.005, // Slight offset for realistic routing
        'lng': midLng + 0.005,
        'name': 'Route via Tokyo Streets',
        'type': 'waypoint'
      },
      {
        'lat': toCoords['lat'],
        'lng': toCoords['lng'],
        'name': _toController.text,
        'type': 'arrival'
      },
    ];
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error loading data',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            error,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
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
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
} 