import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/colors.dart';

class AIQuickChatWidget extends StatefulWidget {
  const AIQuickChatWidget({super.key});

  @override
  State<AIQuickChatWidget> createState() => _AIQuickChatWidgetState();
}

class _AIQuickChatWidgetState extends State<AIQuickChatWidget> {
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _showSuggestions = true;

  final List<Map<String, dynamic>> _suggestionPools = [
    {
      'icon': Icons.mosque,
      'text': 'Find nearby mosques',
      'query': 'Show me the nearest mosques to my location',
    },
    {
      'icon': Icons.calendar_today,
      'text': 'Plan Hajj journey',
      'query': 'Help me plan my Hajj journey step by step',
    },
    {
      'icon': Icons.hotel,
      'text': 'Budget hotels in Mecca',
      'query': 'Find budget-friendly hotels near Masjid al-Haram',
    },
    {
      'icon': Icons.restaurant,
      'text': 'Halal restaurants',
      'query': 'Recommend halal restaurants with good reviews',
    },
    {
      'icon': Icons.attach_money,
      'text': 'Convert currency',
      'query': 'Convert 1000 USD to Saudi Riyal',
    },
    {
      'icon': Icons.wb_sunny,
      'text': 'Weather forecast',
      'query': 'What\'s the weather like in Medina this week?',
    },
    {
      'icon': Icons.map,
      'text': 'Create itinerary',
      'query': 'Create a 5-day Umrah itinerary for me',
    },
    {
      'icon': Icons.local_offer,
      'text': 'Find vouchers',
      'query': 'Show me available discount vouchers',
    },
    {
      'icon': Icons.flight,
      'text': 'Flight deals',
      'query': 'Find cheap flights to Saudi Arabia',
    },
    {
      'icon': Icons.shopping_bag,
      'text': 'Shopping guide',
      'query': 'What should I buy as souvenirs from Mecca?',
    },
    {
      'icon': Icons.medical_services,
      'text': 'Travel insurance',
      'query': 'Compare travel insurance plans for Hajj',
    },
    {
      'icon': Icons.directions_walk,
      'text': 'Walking routes',
      'query': 'Best walking routes around the Haram',
    },
  ];
  
  List<Map<String, dynamic>> _currentSuggestions = [];

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showSuggestions = false;
        });
      }
    });
    _refreshSuggestions();
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    
    // Navigate to chatbot with the message
    context.push('/chatbot', extra: {
      'initialMessage': message.trim(),
    });
  }

  void _selectSuggestion(String suggestion) {
    _textController.text = suggestion;
    _sendMessage(suggestion);
  }

  void _refreshSuggestions() {
    // Gacha system - randomly select 3 suggestions
    final random = math.Random();
    final shuffled = List<Map<String, dynamic>>.from(_suggestionPools)..shuffle(random);
    setState(() {
      _currentSuggestions = shuffled.take(3).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.info,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Ask Safiyah AI',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Get instant help with Islamic travel guidance',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Text Input
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything about Islamic travel...',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      style: Theme.of(context).textTheme.bodyMedium,
                      textInputAction: TextInputAction.send,
                      onSubmitted: _sendMessage,
                      onChanged: (value) {
                        setState(() {}); // Update buttons
                      },
                    ),
                  ),
                  if (_textController.text.isEmpty) ...[
                    IconButton(
                      icon: const Icon(Icons.mic, size: 20),
                      color: AppColors.info,
                      onPressed: () => context.push('/chatbot/realtime'),
                      tooltip: 'Voice Chat',
                    ),
                  ],
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      size: 20,
                      color: _textController.text.isNotEmpty 
                          ? AppColors.primary 
                          : Colors.grey[400],
                    ),
                    onPressed: () => _sendMessage(_textController.text),
                    tooltip: 'Send Message',
                  ),
                ],
              ),
            ),
            
            // Suggestion Questions
            if (_showSuggestions) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    'Quick Questions',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.casino, size: 16),
                    onPressed: _refreshSuggestions,
                    tooltip: 'Refresh suggestions',
                    color: AppColors.primary,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 32,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _currentSuggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _currentSuggestions[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _selectSuggestion(suggestion['query']),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.info.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppColors.info.withValues(alpha: 0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                suggestion['icon'],
                                size: 14,
                                color: AppColors.info,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                suggestion['text'],
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: AppColors.info,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
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
          ],
        ),
      ),
    );
  }
} 