import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/event_model.dart';
import '../../bloc/events/events_bloc.dart';
import '../../bloc/events/events_event.dart';
import '../../bloc/events/events_state.dart';
import '../../widgets/events/event_card.dart';
import '../../widgets/common/loading_widget.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController _tabController;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    context.read<EventsBloc>().add(const LoadEvents());
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) return;
    
    switch (_tabController.index) {
      case 0:
        context.read<EventsBloc>().add(const LoadEvents());
        break;
      case 1:
        context.read<EventsBloc>().add(const LoadUpcomingEvents());
        break;
      case 2:
        context.read<EventsBloc>().add(const LoadOngoingEvents());
        break;
      case 3:
        context.read<EventsBloc>().add(const LoadFreeEvents());
        break;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            _buildSliverAppBar(context, innerBoxIsScrolled),
            _buildSliverTabBar(context),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildAllEventsTab(),
            _buildUpcomingEventsTab(),
            _buildOngoingEventsTab(),
            _buildFreeEventsTab(),
          ],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      surfaceTintColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Events',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        titlePadding: const EdgeInsets.only(left: 16, bottom: 76),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Theme.of(context).colorScheme.surfaceVariant,
                Theme.of(context).colorScheme.surface,
              ],
            ),
          ),
          child: Stack(
            children: [
              // Decorative pattern
              ...List.generate(3, (index) {
                return Positioned(
                  right: -30 + (index * 40),
                  top: 20 + (index * 30),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.05),
                    ),
                  ),
                );
              }),
              Positioned(
                top: 60,
                left: 16,
                right: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Discover Japan',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find amazing cultural events and experiences',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: _buildSearchBar(context),
        ),
      ),
      actions: [
        IconButton(
          icon: Badge(
            isLabelVisible: _showFilters,
            child: Icon(
              _showFilters ? Icons.filter_list_off : Icons.filter_list,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          onPressed: () {
            setState(() {
              _showFilters = !_showFilters;
            });
          },
        ),
        IconButton(
          icon: Icon(Icons.sort, color: Theme.of(context).colorScheme.onSurfaceVariant),
          onPressed: () => _showSortDialog(context),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.circular(28),
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: TextField(
        controller: _searchController,
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: 'Search events, venues, or categories...',
          hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          prefixIcon: Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  onPressed: () {
                    _searchController.clear();
                    context.read<EventsBloc>().add(const LoadEvents());
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(28),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        ),
        onSubmitted: (query) {
          if (query.isNotEmpty) {
            context.read<EventsBloc>().add(SearchEvents(query: query));
          } else {
            context.read<EventsBloc>().add(const LoadEvents());
          }
        },
      ),
    );
  }

  Widget _buildSliverTabBar(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabBarDelegate(
        showFilters: _showFilters,
        child: Column(
          children: [
            if (_showFilters) _buildFiltersSection(context),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor.withOpacity(0.1),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                labelColor: Theme.of(context).colorScheme.primary,
                unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
                indicatorColor: Theme.of(context).colorScheme.primary,
                indicatorWeight: 3,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
                unselectedLabelStyle: Theme.of(context).textTheme.labelLarge,
                tabs: const [
                  Tab(text: 'All Events'),
                  Tab(text: 'Upcoming'),
                  Tab(text: 'Live Now'),
                  Tab(text: 'Free'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filters',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          
          // Category filters
          Text(
            'Categories',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: EventCategory.values.map((category) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(category.displayName),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    onSelected: (selected) {
                      context.read<EventsBloc>().add(
                        FilterEventsByCategory(category: selected ? category : null),
                      );
                    },
                    selected: false,
                    showCheckmark: false,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                );
              }).toList(),
            ),
          ),
          
          const SizedBox(height: 12),
          
          // Type filters
          Text(
            'Event Types',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: EventType.values.map((type) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type.displayName),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    onSelected: (selected) {
                      context.read<EventsBloc>().add(
                        FilterEventsByType(type: selected ? type : null),
                      );
                    },
                    selected: false,
                    showCheckmark: false,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    selectedColor: Theme.of(context).colorScheme.primaryContainer,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAllEventsTab() {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return _buildEventsList(context, state);
      },
    );
  }

  Widget _buildUpcomingEventsTab() {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return _buildEventsList(context, state);
      },
    );
  }

  Widget _buildOngoingEventsTab() {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return _buildEventsList(context, state);
      },
    );
  }

  Widget _buildFreeEventsTab() {
    return BlocBuilder<EventsBloc, EventsState>(
      builder: (context, state) {
        return _buildEventsList(context, state);
      },
    );
  }

  Widget _buildEventsList(BuildContext context, EventsState state) {
    if (state is EventsLoading) {
      return const Center(child: LoadingWidget());
    }

    if (state is EventsError) {
      return _buildErrorWidget(context, state.message);
    }

    if (state is EventsEmpty) {
      return _buildEmptyWidget(context, state.message);
    }

    if (state is EventsLoaded) {
      return RefreshIndicator(
        onRefresh: () async {
          context.read<EventsBloc>().add(const RefreshEvents());
        },
        child: Column(
          children: [
            if (state.hasActiveFilters) _buildActiveFiltersChip(context, state),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 100),
                itemCount: state.events.length,
                itemBuilder: (context, index) {
                  final event = state.events[index];
                  return EventCard(
                    event: event,
                    onTap: () => _navigateToEventDetail(context, event.id),
                  );
                },
              ),
            ),
          ],
        ),
      );
    }

    return Container();
  }

  Widget _buildActiveFiltersChip(BuildContext context, EventsLoaded state) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Filters active',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              context.read<EventsBloc>().add(const ClearFilters());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
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
            'Oops! Something went wrong',
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
              context.read<EventsBloc>().add(const LoadEvents());
            },
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.event_busy,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Events Found',
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
              context.read<EventsBloc>().add(const LoadEvents());
            },
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showQuickFilters(context),
      icon: const Icon(Icons.explore_outlined),
      label: const Text('Explore'),
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      elevation: 0,
    );
  }

  void _showSortDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Sort Events',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...EventSortType.values.map((sortType) {
              return ListTile(
                leading: Icon(_getSortIcon(sortType)),
                title: Text(_getSortLabel(sortType)),
                onTap: () {
                  context.read<EventsBloc>().add(SortEvents(sortType: sortType));
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  void _showQuickFilters(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Text(
              'Quick Filters',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.upcoming, color: Colors.blue),
              title: const Text('Upcoming Events'),
              onTap: () {
                context.read<EventsBloc>().add(const LoadUpcomingEvents());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.live_tv, color: Colors.red),
              title: const Text('Live Events'),
              onTap: () {
                context.read<EventsBloc>().add(const LoadOngoingEvents());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.money_off, color: Colors.green),
              title: const Text('Free Events'),
              onTap: () {
                context.read<EventsBloc>().add(const LoadFreeEvents());
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.animation, color: Colors.purple),
              title: const Text('Anime Events'),
              onTap: () {
                context.read<EventsBloc>().add(const FilterEventsByCategory(category: EventCategory.anime));
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.festival, color: Colors.orange),
              title: const Text('Traditional Festivals'),
              onTap: () {
                context.read<EventsBloc>().add(const FilterEventsByCategory(category: EventCategory.traditional));
                Navigator.pop(context);
              },
            ),
            const SizedBox(height: 32),
          ],
        );
      },
    );
  }

  IconData _getSortIcon(EventSortType sortType) {
    switch (sortType) {
      case EventSortType.startDate:
        return Icons.schedule;
      case EventSortType.name:
        return Icons.sort_by_alpha;
      case EventSortType.rating:
        return Icons.star;
      case EventSortType.attendeeCount:
        return Icons.people;
      case EventSortType.price:
        return Icons.attach_money;
    }
  }

  String _getSortLabel(EventSortType sortType) {
    switch (sortType) {
      case EventSortType.startDate:
        return 'By Date';
      case EventSortType.name:
        return 'By Name';
      case EventSortType.rating:
        return 'By Rating';
      case EventSortType.attendeeCount:
        return 'By Popularity';
      case EventSortType.price:
        return 'By Price';
    }
  }

  void _navigateToEventDetail(BuildContext context, String eventId) {
    context.push('/events/detail/$eventId');
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final bool showFilters;

  _SliverTabBarDelegate({
    required this.child,
    required this.showFilters,
  });

  @override
  double get minExtent => kToolbarHeight;

  @override
  double get maxExtent => showFilters ? kToolbarHeight + 160 : kToolbarHeight;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: child,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return showFilters != oldDelegate.showFilters;
  }
} 