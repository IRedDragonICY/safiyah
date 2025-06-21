import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;
  final double rate; // Rate relative to USD

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
    required this.rate,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Currency && runtimeType == other.runtimeType && code == other.code;

  @override
  int get hashCode => code.hashCode;
}

class CurrencyService extends ChangeNotifier {
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  static const String _currencyCodeKey = 'selected_currency_code';
  Currency _selectedCurrency = currencies[0]; // Default to USD

  Currency get selectedCurrency => _selectedCurrency;

  // Comprehensive list of supported currencies
  static const List<Currency> currencies = [
    Currency(code: 'USD', name: 'US Dollar', symbol: '\$', flag: '🇺🇸', rate: 1.0),
    Currency(code: 'JPY', name: 'Japanese Yen', symbol: '¥', flag: '🇯🇵', rate: 150.0),
    Currency(code: 'IDR', name: 'Indonesian Rupiah', symbol: 'Rp', flag: '🇮🇩', rate: 15700.0),
    Currency(code: 'EUR', name: 'Euro', symbol: '€', flag: '🇪🇺', rate: 0.85),
    Currency(code: 'GBP', name: 'British Pound', symbol: '£', flag: '🇬🇧', rate: 0.73),
    Currency(code: 'SGD', name: 'Singapore Dollar', symbol: 'S\$', flag: '🇸🇬', rate: 1.35),
    Currency(code: 'MYR', name: 'Malaysian Ringgit', symbol: 'RM', flag: '🇲🇾', rate: 4.67),
    Currency(code: 'THB', name: 'Thai Baht', symbol: '฿', flag: '🇹🇭', rate: 36.0),
    Currency(code: 'KRW', name: 'South Korean Won', symbol: '₩', flag: '🇰🇷', rate: 1320.0),
    Currency(code: 'CNY', name: 'Chinese Yuan', symbol: '¥', flag: '🇨🇳', rate: 7.30),
    Currency(code: 'AUD', name: 'Australian Dollar', symbol: 'A\$', flag: '🇦🇺', rate: 1.52),
    Currency(code: 'CAD', name: 'Canadian Dollar', symbol: 'C\$', flag: '🇨🇦', rate: 1.36),
    Currency(code: 'CHF', name: 'Swiss Franc', symbol: 'Fr', flag: '🇨🇭', rate: 0.88),
    Currency(code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK\$', flag: '🇭🇰', rate: 7.80),
    Currency(code: 'NZD', name: 'New Zealand Dollar', symbol: 'NZ\$', flag: '🇳🇿', rate: 1.65),
    Currency(code: 'SEK', name: 'Swedish Krona', symbol: 'kr', flag: '🇸🇪', rate: 10.85),
    Currency(code: 'NOK', name: 'Norwegian Krone', symbol: 'kr', flag: '🇳🇴', rate: 10.90),
    Currency(code: 'DKK', name: 'Danish Krone', symbol: 'kr', flag: '🇩🇰', rate: 6.85),
    Currency(code: 'PLN', name: 'Polish Zloty', symbol: 'zł', flag: '🇵🇱', rate: 4.25),
    Currency(code: 'CZK', name: 'Czech Koruna', symbol: 'Kč', flag: '🇨🇿', rate: 23.50),
    Currency(code: 'HUF', name: 'Hungarian Forint', symbol: 'Ft', flag: '🇭🇺', rate: 365.0),
    Currency(code: 'RON', name: 'Romanian Leu', symbol: 'lei', flag: '🇷🇴', rate: 4.95),
    Currency(code: 'BGN', name: 'Bulgarian Lev', symbol: 'лв', flag: '🇧🇬', rate: 1.83),
    Currency(code: 'HRK', name: 'Croatian Kuna', symbol: 'kn', flag: '🇭🇷', rate: 7.50),
    Currency(code: 'RUB', name: 'Russian Ruble', symbol: '₽', flag: '🇷🇺', rate: 92.0),
    Currency(code: 'TRY', name: 'Turkish Lira', symbol: '₺', flag: '🇹🇷', rate: 28.50),
    Currency(code: 'BRL', name: 'Brazilian Real', symbol: 'R\$', flag: '🇧🇷', rate: 5.15),
    Currency(code: 'MXN', name: 'Mexican Peso', symbol: '\$', flag: '🇲🇽', rate: 17.80),
    Currency(code: 'ARS', name: 'Argentine Peso', symbol: '\$', flag: '🇦🇷', rate: 350.0),
    Currency(code: 'CLP', name: 'Chilean Peso', symbol: '\$', flag: '🇨🇱', rate: 900.0),
    Currency(code: 'COP', name: 'Colombian Peso', symbol: '\$', flag: '🇨🇴', rate: 4200.0),
    Currency(code: 'PEN', name: 'Peruvian Sol', symbol: 'S/', flag: '🇵🇪', rate: 3.75),
    Currency(code: 'INR', name: 'Indian Rupee', symbol: '₹', flag: '🇮🇳', rate: 83.0),
    Currency(code: 'PKR', name: 'Pakistani Rupee', symbol: '₨', flag: '🇵🇰', rate: 285.0),
    Currency(code: 'LKR', name: 'Sri Lankan Rupee', symbol: '₨', flag: '🇱🇰', rate: 325.0),
    Currency(code: 'BDT', name: 'Bangladeshi Taka', symbol: '৳', flag: '🇧🇩', rate: 110.0),
    Currency(code: 'VND', name: 'Vietnamese Dong', symbol: '₫', flag: '🇻🇳', rate: 24500.0),
    Currency(code: 'PHP', name: 'Philippine Peso', symbol: '₱', flag: '🇵🇭', rate: 56.0),
    Currency(code: 'AED', name: 'UAE Dirham', symbol: 'د.إ', flag: '🇦🇪', rate: 3.67),
    Currency(code: 'SAR', name: 'Saudi Riyal', symbol: '﷼', flag: '🇸🇦', rate: 3.75),
    Currency(code: 'QAR', name: 'Qatari Riyal', symbol: '﷼', flag: '🇶🇦', rate: 3.64),
    Currency(code: 'KWD', name: 'Kuwaiti Dinar', symbol: 'د.ك', flag: '🇰🇼', rate: 0.31),
    Currency(code: 'BHD', name: 'Bahraini Dinar', symbol: '.د.ب', flag: '🇧🇭', rate: 0.38),
    Currency(code: 'OMR', name: 'Omani Rial', symbol: '﷼', flag: '🇴🇲', rate: 0.38),
    Currency(code: 'JOD', name: 'Jordanian Dinar', symbol: 'د.ا', flag: '🇯🇴', rate: 0.71),
    Currency(code: 'LBP', name: 'Lebanese Pound', symbol: '£', flag: '🇱🇧', rate: 15000.0),
    Currency(code: 'EGP', name: 'Egyptian Pound', symbol: '£', flag: '🇪🇬', rate: 31.0),
    Currency(code: 'ILS', name: 'Israeli Shekel', symbol: '₪', flag: '🇮🇱', rate: 3.85),
    Currency(code: 'ZAR', name: 'South African Rand', symbol: 'R', flag: '🇿🇦', rate: 18.50),
    Currency(code: 'NGN', name: 'Nigerian Naira', symbol: '₦', flag: '🇳🇬', rate: 800.0),
    Currency(code: 'GHS', name: 'Ghanaian Cedi', symbol: '₵', flag: '🇬🇭', rate: 12.0),
    Currency(code: 'KES', name: 'Kenyan Shilling', symbol: 'KSh', flag: '🇰🇪', rate: 150.0),
    Currency(code: 'MAD', name: 'Moroccan Dirham', symbol: 'د.م.', flag: '🇲🇦', rate: 10.15),
    Currency(code: 'TND', name: 'Tunisian Dinar', symbol: 'د.ت', flag: '🇹🇳', rate: 3.12),
  ];

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCurrencyCode = prefs.getString(_currencyCodeKey);
    
    if (savedCurrencyCode != null) {
      final currency = currencies.firstWhere(
        (c) => c.code == savedCurrencyCode,
        orElse: () => currencies[0],
      );
      _selectedCurrency = currency;
    }
  }

