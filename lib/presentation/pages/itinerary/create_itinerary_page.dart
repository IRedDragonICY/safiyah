import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../data/models/itinerary_model.dart';
import '../../bloc/itinerary/itinerary_bloc.dart';
import '../../bloc/itinerary/itinerary_event.dart';
import '../../bloc/itinerary/itinerary_state.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class CreateItineraryPage extends StatefulWidget {
  final String? itineraryId;

  const CreateItineraryPage({
    super.key,
    this.itineraryId,
  });

  @override
  State<CreateItineraryPage> createState() => _CreateItineraryPageState();
}

class _CreateItineraryPageState extends State<CreateItineraryPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _destinationController = TextEditingController();
  final _budgetController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  String _currency = 'USD';
  final List<String> _tags = [];
  final TextEditingController _tagController = TextEditingController();

  bool get _isEditing => widget.itineraryId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      context.read<ItineraryBloc>().add(
        LoadItineraryById(itineraryId: widget.itineraryId!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Itinerary' : 'Create Itinerary'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<ItineraryBloc, ItineraryState>(
        listener: (context, state) {
          if (state is ItineraryOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
            context.pop();
          } else if (state is ItineraryOperationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is ItineraryLoaded && state.selectedItinerary != null) {
            _populateFields(state.selectedItinerary!);
          }
        },
        builder: (context, state) {
          if (state is ItineraryLoading && _isEditing) {
            return const Center(child: CircularProgressIndicator());
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildBasicInfoSection(),
                  const SizedBox(height: 24),
                  _buildDatesSection(),
                  const SizedBox(height: 24),
                  _buildBudgetSection(),
                  const SizedBox(height: 24),
                  _buildTagsSection(),
                  const SizedBox(height: 32),
                  _buildSaveButton(state),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _titleController,
              labelText: 'Itinerary Title *',
              hintText: 'Enter a descriptive title',
              prefixIcon: const Icon(Icons.title),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _destinationController,
              labelText: 'Destination *',
              hintText: 'City, Country',
              prefixIcon: const Icon(Icons.location_on),
            ),
            const SizedBox(height: 16),
            CustomTextField(
              controller: _descriptionController,
              labelText: 'Description',
              hintText: 'Describe your travel plans...',
              prefixIcon: const Icon(Icons.description),
              maxLines: 3,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDatesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Travel Dates',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateField(
                    label: 'Start Date *',
                    date: _startDate,
                    onTap: () => _selectStartDate(),
                    icon: Icons.calendar_today,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildDateField(
                    label: 'End Date *',
                    date: _endDate,
                    onTap: () => _selectEndDate(),
                    icon: Icons.event,
                  ),
                ),
              ],
            ),
            if (_startDate != null && _endDate != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Duration: ${_endDate!.difference(_startDate!).inDays + 1} days',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String label,
    required DateTime? date,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.grey[600]),
            const SizedBox(width: 8),
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
                    date != null
                        ? DateFormat('MMM d, yyyy').format(date)
                        : 'Select date',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: date != null ? null : Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Budget (Optional)',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomTextField(
                    controller: _budgetController,
                    labelText: 'Estimated Budget',
                    hintText: '0',
                    keyboardType: TextInputType.number,
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _currency,
                    decoration: const InputDecoration(
                      labelText: 'Currency',
                    ),
                    items: ['USD', 'EUR', 'GBP', 'MYR', 'IDR', 'SAR', 'AED']
                        .map((currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _currency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTagsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tags',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: _tagController,
                    labelText: 'Add Tag',
                    hintText: 'e.g., halal, heritage, food',
                    prefixIcon: const Icon(Icons.tag),
                    onSubmitted: (value) => _addTag(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _addTag,
                  icon: const Icon(Icons.add),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            if (_tags.isNotEmpty) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _tags.map((tag) {
                  return Chip(
                    label: Text(tag),
                    deleteIcon: const Icon(Icons.close, size: 16),
                    onDeleted: () {
                      setState(() {
                        _tags.remove(tag);
                      });
                    },
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    deleteIconColor: AppColors.primary,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(ItineraryState state) {
    return CustomButton(
      text: _isEditing ? 'Update Itinerary' : 'Create Itinerary',
      onPressed: () => _saveItinerary(),
      isLoading: state is ItineraryOperationLoading,
      icon: _isEditing ? Icons.update : Icons.save,
    );
  }

  void _populateFields(ItineraryModel itinerary) {
    _titleController.text = itinerary.title;
    _descriptionController.text = itinerary.description;
    _destinationController.text = itinerary.destination;
    _budgetController.text = itinerary.estimatedBudget.toString();
    _startDate = itinerary.startDate;
    _endDate = itinerary.endDate;
    _currency = itinerary.currency;
    _tags.clear();
    _tags.addAll(itinerary.tags);
    setState(() {});
  }

  void _addTag() {
    final tag = _tagController.text.trim();
    if (tag.isNotEmpty && !_tags.contains(tag)) {
      setState(() {
        _tags.add(tag);
        _tagController.clear();
      });
    }
  }

  Future<void> _selectStartDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
    );

    if (date != null) {
      setState(() {
        _startDate = date;
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = null;
        }
      });
    }
  }

  Future<void> _selectEndDate() async {
    if (_startDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select start date first')),
      );
      return;
    }

    final date = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate!.add(const Duration(days: 1)),
      firstDate: _startDate!,
      lastDate: _startDate!.add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() {
        _endDate = date;
      });
    }
  }

  void _saveItinerary() {
    if (!_validateForm()) return;

    final itinerary = ItineraryModel(
      id: _isEditing ? widget.itineraryId! : '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      destination: _destinationController.text.trim(),
      startDate: _startDate!,
      endDate: _endDate!,
      days: _generateInitialDays(),
      userId: 'user123', // In real app, get from auth
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      imageUrls: [],
      estimatedBudget: double.tryParse(_budgetController.text) ?? 0,
      currency: _currency,
      isPublic: false,
      tags: _tags,
    );

    if (_isEditing) {
      context.read<ItineraryBloc>().add(UpdateItinerary(itinerary: itinerary));
    } else {
      context.read<ItineraryBloc>().add(CreateItinerary(itinerary: itinerary));
    }
  }

  List<ItineraryDay> _generateInitialDays() {
    if (_startDate == null || _endDate == null) return [];

    final days = <ItineraryDay>[];
    var currentDate = _startDate!;
    var dayNumber = 1;

    while (!currentDate.isAfter(_endDate!)) {
      days.add(ItineraryDay(
        date: currentDate,
        title: 'Day $dayNumber',
        activities: [],
      ));
      currentDate = currentDate.add(const Duration(days: 1));
      dayNumber++;
    }

    return days;
  }

  bool _validateForm() {
    if (_titleController.text.trim().isEmpty) {
      _showError('Please enter a title');
      return false;
    }

    if (_destinationController.text.trim().isEmpty) {
      _showError('Please enter a destination');
      return false;
    }

    if (_startDate == null) {
      _showError('Please select a start date');
      return false;
    }

    if (_endDate == null) {
      _showError('Please select an end date');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _destinationController.dispose();
    _budgetController.dispose();
    _tagController.dispose();
    super.dispose();
  }
}