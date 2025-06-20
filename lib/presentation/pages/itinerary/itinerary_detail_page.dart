import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/itinerary_model.dart';
import '../../bloc/itinerary/itinerary_bloc.dart';
import '../../bloc/itinerary/itinerary_event.dart';
import '../../bloc/itinerary/itinerary_state.dart';
import '../../widgets/common/loading_widget.dart';

class ItineraryDetailPage extends StatefulWidget {
  final String itineraryId;

  const ItineraryDetailPage({
    super.key,
    required this.itineraryId,
  });

  @override
  State<ItineraryDetailPage> createState() => _ItineraryDetailPageState();
}

class _ItineraryDetailPageState extends State<ItineraryDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<ItineraryBloc>().add(
      LoadItineraryById(itineraryId: widget.itineraryId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ItineraryBloc, ItineraryState>(
        builder: (context, state) {
          if (state is ItineraryLoading) {
            return const Scaffold(
              body: Center(child: LoadingWidget()),
            );
          }

          if (state is ItineraryError) {
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

          if (state is ItineraryLoaded && state.selectedItinerary != null) {
            return _buildItineraryDetail(context, state.selectedItinerary!);
          }

          return const Scaffold(
            body: Center(child: Text('Itinerary not found')),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/itinerary/edit/${widget.itineraryId}'),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.edit, color: Colors.white),
      ),
    );
  }

  Widget _buildItineraryDetail(BuildContext context, ItineraryModel itinerary) {
    return CustomScrollView(
      slivers: [
        _buildSliverAppBar(context, itinerary),
        SliverList(
          delegate: SliverChildListDelegate([
            _buildItineraryInfo(context, itinerary),
            _buildDaysList(context, itinerary),
            const SizedBox(height: 100), // Bottom padding for FAB
          ]),
        ),
      ],
    );
  }

  Widget _buildSliverAppBar(BuildContext context, ItineraryModel itinerary) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          itinerary.title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.primaryGradient,
            ),
          ),
          child: Stack(
            children: [
              if (itinerary.imageUrls.isNotEmpty)
                Image.network(
                  itinerary.imageUrls.first,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
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
            ],
          ),
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          onSelected: (value) {
            switch (value) {
              case 'edit':
                context.push('/itinerary/edit/${itinerary.id}');
                break;
              case 'share':
                _shareItinerary(itinerary);
                break;
              case 'delete':
                _confirmDelete(context, itinerary);
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem<String>(
              value: 'edit',
              child: ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'share',
              child: ListTile(
                leading: Icon(Icons.share),
                title: Text('Share'),
              ),
            ),
            const PopupMenuItem<String>(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete, color: Colors.red),
                title: Text('Delete', style: TextStyle(color: Colors.red)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildItineraryInfo(BuildContext context, ItineraryModel itinerary) {
    final dateFormat = DateFormat('MMM d, yyyy');

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Destination and Dates
          Row(
            children: [
              Icon(Icons.location_on, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  itinerary.destination,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Duration Info
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.calendar_today, color: AppColors.primary),
                      const SizedBox(height: 4),
                      Text(
                        '${dateFormat.format(itinerary.startDate)} -\n${dateFormat.format(itinerary.endDate)}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.schedule, color: AppColors.primary),
                      const SizedBox(height: 4),
                      Text(
                        '${itinerary.durationInDays} Days',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: Column(
                    children: [
                      Icon(Icons.list_alt, color: AppColors.primary),
                      const SizedBox(height: 4),
                      Text(
                        '${itinerary.totalActivities} Activities',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Description
          if (itinerary.description.isNotEmpty) ...[
            Text(
              'Description',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              itinerary.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
          ],

          // Budget
          if (itinerary.estimatedBudget > 0) ...[
            Row(
              children: [
                Icon(Icons.attach_money, color: AppColors.secondary),
                const SizedBox(width: 8),
                Text(
                  'Budget: ${itinerary.estimatedBudget.toStringAsFixed(0)} ${itinerary.currency}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],

          // Tags
          if (itinerary.tags.isNotEmpty) ...[
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: itinerary.tags.map((tag) {
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
                    '#$tag',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDaysList(BuildContext context, ItineraryModel itinerary) {
    if (itinerary.days.isEmpty) {
      return Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_note,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No activities planned yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Start adding activities to your itinerary',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Daily Itinerary',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ...itinerary.days.map((day) => _buildDayCard(context, day, itinerary)),
      ],
    );
  }

  Widget _buildDayCard(BuildContext context, ItineraryDay day, ItineraryModel itinerary) {
    final dateFormat = DateFormat('EEE, MMM d');
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.all(16),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${day.date.day}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          title: Text(
            day.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dateFormat.format(day.date),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${day.activities.length} activities',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddActivityDialog(context, itinerary, day.date),
          ),
          children: [
            if (day.activities.isEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.event_available,
                      size: 32,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No activities planned for this day',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              )
            else
              ...day.activities.map((activity) => _buildActivityCard(
                context,
                activity,
                itinerary,
                day.date,
              )),

            if (day.notes != null && day.notes!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.note,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        day.notes!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
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

  Widget _buildActivityCard(
    BuildContext context,
    ItineraryActivity activity,
    ItineraryModel itinerary,
    DateTime date,
  ) {
    final timeFormat = DateFormat('HH:mm');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: activity.isCompleted
            ? AppColors.success.withValues(alpha: 0.1)
            : Colors.white,
        border: Border.all(
          color: activity.isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : Colors.grey[200]!,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              context.read<ItineraryBloc>().add(
                MarkActivityCompleted(
                  itineraryId: itinerary.id,
                  date: date,
                  activityId: activity.id,
                  isCompleted: !activity.isCompleted,
                ),
              );
            },
            child: Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: activity.isCompleted
                    ? AppColors.success
                    : Colors.transparent,
                border: Border.all(
                  color: activity.isCompleted
                      ? AppColors.success
                      : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: activity.isCompleted
                  ? const Icon(
                      Icons.check,
                      size: 16,
                      color: Colors.white,
                    )
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        activity.title,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          decoration: activity.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getActivityTypeColor(activity.type).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        activity.type.displayName,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: _getActivityTypeColor(activity.type),
                          fontWeight: FontWeight.w500,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${timeFormat.format(activity.startTime)} - ${timeFormat.format(activity.endTime)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
                if (activity.description.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    activity.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[700],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (activity.location != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 12,
                        color: Colors.grey[500],
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          activity.location!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
                if (activity.estimatedCost != null && activity.estimatedCost! > 0) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Cost: ${activity.estimatedCost!.toStringAsFixed(0)} ${itinerary.currency}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            icon: Icon(
              Icons.more_vert,
              size: 16,
              color: Colors.grey[600],
            ),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _showEditActivityDialog(context, itinerary, date, activity);
                  break;
                case 'delete':
                  _confirmDeleteActivity(context, itinerary, date, activity);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'edit',
                child: Text('Edit'),
              ),
              const PopupMenuItem<String>(
                value: 'delete',
                child: Text('Delete'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getActivityTypeColor(ActivityType type) {
    switch (type) {
      case ActivityType.sightseeing:
        return AppColors.primary;
      case ActivityType.dining:
        return AppColors.halalFood;
      case ActivityType.shopping:
        return AppColors.warning;
      case ActivityType.transportation:
        return AppColors.info;
      case ActivityType.accommodation:
        return AppColors.secondary;
      case ActivityType.prayer:
        return AppColors.prayerTime;
      case ActivityType.entertainment:
        return Colors.purple;
      case ActivityType.business:
        return Colors.grey;
      case ActivityType.other:
        return Colors.teal;
    }
  }

  void _showAddActivityDialog(BuildContext context, ItineraryModel itinerary, DateTime date) {
    showDialog(
      context: context,
      builder: (context) => _ActivityDialog(
        itinerary: itinerary,
        date: date,
        onSave: (activity) {
          context.read<ItineraryBloc>().add(
            AddActivityToItinerary(
              itineraryId: itinerary.id,
              date: date,
              activity: activity,
            ),
          );
        },
      ),
    );
  }

  void _showEditActivityDialog(
    BuildContext context,
    ItineraryModel itinerary,
    DateTime date,
    ItineraryActivity activity,
  ) {
    showDialog(
      context: context,
      builder: (context) => _ActivityDialog(
        itinerary: itinerary,
        date: date,
        activity: activity,
        onSave: (updatedActivity) {
          context.read<ItineraryBloc>().add(
            UpdateActivity(
              itineraryId: itinerary.id,
              date: date,
              activity: updatedActivity,
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteActivity(
    BuildContext context,
    ItineraryModel itinerary,
    DateTime date,
    ItineraryActivity activity,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Activity'),
          content: Text('Are you sure you want to delete "${activity.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ItineraryBloc>().add(
                  DeleteActivity(
                    itineraryId: itinerary.id,
                    date: date,
                    activityId: activity.id,
                  ),
                );
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _shareItinerary(ItineraryModel itinerary) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality will be implemented'),
      ),
    );
  }

  void _confirmDelete(BuildContext context, ItineraryModel itinerary) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Itinerary'),
          content: Text(
            'Are you sure you want to delete "${itinerary.title}"? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<ItineraryBloc>().add(
                  DeleteItinerary(itineraryId: itinerary.id),
                );
                context.pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.error,
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

class _ActivityDialog extends StatefulWidget {
  final ItineraryModel itinerary;
  final DateTime date;
  final ItineraryActivity? activity;
  final Function(ItineraryActivity) onSave;

  const _ActivityDialog({
    required this.itinerary,
    required this.date,
    this.activity,
    required this.onSave,
  });

  @override
  State<_ActivityDialog> createState() => _ActivityDialogState();
}

class _ActivityDialogState extends State<_ActivityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _costController = TextEditingController();
  final _notesController = TextEditingController();

  ActivityType _selectedType = ActivityType.sightseeing;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);

  bool get _isEditing => widget.activity != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      _populateFields();
    }
  }

  void _populateFields() {
    final activity = widget.activity!;
    _titleController.text = activity.title;
    _descriptionController.text = activity.description;
    _locationController.text = activity.location ?? '';
    _costController.text = activity.estimatedCost?.toString() ?? '';
    _notesController.text = activity.notes ?? '';
    _selectedType = activity.type;
    _startTime = TimeOfDay.fromDateTime(activity.startTime);
    _endTime = TimeOfDay.fromDateTime(activity.endTime);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                _isEditing ? 'Edit Activity' : 'Add Activity',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Activity Title *',
                          prefixIcon: Icon(Icons.title),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<ActivityType>(
                        value: _selectedType,
                        decoration: const InputDecoration(
                          labelText: 'Activity Type',
                          prefixIcon: Icon(Icons.category),
                        ),
                        items: ActivityType.values.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type.displayName),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(true),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Start Time',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      _startTime.format(context),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => _selectTime(false),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'End Time',
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    Text(
                                      _endTime.format(context),
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Location',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _descriptionController,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          prefixIcon: Icon(Icons.description),
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _costController,
                        decoration: InputDecoration(
                          labelText: 'Estimated Cost (${widget.itinerary.currency})',
                          prefixIcon: const Icon(Icons.attach_money),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notes',
                          prefixIcon: Icon(Icons.note),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveActivity,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: Text(_isEditing ? 'Update' : 'Add'),
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

  Future<void> _selectTime(bool isStartTime) async {
    final time = await showTimePicker(
      context: context,
      initialTime: isStartTime ? _startTime : _endTime,
    );

    if (time != null) {
      setState(() {
        if (isStartTime) {
          _startTime = time;
          // Automatically set end time to 1 hour later if it's before start time
          if (_endTime.hour < _startTime.hour ||
              (_endTime.hour == _startTime.hour && _endTime.minute <= _startTime.minute)) {
            _endTime = TimeOfDay(
              hour: (_startTime.hour + 1) % 24,
              minute: _startTime.minute,
            );
          }
        } else {
          _endTime = time;
        }
      });
    }
  }

  void _saveActivity() {
    if (!_formKey.currentState!.validate()) return;

    final startDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      _startTime.hour,
      _startTime.minute,
    );

    final endDateTime = DateTime(
      widget.date.year,
      widget.date.month,
      widget.date.day,
      _endTime.hour,
      _endTime.minute,
    );

    final activity = ItineraryActivity(
      id: _isEditing ? widget.activity!.id : '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      startTime: startDateTime,
      endTime: endDateTime,
      location: _locationController.text.trim().isEmpty
          ? null
          : _locationController.text.trim(),
      type: _selectedType,
      estimatedCost: double.tryParse(_costController.text),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      imageUrls: [],
      isCompleted: _isEditing ? widget.activity!.isCompleted : false,
    );

    widget.onSave(activity);
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _costController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
