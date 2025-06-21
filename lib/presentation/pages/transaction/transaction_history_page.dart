import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/common/loading_widget.dart';

class TransactionHistoryPage extends StatefulWidget {
  const TransactionHistoryPage({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryPage> createState() => _TransactionHistoryPageState();
}

class _TransactionHistoryPageState extends State<TransactionHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TransactionRepository _repository = TransactionRepository();
  
  List<TransactionModel> _allTransactions = [];
  List<TransactionModel> _filteredTransactions = [];
  TransactionType? _selectedType;
  TransactionStatus? _selectedStatus;
  String _searchQuery = '';
  bool _isLoading = true;
  
  final _searchController = TextEditingController();
  final _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTransactions();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadTransactions() async {
    setState(() => _isLoading = true);
    
    try {
      final transactions = await _repository.getAllTransactions('user123');
      setState(() {
        _allTransactions = transactions;
        _filterTransactions();
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading transactions: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _filterTransactions() {
    _filteredTransactions = _allTransactions.where((transaction) {
      // Filter by search query
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        if (!transaction.details.title.toLowerCase().contains(query) &&
            !transaction.details.description.toLowerCase().contains(query) &&
            !(transaction.referenceNumber?.toLowerCase().contains(query) ?? false)) {
          return false;
        }
      }

      // Filter by type
      if (_selectedType != null && transaction.type != _selectedType) {
        return false;
      }

      // Filter by status
      if (_selectedStatus != null && transaction.status != _selectedStatus) {
        return false;
      }

      // Filter by tab
      switch (_tabController.index) {
        case 0: // All
          return true;
        case 1: // Active
          return [
            TransactionStatus.pending,
            TransactionStatus.processing,
            TransactionStatus.refundable,
          ].contains(transaction.status);
        case 2: // Completed
          return [
            TransactionStatus.completed,
            TransactionStatus.refunded,
            TransactionStatus.cancelled,
            TransactionStatus.failed,
          ].contains(transaction.status);
        default:
          return true;
      }
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDarkMode 
                ? [
                    const Color(0xFF1A1A2E),
                    const Color(0xFF16213E),
                    const Color(0xFF0F3460),
                  ]
                : [
                    AppColors.primary,
                    AppColors.primary.withOpacity(0.8),
                    AppColors.primary.withOpacity(0.6),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Transaction History',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Search Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      _filterTransactions();
                    });
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search transactions...',
                    hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withOpacity(0.8)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Filter Chips
              Container(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _buildFilterChip(
                      label: 'All Types',
                      isSelected: _selectedType == null,
                      onSelected: (selected) {
                        setState(() {
                          _selectedType = null;
                          _filterTransactions();
                        });
                      },
                    ),
                    ...TransactionType.values.map((type) => _buildFilterChip(
                      label: _getTypeLabel(type),
                      isSelected: _selectedType == type,
                      onSelected: (selected) {
                        setState(() {
                          _selectedType = selected ? type : null;
                          _filterTransactions();
                        });
                      },
                    )),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Tabs
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  onTap: (index) {
                    setState(() {
                      _filterTransactions();
                    });
                  },
                  indicator: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelColor: isDarkMode ? const Color(0xFF1A1A2E) : AppColors.primary,
                  unselectedLabelColor: Colors.white.withOpacity(0.8),
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  tabs: const [
                    Tab(text: 'All'),
                    Tab(text: 'Active'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: _isLoading
                      ? const Center(child: LoadingWidget())
                      : RefreshIndicator(
                          onRefresh: _loadTransactions,
                          child: _filteredTransactions.isEmpty
                              ? _buildEmptyState()
                              : ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount: _filteredTransactions.length,
                                  itemBuilder: (context, index) {
                                    final transaction = _filteredTransactions[index];
                                    return _buildTransactionCard(transaction);
                                  },
                                ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          context.push('/transaction/statistics');
        },
        icon: const Icon(Icons.analytics),
        label: const Text('Statistics'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: onSelected,
        backgroundColor: Colors.white.withOpacity(0.15),
        selectedColor: Colors.white,
        checkmarkColor: AppColors.primary,
        side: BorderSide(color: Colors.white.withOpacity(0.3)),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.primary : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.receipt_long,
              size: 64,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No transactions found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty 
                ? 'Try adjusting your search or filters' 
                : 'Your transactions will appear here',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _searchQuery = '';
                  _selectedType = null;
                  _selectedStatus = null;
                  _filterTransactions();
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Clear filters'),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTransactionCard(TransactionModel transaction) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final canRefund = _canRequestRefund(transaction);
    final refundAmount = transaction.calculateRefundAmount();
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDarkMode
              ? [
                  const Color(0xFF2D2D44),
                  const Color(0xFF252542),
                ]
              : [
                  Colors.white,
                  Colors.grey[50]!,
                ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          context.push('/transaction/detail/${transaction.id}');
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  _buildTypeIcon(transaction.type),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          transaction.details.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          transaction.details.description,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white70 : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _currencyFormatter.format(transaction.amount),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _buildStatusChip(transaction.status),
                    ],
                  ),
                ],
              ),
              
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      isDarkMode ? Colors.white24 : Colors.grey[300]!,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              
              // Details
              Row(
                children: [
                  Expanded(
                    child: _buildDetailColumn(
                      'Reference', 
                      transaction.referenceNumber ?? '-',
                      isDarkMode,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailColumn(
                      'Payment Method', 
                      transaction.paymentMethod.displayName,
                      isDarkMode,
                    ),
                  ),
                  Expanded(
                    child: _buildDetailColumn(
                      'Date', 
                      DateFormat('dd MMM yyyy').format(transaction.createdAt),
                      isDarkMode,
                    ),
                  ),
                ],
              ),
              
              // Refund Information
              if (transaction.refundInfo != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getRefundBackgroundColor(transaction.refundInfo!.status),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getRefundIcon(transaction.refundInfo!.status),
                        color: _getRefundColor(transaction.refundInfo!.status),
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Refund ${_getRefundStatusText(transaction.refundInfo!.status)}',
                              style: TextStyle(
                                color: _getRefundColor(transaction.refundInfo!.status),
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (transaction.refundInfo!.refundAmount != null) ...[
                              const SizedBox(height: 4),
                              Text(
                                'Amount: ${_currencyFormatter.format(transaction.refundInfo!.refundAmount)}',
                                style: TextStyle(
                                  color: _getRefundColor(transaction.refundInfo!.status),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      if (transaction.refundInfo!.status == RefundStatus.requested)
                        ElevatedButton(
                          onPressed: () {
                            context.push('/transaction/refund/${transaction.id}');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _getRefundColor(transaction.refundInfo!.status),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('View', style: TextStyle(fontSize: 12)),
                        ),
                    ],
                  ),
                ),
              ] else if (canRefund) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withOpacity(0.1),
                        Colors.green.withOpacity(0.05),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.info_outline,
                        color: Colors.green,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Eligible for refund',
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Estimated refund: ${_currencyFormatter.format(refundAmount)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          _showRefundDialog(transaction);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Request', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailColumn(String label, String value, bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isDarkMode ? Colors.white60 : Colors.grey[600],
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildTypeIcon(TransactionType type) {
    IconData icon;
    Color color;
    
    switch (type) {
      case TransactionType.flight:
        icon = Icons.flight_takeoff;
        color = Colors.blue;
        break;
      case TransactionType.train:
        icon = Icons.train;
        color = Colors.orange;
        break;
      case TransactionType.bus:
        icon = Icons.directions_bus;
        color = Colors.green;
        break;
      case TransactionType.hotel:
        icon = Icons.hotel;
        color = Colors.purple;
        break;
      case TransactionType.hajjUmroh:
        icon = Icons.mosque;
        color = Colors.teal;
        break;
      case TransactionType.insurance:
        icon = Icons.security;
        color = Colors.indigo;
        break;
      case TransactionType.holidayPackage:
        icon = Icons.beach_access;
        color = Colors.pink;
        break;
      case TransactionType.food:
        icon = Icons.restaurant;
        color = Colors.amber;
        break;
      case TransactionType.voucher:
        icon = Icons.local_offer;
        color = Colors.red;
        break;
      case TransactionType.event:
        icon = Icons.event;
        color = Colors.cyan;
        break;
      case TransactionType.guideTour:
        icon = Icons.tour;
        color = Colors.lime;
        break;
      case TransactionType.rental:
        icon = Icons.car_rental;
        color = Colors.brown;
        break;
      case TransactionType.ride:
        icon = Icons.local_taxi;
        color = Colors.deepOrange;
        break;
      default:
        icon = Icons.receipt;
        color = Colors.grey;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildStatusChip(TransactionStatus status) {
    Color color;
    String label;
    
    switch (status) {
      case TransactionStatus.pending:
        color = Colors.orange;
        label = 'Pending';
        break;
      case TransactionStatus.processing:
        color = Colors.blue;
        label = 'Processing';
        break;
      case TransactionStatus.completed:
        color = Colors.green;
        label = 'Completed';
        break;
      case TransactionStatus.failed:
        color = Colors.red;
        label = 'Failed';
        break;
      case TransactionStatus.cancelled:
        color = Colors.grey;
        label = 'Cancelled';
        break;
      case TransactionStatus.refunded:
        color = Colors.purple;
        label = 'Refunded';
        break;
      case TransactionStatus.refundable:
        color = Colors.teal;
        label = 'Refundable';
        break;
      case TransactionStatus.partiallyRefunded:
        color = Colors.indigo;
        label = 'Partial Refund';
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.2),
            color.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _getTypeLabel(TransactionType type) {
    switch (type) {
      case TransactionType.flight:
        return 'Flight';
      case TransactionType.train:
        return 'Train';
      case TransactionType.bus:
        return 'Bus';
      case TransactionType.hotel:
        return 'Hotel';
      case TransactionType.hajjUmroh:
        return 'Hajj/Umroh';
      case TransactionType.insurance:
        return 'Insurance';
      case TransactionType.holidayPackage:
        return 'Holiday';
      case TransactionType.food:
        return 'Food';
      case TransactionType.voucher:
        return 'Voucher';
      case TransactionType.event:
        return 'Event';
      case TransactionType.guideTour:
        return 'Tour';
      case TransactionType.rental:
        return 'Rental';
      case TransactionType.ride:
        return 'Ride';
      default:
        return 'Other';
    }
  }

  bool _canRequestRefund(TransactionModel transaction) {
    if (transaction.status != TransactionStatus.completed &&
        transaction.status != TransactionStatus.refundable) {
      return false;
    }
    
    if (transaction.refundInfo == null) return false;
    
    final refundAmount = transaction.calculateRefundAmount();
    return refundAmount > 0;
  }

  IconData _getRefundIcon(RefundStatus status) {
    switch (status) {
      case RefundStatus.requested:
        return Icons.hourglass_empty;
      case RefundStatus.approved:
        return Icons.check_circle;
      case RefundStatus.rejected:
        return Icons.cancel;
      case RefundStatus.processing:
        return Icons.refresh;
      case RefundStatus.completed:
        return Icons.done_all;
    }
  }

  Color _getRefundColor(RefundStatus status) {
    switch (status) {
      case RefundStatus.requested:
        return Colors.orange;
      case RefundStatus.approved:
        return Colors.green;
      case RefundStatus.rejected:
        return Colors.red;
      case RefundStatus.processing:
        return Colors.blue;
      case RefundStatus.completed:
        return Colors.teal;
    }
  }

  Color _getRefundBackgroundColor(RefundStatus status) {
    return _getRefundColor(status).withOpacity(0.1);
  }

  String _getRefundStatusText(RefundStatus status) {
    switch (status) {
      case RefundStatus.requested:
        return 'Requested';
      case RefundStatus.approved:
        return 'Approved';
      case RefundStatus.rejected:
        return 'Rejected';
      case RefundStatus.processing:
        return 'Processing';
      case RefundStatus.completed:
        return 'Completed';
    }
  }

  void _showRefundDialog(TransactionModel transaction) {
    final refundAmount = transaction.calculateRefundAmount();
    final reasonController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request Refund'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transaction: ${transaction.details.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Original Amount: ${_currencyFormatter.format(transaction.amount)}'),
            Text(
              'Refund Amount: ${_currencyFormatter.format(refundAmount)}',
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason for refund',
                hintText: 'Please provide a reason...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please provide a reason for refund'),
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              
              // Request refund
              final success = await _repository.requestRefund(
                transaction.id,
                reasonController.text,
              );
              
              if (success) {
                _loadTransactions();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Refund request submitted successfully'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } else {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to submit refund request'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Submit Request'),
          ),
        ],
      ),
    );
  }
} 