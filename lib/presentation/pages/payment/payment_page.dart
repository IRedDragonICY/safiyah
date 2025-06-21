import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../data/models/transaction_model.dart';
import '../../../core/services/payment_service.dart';
import '../../../core/constants/colors.dart';
import '../../widgets/common/loading_widget.dart';

class PaymentPage extends StatefulWidget {
  final Map<String, dynamic> orderDetails;
  final double amount;
  final String currency;
  final TransactionType transactionType;
  
  const PaymentPage({
    Key? key,
    required this.orderDetails,
    required this.amount,
    required this.currency,
    required this.transactionType,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final PaymentService _paymentService = PaymentService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  PaymentType? _selectedPaymentType;
  PaymentMethod? _selectedPaymentMethod;
  List<PaymentMethodOption> _availablePaymentMethods = [];
  bool _isLoading = true;
  bool _isProcessing = false;
  
  // Form controllers
  final _cardNumberController = TextEditingController();
  final _cardNameController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _bankAccountController = TextEditingController();
  Bank? _selectedBank;
  
  // User location (mock)
  final String _userCountry = 'ID'; // Would come from location service
  
  @override
  void initState() {
    super.initState();
    _loadPaymentMethods();
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardNameController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _bankAccountController.dispose();
    super.dispose();
  }

  void _loadPaymentMethods() {
    setState(() => _isLoading = true);
    
    try {
      final methods = _paymentService.getAvailablePaymentMethods(
        country: _userCountry,
        amount: widget.amount,
        currency: widget.currency,
      );
      
      setState(() {
        _availablePaymentMethods = methods;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading payment methods: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final currencyFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: widget.currency == 'IDR' ? 'Rp ' : widget.currency + ' ',
    );

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
          child: _isLoading
              ? const Center(child: LoadingWidget())
              : Column(
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
                            'Payment',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Order Summary
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.white.withOpacity(0.2),
                            Colors.white.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white.withOpacity(0.3)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.receipt_long,
                                color: Colors.white,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Order Summary',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.orderDetails['title'] ?? 'Order',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    if (widget.orderDetails['description'] != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        widget.orderDetails['description'],
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.8),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  currencyFormatter.format(widget.amount),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Payment Methods Content
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Select Payment Method',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: isDarkMode ? Colors.white : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 20),
                              
                              // Popular Methods
                              if (_availablePaymentMethods.any((m) => m.isPopular)) ...[
                                _buildSectionHeader('Popular', isDarkMode),
                                const SizedBox(height: 12),
                                ..._buildPaymentMethodsList(
                                  _availablePaymentMethods.where((m) => m.isPopular).toList(),
                                  isDarkMode,
                                ),
                                const SizedBox(height: 24),
                              ],
                              
                              // Credit/Debit Cards
                              _buildSectionHeader('Credit/Debit Cards', isDarkMode),
                              const SizedBox(height: 12),
                              ..._buildPaymentMethodsList(
                                _availablePaymentMethods.where((m) => [
                                  PaymentType.visa,
                                  PaymentType.mastercard,
                                  PaymentType.amex,
                                  PaymentType.jcb,
                                  PaymentType.unionPay,
                                  PaymentType.discover,
                                ].contains(m.type)).toList(),
                                isDarkMode,
                              ),
                              const SizedBox(height: 24),
                              
                              // Digital Wallets
                              _buildSectionHeader('Digital Wallets', isDarkMode),
                              const SizedBox(height: 12),
                              ..._buildPaymentMethodsList(
                                _availablePaymentMethods.where((m) => [
                                  PaymentType.gopay,
                                  PaymentType.ovo,
                                  PaymentType.dana,
                                  PaymentType.shopeePay,
                                  PaymentType.linkAja,
                                  PaymentType.touchNGo,
                                  PaymentType.grabPay,
                                  PaymentType.alipay,
                                  PaymentType.paypal,
                                ].contains(m.type)).toList(),
                                isDarkMode,
                              ),
                              const SizedBox(height: 24),
                              
                              // Bank Transfer
                              _buildSectionHeader('Bank Transfer', isDarkMode),
                              const SizedBox(height: 12),
                              ..._buildPaymentMethodsList(
                                _availablePaymentMethods.where((m) => 
                                  m.type == PaymentType.bankTransfer
                                ).toList(),
                                isDarkMode,
                              ),
                              const SizedBox(height: 24),
                              
                              // Other Methods
                              _buildSectionHeader('Other Methods', isDarkMode),
                              const SizedBox(height: 12),
                              ..._buildPaymentMethodsList(
                                _availablePaymentMethods.where((m) => [
                                  PaymentType.qris,
                                  PaymentType.applePay,
                                  PaymentType.googlePay,
                                ].contains(m.type)).toList(),
                                isDarkMode,
                              ),
                              const SizedBox(height: 24),
                              
                              // Payment Form
                              if (_selectedPaymentType != null)
                                _buildPaymentForm(isDarkMode),
                              
                              const SizedBox(height: 100), // Bottom padding for floating button
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
      bottomNavigationBar: _selectedPaymentType != null
          ? Container(
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_selectedPaymentType != null &&
                        _getSelectedMethod() != null) ...[
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.05)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isDarkMode 
                                ? Colors.white.withOpacity(0.1)
                                : Colors.grey[200]!,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Processing Fee:',
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(_getSelectedMethod()!.processingFee),
                                  style: TextStyle(
                                    color: isDarkMode ? Colors.white70 : Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Total:',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: isDarkMode ? Colors.white : Colors.black87,
                                  ),
                                ),
                                Text(
                                  currencyFormatter.format(
                                    widget.amount + _getSelectedMethod()!.processingFee,
                                  ),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isProcessing ? null : _processPayment,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              )
                            : Text(
                                'Pay ${currencyFormatter.format(widget.amount + (_getSelectedMethod()?.processingFee ?? 0))}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  Widget _buildSectionHeader(String title, bool isDarkMode) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: isDarkMode ? Colors.white : Colors.black87,
          ),
        ),
      ],
    );
  }

