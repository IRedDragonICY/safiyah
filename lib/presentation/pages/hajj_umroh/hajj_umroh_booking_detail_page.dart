import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HajjUmrohBookingDetailPage extends StatelessWidget {
  final String bookingId;

  const HajjUmrohBookingDetailPage({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Sample booking data
    final bookings = [
      {
        'id': 'UP-2024-001',
        'title': 'Premium Umroh Package',
        'type': 'Umroh',
        'status': 'Confirmed',
        'date': 'December 20, 2024',
        'participants': 2,
        'amount': 5000000,
        'provider': 'Baitul Haram Travel',
        'duration': '12 Days',
        'hotel': '5-Star Hotel',
        'distance': '200m from Masjidil Haram',
        'paymentStatus': 'Paid',
        'paymentMethod': 'Full Payment',
        'bookingDate': 'November 15, 2024',
        'passengers': [
          {'name': 'Ahmad Tanaka', 'passport': 'JP1234567', 'relation': 'Self'},
          {'name': 'Fatima Tanaka', 'passport': 'JP1234568', 'relation': 'Wife'},
        ],
        'timeline': [
          {'date': 'Nov 15, 2024', 'status': 'Booking Confirmed', 'completed': true},
          {'date': 'Nov 20, 2024', 'status': 'Payment Received', 'completed': true},
          {'date': 'Dec 1, 2024', 'status': 'Visa Processing', 'completed': false},
          {'date': 'Dec 15, 2024', 'status': 'Final Documents', 'completed': false},
          {'date': 'Dec 20, 2024', 'status': 'Departure', 'completed': false},
        ],
        'inclusions': [
          'Round-trip flights from Tokyo',
          'Luxury 5-star accommodation',
          'All meals included',
          'Private transportation',
          'Professional guide',
          'Visa processing',
          'Travel insurance',
        ],
        'contactInfo': {
          'phone': '+81-3-1234-5678',
          'email': 'support@baitulharam.com',
          'whatsapp': '+81-90-1234-5678',
        }
      },
      {
        'id': 'HR-2025-002',
        'title': 'Regular Hajj Package 2025',
        'type': 'Hajj',
        'status': 'Pending',
        'date': 'June 15, 2025',
        'participants': 1,
        'amount': 6500000,
        'provider': 'Al-Hijrah Tours',
        'duration': '40 Days',
        'hotel': '4-Star Hotel',
        'distance': '500m from Masjidil Haram',
        'paymentStatus': 'Partial',
        'paymentMethod': 'Down Payment',
        'bookingDate': 'October 10, 2024',
        'passengers': [
          {'name': 'Yuki Yamamoto', 'passport': 'JP9876543', 'relation': 'Self'},
        ],
        'timeline': [
          {'date': 'Oct 10, 2024', 'status': 'Booking Received', 'completed': true},
          {'date': 'Oct 15, 2024', 'status': 'Down Payment', 'completed': true},
          {'date': 'Jan 15, 2025', 'status': 'Full Payment Due', 'completed': false},
          {'date': 'May 15, 2025', 'status': 'Visa Processing', 'completed': false},
          {'date': 'June 15, 2025', 'status': 'Departure', 'completed': false},
        ],
        'inclusions': [
          'Round-trip flights from Tokyo',
          '4-star hotel accommodation',
          'All meals included',
          'Group transportation',
          'Experienced guide',
          'Visa assistance',
          'Medical support',
        ],
        'contactInfo': {
          'phone': '+81-3-9876-5432',
          'email': 'info@alhijrah.com',
          'whatsapp': '+81-90-9876-5432',
        }
      },
    ];

    final bookingIndex = bookingId == '0' ? 0 : 1;
    final booking = bookings[bookingIndex];
    final isHajj = booking['type'] == 'Hajj';
    final statusColor = booking['status'] == 'Confirmed' ? Colors.green : Colors.orange;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainer,
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: colorScheme.surface,
        actions: [
          IconButton(
            onPressed: () {
              _showContactDialog(context, booking['contactInfo'] as Map<String, String>);
            },
            icon: const Icon(Icons.support_agent),
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'download',
                child: Row(
                  children: [
                    Icon(Icons.download),
                    SizedBox(width: 8),
                    Text('Download Voucher'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'share',
                child: Row(
                  children: [
                    Icon(Icons.share),
                    SizedBox(width: 8),
                    Text('Share Booking'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: [
                    Icon(Icons.cancel, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Cancel Booking'),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'download':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Downloading booking voucher...')),
                  );
                  break;
                case 'share':
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Sharing booking details...')),
                  );
                  break;
                case 'cancel':
                  _showCancelDialog(context);
                  break;
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildBookingHeader(booking, colorScheme, isHajj, statusColor),
            _buildBookingTimeline(context, booking, colorScheme),
            _buildPassengerDetails(context, booking, colorScheme),
            _buildBookingInclusions(context, booking, colorScheme),
            _buildPaymentInfo(context, booking, colorScheme),
            const SizedBox(height: 100), // Space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActions(context, booking, colorScheme),
    );
  }

  Widget _buildBookingHeader(Map<String, dynamic> booking, ColorScheme colorScheme, bool isHajj, Color statusColor) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            isHajj ? colorScheme.primary : Colors.green,
            (isHajj ? colorScheme.primary : Colors.green).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking['type'] as String,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking['status'] as String,
                  style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            booking['title'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            booking['provider'] as String,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildInfoItem(Icons.calendar_today, 'Departure', booking['date'] as String),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.people, 'Passengers', '${booking['participants']} person(s)'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildInfoItem(Icons.schedule, 'Duration', booking['duration'] as String),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.hotel, 'Hotel', booking['hotel'] as String),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Text(
                'Booking ID: ',
                style: TextStyle(color: Colors.white70),
              ),
              Text(
                booking['id'] as String,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                '¥${(booking['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.white70, size: 16),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBookingTimeline(BuildContext context, Map<String, dynamic> booking, ColorScheme colorScheme) {
    final timeline = booking['timeline'] as List<Map<String, dynamic>>;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Booking Timeline',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...timeline.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isCompleted = item['completed'] as bool;
              final isLast = index == timeline.length - 1;

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isCompleted ? Colors.green : colorScheme.outline,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isCompleted ? Icons.check : Icons.circle,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 2,
                          height: 40,
                          color: isCompleted ? Colors.green : colorScheme.outline,
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['status'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isCompleted ? Colors.green : null,
                          ),
                        ),
                        Text(
                          item['date'] as String,
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerDetails(BuildContext context, Map<String, dynamic> booking, ColorScheme colorScheme) {
    final passengers = booking['passengers'] as List<Map<String, dynamic>>;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Passenger Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...passengers.map((passenger) => Card(
              color: colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: colorScheme.primary,
                      child: Text(
                        passenger['name'].toString().substring(0, 1),
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            passenger['name'] as String,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Passport: ${passenger['passport']}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                          Text(
                            'Relation: ${passenger['relation']}',
                            style: TextStyle(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingInclusions(BuildContext context, Map<String, dynamic> booking, ColorScheme colorScheme) {
    final inclusions = booking['inclusions'] as List<String>;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Package Inclusions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...inclusions.map((inclusion) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 16),
                  const SizedBox(width: 8),
                  Expanded(child: Text(inclusion)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentInfo(BuildContext context, Map<String, dynamic> booking, ColorScheme colorScheme) {
    final paymentStatusColor = booking['paymentStatus'] == 'Paid' ? Colors.green : Colors.orange;
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Information',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text('Payment Status:'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: paymentStatusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking['paymentStatus'] as String,
                    style: TextStyle(color: paymentStatusColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Payment Method:'),
                const Spacer(),
                Text(
                  booking['paymentMethod'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Total Amount:'),
                const Spacer(),
                Text(
                  '¥${(booking['amount'] as int).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.primary,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Booking Date:'),
                const Spacer(),
                Text(
                  booking['bookingDate'] as String,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(BuildContext context, Map<String, dynamic> booking, ColorScheme colorScheme) {
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
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                _showContactDialog(context, booking['contactInfo'] as Map<String, String>);
              },
              icon: const Icon(Icons.chat),
              label: const Text('Contact Support'),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: booking['paymentStatus'] == 'Partial' ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Redirecting to payment...')),
                );
              } : null,
              icon: Icon(booking['paymentStatus'] == 'Partial' ? Icons.payment : Icons.check_circle),
              label: Text(booking['paymentStatus'] == 'Partial' ? 'Complete Payment' : 'Paid'),
            ),
          ),
        ],
      ),
    );
  }

  void _showContactDialog(BuildContext context, Map<String, String> contactInfo) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              leading: const Icon(Icons.phone),
              title: Text(contactInfo['phone']!),
              subtitle: const Text('Call Support'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening phone dialer...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(contactInfo['email']!),
              subtitle: const Text('Email Support'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening email client...')),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat),
              title: Text(contactInfo['whatsapp']!),
              subtitle: const Text('WhatsApp Support'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Opening WhatsApp...')),
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Booking'),
        content: const Text(
          'Are you sure you want to cancel this booking? '
          'Cancellation charges may apply as per the terms and conditions.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Keep Booking'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Booking cancellation request submitted')),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Cancel Booking'),
          ),
        ],
      ),
    );
  }
} 