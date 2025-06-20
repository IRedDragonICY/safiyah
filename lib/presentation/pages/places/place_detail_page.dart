import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/place_model.dart';
import '../../bloc/places/places_bloc.dart';
import '../../bloc/places/places_event.dart';
import '../../bloc/places/places_state.dart';
import '../../widgets/common/loading_widget.dart';

class PlaceDetailPage extends StatefulWidget {
  final String placeId;

  const PlaceDetailPage({
    super.key,
    required this.placeId,
  });

  @override
  State<PlaceDetailPage> createState() => _PlaceDetailPageState();
}

class _PlaceDetailPageState extends State<PlaceDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<PlacesBloc>().add(LoadPlaceById(id: widget.placeId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PlacesBloc, PlacesState>(
        builder: (context, state) {
          if (state is PlacesLoading) {
            return const Scaffold(
              body: Center(child: LoadingWidget()),
            );
          }

          if (state is PlacesError) {
            return Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              body: Center(
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
              ),
            );
          }

          if (state is PlaceDetailLoaded) {
            return _buildPlaceDetail(context, state.place);
          }

          return const Scaffold(
            body: Center(child: Text('Place not found')),
          );
        },
      ),
    );
  }

  Widget _buildPlaceDetail(BuildContext context, PlaceModel place) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, place),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildPlaceInfo(context, place),
            _buildActionButtons(context, place),
            _buildDescription(context, place),
            if (place.openingHours != null)
              _buildOpeningHours(context, place),
            _buildAmenities(context, place),
            _buildMap(context, place),
            _buildReviews(context, place),
            const SizedBox(height: 100), // Bottom padding for FAB
          ]),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, PlaceModel place) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: place.imageUrls.isNotEmpty
            ? PageView.builder(
                itemCount: place.imageUrls.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: place.imageUrls[index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(
                          _getPlaceIcon(place.type),
                          size: 60,
                          color: _getPlaceColor(place.type),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container(
                color: Colors.grey[200],
                child: Center(
                  child: Icon(
                    _getPlaceIcon(place.type),
                    size: 80,
                    color: _getPlaceColor(place.type),
                  ),
                ),
              ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _sharePlace(place),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _addToFavorites(place),
        ),
      ],
    );
  }

  Widget _buildPlaceInfo(BuildContext context, PlaceModel place) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  place.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getPlaceColor(place.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  place.type.displayName,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getPlaceColor(place.type),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Rating and Reviews
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[600], size: 20),
              const SizedBox(width: 4),
              Text(
                '${place.rating}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${place.reviewCount} reviews)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    place.distanceText,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.place, color: Colors.grey[600], size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  place.address,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[700],
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Halal Certification and Status
          Row(
            children: [
              if (place.isHalalCertified) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.halalFood.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.verified,
                        size: 16,
                        color: AppColors.halalFood,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Halal Certified',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.halalFood,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (place.halalCertification != null) ...[
                        const SizedBox(width: 4),
                        Text(
                          '(${place.halalCertification})',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.halalFood,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (place.openingHours != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: place.openingHours!.isOpenNow
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    place.openingHours!.isOpenNow ? 'Open Now' : 'Closed',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: place.openingHours!.isOpenNow
                          ? AppColors.success
                          : AppColors.error,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, PlaceModel place) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _launchDirections(place),
              icon: const Icon(Icons.directions),
              label: const Text('Directions'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
          const SizedBox(width: 12),
          if (place.phoneNumber != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _launchPhone(place.phoneNumber!),
                icon: const Icon(Icons.phone),
                label: const Text('Call'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          const SizedBox(width: 12),
          if (place.website != null)
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _launchWebsite(place.website!),
                icon: const Icon(Icons.language),
                label: const Text('Website'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, PlaceModel place) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            place.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOpeningHours(BuildContext context, PlaceModel place) {
    final openingHours = place.openingHours!;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Opening Hours',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          ...openingHours.hours.entries.map((entry) {
            final day = entry.key;
            final hours = entry.value;
            final isToday = _isToday(day);
            
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      _formatDay(day),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                        color: isToday ? AppColors.primary : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    hours.isClosed 
                        ? 'Closed'
                        : '${hours.open} - ${hours.close}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
                      color: isToday ? AppColors.primary : Colors.grey[700],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAmenities(BuildContext context, PlaceModel place) {
    if (place.amenities.isEmpty) return const SizedBox.shrink();
    
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: place.amenities.map((amenity) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  amenity,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(BuildContext context, PlaceModel place) {
    return Container(
      margin: const EdgeInsets.all(20),
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: FlutterMap(
          options: MapOptions(
            initialCenter: LatLng(place.latitude, place.longitude),
            initialZoom: 15.0,
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
            ),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.safiyah.app',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: LatLng(place.latitude, place.longitude),
                  width: 40,
                  height: 40,
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getPlaceColor(place.type),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Icon(
                      _getPlaceIcon(place.type),
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviews(BuildContext context, PlaceModel place) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Reviews',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {
                  // Navigate to reviews page
                },
                child: const Text('View all'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[600], size: 24),
              const SizedBox(width: 8),
              Text(
                '${place.rating}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'out of 5',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Based on ${place.reviewCount} reviews',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          // Sample reviews (dummy data)
          _buildReviewItem(
            context,
            'Ahmad Rahman',
            5,
            'Excellent halal restaurant! The food is authentic and delicious. Highly recommended for Muslim travelers.',
            '2 days ago',
          ),
          const SizedBox(height: 12),
          _buildReviewItem(
            context,
            'Fatima Al-Zahra',
            4,
            'Great location and clean facilities. The prayer room is well-maintained.',
            '1 week ago',
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(
    BuildContext context,
    String name,
    int rating,
    String comment,
    String time,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: Text(
                  name[0],
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              size: 12,
                              color: Colors.amber[600],
                            );
                          }),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          time,
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
          const SizedBox(height: 8),
          Text(
            comment,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
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

  bool _isToday(String day) {
    final today = DateTime.now().weekday;
    final dayNames = [
      'monday',
      'tuesday',
      'wednesday',
      'thursday',
      'friday',
      'saturday',
      'sunday'
    ];
    return dayNames[today - 1] == day.toLowerCase();
  }

  String _formatDay(String day) {
    return day[0].toUpperCase() + day.substring(1).toLowerCase();
  }

  void _launchDirections(PlaceModel place) async {
    final url = 'https://www.google.com/maps/dir/?api=1&destination=${place.latitude},${place.longitude}';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _launchPhone(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _launchWebsite(String website) async {
    if (await canLaunchUrl(Uri.parse(website))) {
      await launchUrl(Uri.parse(website));
    }
  }

  void _sharePlace(PlaceModel place) {
    // Implement share functionality
  }

  void _addToFavorites(PlaceModel place) {
    // Implement add to favorites functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to favorites'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