  List<Widget> _buildPaymentMethodsList(List<PaymentMethodOption> methods, bool isDarkMode) {
    return methods.map((method) {
      final isSelected = _selectedPaymentType == method.type;
      
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isSelected
                ? isDarkMode
                    ? [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.primary.withOpacity(0.1),
                      ]
                    : [
                        AppColors.primary.withOpacity(0.1),
                        AppColors.primary.withOpacity(0.05),
                      ]
                : isDarkMode
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
          border: Border.all(
            color: isSelected 
                ? AppColors.primary 
                : isDarkMode 
                    ? Colors.white.withOpacity(0.1)
                    : Colors.grey[200]!,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? AppColors.primary.withOpacity(0.1)
                  : isDarkMode 
                      ? Colors.black.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.05),
              blurRadius: isSelected ? 12 : 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () {
            setState(() {
              _selectedPaymentType = method.type;
              _formKey.currentState?.reset();
            });
          },
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
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
                    method.icon,
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
                        method.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isDarkMode ? Colors.white : Colors.black87,
                        ),
                      ),
                      if (method.processingTime != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Processing time: ${method.processingTime}',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white60 : Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (method.processingFee > 0)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.withOpacity(0.3)),
                        ),
                        child: Text(
                          '+${NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: widget.currency == 'IDR' ? 'Rp ' : '',
                            decimalDigits: 0,
                          ).format(method.processingFee)}',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.green.withOpacity(0.3)),
                        ),
                        child: const Text(
                          'No fee',
                          style: TextStyle(
                            color: Colors.green,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected ? AppColors.primary : Colors.grey,
                          width: 2,
                        ),
                      ),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.transparent,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }).toList();
  }

  Widget _buildPaymentForm(bool isDarkMode) {
    switch (_selectedPaymentType) {
      case PaymentType.visa:
      case PaymentType.mastercard:
      case PaymentType.amex:
      case PaymentType.jcb:
      case PaymentType.unionPay:
      case PaymentType.discover:
      case PaymentType.creditCard:
      case PaymentType.debitCard:
        return _buildCardForm(isDarkMode);
      case PaymentType.bankTransfer:
        return _buildBankTransferForm(isDarkMode);
      case PaymentType.qris:
        return _buildQRISInfo(isDarkMode);
      case PaymentType.gopay:
      case PaymentType.ovo:
      case PaymentType.dana:
      case PaymentType.shopeePay:
      case PaymentType.linkAja:
      case PaymentType.touchNGo:
      case PaymentType.grabPay:
      case PaymentType.alipay:
        return _buildDigitalWalletInfo(isDarkMode);
      case PaymentType.paypal:
        return _buildPayPalInfo(isDarkMode);
      case PaymentType.applePay:
      case PaymentType.googlePay:
        return _buildMobilePayInfo(isDarkMode);
      default:
        return const SizedBox();
    }
  }

  Widget _buildCardForm(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.credit_card,
                  color: AppColors.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Card Details',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: isDarkMode ? Colors.white : Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cardNumberController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Card Number',
                hintText: '1234 5678 9012 3456',
                prefixIcon: Icon(
                  Icons.credit_card,
                  color: AppColors.primary,
                ),
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white30 : Colors.grey[400],
                ),
                filled: true,
                fillColor: isDarkMode 
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                _CardNumberFormatter(),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter card number';
                }
                if (value.replaceAll(' ', '').length < 16) {
                  return 'Please enter valid card number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cardNameController,
              style: TextStyle(
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
              decoration: InputDecoration(
                labelText: 'Cardholder Name',
                hintText: 'John Doe',
                prefixIcon: Icon(
                  Icons.person,
                  color: AppColors.primary,
                ),
                labelStyle: TextStyle(
                  color: isDarkMode ? Colors.white70 : Colors.grey[600],
                ),
                hintStyle: TextStyle(
                  color: isDarkMode ? Colors.white30 : Colors.grey[400],
                ),
                filled: true,
                fillColor: isDarkMode 
                    ? Colors.white.withOpacity(0.05)
                    : Colors.grey[50],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey[300]!,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isDarkMode 
                        ? Colors.white.withOpacity(0.2)
                        : Colors.grey[300]!,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              textCapitalization: TextCapitalization.words,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter cardholder name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _expiryController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      hintText: 'MM/YY',
                      prefixIcon: Icon(
                        Icons.calendar_today,
                        color: AppColors.primary,
                      ),
                      labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white30 : Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: isDarkMode 
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      _ExpiryDateFormatter(),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length < 5) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cvvController,
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      hintText: '123',
                      prefixIcon: Icon(
                        Icons.security,
                        color: AppColors.primary,
                      ),
                      labelStyle: TextStyle(
                        color: isDarkMode ? Colors.white70 : Colors.grey[600],
                      ),
                      hintStyle: TextStyle(
                        color: isDarkMode ? Colors.white30 : Colors.grey[400],
                      ),
                      filled: true,
                      fillColor: isDarkMode 
                          ? Colors.white.withOpacity(0.05)
                          : Colors.grey[50],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey[300]!,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: isDarkMode 
                              ? Colors.white.withOpacity(0.2)
                              : Colors.grey[300]!,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Required';
                      }
                      if (value.length < 3) {
                        return 'Invalid';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.security,
                    color: Colors.blue,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Your card information is encrypted and secure',
                      style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 12,
                      ),
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

  Widget _buildBankTransferForm(bool isDarkMode) {
    final banks = _paymentService.getSupportedBanks(_userCountry);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: AppColors.primary,
                size: 24,
              ),
              const SizedBox(width: 12),
              Text(
                'Bank Transfer Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Bank>(
            value: _selectedBank,
            decoration: InputDecoration(
              labelText: 'Select Bank',
              labelStyle: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
              hintText: 'Select a bank',
              hintStyle: TextStyle(
                color: isDarkMode ? Colors.white30 : Colors.grey[400],
              ),
              filled: true,
              fillColor: isDarkMode 
                  ? Colors.white.withOpacity(0.05)
                  : Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isDarkMode 
                      ? Colors.white.withOpacity(0.2)
                      : Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: AppColors.primary,
                  width: 2,
                ),
              ),
            ),
            items: banks.map((bank) {
              return DropdownMenuItem(
                value: bank,
                child: Text(bank.name),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBank = value;
              });
            },
            validator: (value) {
              if (value == null) {
                return 'Please select a bank';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.amber.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: Colors.amber,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'How Bank Transfer Works:',
                      style: TextStyle(
                        color: Colors.amber[800],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '1. You\'ll receive a virtual account number\n'
                  '2. Transfer the exact amount to this account\n'
                  '3. Payment will be verified automatically\n'
                  '4. Processing time: 1-2 business days',
                  style: TextStyle(
                    color: Colors.amber[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRISInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(
            Icons.qr_code,
            size: 64,
            color: Colors.blue,
          ),
          const SizedBox(height: 16),
          Text(
            'QRIS Payment',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scan QR code with any QRIS-supported app',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _buildQRISAppChip('GoPay', isDarkMode),
              _buildQRISAppChip('OVO', isDarkMode),
              _buildQRISAppChip('DANA', isDarkMode),
              _buildQRISAppChip('ShopeePay', isDarkMode),
              _buildQRISAppChip('LinkAja', isDarkMode),
              _buildQRISAppChip('BCA Mobile', isDarkMode),
              _buildQRISAppChip('Livin\' by Mandiri', isDarkMode),
              _buildQRISAppChip('BRImo', isDarkMode),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQRISAppChip(String appName, bool isDarkMode) {
    return Chip(
      label: Text(
        appName,
        style: TextStyle(
          fontSize: 12,
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildDigitalWalletInfo(bool isDarkMode) {
    final walletName = _getSelectedMethod()?.name ?? 'Digital Wallet';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.account_balance_wallet,
            size: 64,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            '$walletName Payment',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
                      const SizedBox(height: 8),
            Text(
              'You will be redirected to $walletName app',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.withOpacity(0.3)),
            ),
            child: Text(
              'Make sure you have sufficient balance in your $walletName account',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayPalInfo(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Image.network(
            'https://www.paypalobjects.com/webstatic/mktg/logo/pp_cc_mark_111x69.jpg',
            height: 60,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.payment,
                size: 60,
                color: Colors.blue,
              );
            },
          ),
          const SizedBox(height: 16),
          Text(
            'PayPal Checkout',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
                      const SizedBox(height: 8),
            Text(
              'Log in to your PayPal account to complete payment',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                size: 16,
                color: Colors.grey[600],
              ),
                              const SizedBox(width: 4),
                Text(
                  'PayPal Buyer Protection',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white60 : Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobilePayInfo(bool isDarkMode) {
    final isApplePay = _selectedPaymentType == PaymentType.applePay;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
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
        border: Border.all(
          color: isDarkMode 
              ? Colors.white.withOpacity(0.1)
              : Colors.grey[200]!,
        ),
        boxShadow: [
          BoxShadow(
            color: isDarkMode 
                ? Colors.black.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            isApplePay ? Icons.phone_iphone : Icons.phone_android,
            size: 64,
            color: isApplePay ? Colors.black : Colors.green,
          ),
          const SizedBox(height: 16),
                      Text(
              isApplePay ? 'Apple Pay' : 'Google Pay',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: isDarkMode ? Colors.white : Colors.black87,
              ),
            ),
          const SizedBox(height: 8),
                      Text(
              isApplePay
                  ? 'Use Touch ID or Face ID to pay'
                  : 'Use your saved cards in Google Pay',
              style: TextStyle(
                color: isDarkMode ? Colors.white70 : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.speed,
                  size: 16,
                  color: Colors.blue,
                ),
                const SizedBox(width: 4),
                Text(
                  'Fast and secure checkout',
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  PaymentMethodOption? _getSelectedMethod() {
    try {
      return _availablePaymentMethods.firstWhere(
        (method) => method.type == _selectedPaymentType,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> _processPayment() async {
    // Validate form if needed
    if (_selectedPaymentType == PaymentType.creditCard ||
        _selectedPaymentType == PaymentType.debitCard ||
        [
          PaymentType.visa,
          PaymentType.mastercard,
          PaymentType.amex,
          PaymentType.jcb,
          PaymentType.unionPay,
          PaymentType.discover,
        ].contains(_selectedPaymentType)) {
      if (!(_formKey.currentState?.validate() ?? false)) {
        return;
      }
    }

    setState(() => _isProcessing = true);

    try {
      // Create payment method object
      PaymentMethod? paymentMethod;
      
      switch (_selectedPaymentType) {
        case PaymentType.visa:
        case PaymentType.mastercard:
        case PaymentType.amex:
        case PaymentType.jcb:
        case PaymentType.unionPay:
        case PaymentType.discover:
        case PaymentType.creditCard:
        case PaymentType.debitCard:
          paymentMethod = PaymentMethod(
            type: _selectedPaymentType!,
            cardLast4: _cardNumberController.text.replaceAll(' ', '').substring(
              _cardNumberController.text.replaceAll(' ', '').length - 4,
            ),
            cardBrand: _getCardBrand(_selectedPaymentType!),
          );
          break;
        case PaymentType.bankTransfer:
          paymentMethod = PaymentMethod(
            type: _selectedPaymentType!,
            bankName: _selectedBank?.name,
            accountNumber: 'VA${DateTime.now().millisecondsSinceEpoch % 10000}',
          );
          break;
        default:
          paymentMethod = PaymentMethod(
            type: _selectedPaymentType!,
            walletType: _getSelectedMethod()?.name,
          );
      }

      // Process payment
      final result = await _paymentService.processPayment(
        paymentMethod: paymentMethod,
        amount: widget.amount,
        currency: widget.currency,
        orderDetails: widget.orderDetails,
      );

      setState(() => _isProcessing = false);

      if (result.success) {
        // Navigate to success page
        if (mounted) {
          context.go('/payment/success', extra: {
            'transactionId': result.transactionId,
            'amount': widget.amount,
            'paymentMethod': paymentMethod,
            'orderDetails': widget.orderDetails,
            'additionalData': result.additionalData,
          });
        }
      } else {
        // Show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(result.errorMessage ?? 'Payment failed'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      setState(() => _isProcessing = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error processing payment: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _getCardBrand(PaymentType type) {
    switch (type) {
      case PaymentType.visa:
        return 'Visa';
      case PaymentType.mastercard:
        return 'Mastercard';
      case PaymentType.amex:
        return 'American Express';
      case PaymentType.jcb:
        return 'JCB';
      case PaymentType.unionPay:
        return 'UnionPay';
      case PaymentType.discover:
        return 'Discover';
      default:
        return 'Card';
    }
  }
}

// Custom formatters
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) {
        buffer.write(' ');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text.replaceAll('/', '');
    final buffer = StringBuffer();
    
    for (int i = 0; i < text.length && i < 4; i++) {
      if (i == 2) {
        buffer.write('/');
      }
      buffer.write(text[i]);
    }
    
    return TextEditingValue(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
} 