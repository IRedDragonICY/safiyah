import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/event_model.dart';
import '../../bloc/events/events_bloc.dart';
import '../../bloc/events/events_event.dart';
import '../../bloc/events/events_state.dart';
import '../../widgets/common/loading_widget.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({
    super.key,
    required this.eventId,
  });

  @override
  State<EventDetailPage> createState() => _EventDetailPageState();
}

class _EventDetailPageState extends State<EventDetailPage> {
  int _currentImageIndex = 0;
  PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    context.read<EventsBloc>().add(LoadEventById(eventId: widget.eventId));
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<EventsBloc, EventsState>(
        builder: (context, state) {
          if (state is EventsLoading) {
            return const Center(child: LoadingWidget());
          }

          if (state is EventsError) {
            return _buildErrorWidget(context, state.message);
          }

          if (state is EventDetailLoaded) {
            return _buildEventDetail(context, state.event);
          }

          return const Center(child: Text('Event not found'));
        },
      ),
    );
  }

  Widget _buildEventDetail(BuildContext context, EventModel event) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, event),
        SliverToBoxAdapter(
          child: Column(
            children: [
              _buildBasicInfo(context, event),
              _buildDescription(context, event),
              _buildSchedule(context, event),
              _buildHighlights(context, event),
              _buildTicketInfo(context, event),
              _buildAccessibilityInfo(context, event),
              _buildLocationInfo(context, event),
              _buildContactInfo(context, event),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, EventModel event) {
    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            if (event.imageUrls.isNotEmpty)
              PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentImageIndex = index;
                  });
                },
                itemCount: event.imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    event.imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 300,
                  );
                },
              ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Status and price badges
            Positioned(
              top: 60,
              left: 16,
              child: _buildStatusBadge(context, event),
            ),
            Positioned(
              top: 60,
              right: 16,
              child: _buildPriceBadge(context, event),
            ),
            // Image indicators
            if (event.imageUrls.length > 1)
              Positioned(
                bottom: 80,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    event.imageUrls.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentImageIndex
                            ? Colors.white
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () => _shareEvent(event),
        ),
        IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () => _addToFavorites(event),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(BuildContext context, EventModel event) {
    Color badgeColor;
    String statusText;
    
    if (event.isHappeningNow) {
      badgeColor = Colors.red;
      statusText = 'LIVE NOW';
    } else if (event.isUpcoming) {
      badgeColor = AppColors.primary;
      statusText = 'UPCOMING';
    } else {
      badgeColor = Colors.grey;
      statusText = 'ENDED';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        statusText,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPriceBadge(BuildContext context, EventModel event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: event.priceInfo.isFree 
            ? Colors.green 
            : AppColors.secondary.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        event.priceInfo.displayPrice,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildBasicInfo(BuildContext context, EventModel event) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and category
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.name,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(event.category).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        event.category.displayName,
                        style: TextStyle(
                          color: _getCategoryColor(event.category),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _buildRatingWidget(context, event),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Date and time
          _buildInfoRow(
            context,
            Icons.schedule,
            'Date & Time',
            _formatEventDateTime(event),
          ),
          
          // Duration
          _buildInfoRow(
            context,
            Icons.timer,
            'Duration',
            event.durationText,
          ),
          
          // Venue
          _buildInfoRow(
            context,
            Icons.location_on,
            'Venue',
            event.venue,
          ),
          
          // Attendees
          if (event.attendeeCount > 0)
            _buildInfoRow(
              context,
              Icons.people,
              'Expected Attendees',
              _formatAttendeeCount(event.attendeeCount),
            ),
          
          const SizedBox(height: 16),
          
          // Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: event.tags.map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '#$tag',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingWidget(BuildContext context, EventModel event) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.star,
            size: 18,
            color: Colors.amber,
          ),
          const SizedBox(width: 4),
          Text(
            event.rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(BuildContext context, EventModel event) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About This Event',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              event.detailedDescription,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSchedule(BuildContext context, EventModel event) {
    if (event.schedule.isEmpty) return Container();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Schedule',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...event.schedule.map((schedule) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${DateFormat('HH:mm').format(schedule.startTime)} - ${DateFormat('HH:mm').format(schedule.endTime)}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      schedule.title,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (schedule.description != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        schedule.description!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                    if (schedule.location != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.place,
                            size: 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            schedule.location!,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlights(BuildContext context, EventModel event) {
    if (event.highlights.isEmpty) return Container();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Highlights',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...event.highlights.map((highlight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        highlight,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketInfo(BuildContext context, EventModel event) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            if (event.priceInfo.isFree) ...[
              Row(
                children: [
                  Icon(
                    Icons.card_giftcard,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Free Entry',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              if (event.priceInfo.priceNote != null) ...[
                const SizedBox(height: 8),
                Text(
                  event.priceInfo.priceNote!,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ] else ...[
              if (event.priceInfo.ticketTiers != null) ...[
                ...event.priceInfo.ticketTiers!.map((tier) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: tier.isAvailable 
                            ? AppColors.primary.withValues(alpha: 0.3)
                            : Colors.grey.withValues(alpha: 0.3),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                tier.name,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '¥${tier.price.toInt()}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tier.description,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        if (tier.remainingTickets != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            '${tier.remainingTickets} tickets remaining',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: tier.remainingTickets! < 50 ? Colors.red : Colors.green,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        if (!tier.isAvailable) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Sold Out',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ] else ...[
                Text(
                  event.priceInfo.displayPrice,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
            
            const SizedBox(height: 16),
            
            // Ticket actions
            if (event.requiresTicket && event.ticketUrl != null) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _launchUrl(event.ticketUrl!),
                  icon: const Icon(Icons.confirmation_num),
                  label: Text(event.priceInfo.isFree ? 'Reserve Free Ticket' : 'Buy Tickets'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ] else if (!event.requiresTicket) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'No ticket required - just show up!',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityInfo(BuildContext context, EventModel event) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Accessibility',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            _buildAccessibilityFeature(
              context,
              Icons.accessible,
              'Wheelchair Accessible',
              event.accessibility.wheelchairAccessible,
            ),
            _buildAccessibilityFeature(
              context,
              Icons.sign_language,
              'Sign Language Interpretation',
              event.accessibility.hasSignLanguage,
            ),
            _buildAccessibilityFeature(
              context,
              Icons.hearing,
              'Audio Description',
              event.accessibility.hasAudioDescription,
            ),
            _buildAccessibilityFeature(
              context,
              Icons.touch_app,
              'Braille Materials',
              event.accessibility.hasBraille,
            ),
            
            if (event.accessibility.accessibilityFeatures.isNotEmpty) ...[
              const SizedBox(height: 8),
              ...event.accessibility.accessibilityFeatures.map((feature) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        width: 4,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          feature,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccessibilityFeature(BuildContext context, IconData icon, String feature, bool available) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: available ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: available ? null : Colors.grey,
              ),
            ),
          ),
          Icon(
            available ? Icons.check : Icons.close,
            size: 16,
            color: available ? Colors.green : Colors.grey,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationInfo(BuildContext context, EventModel event) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Location & Directions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            // Address
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    event.address,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Transportation info
            if (event.transportationInfo != null) ...[
              Text(
                'Transportation',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Nearest stations
              if (event.transportationInfo!.nearestStations.isNotEmpty) ...[
                Text(
                  'Nearest Stations:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ...event.transportationInfo!.nearestStations.map((station) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Row(
                      children: [
                        Icon(
                          Icons.train,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 8),
                        Text(station),
                      ],
                    ),
                  );
                }),
              ],
              
              const SizedBox(height: 8),
              
              // Directions
              if (event.transportationInfo!.directions.isNotEmpty) ...[
                Text(
                  'Directions:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                ...event.transportationInfo!.directions.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 16, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.key,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          entry.value,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
              
              // Parking info
              if (event.transportationInfo!.parkingInfo != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.local_parking,
                      size: 16,
                      color: event.transportationInfo!.hasParkingAvailable 
                          ? Colors.green 
                          : Colors.red,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.transportationInfo!.parkingInfo!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ],
              
              const SizedBox(height: 16),
            ],
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _openInMaps(event),
                    icon: const Icon(Icons.map),
                    label: const Text('Open in Maps'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _getDirections(event),
                    icon: const Icon(Icons.directions),
                    label: const Text('Get Directions'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, EventModel event) {
    if (event.contactInfo == null) return Container();
    
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            if (event.contactInfo!.phoneNumber != null)
              _buildContactRow(
                context,
                Icons.phone,
                'Phone',
                event.contactInfo!.phoneNumber!,
                () => _launchUrl('tel:${event.contactInfo!.phoneNumber}'),
              ),
            
            if (event.contactInfo!.email != null)
              _buildContactRow(
                context,
                Icons.email,
                'Email',
                event.contactInfo!.email!,
                () => _launchUrl('mailto:${event.contactInfo!.email}'),
              ),
            
            if (event.websiteUrl != null)
              _buildContactRow(
                context,
                Icons.language,
                'Website',
                'Official Website',
                () => _launchUrl(event.websiteUrl!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String label, String value, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: AppColors.primary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.open_in_new,
              size: 16,
              color: Colors.grey[600],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event Details'),
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
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Error Loading Event',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                context.read<EventsBloc>().add(LoadEventById(eventId: widget.eventId));
              },
              child: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  // Helper methods
  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.traditional:
        return Colors.brown;
      case EventCategory.modern:
        return Colors.blue;
      case EventCategory.anime:
        return Colors.purple;
      case EventCategory.popCulture:
        return Colors.pink;
      case EventCategory.nature:
        return Colors.green;
      case EventCategory.history:
        return Colors.indigo;
      case EventCategory.foodAndDrink:
        return Colors.orange;
      case EventCategory.entertainment:
        return Colors.red;
      case EventCategory.education:
        return Colors.teal;
      case EventCategory.shopping:
        return Colors.cyan;
    }
  }

  String _formatEventDateTime(EventModel event) {
    final dateFormat = DateFormat('EEEE, MMMM d, y');
    final timeFormat = DateFormat('HH:mm');
    
    if (event.startDate.day == event.endDate.day) {
      return '${dateFormat.format(event.startDate)}\n${timeFormat.format(event.startDate)} - ${timeFormat.format(event.endDate)}';
    } else {
      return '${dateFormat.format(event.startDate)} - ${dateFormat.format(event.endDate)}';
    }
  }

  String _formatAttendeeCount(int count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M people';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K people';
    } else {
      return '$count people';
    }
  }

  void _shareEvent(EventModel event) {
    // Implement share functionality
  }

  void _addToFavorites(EventModel event) {
    // Implement add to favorites functionality
  }

  void _launchUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _openInMaps(EventModel event) {
    if (event.latitude != null && event.longitude != null) {
      final url = 'https://maps.google.com/?q=${event.latitude},${event.longitude}';
      _launchUrl(url);
    }
  }

  void _getDirections(EventModel event) {
    if (event.latitude != null && event.longitude != null) {
      final url = 'https://maps.google.com/maps?daddr=${event.latitude},${event.longitude}';
      _launchUrl(url);
    }
  }
} 
