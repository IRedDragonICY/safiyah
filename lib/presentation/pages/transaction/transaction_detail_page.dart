import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:timeline_tile/timeline_tile.dart';
import '../../../data/models/transaction_model.dart';
import '../../../data/repositories/transaction_repository.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/common/loading_widget.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;
  
  const TransactionDetailPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  final TransactionRepository _repository = TransactionRepository();
  TransactionModel? _transaction;
  bool _isLoading = true;
  
  final _currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    setState(() => _isLoading = true);
    
    try {
      final transaction = await _repository.getTransactionById(widget.transactionId);
      setState(() {
        _transaction = transaction;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading transaction: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
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
                        'Transaction Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const Expanded(
                  child: Center(child: LoadingWidget()),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (_transaction == null) {
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
                        'Transaction Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24),
                        topRight: Radius.circular(24),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Transaction not found',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: isDarkMode ? Colors.white : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context.pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text('Go Back'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

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
                    _getStatusColor(_transaction!.status),
                    _getStatusColor(_transaction!.status).withOpacity(0.8),
                    _getStatusColor(_transaction!.status).withOpacity(0.6),
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar with Status
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Transaction Details',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: _shareTransaction,
                        ),
                        IconButton(
                          icon: const Icon(Icons.download, color: Colors.white),
                          onPressed: _downloadInvoice,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Text(
                        _getStatusText(_transaction!.status),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scrollable Content
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        _buildHeader(isDarkMode),
                        const SizedBox(height: 20),
                        _buildAmountCard(isDarkMode),
                        const SizedBox(height: 16),
                        _buildDetailsCard(isDarkMode),
                        const SizedBox(height: 16),
                        _buildPaymentMethodCard(isDarkMode),
                        if (_transaction!.refundInfo != null) ...[
                          const SizedBox(height: 16),
                          _buildRefundCard(isDarkMode),
                        ],
                        const SizedBox(height: 16),
                        _buildRefundPolicyCard(isDarkMode),
                        const SizedBox(height: 16),
                        _buildTimelineCard(isDarkMode),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(isDarkMode),
    );
  }

  Widget _buildHeader(bool isDarkMode) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                _getStatusColor(_transaction!.status).withOpacity(0.1),
                _getStatusColor(_transaction!.status).withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _getStatusColor(_transaction!.status).withOpacity(0.3),
            ),
          ),
          child: Icon(
            _getTypeIcon(_transaction!.type),
            size: 48,
            color: _getStatusColor(_transaction!.status),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _transaction!.details.title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          _transaction!.details.description,
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? Colors.white70 : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ]
                  : [
                      Colors.grey[100]!,
                      Colors.grey[50]!,
                    ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDarkMode 
                  ? Colors.white.withOpacity(0.2)
                  : Colors.grey[300]!,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.confirmation_number,
                size: 18,
                color: isDarkMode ? Colors.white70 : Colors.grey[700],
              ),
              const SizedBox(width: 8),
              Text(
                _transaction!.referenceNumber ?? 'N/A',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.grey[700],
                ),
              ),
              const SizedBox(width: 12),
              InkWell(
                onTap: () {
                  Clipboard.setData(
                    ClipboardData(text: _transaction!.referenceNumber ?? ''),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Reference number copied'),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Icon(
                    Icons.copy,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountCard(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(24),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Total Amount',
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.1),
                  AppColors.primary.withOpacity(0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Text(
              _currencyFormatter.format(_transaction!.amount),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAmountDetail(
                'Paid on',
                DateFormat('dd MMM yyyy').format(_transaction!.createdAt),
                isDarkMode,
              ),
              if (_transaction!.completedAt != null)
                _buildAmountDetail(
                  'Completed',
                  DateFormat('HH:mm').format(_transaction!.completedAt!),
                  isDarkMode,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmountDetail(String label, String value, bool isDarkMode) {
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
        const SizedBox(height: 6),
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

  Widget _buildDetailsCard(bool isDarkMode) {
    final details = _transaction!.details;
    final itemDetails = details.itemDetails;
    
    return Container(
      padding: const EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.info_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Transaction Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Type-specific details
          if (_transaction!.type == TransactionType.flight ||
              _transaction!.type == TransactionType.train ||
              _transaction!.type == TransactionType.bus) ...[
            _buildDetailRow('From', details.origin ?? '-', isDarkMode),
            _buildDetailRow('To', details.destination ?? '-', isDarkMode),
            if (details.departureDate != null)
              _buildDetailRow(
                'Departure',
                DateFormat('dd MMM yyyy, HH:mm').format(details.departureDate!),
                isDarkMode,
              ),
            if (details.arrivalDate != null)
              _buildDetailRow(
                'Arrival',
                DateFormat('dd MMM yyyy, HH:mm').format(details.arrivalDate!),
                isDarkMode,
              ),
            if (details.passengerNames != null)
              _buildDetailRow(
                'Passengers',
                details.passengerNames!.join(', '),
                isDarkMode,
              ),
          ],
          
          // Generic item details
          ...itemDetails.entries.map((entry) {
            if (entry.value is List) {
              return _buildDetailRow(
                _formatKey(entry.key),
                (entry.value as List).join(', '),
                isDarkMode,
              );
            }
            return _buildDetailRow(
              _formatKey(entry.key),
              entry.value.toString(),
              isDarkMode,
            );
          }),
          
          if (details.merchantName != null)
            _buildDetailRow('Merchant', details.merchantName!, isDarkMode),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: isDarkMode ? Colors.white60 : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(bool isDarkMode) {
    final payment = _transaction!.paymentMethod;
    
    return Container(
      padding: const EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.payment,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Payment Method',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.2),
                      AppColors.primary.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Icon(
                  _getPaymentIcon(payment.type),
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      payment.displayName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _getPaymentTypeLabel(payment.type),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRefundCard(bool isDarkMode) {
    final refund = _transaction!.refundInfo!;
    
    return Container(
      padding: const EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getRefundColor(refund.status),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _getRefundColor(refund.status).withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getRefundIcon(refund.status),
                color: _getRefundColor(refund.status),
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Refund Status',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: _getRefundColor(refund.status),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _getRefundColor(refund.status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getRefundColor(refund.status).withOpacity(0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getRefundStatusText(refund.status),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: _getRefundColor(refund.status),
                  ),
                ),
                if (refund.refundAmount != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Refund Amount: ${_currencyFormatter.format(refund.refundAmount)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: _getRefundColor(refund.status),
                    ),
                  ),
                ],
                if (refund.reason != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Reason:',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: isDarkMode ? Colors.white70 : Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    refund.reason!,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
                if (refund.processedAt != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Processed on ${DateFormat('dd MMM yyyy, HH:mm').format(refund.processedAt!)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDarkMode ? Colors.white60 : Colors.grey[600],
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (refund.notes != null) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withOpacity(0.3)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.info_outline,
                    color: Colors.amber,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      refund.notes!,
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRefundPolicyCard(bool isDarkMode) {
    if (_transaction!.refundInfo?.refundPolicy == null) return const SizedBox();
    
    final policy = _transaction!.refundInfo!.refundPolicy;
    final canRefund = _canRequestRefund();
    
    return Container(
      padding: const EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.policy,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Refund Policy',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            policy.name,
            style: TextStyle(
              color: isDarkMode ? Colors.white70 : Colors.grey[600],
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          ...policy.tiers.map((tier) {
            final isActive = _isDaysTierActive(tier);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isActive 
                      ? [
                          Colors.green.withOpacity(0.1),
                          Colors.green.withOpacity(0.05),
                        ]
                      : [
                          (isDarkMode ? Colors.white : Colors.grey).withOpacity(0.1),
                          (isDarkMode ? Colors.white : Colors.grey).withOpacity(0.05),
                        ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isActive 
                      ? Colors.green 
                      : isDarkMode 
                          ? Colors.white.withOpacity(0.2)
                          : Colors.grey[300]!,
                  width: isActive ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isActive ? Icons.check_circle : Icons.cancel,
                    color: isActive ? Colors.green : Colors.grey,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${tier.daysBeforeDeparture}+ days before',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: isActive 
                                ? Colors.green[700] 
                                : isDarkMode 
                                    ? Colors.white70 
                                    : Colors.grey[700],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${tier.refundPercentage}% refund',
                          style: TextStyle(
                            color: isActive 
                                ? Colors.green[600] 
                                : isDarkMode 
                                    ? Colors.white60 
                                    : Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isActive && canRefund)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Current',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }),
          if (policy.conditions != null && policy.conditions!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Special Conditions:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            ...policy.conditions!.map((condition) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '• ', 
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        condition,
                        style: TextStyle(
                          color: isDarkMode ? Colors.white70 : Colors.grey[700],
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildTimelineCard(bool isDarkMode) {
    final history = _transaction!.history;
    
    return Container(
      padding: const EdgeInsets.all(20),
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
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.2)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.timeline,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Transaction Timeline',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...history.asMap().entries.map((entry) {
            final index = entry.key;
            final event = entry.value;
            final isFirst = index == 0;
            final isLast = index == history.length - 1;
            
            return TimelineTile(
              alignment: TimelineAlign.manual,
              lineXY: 0.1,
              isFirst: isFirst,
              isLast: isLast,
              indicatorStyle: IndicatorStyle(
                width: 24,
                color: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 4),
              ),
              beforeLineStyle: LineStyle(
                color: AppColors.primary.withOpacity(0.3),
                thickness: 2,
              ),
              afterLineStyle: LineStyle(
                color: AppColors.primary.withOpacity(0.3),
                thickness: 2,
              ),
              endChild: Container(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.action,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: isDarkMode ? Colors.white : Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      DateFormat('dd MMM yyyy, HH:mm').format(event.timestamp),
                      style: TextStyle(
                        color: isDarkMode ? Colors.white60 : Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                    if (event.performedBy != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        'By: ${event.performedBy}',
                        style: TextStyle(
                          color: isDarkMode ? Colors.white60 : Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (event.details != null && event.details!.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDarkMode 
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: event.details!.entries.map((detail) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                '${_formatKey(detail.key)}: ${detail.value}',
                                style: TextStyle(
                                  color: isDarkMode ? Colors.white70 : Colors.grey[700],
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBottomBar(bool isDarkMode) {
    final canRefund = _canRequestRefund();
    final hasActiveRefund = _transaction!.refundInfo?.status == RefundStatus.requested ||
        _transaction!.refundInfo?.status == RefundStatus.processing;
    
    if (!canRefund && !hasActiveRefund) return const SizedBox();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDarkMode 
              ? [
                  const Color(0xFF1E1E2E),
                  const Color(0xFF2D2D44),
                ]
              : [
                  Colors.white,
                  Colors.grey[50]!,
                ],
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (canRefund) ...[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Eligible for refund',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _currencyFormatter.format(_transaction!.calculateRefundAmount()),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green[700],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Color(0xFF4CAF50)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: _requestRefund,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Request Refund',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ] else if (hasActiveRefund) ...[
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    context.push('/transaction/refund/${_transaction!.id}');
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    'View Refund Status',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper methods
  IconData _getTypeIcon(TransactionType type) {
    switch (type) {
      case TransactionType.flight:
        return Icons.flight_takeoff;
      case TransactionType.train:
        return Icons.train;
      case TransactionType.bus:
        return Icons.directions_bus;
      case TransactionType.hotel:
        return Icons.hotel;
      case TransactionType.hajjUmroh:
        return Icons.mosque;
      case TransactionType.insurance:
        return Icons.security;
      case TransactionType.holidayPackage:
        return Icons.beach_access;
      case TransactionType.food:
        return Icons.restaurant;
      case TransactionType.voucher:
        return Icons.local_offer;
      case TransactionType.event:
        return Icons.event;
      case TransactionType.guideTour:
        return Icons.tour;
      case TransactionType.rental:
        return Icons.car_rental;
      case TransactionType.ride:
        return Icons.local_taxi;
      default:
        return Icons.receipt;
    }
  }

  IconData _getPaymentIcon(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
      case PaymentType.debitCard:
      case PaymentType.visa:
      case PaymentType.mastercard:
      case PaymentType.amex:
      case PaymentType.jcb:
      case PaymentType.unionPay:
      case PaymentType.discover:
        return Icons.credit_card;
      case PaymentType.bankTransfer:
        return Icons.account_balance;
      case PaymentType.digitalWallet:
      case PaymentType.gopay:
      case PaymentType.ovo:
      case PaymentType.dana:
      case PaymentType.shopeePay:
      case PaymentType.linkAja:
      case PaymentType.touchNGo:
      case PaymentType.grabPay:
      case PaymentType.alipay:
        return Icons.account_balance_wallet;
      case PaymentType.qris:
        return Icons.qr_code;
      case PaymentType.paypal:
        return Icons.payment;
      case PaymentType.applePay:
        return Icons.phone_iphone;
      case PaymentType.googlePay:
        return Icons.phone_android;
      case PaymentType.cash:
        return Icons.money;
      default:
        return Icons.payment;
    }
  }

  String _getPaymentTypeLabel(PaymentType type) {
    switch (type) {
      case PaymentType.creditCard:
        return 'Credit Card';
      case PaymentType.debitCard:
        return 'Debit Card';
      case PaymentType.bankTransfer:
        return 'Bank Transfer';
      case PaymentType.qris:
        return 'QRIS Payment';
      default:
        return 'Digital Payment';
    }
  }

  Color _getStatusColor(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return Colors.orange;
      case TransactionStatus.processing:
        return Colors.blue;
      case TransactionStatus.completed:
        return Colors.green;
      case TransactionStatus.failed:
        return Colors.red;
      case TransactionStatus.cancelled:
        return Colors.grey;
      case TransactionStatus.refunded:
        return Colors.purple;
      case TransactionStatus.refundable:
        return Colors.teal;
      case TransactionStatus.partiallyRefunded:
        return Colors.indigo;
    }
  }

  String _getStatusText(TransactionStatus status) {
    switch (status) {
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.processing:
        return 'Processing';
      case TransactionStatus.completed:
        return 'Completed';
      case TransactionStatus.failed:
        return 'Failed';
      case TransactionStatus.cancelled:
        return 'Cancelled';
      case TransactionStatus.refunded:
        return 'Refunded';
      case TransactionStatus.refundable:
        return 'Refundable';
      case TransactionStatus.partiallyRefunded:
        return 'Partially Refunded';
    }
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

  String _getRefundStatusText(RefundStatus status) {
    switch (status) {
      case RefundStatus.requested:
        return 'Refund Requested';
      case RefundStatus.approved:
        return 'Refund Approved';
      case RefundStatus.rejected:
        return 'Refund Rejected';
      case RefundStatus.processing:
        return 'Processing Refund';
      case RefundStatus.completed:
        return 'Refund Completed';
    }
  }

  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}' 
            : word)
        .join(' ');
  }

  bool _canRequestRefund() {
    if (_transaction!.status != TransactionStatus.completed &&
        _transaction!.status != TransactionStatus.refundable) {
      return false;
    }
    
    if (_transaction!.refundInfo == null) return false;
    
    final refundAmount = _transaction!.calculateRefundAmount();
    return refundAmount > 0;
  }

  bool _isDaysTierActive(RefundTier tier) {
    if (_transaction!.refundInfo?.departureDate == null) return false;
    
    final daysUntilDeparture = _transaction!.refundInfo!.calculateDaysUntilDeparture();
    return daysUntilDeparture >= tier.daysBeforeDeparture;
  }

  void _shareTransaction() {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share functionality coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _downloadInvoice() {
    // Implement download invoice functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Invoice download coming soon'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _requestRefund() {
    final refundAmount = _transaction!.calculateRefundAmount();
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
              'Transaction: ${_transaction!.details.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Original Amount: ${_currencyFormatter.format(_transaction!.amount)}'),
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
                _transaction!.id,
                reasonController.text,
              );
              
              if (success) {
                _loadTransaction();
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