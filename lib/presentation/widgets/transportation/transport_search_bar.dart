import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';

class TransportSearchBar extends StatefulWidget {
  final TextEditingController fromController;
  final TextEditingController toController;
  final DateTime selectedDate;
  final DateTime? returnDate;
  final Function(DateTime) onDateSelected;
  final Function(DateTime?)? onReturnDateSelected;
  final VoidCallback onSearch;
  final bool isRoundTrip;
  final Function(bool)? onTripTypeChanged;

  const TransportSearchBar({
    super.key,
    required this.fromController,
    required this.toController,
    required this.selectedDate,
    this.returnDate,
    required this.onDateSelected,
    this.onReturnDateSelected,
    required this.onSearch,
    this.isRoundTrip = false,
    this.onTripTypeChanged,
  });

  @override
  State<TransportSearchBar> createState() => _TransportSearchBarState();
}

class _TransportSearchBarState extends State<TransportSearchBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Trip Type Toggle
          if (widget.onTripTypeChanged != null) ...[
            Row(
              children: [
                Expanded(
                  child: _buildTripTypeButton('One Way', !widget.isRoundTrip),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildTripTypeButton('Round Trip', widget.isRoundTrip),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          
          // Location Fields
          Row(
            children: [
              Expanded(
                child: _buildLocationField(
                  context,
                  controller: widget.fromController,
                  label: 'From',
                  icon: Icons.my_location,
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _swapLocations,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.swap_horiz,
                    color: AppColors.primary,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocationField(
                  context,
                  controller: widget.toController,
                  label: 'To',
                  icon: Icons.location_on,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Date Fields
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context,
                  'Departure',
                  widget.selectedDate,
                  widget.onDateSelected,
                ),
              ),
              if (widget.isRoundTrip && widget.onReturnDateSelected != null) ...[
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDateField(
                    context,
                    'Return',
                    widget.returnDate ?? widget.selectedDate.add(const Duration(days: 7)),
                    widget.onReturnDateSelected!,
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          
          // Search Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: widget.onSearch,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.search),
              label: const Text(
                'Search Flights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeButton(String text, bool isSelected) {
    return GestureDetector(
      onTap: () {
        if (widget.onTripTypeChanged != null) {
          widget.onTripTypeChanged!(text == 'Round Trip');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.grey[300]!,
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 16,
        ),
      ),
      onTap: () => _showLocationPicker(context, controller, label),
      readOnly: true,
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime date,
    Function(DateTime) onDateChange,
  ) {
    return GestureDetector(
      onTap: () => _showDatePicker(context, date, onDateChange),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primary, size: 16),
                const SizedBox(width: 8),
                Text(
                  DateFormat('MMM dd, yyyy').format(date),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _swapLocations() {
    final temp = widget.fromController.text;
    widget.fromController.text = widget.toController.text;
    widget.toController.text = temp;
  }

  void _showLocationPicker(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) {
    final locations = [
      {
        'city': 'Tokyo',
        'airport': 'Haneda Airport (HND)',
        'code': 'HND',
      },
      {
        'city': 'Tokyo',
        'airport': 'Narita International Airport (NRT)',
        'code': 'NRT',
      },
      {
        'city': 'Osaka',
        'airport': 'Kansai International Airport (KIX)',
        'code': 'KIX',
      },
      {
        'city': 'Osaka',
        'airport': 'Itami Airport (ITM)',
        'code': 'ITM',
      },
      {
        'city': 'Kyoto',
        'airport': 'Kansai International Airport (KIX)',
        'code': 'KIX',
      },
      {
        'city': 'Nagoya',
        'airport': 'Chubu Centrair International Airport (NGO)',
        'code': 'NGO',
      },
      {
        'city': 'Hiroshima',
        'airport': 'Hiroshima Airport (HIJ)',
        'code': 'HIJ',
      },
      {
        'city': 'Sapporo',
        'airport': 'New Chitose Airport (CTS)',
        'code': 'CTS',
      },
      {
        'city': 'Fukuoka',
        'airport': 'Fukuoka Airport (FUK)',
        'code': 'FUK',
      },
      {
        'city': 'Okinawa',
        'airport': 'Naha Airport (OKA)',
        'code': 'OKA',
      },
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(top: 8, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    'Select $label Location',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: locations.length,
                itemBuilder: (context, index) {
                  final location = locations[index];
                  return ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.flight,
                        color: AppColors.primary,
                        size: 20,
                      ),
                    ),
                    title: Text(
                      location['city']!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(location['airport']!),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.secondary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        location['code']!,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    onTap: () {
                      controller.text = '${location['city']} (${location['code']})';
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(
    BuildContext context,
    DateTime currentDate,
    Function(DateTime) onDateChange,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: AppColors.primary,
                  secondary: AppColors.secondary,
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != currentDate) {
      onDateChange(picked);
    }
  }
} 