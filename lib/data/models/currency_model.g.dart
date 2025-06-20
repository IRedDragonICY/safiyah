// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CurrencyModel _$CurrencyModelFromJson(Map<String, dynamic> json) =>
    CurrencyModel(
      code: json['code'] as String,
      name: json['name'] as String,
      symbol: json['symbol'] as String,
      flagUrl: json['flagUrl'] as String,
      rate: (json['rate'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrencyModelToJson(CurrencyModel instance) =>
    <String, dynamic>{
      'code': instance.code,
      'name': instance.name,
      'symbol': instance.symbol,
      'flagUrl': instance.flagUrl,
      'rate': instance.rate,
    };

TransferCalculationModel _$TransferCalculationModelFromJson(
        Map<String, dynamic> json) =>
    TransferCalculationModel(
      sourceAmount: (json['sourceAmount'] as num).toDouble(),
      destinationAmount: (json['destinationAmount'] as num).toDouble(),
      sourceCurrency: CurrencyModel.fromJson(
          json['sourceCurrency'] as Map<String, dynamic>),
      destinationCurrency: CurrencyModel.fromJson(
          json['destinationCurrency'] as Map<String, dynamic>),
      exchangeRate: (json['exchangeRate'] as num).toDouble(),
      transferFee: (json['transferFee'] as num).toDouble(),
      totalCost: (json['totalCost'] as num).toDouble(),
      estimatedTime: json['estimatedTime'] as String,
      discountAmount: (json['discountAmount'] as num?)?.toDouble(),
      promoCode: json['promoCode'] as String?,
    );

Map<String, dynamic> _$TransferCalculationModelToJson(
        TransferCalculationModel instance) =>
    <String, dynamic>{
      'sourceAmount': instance.sourceAmount,
      'destinationAmount': instance.destinationAmount,
      'sourceCurrency': instance.sourceCurrency,
      'destinationCurrency': instance.destinationCurrency,
      'exchangeRate': instance.exchangeRate,
      'transferFee': instance.transferFee,
      'totalCost': instance.totalCost,
      'estimatedTime': instance.estimatedTime,
      'discountAmount': instance.discountAmount,
      'promoCode': instance.promoCode,
    };

CurrencyRateModel _$CurrencyRateModelFromJson(Map<String, dynamic> json) =>
    CurrencyRateModel(
      fromCurrency: json['fromCurrency'] as String,
      toCurrency: json['toCurrency'] as String,
      rate: (json['rate'] as num).toDouble(),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      change24h: (json['change24h'] as num).toDouble(),
      changePercent24h: (json['changePercent24h'] as num).toDouble(),
    );

Map<String, dynamic> _$CurrencyRateModelToJson(CurrencyRateModel instance) =>
    <String, dynamic>{
      'fromCurrency': instance.fromCurrency,
      'toCurrency': instance.toCurrency,
      'rate': instance.rate,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'change24h': instance.change24h,
      'changePercent24h': instance.changePercent24h,
    };

PromoModel _$PromoModelFromJson(Map<String, dynamic> json) => PromoModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      code: json['code'] as String,
      discountPercentage: (json['discountPercentage'] as num).toDouble(),
      maxDiscount: (json['maxDiscount'] as num?)?.toDouble(),
      usageLimit: (json['usageLimit'] as num).toInt(),
      usedCount: (json['usedCount'] as num).toInt(),
      validFrom: DateTime.parse(json['validFrom'] as String),
      validUntil: DateTime.parse(json['validUntil'] as String),
      isActive: json['isActive'] as bool,
      applicableCountries: (json['applicableCountries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$PromoModelToJson(PromoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'code': instance.code,
      'discountPercentage': instance.discountPercentage,
      'maxDiscount': instance.maxDiscount,
      'usageLimit': instance.usageLimit,
      'usedCount': instance.usedCount,
      'validFrom': instance.validFrom.toIso8601String(),
      'validUntil': instance.validUntil.toIso8601String(),
      'isActive': instance.isActive,
      'applicableCountries': instance.applicableCountries,
    };

CurrencyAlertModel _$CurrencyAlertModelFromJson(Map<String, dynamic> json) =>
    CurrencyAlertModel(
      id: json['id'] as String,
      sourceCurrency: CurrencyModel.fromJson(
          json['sourceCurrency'] as Map<String, dynamic>),
      targetCurrency: CurrencyModel.fromJson(
          json['targetCurrency'] as Map<String, dynamic>),
      targetRate: (json['targetRate'] as num).toDouble(),
      currentRate: (json['currentRate'] as num).toDouble(),
      isActive: json['isActive'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      triggeredAt: json['triggeredAt'] == null
          ? null
          : DateTime.parse(json['triggeredAt'] as String),
    );

Map<String, dynamic> _$CurrencyAlertModelToJson(CurrencyAlertModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sourceCurrency': instance.sourceCurrency,
      'targetCurrency': instance.targetCurrency,
      'targetRate': instance.targetRate,
      'currentRate': instance.currentRate,
      'isActive': instance.isActive,
      'createdAt': instance.createdAt.toIso8601String(),
      'triggeredAt': instance.triggeredAt?.toIso8601String(),
    };
