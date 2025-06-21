import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../core/services/zakat_service.dart';
import '../../../data/models/zakat_model.dart';

class ZakatReminderPage extends StatefulWidget {
  const ZakatReminderPage({super.key});

  @override
  State<ZakatReminderPage> createState() => _ZakatReminderPageState();
}

class _ZakatReminderPageState extends State<ZakatReminderPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<ZakatReminder> _reminders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadReminders();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadReminders() {
    setState(() {
      _isLoading = true;
    });

    // Sample reminders for demonstration
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _reminders.addAll([
          ZakatReminder(
            id: '1',
            title: 'Annual Wealth Zakat',
            zakatType: ZakatType.wealth,
            reminderDate: DateTime.now().add(const Duration(days: 30)),
            amount: 2500000.0,
            currency: 'JPY',
            isActive: true,
            location: 'Tokyo, Japan',
            timezone: 'Asia/Tokyo',
          ),
          ZakatReminder(
            id: '2',
            title: 'Zakat Fitrah - Ramadan',
            zakatType: ZakatType.fitrah,
            reminderDate: DateTime(2024, 4, 8), // Expected Ramadan end
            amount: 0.0,
            currency: 'JPY',
            isActive: true,
            location: 'Tokyo, Japan',
            timezone: 'Asia/Tokyo',
          ),
        ]);
        _isLoading = false;
      });
    });
  }

  void _addReminder() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => AddReminderBottomSheet(
        onReminderAdded: (reminder) {
          setState(() {
            _reminders.add(reminder);
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onPrimary,
        title: const Text(
          'Zakat Reminders',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addReminder,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.onPrimary,
          unselectedLabelColor: AppColors.onPrimary.withOpacity(0.7),
          indicatorWeight: 3,
          tabs: const [
            Tab(
              icon: Icon(Icons.schedule),
              text: 'Upcoming',
            ),
            Tab(
              icon: Icon(Icons.settings),
              text: 'Settings',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildSettingsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        backgroundColor: AppColors.secondary,
        foregroundColor: AppColors.onPrimary,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildUpcomingTab() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: AppColors.secondary,
        ),
      );
    }

    if (_reminders.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.schedule,
                  size: 64,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No Reminders Set',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Set reminders to never miss your zakat obligations while traveling',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _addReminder,
                icon: const Icon(Icons.add),
                label: const Text('Add Reminder'),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Japan Time Info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.info.withOpacity(0.1),
                  AppColors.secondary.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.info.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.info,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.access_time,
                    color: AppColors.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Japan Standard Time (JST)',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        'Current time: ${_formatTime(DateTime.now())}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text(
            'Upcoming Reminders',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(height: 16),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _reminders.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildReminderCard(_reminders[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Notification Settings
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.secondary.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.secondary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.notifications,
                        color: AppColors.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Notification Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildSettingItem(
                  'Push Notifications',
                  'Receive notifications for upcoming zakat',
                  true,
                  (value) {},
                ),
                const SizedBox(height: 12),
                _buildSettingItem(
                  'Email Reminders',
                  'Get email reminders 7 days before due date',
                  true,
                  (value) {},
                ),
                const SizedBox(height: 12),
                _buildSettingItem(
                  'Prayer Time Integration',
                  'Schedule reminders based on prayer times',
                  false,
                  (value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Location Settings
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.info.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.info,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.location_on,
                        color: AppColors.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Location Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                Text(
                  'Current Location',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.info.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.info.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_city,
                        color: AppColors.info,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Tokyo, Japan (JST +09:00)',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.info,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit, size: 16),
                        onPressed: () {},
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _buildSettingItem(
                  'Auto-detect Location',
                  'Automatically adjust reminders based on your location',
                  true,
                  (value) {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Advanced Settings
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.warning.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.tune,
                        color: AppColors.onPrimary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Advanced Settings',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                _buildSettingItem(
                  'Lunar Calendar Sync',
                  'Sync with Islamic lunar calendar for accurate dates',
                  true,
                  (value) {},
                ),
                const SizedBox(height: 12),
                _buildSettingItem(
                  'Currency Auto-conversion',
                  'Convert between JPY and home currency',
                  true,
                  (value) {},
                ),
                const SizedBox(height: 12),
                _buildSettingItem(
                  'Travel Mode',
                  'Adjust reminders when traveling between countries',
                  false,
                  (value) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard(ZakatReminder reminder) {
    final daysUntil = reminder.reminderDate.difference(DateTime.now()).inDays;
    final isOverdue = daysUntil < 0;
    final isToday = daysUntil == 0;
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isOverdue 
                ? AppColors.error.withOpacity(0.3)
                : isToday 
                    ? AppColors.warning.withOpacity(0.3)
                    : AppColors.secondary.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _getZakatTypeColor(reminder.zakatType).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getZakatTypeIcon(reminder.zakatType),
                    color: _getZakatTypeColor(reminder.zakatType),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.bodyLarge?.color,
                        ),
                      ),
                      Text(
                        _getZakatTypeName(reminder.zakatType),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: reminder.isActive,
                  onChanged: (value) {
                    setState(() {
                      reminder.isActive = value;
                    });
                  },
                  activeColor: AppColors.secondary,
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isOverdue 
                    ? AppColors.error.withOpacity(0.1)
                    : isToday 
                        ? AppColors.warning.withOpacity(0.1)
                        : AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    isOverdue 
                        ? Icons.error 
                        : isToday 
                            ? Icons.today 
                            : Icons.schedule,
                    color: isOverdue 
                        ? AppColors.error 
                        : isToday 
                            ? AppColors.warning 
                            : AppColors.info,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      isOverdue 
                          ? 'Overdue by ${daysUntil.abs()} days'
                          : isToday 
                              ? 'Due today!'
                              : 'Due in $daysUntil days',
                      style: TextStyle(
                        color: isOverdue 
                            ? AppColors.error 
                            : isToday 
                                ? AppColors.warning 
                                : AppColors.info,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Text(
                    _formatDate(reminder.reminderDate),
                    style: TextStyle(
                      color: isOverdue 
                          ? AppColors.error 
                          : isToday 
                              ? AppColors.warning 
                              : AppColors.info,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: 14,
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${reminder.location} (${reminder.timezone})',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
                    ),
                  ),
                ),
                if (reminder.amount > 0) ...[
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ZakatService.formatCurrency(reminder.amount, reminder.currency),
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(String title, String subtitle, bool value, Function(bool) onChanged) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: AppColors.secondary,
        ),
      ],
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  Color _getZakatTypeColor(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return AppColors.primary;
      case ZakatType.fitrah:
        return AppColors.secondary;
      case ZakatType.goldSilver:
        return AppColors.warning;
      case ZakatType.trade:
        return AppColors.info;
      case ZakatType.agriculture:
        return AppColors.success;
      case ZakatType.livestock:
        return const Color(0xFF795548);
      case ZakatType.investment:
        return const Color(0xFF9C27B0);
      case ZakatType.profession:
        return const Color(0xFF607D8B);
      case ZakatType.savings:
        return const Color(0xFF009688);
    }
  }

  IconData _getZakatTypeIcon(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return Icons.account_balance_wallet;
      case ZakatType.fitrah:
        return Icons.rice_bowl;
      case ZakatType.goldSilver:
        return Icons.diamond;
      case ZakatType.trade:
        return Icons.store;
      case ZakatType.agriculture:
        return Icons.agriculture;
      case ZakatType.livestock:
        return Icons.pets;
      case ZakatType.investment:
        return Icons.trending_up;
      case ZakatType.profession:
        return Icons.work;
      case ZakatType.savings:
        return Icons.savings;
    }
  }

  String _getZakatTypeName(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return 'Wealth Zakat';
      case ZakatType.fitrah:
        return 'Fitrah Zakat';
      case ZakatType.goldSilver:
        return 'Gold & Silver';
      case ZakatType.trade:
        return 'Trade Zakat';
      case ZakatType.agriculture:
        return 'Agriculture';
      case ZakatType.livestock:
        return 'Livestock';
      case ZakatType.investment:
        return 'Investment';
      case ZakatType.profession:
        return 'Profession';
      case ZakatType.savings:
        return 'Savings';
    }
  }
}

// Model for Zakat Reminder
class ZakatReminder {
  final String id;
  final String title;
  final ZakatType zakatType;
  final DateTime reminderDate;
  final double amount;
  final String currency;
  bool isActive;
  final String location;
  final String timezone;

  ZakatReminder({
    required this.id,
    required this.title,
    required this.zakatType,
    required this.reminderDate,
    required this.amount,
    required this.currency,
    required this.isActive,
    required this.location,
    required this.timezone,
  });
}

// Add Reminder Bottom Sheet
class AddReminderBottomSheet extends StatefulWidget {
  final Function(ZakatReminder) onReminderAdded;

  const AddReminderBottomSheet({
    super.key,
    required this.onReminderAdded,
  });

  @override
  State<AddReminderBottomSheet> createState() => _AddReminderBottomSheetState();
}

class _AddReminderBottomSheetState extends State<AddReminderBottomSheet> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  ZakatType _selectedType = ZakatType.wealth;
  String _selectedCurrency = 'JPY';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 30));
  final List<String> _currencies = ['JPY', 'IDR', 'USD', 'EUR', 'MYR', 'SAR'];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Add Zakat Reminder',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyLarge?.color,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                      labelText: 'Reminder Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  DropdownButtonFormField<ZakatType>(
                    value: _selectedType,
                    decoration: const InputDecoration(
                      labelText: 'Zakat Type',
                      border: OutlineInputBorder(),
                    ),
                    items: ZakatType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_getZakatTypeName(type)),
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
                        flex: 2,
                        child: TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Estimated Amount',
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          decoration: const InputDecoration(
                            labelText: 'Currency',
                            border: OutlineInputBorder(),
                          ),
                          items: _currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
                      );
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 12),
                          Text(
                            'Reminder Date: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  final reminder = ZakatReminder(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: _titleController.text,
                    zakatType: _selectedType,
                    reminderDate: _selectedDate,
                    amount: double.tryParse(_amountController.text) ?? 0.0,
                    currency: _selectedCurrency,
                    isActive: true,
                    location: 'Tokyo, Japan',
                    timezone: 'Asia/Tokyo',
                  );
                  widget.onReminderAdded(reminder);
                  Navigator.pop(context);
                }
              },
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Add Reminder'),
            ),
          ),
        ],
      ),
    );
  }

  String _getZakatTypeName(ZakatType type) {
    switch (type) {
      case ZakatType.wealth:
        return 'Wealth Zakat';
      case ZakatType.fitrah:
        return 'Fitrah Zakat';
      case ZakatType.goldSilver:
        return 'Gold & Silver';
      case ZakatType.trade:
        return 'Trade Zakat';
      case ZakatType.agriculture:
        return 'Agriculture';
      case ZakatType.livestock:
        return 'Livestock';
      case ZakatType.investment:
        return 'Investment';
      case ZakatType.profession:
        return 'Profession';
      case ZakatType.savings:
        return 'Savings';
    }
  }
} 