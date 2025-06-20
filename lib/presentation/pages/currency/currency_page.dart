import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/currency_model.dart';

class CurrencyPage extends StatefulWidget {
  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  
  // Controllers
  final TextEditingController _sourceAmountController = TextEditingController();
  final TextEditingController _destinationAmountController = TextEditingController();
  final TextEditingController _promoCodeController = TextEditingController();
  
  // Selected currencies
  CurrencyModel _sourceCurrency = const CurrencyModel(
    code: 'IDR',
    name: 'Indonesian Rupiah',
    symbol: 'Rp',
    flagUrl: '🇮🇩',
    rate: 1.0,
  );
  
  CurrencyModel _destinationCurrency = const CurrencyModel(
    code: 'JPY',
    name: 'Japanese Yen',
    symbol: '¥',
    flagUrl: '🇯🇵',
    rate: 0.0067,
  );
  
  bool _isSourceInput = true;
  String? _appliedPromoCode;
  double? _discountAmount;
  
  // Mock data
  final List<CurrencyModel> _currencies = [
    const CurrencyModel(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', flagUrl: '🇮🇩', rate: 1.0),
    const CurrencyModel(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flagUrl: '🇯🇵', rate: 0.0067),
    const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$', flagUrl: '🇺🇸', rate: 0.000067),
    const CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flagUrl: '🇪🇺', rate: 0.000062),
    const CurrencyModel(code: 'GBP', name: 'British Pound', symbol: '£', flagUrl: '🇬🇧', rate: 0.000053),
  ];

  final List<PromoModel> _availablePromos = [
    PromoModel(
      id: 'NEWUSER50',
      title: 'New User Discount',
      description: 'Get 50% off transfer fees for your first 2 transfers',
      code: 'NEWUSER50',
      discountPercentage: 50.0,
      maxDiscount: 50000.0,
      usageLimit: 2,
      usedCount: 0,
      validFrom: DateTime.now().subtract(const Duration(days: 1)),
      validUntil: DateTime.now().add(const Duration(days: 30)),
      isActive: true,
      applicableCountries: ['JP', 'US', 'EU', 'GB', 'AU', 'CA', 'SG'],
    ),
    PromoModel(
      id: 'WEEKEND20',
      title: 'Weekend Special',
      description: '20% off for weekend transfers',
      code: 'WEEKEND20',
      discountPercentage: 20.0,
      maxDiscount: 25000.0,
      usageLimit: 5,
      usedCount: 1,
      validFrom: DateTime.now().subtract(const Duration(days: 1)),
      validUntil: DateTime.now().add(const Duration(days: 7)),
      isActive: true,
      applicableCountries: ['JP', 'US'],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _sourceAmountController.addListener(_onSourceAmountChanged);
    _destinationAmountController.addListener(_onDestinationAmountChanged);
  }

  @override
  void dispose() {
    _sourceAmountController.dispose();
    _destinationAmountController.dispose();
    _promoCodeController.dispose();
    super.dispose();
  }

  void _onSourceAmountChanged() {
    if (_isSourceInput && _sourceAmountController.text.isNotEmpty) {
      final sourceAmount = double.tryParse(_sourceAmountController.text.replaceAll(',', '')) ?? 0;
      final rate = _destinationCurrency.rate / _sourceCurrency.rate;
      final destinationAmount = sourceAmount * rate;
      _destinationAmountController.text = NumberFormat('#,###.##').format(destinationAmount);
    }
  }

  void _onDestinationAmountChanged() {
    if (!_isSourceInput && _destinationAmountController.text.isNotEmpty) {
      final destinationAmount = double.tryParse(_destinationAmountController.text.replaceAll(',', '')) ?? 0;
      final rate = _sourceCurrency.rate / _destinationCurrency.rate;
      final sourceAmount = destinationAmount * rate;
      _sourceAmountController.text = NumberFormat('#,###.##').format(sourceAmount);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text(
          'Transfer Luar Negeri',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        elevation: 0,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
            child: FilledButton.icon(
              onPressed: () => _showRateAlertDialog(),
              icon: const Icon(Icons.notifications_outlined, size: 18),
              label: const Text('Pengingat Kurs'),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primaryContainer,
                foregroundColor: colorScheme.onPrimaryContainer,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ),
        ],
      ),
      body: _buildModernTransferPage(),
    );
  }

