import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency_model.g.dart';

@JsonSerializable()
class CurrencyModel extends Equatable {
  final String code;
  final String name;
  final String symbol;
  final String flagUrl;
  final double rate; // Rate to IDR

  const CurrencyModel({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flagUrl,
    required this.rate,
  });

  factory CurrencyModel.fromJson(Map<String, dynamic> json) => 
      _$CurrencyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyModelToJson(this);

  @override
  List<Object?> get props => [code, name, symbol, flagUrl, rate];
}

@JsonSerializable()
class TransferCalculationModel extends Equatable {
  final double sourceAmount;
  final double destinationAmount;
  final CurrencyModel sourceCurrency;
  final CurrencyModel destinationCurrency;
  final double exchangeRate;
  final double transferFee;
  final double totalCost;
  final String estimatedTime;
  final double? discountAmount;
  final String? promoCode;

  const TransferCalculationModel({
    required this.sourceAmount,
    required this.destinationAmount,
    required this.sourceCurrency,
    required this.destinationCurrency,
    required this.exchangeRate,
    required this.transferFee,
    required this.totalCost,
    required this.estimatedTime,
    this.discountAmount,
    this.promoCode,
  });

  factory TransferCalculationModel.fromJson(Map<String, dynamic> json) => 
      _$TransferCalculationModelFromJson(json);

  Map<String, dynamic> toJson() => _$TransferCalculationModelToJson(this);

  @override
  List<Object?> get props => [
        sourceAmount,
        destinationAmount,
        sourceCurrency,
        destinationCurrency,
        exchangeRate,
        transferFee,
        totalCost,
        estimatedTime,
        discountAmount,
        promoCode,
      ];
}

@JsonSerializable()
class CurrencyRateModel extends Equatable {
  final String fromCurrency;
  final String toCurrency;
  final double rate;
  final DateTime lastUpdated;
  final double change24h;
  final double changePercent24h;

  const CurrencyRateModel({
    required this.fromCurrency,
    required this.toCurrency,
    required this.rate,
    required this.lastUpdated,
    required this.change24h,
    required this.changePercent24h,
  });

  factory CurrencyRateModel.fromJson(Map<String, dynamic> json) => 
      _$CurrencyRateModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyRateModelToJson(this);

  @override
  List<Object?> get props => [
        fromCurrency,
        toCurrency,
        rate,
        lastUpdated,
        change24h,
        changePercent24h,
      ];
}

@JsonSerializable()
class PromoModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String code;
  final double discountPercentage;
  final double? maxDiscount;
  final int usageLimit;
  final int usedCount;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final List<String> applicableCountries;

  const PromoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discountPercentage,
    this.maxDiscount,
    required this.usageLimit,
    required this.usedCount,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.applicableCountries,
  });

  factory PromoModel.fromJson(Map<String, dynamic> json) => 
      _$PromoModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromoModelToJson(this);

  bool get isValid {
    final now = DateTime.now();
    return isActive && 
           now.isAfter(validFrom) && 
           now.isBefore(validUntil) && 
           usedCount < usageLimit;
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        code,
        discountPercentage,
        maxDiscount,
        usageLimit,
        usedCount,
        validFrom,
        validUntil,
        isActive,
        applicableCountries,
      ];
}

@JsonSerializable()
class CurrencyAlertModel extends Equatable {
  final String id;
  final CurrencyModel sourceCurrency;
  final CurrencyModel targetCurrency;
  final double targetRate;
  final double currentRate;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? triggeredAt;

  const CurrencyAlertModel({
    required this.id,
    required this.sourceCurrency,
    required this.targetCurrency,
    required this.targetRate,
    required this.currentRate,
    required this.isActive,
    required this.createdAt,
    this.triggeredAt,
  });

  factory CurrencyAlertModel.fromJson(Map<String, dynamic> json) => 
      _$CurrencyAlertModelFromJson(json);

  Map<String, dynamic> toJson() => _$CurrencyAlertModelToJson(this);

  bool get isTriggered => triggeredAt != null;

  @override
  List<Object?> get props => [
        id,
        sourceCurrency,
        targetCurrency,
        targetRate,
        currentRate,
        isActive,
        createdAt,
        triggeredAt,
      ];
} 
