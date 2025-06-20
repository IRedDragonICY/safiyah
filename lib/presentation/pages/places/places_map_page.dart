import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/place_model.dart';
import '../../bloc/places/places_bloc.dart';
import '../../bloc/places/places_event.dart';
import '../../bloc/places/places_state.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/places/place_card.dart';

class PlacesMapPage extends StatefulWidget {
  final PlaceType? filterType;

  const PlacesMapPage({
    super.key,
    this.filterType,
  });

  @override
  State<PlacesMapPage> createState() => _PlacesMapPageState();
}

class _PlacesMapPageState extends State<PlacesMapPage> {
  final MapController _mapController = MapController();
  PlaceType? _selectedFilter;
  String _searchQuery = '';
  PlaceModel? _selectedPlace;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.filterType;
    context.read<PlacesBloc>().add(
      LoadNearbyPlaces(type: _selectedFilter),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Halal Places'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search places...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                      if (value.isNotEmpty) {
                        context.read<PlacesBloc>().add(
                          SearchPlaces(query: value),
                        );
                      } else {
                        context.read<PlacesBloc>().add(
                          LoadNearbyPlaces(type: _selectedFilter),
                        );
                      }
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.filter_list, color: Colors.white),
                  onPressed: _showFilterBottomSheet,
                ),
              ],
            ),
          ),
        ),
      ),
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return const Center(child: LoadingWidget());
          }

          if (state is PlacesError) {
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
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<PlacesBloc>().add(
                        LoadNearbyPlaces(type: _selectedFilter),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PlacesLoaded) {
            return Stack(
              children: [
                _buildMap(context, state),
                if (_selectedPlace != null)
                  Positioned(
                    bottom: 16,
                    left: 16,
                    right: 16,
                    child: PlaceCard(
                      place: _selectedPlace!,
                      onTap: () {
                        context.push('/places/detail/${_selectedPlace!.id}');
                      },
                    ),
                  ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: "my_location",
            onPressed: _goToCurrentLocation,
            backgroundColor: Colors.white,
            child: const Icon(Icons.my_location, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: "list_view",
            onPressed: () {
              _showPlacesListBottomSheet();
            },
            backgroundColor: AppColors.primary,
            child: const Icon(Icons.list, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, PlacesLoaded state) {
    final places = state.places;
    
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: const LatLng(3.1390, 101.6869), // KL coordinates
        initialZoom: 15.0,
        onTap: (tapPosition, point) {
          setState(() {
            _selectedPlace = null;
          });
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.safiyah.app',
        ),
        MarkerLayer(
          markers: [
            // User location marker
            const Marker(
              point: LatLng(3.1390, 101.6869),
              width: 40,
              height: 40,
              child: Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 30,
              ),
            ),
            // Place markers
            ...places.map((place) {
              return Marker(
                point: LatLng(place.latitude, place.longitude),
                width: 40,
                height: 40,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedPlace = place;
                    });
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getPlaceColor(place.type),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getPlaceIcon(place.type),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Filter Places',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFilterChip('All', null),
                  _buildFilterChip('Mosques', PlaceType.mosque),
                  _buildFilterChip('Restaurants', PlaceType.restaurant),
                  _buildFilterChip('Hotels', PlaceType.hotel),
                  _buildFilterChip('Stores', PlaceType.store),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String label, PlaceType? type) {
    final isSelected = _selectedFilter == type;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? type : null;
        });
        context.read<PlacesBloc>().add(
          LoadNearbyPlaces(type: _selectedFilter),
        );
        Navigator.pop(context);
      },
      selectedColor: AppColors.primary.withValues(alpha: 0.2),
      checkmarkColor: AppColors.primary,
    );
  }

  void _showPlacesListBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          builder: (context, scrollController) {
            return BlocBuilder<PlacesBloc, PlacesState>(
              builder: (context, state) {
                if (state is PlacesLoaded) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nearby Places (${state.places.length})',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: state.places.length,
                            itemBuilder: (context, index) {
                              final place = state.places[index];
                              return PlaceCard(
                                place: place,
                                onTap: () {
                                  Navigator.pop(context);
                                  context.push('/places/detail/${place.id}');
                                },
                                margin: const EdgeInsets.only(bottom: 12),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            );
          },
        );
      },
    );
  }

  void _goToCurrentLocation() {
    _mapController.move(const LatLng(3.1390, 101.6869), 15.0);
  }

  Color _getPlaceColor(PlaceType type) {
    switch (type) {
      case PlaceType.mosque:
        return AppColors.mosque;
      case PlaceType.restaurant:
        return AppColors.halalFood;
      case PlaceType.hotel:
        return AppColors.primary;
      case PlaceType.store:
        return AppColors.warning;
      case PlaceType.attraction:
        return AppColors.secondary;
      case PlaceType.airport:
        return AppColors.info;
      case PlaceType.hospital:
        return AppColors.error;
      case PlaceType.bank:
        return AppColors.success;
    }
  }

  IconData _getPlaceIcon(PlaceType type) {
    switch (type) {
      case PlaceType.mosque:
        return Icons.mosque;
      case PlaceType.restaurant:
        return Icons.restaurant;
      case PlaceType.hotel:
        return Icons.hotel;
      case PlaceType.store:
        return Icons.store;
      case PlaceType.attraction:
        return Icons.attractions;
      case PlaceType.airport:
        return Icons.flight;
      case PlaceType.hospital:
        return Icons.local_hospital;
      case PlaceType.bank:
        return Icons.account_balance;
    }
  }
}