  Future<void> setCurrency(Currency currency) async {
    if (_selectedCurrency != currency) {
      _selectedCurrency = currency;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_currencyCodeKey, currency.code);
      
      notifyListeners();
    }
  }

  String formatAmount(double amount, {bool includeSymbol = true, int decimalPlaces = 0}) {
    // Convert from base currency (USD) to selected currency
    final convertedAmount = amount * _selectedCurrency.rate;
    
    // Format based on currency
    String formattedAmount;
    if (convertedAmount >= 1000000) {
      formattedAmount = (convertedAmount / 1000000).toStringAsFixed(1) + 'M';
    } else if (convertedAmount >= 1000) {
      // Use appropriate decimal places based on currency
      final decimals = _selectedCurrency.code == 'JPY' || _selectedCurrency.code == 'KRW' || 
                      _selectedCurrency.code == 'IDR' || _selectedCurrency.code == 'VND' ? 0 : decimalPlaces;
      formattedAmount = convertedAmount.toStringAsFixed(decimals).replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    } else {
      final decimals = _selectedCurrency.code == 'JPY' || _selectedCurrency.code == 'KRW' || 
                      _selectedCurrency.code == 'IDR' || _selectedCurrency.code == 'VND' ? 0 : decimalPlaces;
      formattedAmount = convertedAmount.toStringAsFixed(decimals);
    }

    return includeSymbol ? '${_selectedCurrency.symbol}$formattedAmount' : formattedAmount;
  }

  double convertFromUSD(double usdAmount) {
    return usdAmount * _selectedCurrency.rate;
  }

  double convertToUSD(double amount) {
    return amount / _selectedCurrency.rate;
  }

  List<Currency> searchCurrencies(String query) {
    if (query.isEmpty) return currencies;
    
    final lowercaseQuery = query.toLowerCase();
    return currencies.where((currency) {
      return currency.code.toLowerCase().contains(lowercaseQuery) ||
             currency.name.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }

  Currency? getCurrencyByCode(String code) {
    try {
      return currencies.firstWhere((c) => c.code == code);
    } catch (e) {
      return null;
    }
  }

  // Popular currencies for quick access
  static const List<String> popularCurrencyCodes = [
    'USD', 'JPY', 'IDR', 'EUR', 'GBP', 'SGD', 'MYR', 'THB', 'KRW', 'CNY'
  ];

  List<Currency> get popularCurrencies {
    return currencies.where((c) => popularCurrencyCodes.contains(c.code)).toList();
  }
} 