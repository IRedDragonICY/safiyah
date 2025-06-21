import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HajjUmrohBookingPage extends StatefulWidget {
  final String packageId;

  const HajjUmrohBookingPage({super.key, required this.packageId});

  @override
  State<HajjUmrohBookingPage> createState() => _HajjUmrohBookingPageState();
}

class _HajjUmrohBookingPageState extends State<HajjUmrohBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passportController = TextEditingController();
  final _emergencyContactController = TextEditingController();
  final _emergencyPhoneController = TextEditingController();
  final _specialRequestsController = TextEditingController();

  int _pilgrimCount = 1;
  String _selectedGender = 'Male';
  String _selectedRoomType = 'Double';
  String _selectedPaymentMethod = 'Full Payment';
  bool _hasSpecialRequests = false;
  bool _agreedToTerms = false;

  final packages = [
    {
      'title': 'Regular Hajj Package 2025',
      'type': 'Hajj',
      'price': 6500000,
      'duration': '40 Days',
      'departure': 'June 15, 2025',
      'provider': 'Al-Hijrah Tours',
    },
    {
      'title': 'Premium Umroh Package',
      'type': 'Umroh',
      'price': 2500000,
      'duration': '12 Days',
      'departure': 'December 20, 2024',
      'provider': 'Baitul Haram Travel',
    },
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passportController.dispose();
    _emergencyContactController.dispose();
    _emergencyPhoneController.dispose();
    _specialRequestsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final packageIndex = int.tryParse(widget.packageId) ?? 0;
    final package = packages[packageIndex % packages.length];

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: const Text('Booking Registration'),
        backgroundColor: colorScheme.surface,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildPackageSummary(package, colorScheme),
                    const SizedBox(height: 24),
                    _buildPersonalInformation(),
                    const SizedBox(height: 24),
                    _buildBookingDetails(),
                    const SizedBox(height: 24),
                    _buildPaymentOptions(),
                    const SizedBox(height: 24),
                    _buildSpecialRequests(),
                    const SizedBox(height: 24),
                    _buildTermsAndConditions(),
                  ],
                ),
              ),
            ),
            _buildBookingFooter(package, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildPackageSummary(Map<String, dynamic> package, ColorScheme colorScheme) {
    final isHajj = package['type'] == 'Hajj';
    final totalPrice = (package['price'] as int) * _pilgrimCount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isHajj ? colorScheme.primary : Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    package['type'] as String,
                    style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                Text(
                  '¥${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              package['title'] as String,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              package['provider'] as String,
              style: TextStyle(color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(package['duration'] as String),
                const SizedBox(width: 16),
                Icon(Icons.flight_takeoff, size: 16, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(package['departure'] as String),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPersonalInformation() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email Address',
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _passportController,
              decoration: const InputDecoration(
                labelText: 'Passport Number',
                prefixIcon: Icon(Icons.card_membership),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your passport number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: const InputDecoration(
                labelText: 'Gender',
                prefixIcon: Icon(Icons.person_outline),
              ),
              items: ['Male', 'Female']
                  .map((gender) => DropdownMenuItem(value: gender, child: Text(gender)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGender = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Expanded(
                  child: Text('Number of Pilgrims'),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Theme.of(context).colorScheme.outline),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _pilgrimCount > 1 ? () {
                          setState(() {
                            _pilgrimCount--;
                          });
                        } : null,
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$_pilgrimCount', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _pilgrimCount++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedRoomType,
              decoration: const InputDecoration(
                labelText: 'Room Type',
                prefixIcon: Icon(Icons.hotel),
              ),
              items: ['Single', 'Double', 'Triple', 'Quad']
                  .map((room) => DropdownMenuItem(value: room, child: Text(room)))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRoomType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            Text(
              'Emergency Contact',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _emergencyContactController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact Name',
                prefixIcon: Icon(Icons.contact_emergency),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter emergency contact name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _emergencyPhoneController,
              decoration: const InputDecoration(
                labelText: 'Emergency Contact Phone',
                prefixIcon: Icon(Icons.phone_in_talk),
              ),
              keyboardType: TextInputType.phone,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter emergency contact phone';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentOptions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...['Full Payment', 'Down Payment (30%)', 'Installment Plan']
                .map((method) => RadioListTile<String>(
                      title: Text(method),
                      subtitle: method == 'Down Payment (30%)' 
                          ? const Text('Pay 30% now, remaining before departure')
                          : method == 'Installment Plan'
                              ? const Text('Monthly payments available')
                              : const Text('Pay complete amount now'),
                      value: method,
                      groupValue: _selectedPaymentMethod,
                      onChanged: (value) {
                        setState(() {
                          _selectedPaymentMethod = value!;
                        });
                      },
                    )),
          ],
        ),
      ),
    );
  }

  Widget _buildSpecialRequests() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Special Requests',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('I have special requirements'),
              value: _hasSpecialRequests,
              onChanged: (value) {
                setState(() {
                  _hasSpecialRequests = value;
                });
              },
            ),
            if (_hasSpecialRequests) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _specialRequestsController,
                decoration: const InputDecoration(
                  labelText: 'Please describe your special requirements',
                  hintText: 'Medical needs, dietary restrictions, accessibility requirements, etc.',
                ),
                maxLines: 3,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTermsAndConditions() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms & Conditions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              title: const Text('I agree to the Terms and Conditions'),
              subtitle: const Text('By checking this box, you agree to our terms of service and cancellation policy'),
              value: _agreedToTerms,
              onChanged: (value) {
                setState(() {
                  _agreedToTerms = value!;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Terms & Conditions'),
                    content: const SingleChildScrollView(
                      child: Text(
                        '1. All bookings are subject to availability\n'
                        '2. Full payment required 30 days before departure\n'
                        '3. Cancellation charges apply as per policy\n'
                        '4. Valid passport required with minimum 6 months validity\n'
                        '5. Medical fitness certificate required\n'
                        '6. Travel insurance recommended\n'
                        '7. Company not liable for visa rejection\n'
                        '8. Itinerary subject to change due to circumstances\n'
                        '9. All government taxes included in package price\n'
                        '10. Refund policy as per company guidelines',
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Read Full Terms & Conditions'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingFooter(Map<String, dynamic> package, ColorScheme colorScheme) {
    final totalPrice = (package['price'] as int) * _pilgrimCount;
    final paymentAmount = _selectedPaymentMethod == 'Down Payment (30%)'
        ? (totalPrice * 0.3).round()
        : totalPrice;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            offset: const Offset(0, -2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Amount',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '¥${totalPrice.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                  if (_selectedPaymentMethod == 'Down Payment (30%)')
                    Text(
                      'Pay Now: ¥${paymentAmount.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: _agreedToTerms ? _submitBooking : null,
                icon: const Icon(Icons.payment),
                label: const Text('Proceed to Payment'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Booking Confirmation'),
          content: const Text(
            'Your booking request has been submitted successfully. '
            'You will receive a confirmation email with payment instructions within 24 hours.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.go('/hajj-umroh');
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
} 