  Widget _buildModernTransferPage() {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildCountrySelector(),
          const SizedBox(height: 24),
          _buildAmountSection(),
          const SizedBox(height: 24),
          _buildRateAndFeeInfo(),
          const SizedBox(height: 24),
          _buildPromoSection(),
          const SizedBox(height: 24),
          _buildSummaryCard(),
          const SizedBox(height: 32),
          _buildContinueButton(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCountrySelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Details',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildCurrencyField(
                  label: 'From',
                  currency: _sourceCurrency,
                  onTap: () => _showCurrencyPicker(true),
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.swap_horiz,
                  color: colorScheme.onPrimaryContainer,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildCurrencyField(
                  label: 'To',
                  currency: _destinationCurrency,
                  onTap: () => _showCurrencyPicker(false),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyField({
    required String label,
    required CurrencyModel currency,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colorScheme.outline.withOpacity(0.5),
              ),
            ),
            child: Row(
              children: [
                Text(currency.flagUrl, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currency.code,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        _getCountryName(currency.code),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: colorScheme.primary,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getCountryName(String code) {
    switch (code) {
      case 'JPY': return 'Jepang';
      case 'USD': return 'Amerika Serikat';
      case 'EUR': return 'Eropa';
      case 'GBP': return 'Inggris';
      case 'AUD': return 'Australia';
      default: return code;
    }
  }

  Widget _buildCurrencyToggle() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mata Uang Tujuan',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF666666),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildCurrencyToggleButton(
                  _destinationCurrency.code,
                  true,
                  () {},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildCurrencyToggleButton(
                  'USD',
                  _destinationCurrency.code == 'USD',
                  () {
                    setState(() {
                      _destinationCurrency = _currencies.firstWhere((c) => c.code == 'USD');
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyToggleButton(String currency, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE5E5E5),
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          currency,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.primary : const Color(0xFF666666),
          ),
        ),
      ),
    );
  }

  Widget _buildTransferMethodTabs() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: AppColors.primary,
                    width: 2,
                  ),
                ),
              ),
              child: Text(
                'Bank',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                'TnG eWallet',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[600],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Amount',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          _buildAmountInput(
            'You Send',
            _sourceCurrency.code,
            _sourceAmountController,
            _sourceCurrency.symbol,
            onChanged: (value) {
              setState(() {
                _isSourceInput = true;
              });
            },
          ),
          const SizedBox(height: 16),
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Recipient gets',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSecondaryContainer,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildAmountInput(
            'Recipient Gets',
            _destinationCurrency.code,
            _destinationAmountController,
            _destinationCurrency.symbol,
            onChanged: (value) {
              setState(() {
                _isSourceInput = false;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInput(String label, String currency, TextEditingController controller, String symbol, {required ValueChanged<String> onChanged}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.outline.withOpacity(0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  currency,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: TextInputType.number,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: '0',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  hintStyle: theme.textTheme.headlineMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRateAndFeeInfo() {
    final rate = _destinationCurrency.rate / _sourceCurrency.rate;
    final transferFee = 31700.0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _buildInfoRow(
            Icons.sync_alt,
            'Kurs ${_destinationCurrency.code} 1',
            'IDR ${NumberFormat('#,###.##').format(1 / rate)}',
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.account_balance_wallet_outlined,
            'Biaya Transfer',
            'IDR ${NumberFormat('#,###').format(transferFee)}',
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F9FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Colors.blue[600],
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Uang diperkirakan sampai kurang dari ${_getEstimatedTime()}.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue[800],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.local_offer, color: colorScheme.primary),
              const SizedBox(width: 8),
              Text(
                'Promo Code',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_appliedPromoCode != null) ...[
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle, color: colorScheme.tertiary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Promo Applied: $_appliedPromoCode',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onTertiaryContainer,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_discountAmount != null)
                          Text(
                            'Discount: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_discountAmount)}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onTertiaryContainer,
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        _appliedPromoCode = null;
                        _discountAmount = null;
                        _promoCodeController.clear();
                      });
                    },
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code (e.g., NEWUSER50)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: _applyPromoCode,
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: _showAvailablePromos,
              icon: Icon(Icons.list_alt, color: colorScheme.primary),
              label: Text(
                'View Available Promos',
                style: TextStyle(color: colorScheme.primary),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAvailablePromos() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Available Promotions',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ..._availablePromos.map((promo) => _buildPromoCard(promo)),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoCard(PromoModel promo) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  promo.code,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${promo.discountPercentage.toInt()}% OFF',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            promo.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            promo.description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                _promoCodeController.text = promo.code;
                Navigator.pop(context);
                _applyPromoCode();
              },
              child: const Text('Use This Promo'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sourceAmount = double.tryParse(_sourceAmountController.text.replaceAll(',', '')) ?? 0;
    final baseFee = 31700.0;
    final transferFee = _discountAmount != null ? (baseFee - _discountAmount!) : baseFee;
    final finalTransferFee = transferFee < 0 ? 0 : transferFee;
    final totalCost = sourceAmount + finalTransferFee;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Total Transfer',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'IDR ${NumberFormat('#,###').format(totalCost)}',
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          if (_discountAmount != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'You saved ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_discountAmount)}!',
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onTertiaryContainer,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildContinueButton() {
    final theme = Theme.of(context);
    final sourceAmount = double.tryParse(_sourceAmountController.text.replaceAll(',', '')) ?? 0;
    final isEnabled = sourceAmount > 0;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: FilledButton(
        onPressed: isEnabled ? _processTransfer : null,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Text(
          'Lanjutkan',
          style: theme.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  void _showRateAlertDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.notifications_outlined, color: AppColors.primary),
            const SizedBox(width: 8),
            const Text(
              'Pengingat Kurs',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Dapatkan notifikasi saat kurs mencapai target Anda',
              style: TextStyle(
                color: Color(0xFF666666),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Target Kurs IDR → JPY',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 0.0070',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue[600]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Kurs saat ini: 0.0067\nAnda akan diberitahu jika kurs naik 4% atau lebih',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('✅ Pengingat kurs berhasil diatur!'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Atur Pengingat'),
          ),
        ],
      ),
         );
   }

   String _getEstimatedTime() {
     switch (_destinationCurrency.code) {
       case 'JPY':
         return '15 menit';
       case 'USD':
         return '2-3 hari kerja';
       case 'EUR':
         return '3-4 hari kerja';
       case 'GBP':
         return '2-3 hari kerja';
       default:
         return '2-4 hari kerja';
     }
   }
 
   Widget _buildExchangeRateCard() {
    final rate = _destinationCurrency.rate / _sourceCurrency.rate;
    final change = 0.05; // Mock change
    final isPositive = change >= 0;

    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(_sourceCurrency.flagUrl, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '1 ${_sourceCurrency.code}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Icon(
                  Icons.arrow_forward,
                  color: AppColors.primary,
                ),
                const Spacer(),
                Text(_destinationCurrency.flagUrl, style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text(
                  '${NumberFormat('#,##0.####').format(rate)} ${_destinationCurrency.code}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  isPositive ? Icons.trending_up : Icons.trending_down,
                  color: isPositive ? AppColors.success : AppColors.error,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${isPositive ? '+' : ''}${(change * 100).toStringAsFixed(2)}% (24h)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isPositive ? AppColors.success : AppColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'Updated: ${DateFormat('HH:mm').format(DateTime.now())}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransferCard() {
    return Card(
      elevation: AppConstants.cardElevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Transfer Amount',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildCurrencyInput(
              label: 'You Send',
              currency: _sourceCurrency,
              controller: _sourceAmountController,
              onCurrencyTap: () => _showCurrencyPicker(true),
              onChanged: (value) {
                setState(() {
                  _isSourceInput = true;
                });
              },
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: _switchCurrencies,
                  icon: Icon(
                    Icons.swap_vert,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _buildCurrencyInput(
              label: 'Recipient Gets',
              currency: _destinationCurrency,
              controller: _destinationAmountController,
              onCurrencyTap: () => _showCurrencyPicker(false),
              onChanged: (value) {
                setState(() {
                  _isSourceInput = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyInput({
    required String label,
    required CurrencyModel currency,
    required TextEditingController controller,
    required VoidCallback onCurrencyTap,
    required ValueChanged<String> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            InkWell(
              onTap: onCurrencyTap,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(currency.flagUrl, style: const TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    Text(
                      currency.code,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.keyboard_arrow_down),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: controller,
                onChanged: onChanged,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d,.]')),
                ],
                decoration: InputDecoration(
                  hintText: '0',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }



  void _applyPromoCode() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final code = _promoCodeController.text.toUpperCase().trim();
    
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a promo code'),
          backgroundColor: colorScheme.error,
        ),
      );
      return;
    }

    // Find promo from available promos
    PromoModel? foundPromo;
    try {
      foundPromo = _availablePromos.firstWhere(
        (promo) => promo.code == code && promo.isValid,
      );
    } catch (e) {
      foundPromo = null;
    }

    if (foundPromo != null) {
      final transferFee = 31700.0; // Base transfer fee
      final discountAmount = (transferFee * foundPromo.discountPercentage / 100).clamp(0.0, foundPromo.maxDiscount ?? 50000.0);
      
      setState(() {
        _appliedPromoCode = code;
        _discountAmount = discountAmount.toDouble();
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ Promo applied! You saved ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(discountAmount)}'),
          backgroundColor: colorScheme.primary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('❌ Invalid or expired promo code'),
          backgroundColor: colorScheme.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
    }
  }



  void _switchCurrencies() {
    setState(() {
      final temp = _sourceCurrency;
      _sourceCurrency = _destinationCurrency;
      _destinationCurrency = temp;
      
      final tempText = _sourceAmountController.text;
      _sourceAmountController.text = _destinationAmountController.text;
      _destinationAmountController.text = tempText;
    });
  }

  void _showCurrencyPicker(bool isSource) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select ${isSource ? 'Source' : 'Destination'} Currency',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            ...(_currencies.where((currency) => 
              isSource || currency.code != 'IDR' // For destination, exclude IDR
            ).map((currency) => _buildCurrencyPickerItem(currency, isSource))),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyPickerItem(CurrencyModel currency, bool isSource) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = isSource 
        ? _sourceCurrency.code == currency.code 
        : _destinationCurrency.code == currency.code;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          setState(() {
            if (isSource) {
              _sourceCurrency = currency;
            } else {
              _destinationCurrency = currency;
            }
            _calculateConversion();
          });
          Navigator.pop(context);
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? colorScheme.primaryContainer.withOpacity(0.5)
                : colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? colorScheme.primary 
                  : colorScheme.outline.withOpacity(0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(currency.flagUrl, style: const TextStyle(fontSize: 24)),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency.code,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      _getCountryName(currency.code),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: colorScheme.primary,
                  size: 24,
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _calculateConversion() {
    if (_isSourceInput && _sourceAmountController.text.isNotEmpty) {
      final sourceAmount = double.tryParse(_sourceAmountController.text.replaceAll(',', '')) ?? 0;
      final rate = _destinationCurrency.rate / _sourceCurrency.rate;
      final destinationAmount = sourceAmount * rate;
      _destinationAmountController.text = NumberFormat('#,##0.##').format(destinationAmount);
    } else if (!_isSourceInput && _destinationAmountController.text.isNotEmpty) {
      final destinationAmount = double.tryParse(_destinationAmountController.text.replaceAll(',', '')) ?? 0;
      final rate = _sourceCurrency.rate / _destinationCurrency.rate;
      final sourceAmount = destinationAmount * rate;
      _sourceAmountController.text = NumberFormat('#,##0.##').format(sourceAmount);
    }
  }

  void _processTransfer() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Transfer'),
          content: const Text('Are you sure you want to proceed with this transfer?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Transfer initiated successfully!'),
                    backgroundColor: AppColors.success,
                  ),
                );
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
}
