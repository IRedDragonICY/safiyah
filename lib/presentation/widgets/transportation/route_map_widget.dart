import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/train_model.dart';

class RouteMapWidget extends StatefulWidget {
  final String from;
  final String to;
  final String transportType;
  final List<Map<String, dynamic>> route;
  final List<TrainStop>? stops;

  const RouteMapWidget({
    super.key,
    required this.from,
    required this.to,
    required this.transportType,
    required this.route,
    this.stops,
  });

  @override
  State<RouteMapWidget> createState() => _RouteMapWidgetState();
}

class _RouteMapWidgetState extends State<RouteMapWidget> {
  bool _showDetails = false;
  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    final routePoints = _generateRouteLatLng();
    final center = routePoints.isNotEmpty 
        ? routePoints.first 
        : const LatLng(35.6762, 139.6503); // Default to Tokyo

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Stack(
          children: [
            // OpenStreetMap using flutter_map
            FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: center,
                initialZoom: _getInitialZoom(),
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
                ),
              ),
              children: [
                // OpenStreetMap Tile Layer
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.ireddragonicy.safiyah',
                  maxZoom: 19,
                ),
                
                // Route Polyline
                if (routePoints.length > 1)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 4.0,
                        color: _getTransportColor(),
                        pattern: widget.transportType == 'train' 
                            ? StrokePattern.dashed(segments: [8, 6])
                            : widget.transportType == 'flight'
                                ? StrokePattern.dotted()
                                : StrokePattern.solid(),
                      ),
                    ],
                  ),
                
                // Markers for stops/waypoints
                MarkerLayer(
                  markers: _buildMapMarkers(routePoints),
                ),
              ],
            ),
            
            // Route Info Overlay
            Positioned(
              top: 12,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getTransportColor().withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      _getTransportIcon(),
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${widget.from} → ${widget.to}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _showDetails = !_showDetails;
                      });
                    },
                    icon: Icon(
                      _showDetails ? Icons.visibility_off : Icons.visibility,
                      color: Colors.white,
                      size: 20,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.9),
                      padding: const EdgeInsets.all(8),
                      minimumSize: Size.zero,
                    ),
                  ),
                ],
              ),
            ),

            // Map Controls
            Positioned(
              right: 12,
              top: 80,
              child: Column(
                children: [
                  FloatingActionButton.small(
                    onPressed: () {
                      _mapController.move(center, _mapController.camera.zoom + 1);
                    },
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: const Icon(Icons.add, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    onPressed: () {
                      _mapController.move(center, _mapController.camera.zoom - 1);
                    },
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: const Icon(Icons.remove, color: Colors.black54),
                  ),
                  const SizedBox(height: 8),
                  FloatingActionButton.small(
                    onPressed: () {
                      if (routePoints.isNotEmpty) {
                        _fitBounds(routePoints);
                      }
                    },
                    backgroundColor: Colors.white.withValues(alpha: 0.9),
                    child: const Icon(Icons.fit_screen, color: Colors.black54),
                  ),
                ],
              ),
            ),

            // Route Details Panel
            if (_showDetails)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  constraints: const BoxConstraints(maxHeight: 120),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(AppConstants.borderRadius),
                      bottomRight: Radius.circular(AppConstants.borderRadius),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTransportTypeDisplay(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: _buildRouteStops(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Transport Type Badge
            Positioned(
              bottom: 12,
              left: 12,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getTransportColor(),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getTransportIcon(),
                      color: Colors.white,
                      size: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _getTransportTypeDisplay(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<LatLng> _generateRouteLatLng() {
    if (widget.route.isEmpty) {
      // Default route from Tokyo to Osaka
      return [
        const LatLng(35.6762, 139.6503), // Tokyo
        const LatLng(34.6937, 135.5023), // Osaka
      ];
    }

    return widget.route.map((point) {
      return LatLng(
        point['lat']?.toDouble() ?? 35.6762,
        point['lng']?.toDouble() ?? 139.6503,
      );
    }).toList();
  }

  List<Marker> _buildMapMarkers(List<LatLng> routePoints) {
    final markers = <Marker>[];

    for (int i = 0; i < routePoints.length; i++) {
      final point = routePoints[i];
      final stopData = i < widget.route.length ? widget.route[i] : null;
      final stopType = stopData?['type'] ?? (i == 0 ? 'departure' : 'arrival');
      
      markers.add(
        Marker(
          point: point,
          width: 30,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
              color: _getStopColor(stopType),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              _getStopIcon(stopType),
              color: Colors.white,
              size: 16,
            ),
          ),
        ),
      );

      // Add name label for major stops
      if (stopData?['name'] != null && (stopType == 'departure' || stopType == 'arrival' || stopType == 'stop')) {
        markers.add(
          Marker(
            point: LatLng(point.latitude + 0.002, point.longitude),
            width: 100,
            height: 30,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                stopData!['name'],
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }
    }

    return markers;
  }

  void _fitBounds(List<LatLng> points) {
    if (points.length < 2) return;

    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLng = points.first.longitude;
    double maxLng = points.first.longitude;

    for (final point in points) {
      minLat = minLat < point.latitude ? minLat : point.latitude;
      maxLat = maxLat > point.latitude ? maxLat : point.latitude;
      minLng = minLng < point.longitude ? minLng : point.longitude;
      maxLng = maxLng > point.longitude ? maxLng : point.longitude;
    }

    final bounds = LatLngBounds(
      LatLng(minLat, minLng),
      LatLng(maxLat, maxLng),
    );

    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  double _getInitialZoom() {
    switch (widget.transportType) {
      case 'flight':
        return 6.0; // Wider view for flights
      case 'train':
        return 8.0; // Medium view for trains
      case 'bus':
        return 9.0; // Closer view for buses
      case 'ridehailing':
        return 12.0; // Very close view for local rides
      default:
        return 8.0;
    }
  }

  Color _getTransportColor() {
    switch (widget.transportType) {
      case 'flight':
        return AppColors.secondary;
      case 'train':
        return AppColors.success;
      case 'bus':
        return AppColors.warning;
      case 'ridehailing':
        return AppColors.primary;
      default:
        return AppColors.primary;
    }
  }

  IconData _getTransportIcon() {
    switch (widget.transportType) {
      case 'flight':
        return Icons.flight;
      case 'train':
        return Icons.train;
      case 'bus':
        return Icons.directions_bus;
      case 'ridehailing':
        return Icons.local_taxi;
      default:
        return Icons.directions;
    }
  }

  IconData _getStopIcon(String? type) {
    switch (type) {
      case 'departure':
        return Icons.play_arrow;
      case 'arrival':
        return Icons.flag;
      case 'stop':
        return Icons.stop;
      case 'waypoint':
        return Icons.location_on;
      default:
        return Icons.circle;
    }
  }

  String _getTransportTypeDisplay() {
    switch (widget.transportType) {
      case 'flight':
        return 'FLIGHT ROUTE';
      case 'train':
        return 'TRAIN ROUTE';
      case 'bus':
        return 'BUS ROUTE';
      case 'ridehailing':
        return 'DRIVE ROUTE';
      default:
        return 'ROUTE';
    }
  }

  List<Widget> _buildRouteStops() {
    if (widget.route.isEmpty) return [];

    return widget.route.asMap().entries.map((entry) {
      final index = entry.key;
      final stop = entry.value;
      final isLast = index == widget.route.length - 1;

      return Row(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getStopColor(stop['type']),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: Text(
                  stop['name'] ?? '',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (!isLast) ...[
            const SizedBox(width: 8),
            Container(
              width: 20,
              height: 2,
              color: Colors.white.withValues(alpha: 0.5),
            ),
            const SizedBox(width: 8),
          ],
        ],
      );
    }).toList();
  }

  Color _getStopColor(String? type) {
    switch (type) {
      case 'departure':
        return Colors.green;
      case 'arrival':
        return Colors.red;
      case 'stop':
        return AppColors.secondary;
      case 'waypoint':
        return Colors.orange;
      default:
        return Colors.white;
    }
  }
} 