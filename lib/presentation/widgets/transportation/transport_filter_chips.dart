import 'package:flutter/material.dart';

import '../../../core/constants/colors.dart';

class TransportFilterChips extends StatefulWidget {
  const TransportFilterChips({super.key});

  @override
  State<TransportFilterChips> createState() => _TransportFilterChipsState();
}

class _TransportFilterChipsState extends State<TransportFilterChips> {
  final Set<String> _selectedFilters = {};
  
  final Map<String, IconData> _filters = {
    'Halal Friendly': Icons.verified,
    'NFC Payment': Icons.nfc,
    'WiFi Available': Icons.wifi,
    'Wheelchair Access': Icons.accessible,
    'Under ¥5000': Icons.attach_money,
    'Fast Route': Icons.speed,
    'Reserved Seat': Icons.event_seat,
    'Real-time Updates': Icons.update,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filter Options',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilters.clear();
                  });
                },
                child: const Text('Clear All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _filters.entries.map((entry) {
              final isSelected = _selectedFilters.contains(entry.key);
              return FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      entry.value,
                      size: 16,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(entry.key),
                  ],
                ),
                onSelected: (selected) {
                  setState(() {
                    if (selected) {
                      _selectedFilters.add(entry.key);
                    } else {
                      _selectedFilters.remove(entry.key);
                    }
                  });
                },
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context, _selectedFilters);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Apply Filters (${_selectedFilters.length})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 