import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../data/models/currency_model.dart';

enum RateCondition {
  lessThan,
  greaterThan,
}

class RateAlert {
  final String id;
  final String fromCurrency;
  final String toCurrency;
  final double targetRate;
  final RateCondition condition;
  final bool isEnabled;
  final DateTime createdAt;

  const RateAlert({
    required this.id,
    required this.fromCurrency,
    required this.toCurrency,
    required this.targetRate,
    required this.condition,
    required this.isEnabled,
    required this.createdAt,
  });

  RateAlert copyWith({
    String? id,
    String? fromCurrency,
    String? toCurrency,
    double? targetRate,
    RateCondition? condition,
    bool? isEnabled,
    DateTime? createdAt,
  }) {
    return RateAlert(
      id: id ?? this.id,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      targetRate: targetRate ?? this.targetRate,
      condition: condition ?? this.condition,
      isEnabled: isEnabled ?? this.isEnabled,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get conditionText {
    switch (condition) {
      case RateCondition.lessThan:
        return 'less than';
      case RateCondition.greaterThan:
        return 'greater than';
    }
  }

  String get description {
    return 'Remind me when $toCurrency 1 is $conditionText ${NumberFormat('#,###.######').format(targetRate)} $fromCurrency';
  }
}

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
  
  // Rate alerts
  final List<RateAlert> _rateAlerts = [
    RateAlert(
      id: '1',
      fromCurrency: 'IDR',
      toCurrency: 'MYR',
      targetRate: 0.00032,
      condition: RateCondition.lessThan,
      isEnabled: true,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    RateAlert(
      id: '2',
      fromCurrency: 'IDR',
      toCurrency: 'JPY',
      targetRate: 0.0070,
      condition: RateCondition.greaterThan,
      isEnabled: false,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];
  
  // Mock data
  final List<CurrencyModel> _currencies = [
    const CurrencyModel(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', flagUrl: '🇮🇩', rate: 1.0),
    const CurrencyModel(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flagUrl: '🇯🇵', rate: 0.0067),
    const CurrencyModel(code: 'USD', name: 'US Dollar', symbol: '\$', flagUrl: '🇺🇸', rate: 0.000067),
    const CurrencyModel(code: 'EUR', name: 'Euro', symbol: '€', flagUrl: '🇪🇺', rate: 0.000062),
    const CurrencyModel(code: 'GBP', name: 'British Pound', symbol: '£', flagUrl: '🇬🇧', rate: 0.000053),
    const CurrencyModel(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', flagUrl: '🇲🇾', rate: 0.00031),
    const CurrencyModel(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', flagUrl: '🇸🇬', rate: 0.000095),
    const CurrencyModel(code: 'THB', name: 'Thai Baht', symbol: '฿', flagUrl: '🇹🇭', rate: 0.0024),
    const CurrencyModel(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flagUrl: '🇦🇺', rate: 0.0001),
    const CurrencyModel(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', flagUrl: '🇨🇦', rate: 0.000092),
    const CurrencyModel(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flagUrl: '🇨🇳', rate: 0.00048),
    const CurrencyModel(code: 'KRW', name: 'South Korean Won', symbol: '₩', flagUrl: '🇰🇷', rate: 0.089),
    const CurrencyModel(code: 'SAR', name: 'Saudi Riyal', symbol: 'SR', flagUrl: '🇸🇦', rate: 0.00025),
    const CurrencyModel(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flagUrl: '🇦🇪', rate: 0.00024),
    const CurrencyModel(code: 'TRY', name: 'Turkish Lira', symbol: '₺', flagUrl: '🇹🇷', rate: 0.0019),
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
      appBar: _buildAppBar(),
      body: _buildNoScrollLayout(),
      bottomNavigationBar: _buildBottomCTA(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return AppBar(
      title: Text(
        'International Transfer',
        style: theme.textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: colorScheme.onPrimary,
        ),
      ),
      elevation: 0,
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
          child: FilledButton.tonalIcon(
            onPressed: () => _showRateAlertDialog(),
            icon: const Icon(Icons.notifications_outlined, size: 18),
            label: const Text('Reminders'),
            style: FilledButton.styleFrom(
              foregroundColor: colorScheme.onPrimary,
              backgroundColor: colorScheme.onPrimary.withValues(alpha: 0.1),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoScrollLayout() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Currency Selector - Compact
            _buildCurrencySelector(),
            
            const SizedBox(height: 12),
            
            // Amount Input - Fixed height
            _buildAmountSection(),
            
            const SizedBox(height: 12),
            
            // Rate & Fee Info - Compact
            _buildRateInfo(),
            
            const SizedBox(height: 12),
            
            // Promo Section - Compact
            _buildCompactPromoSection(),
            
            const SizedBox(height: 12),
            
            // Summary - Compact
            _buildSummaryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencySelector() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card.filled(
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // From Currency
            Expanded(
              child: _buildCompactCurrencyButton(
                currency: _sourceCurrency,
                label: 'From',
                onTap: () => _showCurrencyPicker(true),
              ),
            ),
            
            // Swap Button - Properly centered
            SizedBox(
              width: 60,
              child: Center(
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: _switchCurrencies,
                    icon: Icon(
                      Icons.swap_horiz,
                      color: colorScheme.onPrimaryContainer,
                      size: 20,
                    ),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
            
            // To Currency
            Expanded(
              child: _buildCompactCurrencyButton(
                currency: _destinationCurrency,
                label: 'To',
                onTap: () => _showCurrencyPicker(false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactCurrencyButton({
    required CurrencyModel currency,
    required String label,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        FilledButton.tonal(
          onPressed: onTap,
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            minimumSize: Size.zero,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(currency.flagUrl, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text(
                currency.code,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
              Icon(Icons.expand_more, size: 14, color: colorScheme.onSurfaceVariant),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAmountSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card.filled(
      color: colorScheme.surfaceContainerLow,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Centered title
            Center(
              child: Text(
                'Transfer Amount',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            const SizedBox(height: 12),
            
            // You Send - Compact
            _buildCompactAmountInput(
              label: 'You Send',
              currency: _sourceCurrency,
              controller: _sourceAmountController,
              isPrimary: true,
              onChanged: (value) {
                setState(() {
                  _isSourceInput = true;
                });
              },
            ),
            
            // Conversion Arrow
            Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: colorScheme.secondaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.south,
                color: colorScheme.onSecondaryContainer,
                size: 16,
              ),
            ),
            
            // Recipient Gets - Compact
            _buildCompactAmountInput(
              label: 'Recipient Gets',
              currency: _destinationCurrency,
              controller: _destinationAmountController,
              isPrimary: false,
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

  Widget _buildCompactAmountInput({
    required String label,
    required CurrencyModel currency,
    required TextEditingController controller,
    required bool isPrimary,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isPrimary 
            ? colorScheme.primaryContainer.withValues(alpha: 0.3)
            : colorScheme.secondaryContainer.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPrimary 
              ? colorScheme.primary.withValues(alpha: 0.3)
              : colorScheme.outline.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isPrimary 
                      ? colorScheme.primary.withValues(alpha: 0.1)
                      : colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  currency.code,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: isPrimary 
                        ? colorScheme.primary
                        : colorScheme.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
            decoration: InputDecoration(
              hintText: '0',
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              isDense: true,
              hintStyle: theme.textTheme.headlineSmall?.copyWith(
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateInfo() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final rate = _destinationCurrency.rate / _sourceCurrency.rate;
    final transferFee = 31700.0;

    return Card.outlined(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.trending_up, color: colorScheme.primary, size: 16),
                const SizedBox(width: 6),
                Text(
                  '1 ${_destinationCurrency.code}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'IDR ${NumberFormat('#,###.##').format(1 / rate)}',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.primary,
                  ),
                ),
              ],
            ),
            const Divider(height: 12),
            Row(
              children: [
                Icon(Icons.receipt, color: colorScheme.secondary, size: 16),
                const SizedBox(width: 6),
                Text(
                  'Transfer Fee',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  'IDR ${NumberFormat('#,###').format(transferFee)}',
                  style: theme.textTheme.titleSmall?.copyWith(
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

  Widget _buildCompactPromoSection() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_appliedPromoCode != null) {
      return Card.filled(
        color: colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: colorScheme.tertiary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Promo: $_appliedPromoCode',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (_discountAmount != null)
                      Text(
                        'Saved: ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_discountAmount)}',
                        style: theme.textTheme.labelSmall?.copyWith(
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
                iconSize: 16,
              ),
            ],
          ),
        ),
      );
    }

    return Card.outlined(
      child: InkWell(
        onTap: _showPromoBottomSheet,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(Icons.local_offer, color: colorScheme.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                'Add Promo Code',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant, size: 16),
            ],
          ),
        ),
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

    return Card.filled(
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Total Transfer',
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'IDR ${NumberFormat('#,###').format(totalCost)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
            ),
            if (_discountAmount != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: colorScheme.tertiaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Saved ${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0).format(_discountAmount)}',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCTA() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final sourceAmount = double.tryParse(_sourceAmountController.text.replaceAll(',', '')) ?? 0;
    final isEnabled = sourceAmount > 0;

    return Container(
      padding: const EdgeInsets.only(
        left: 12,
        right: 12,
        top: 12,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: FilledButton(
          onPressed: isEnabled ? _processTransfer : null,
          style: FilledButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            minimumSize: const Size(double.infinity, 48),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            'Continue Transfer',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  void _showPromoBottomSheet() {
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
              'Promo Code',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoCodeController,
                    decoration: InputDecoration(
                      hintText: 'Enter promo code',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: colorScheme.surfaceContainerHighest,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _applyPromoCode();
                  },
                  child: const Text('Apply'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'Available Promos',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
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
    
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          _promoCodeController.text = promo.code;
          Navigator.pop(context);
          _applyPromoCode();
        },
        borderRadius: BorderRadius.circular(12),
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
            ],
          ),
        ),
      ),
    );
  }

  void _showRateAlertDialog() {
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
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications_outlined, color: colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Rate Alerts',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: () => _showAddRateAlertDialog(),
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            if (_rateAlerts.isEmpty) 
              _buildEmptyRateAlerts()
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _rateAlerts.length,
                  itemBuilder: (context, index) {
                    final alert = _rateAlerts[index];
                    return _buildRateAlertItem(alert, index);
                  },
                ),
              ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyRateAlerts() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 64,
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Rate Alerts Yet',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add alerts to get notifications when rates reach your target',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRateAlertItem(RateAlert alert, int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Currency flags
                Text(
                  _getCurrencyFlag(alert.toCurrency),
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    alert.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                // Enable/Disable Switch
                Switch(
                  value: alert.isEnabled,
                  onChanged: (value) {
                    setState(() {
                      _rateAlerts[index] = alert.copyWith(isEnabled: value);
                    });
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: alert.isEnabled 
                        ? colorScheme.primaryContainer
                        : colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    alert.isEnabled ? 'Active' : 'Inactive',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: alert.isEnabled 
                          ? colorScheme.onPrimaryContainer
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Created ${_formatDate(alert.createdAt)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                // Action buttons
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () => _editRateAlert(alert, index),
                      icon: const Icon(Icons.edit_outlined),
                      iconSize: 20,
                      style: IconButton.styleFrom(
                        foregroundColor: colorScheme.primary,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _deleteRateAlert(index),
                      icon: const Icon(Icons.delete_outlined),
                      iconSize: 20,
                      style: IconButton.styleFrom(
                        foregroundColor: colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getCurrencyFlag(String currencyCode) {
    switch (currencyCode) {
      case 'IDR': return '🇮🇩';
      case 'MYR': return '🇲🇾';
      case 'JPY': return '🇯🇵';
      case 'USD': return '🇺🇸';
      case 'EUR': return '🇪🇺';
      case 'GBP': return '🇬🇧';
      case 'SGD': return '🇸🇬';
      case 'THB': return '🇹🇭';
      case 'AUD': return '🇦🇺';
      case 'CAD': return '🇨🇦';
      default: return '🏳️';
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    
    if (difference == 0) {
      return 'today';
    } else if (difference == 1) {
      return 'yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return DateFormat('dd MMM yyyy').format(date);
    }
  }

  void _editRateAlert(RateAlert alert, int index) {
    _showAddRateAlertDialog(editAlert: alert, editIndex: index);
  }

  void _deleteRateAlert(int index) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Alert'),
        content: const Text('Are you sure you want to delete this rate alert?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _rateAlerts.removeAt(index);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Rate alert has been deleted'),
                  backgroundColor: colorScheme.primary,
                ),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: colorScheme.error,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showAddRateAlertDialog({RateAlert? editAlert, int? editIndex}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    
    // Available currencies for search
    final availableCurrencies = [
      {'code': 'MYR', 'name': 'Malaysian Ringgit', 'country': 'Malaysia', 'flag': '🇲🇾'},
      {'code': 'SGD', 'name': 'Singapore Dollar', 'country': 'Singapore', 'flag': '🇸🇬'},
      {'code': 'THB', 'name': 'Thai Baht', 'country': 'Thailand', 'flag': '🇹🇭'},
      {'code': 'JPY', 'name': 'Japanese Yen', 'country': 'Japan', 'flag': '🇯🇵'},
      {'code': 'USD', 'name': 'US Dollar', 'country': 'United States', 'flag': '🇺🇸'},
      {'code': 'EUR', 'name': 'Euro', 'country': 'Europe', 'flag': '🇪🇺'},
      {'code': 'GBP', 'name': 'British Pound', 'country': 'United Kingdom', 'flag': '🇬🇧'},
      {'code': 'AUD', 'name': 'Australian Dollar', 'country': 'Australia', 'flag': '🇦🇺'},
      {'code': 'CAD', 'name': 'Canadian Dollar', 'country': 'Canada', 'flag': '🇨🇦'},
    ];
    
    // Form controllers
    final searchController = TextEditingController();
    final rateController = TextEditingController(
      text: editAlert?.targetRate.toString() ?? '',
    );
    
    // Form state
    String selectedCurrency = editAlert?.toCurrency ?? 'MYR';
    RateCondition selectedCondition = editAlert?.condition ?? RateCondition.lessThan;
    List<Map<String, String>> filteredCurrencies = List.from(availableCurrencies);
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.9,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.add_alert, color: colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      editAlert != null ? 'Edit Rate Alert' : 'Add Rate Alert',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Currency Search
                Text(
                  'Select Target Currency',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search country or currency...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (query) {
                    setModalState(() {
                      if (query.isEmpty) {
                        filteredCurrencies = List.from(availableCurrencies);
                      } else {
                        filteredCurrencies = availableCurrencies
                            .where((currency) =>
                                currency['country']!.toLowerCase().contains(query.toLowerCase()) ||
                                currency['name']!.toLowerCase().contains(query.toLowerCase()) ||
                                currency['code']!.toLowerCase().contains(query.toLowerCase()))
                            .toList();
                      }
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Currency List
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: colorScheme.outline.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.builder(
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      final currency = filteredCurrencies[index];
                      final isSelected = selectedCurrency == currency['code'];
                      
                      return ListTile(
                        leading: Text(currency['flag']!, style: const TextStyle(fontSize: 24)),
                        title: Text(
                          currency['country']!,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text('${currency['code']} - ${currency['name']}'),
                        trailing: isSelected 
                            ? Icon(Icons.check_circle, color: colorScheme.primary)
                            : null,
                        selected: isSelected,
                        selectedTileColor: colorScheme.primaryContainer.withValues(alpha: 0.3),
                        onTap: () {
                          setModalState(() {
                            selectedCurrency = currency['code']!;
                          });
                        },
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                
                // Condition and Rate
                Text(
                  'Alert Settings',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                
                // Condition Selector
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<RateCondition>(
                        value: RateCondition.lessThan,
                        groupValue: selectedCondition,
                        onChanged: (value) {
                          setModalState(() {
                            selectedCondition = value!;
                          });
                        },
                        title: const Text('Less than'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<RateCondition>(
                        value: RateCondition.greaterThan,
                        groupValue: selectedCondition,
                        onChanged: (value) {
                          setModalState(() {
                            selectedCondition = value!;
                          });
                        },
                        title: const Text('Greater than'),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Rate Input
                TextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Target Rate ($selectedCurrency 1 = ? IDR)',
                    hintText: 'Example: 3100.50',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Preview
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Preview:',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Remind me when $selectedCurrency 1 is ${selectedCondition == RateCondition.lessThan ? 'less than' : 'greater than'} ${rateController.text.isEmpty ? '___' : rateController.text} IDR',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () {
                          final rate = double.tryParse(rateController.text);
                          if (rate != null && rate > 0) {
                            final newAlert = RateAlert(
                              id: editAlert?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                              fromCurrency: 'IDR',
                              toCurrency: selectedCurrency,
                              targetRate: rate / 15000, // Convert to relative rate
                              condition: selectedCondition,
                              isEnabled: editAlert?.isEnabled ?? true,
                              createdAt: editAlert?.createdAt ?? DateTime.now(),
                            );
                            
                            setState(() {
                              if (editAlert != null && editIndex != null) {
                                _rateAlerts[editIndex] = newAlert;
                              } else {
                                _rateAlerts.add(newAlert);
                              }
                            });
                            
                            Navigator.pop(context); // Close add dialog
                            Navigator.pop(context); // Close alerts list dialog
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(editAlert != null 
                                    ? '✅ Rate alert updated successfully!'
                                    : '✅ Rate alert added successfully!'),
                                backgroundColor: colorScheme.primary,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Enter a valid target rate'),
                                backgroundColor: colorScheme.error,
                              ),
                            );
                          }
                        },
                        child: Text(editAlert != null ? 'Update' : 'Save'),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getCountryName(String code) {
    switch (code) {
      case 'IDR': return 'Indonesia';
      case 'JPY': return 'Japan';
      case 'USD': return 'United States';
      case 'EUR': return 'Europe';
      case 'GBP': return 'United Kingdom';
      case 'MYR': return 'Malaysia';
      case 'SGD': return 'Singapore';
      case 'THB': return 'Thailand';
      case 'AUD': return 'Australia';
      case 'CAD': return 'Canada';
      case 'CNY': return 'China';
      case 'KRW': return 'South Korea';
      case 'SAR': return 'Saudi Arabia';
      case 'AED': return 'United Arab Emirates';
      case 'TRY': return 'Turkey';
      default: return code;
    }
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
    final searchController = TextEditingController();
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          // Filter currencies based on search
          final availableCurrencies = _currencies.where((currency) => 
            isSource || currency.code != 'IDR' // For destination, exclude IDR
          ).toList();
          
          final filteredCurrencies = searchController.text.isEmpty
              ? availableCurrencies
              : availableCurrencies.where((currency) {
                  final query = searchController.text.toLowerCase();
                  return currency.code.toLowerCase().contains(query) ||
                         currency.name.toLowerCase().contains(query) ||
                         _getCountryName(currency.code).toLowerCase().contains(query);
                }).toList();
          
          return Container(
            padding: const EdgeInsets.all(24),
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.8,
            ),
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
                
                // Search Field
                TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Search currency or country...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                  ),
                  onChanged: (query) {
                    setModalState(() {
                      // Trigger rebuild to update filtered results
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                // Currency List
                Flexible(
                  child: filteredCurrencies.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.search_off,
                                  size: 48,
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No currencies found',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Try a different search term',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          itemCount: filteredCurrencies.length,
                          itemBuilder: (context, index) {
                            final currency = filteredCurrencies[index];
                            return _buildCurrencyPickerItem(currency, isSource);
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrencyPickerItem(CurrencyModel currency, bool isSource) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSelected = isSource 
        ? _sourceCurrency.code == currency.code 
        : _destinationCurrency.code == currency.code;
    
    return Card.outlined(
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
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected 
                ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                : null,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(
              color: colorScheme.primary,
              width: 2,
            ) : null,
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
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Transfer initiated successfully!'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
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


