// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zakat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZakatModel _$ZakatModelFromJson(Map<String, dynamic> json) => ZakatModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$ZakatTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toDouble(),
      zakatDue: (json['zakatDue'] as num).toDouble(),
      calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      paymentDueDate: json['paymentDueDate'] == null
          ? null
          : DateTime.parse(json['paymentDueDate'] as String),
      status: $enumDecode(_$ZakatStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      calculationDetails: ZakatCalculationDetails.fromJson(
          json['calculationDetails'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ZakatModelToJson(ZakatModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$ZakatTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'zakatDue': instance.zakatDue,
      'calculatedAt': instance.calculatedAt.toIso8601String(),
      'paymentDueDate': instance.paymentDueDate?.toIso8601String(),
      'status': _$ZakatStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'calculationDetails': instance.calculationDetails,
    };

const _$ZakatTypeEnumMap = {
  ZakatType.wealth: 'wealth',
  ZakatType.fitrah: 'fitrah',
  ZakatType.goldSilver: 'gold_silver',
  ZakatType.trade: 'trade',
  ZakatType.agriculture: 'agriculture',
  ZakatType.livestock: 'livestock',
  ZakatType.investment: 'investment',
  ZakatType.profession: 'profession',
  ZakatType.savings: 'savings',
};

const _$ZakatStatusEnumMap = {
  ZakatStatus.pending: 'pending',
  ZakatStatus.calculated: 'calculated',
  ZakatStatus.paid: 'paid',
  ZakatStatus.overdue: 'overdue',
};

ZakatCalculationDetails _$ZakatCalculationDetailsFromJson(
        Map<String, dynamic> json) =>
    ZakatCalculationDetails(
      nisabAmount: (json['nisabAmount'] as num).toDouble(),
      zakatRate: (json['zakatRate'] as num).toDouble(),
      currency: json['currency'] as String,
      goldPricePerGram: (json['goldPricePerGram'] as num?)?.toDouble() ?? 0.0,
      silverPricePerGram:
          (json['silverPricePerGram'] as num?)?.toDouble() ?? 0.0,
      additionalData:
          json['additionalData'] as Map<String, dynamic>? ?? const {},
    );

Map<String, dynamic> _$ZakatCalculationDetailsToJson(
        ZakatCalculationDetails instance) =>
    <String, dynamic>{
      'nisabAmount': instance.nisabAmount,
      'zakatRate': instance.zakatRate,
      'currency': instance.currency,
      'goldPricePerGram': instance.goldPricePerGram,
      'silverPricePerGram': instance.silverPricePerGram,
      'additionalData': instance.additionalData,
    };

ZakatTypeInfo _$ZakatTypeInfoFromJson(Map<String, dynamic> json) =>
    ZakatTypeInfo(
      type: $enumDecode(_$ZakatTypeEnumMap, json['type']),
      name: json['name'] as String,
      nameIndonesian: json['nameIndonesian'] as String,
      description: json['description'] as String,
      descriptionIndonesian: json['descriptionIndonesian'] as String,
      nisabInGold: (json['nisabInGold'] as num).toDouble(),
      zakatRate: (json['zakatRate'] as num).toDouble(),
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      requirementsIndonesian: (json['requirementsIndonesian'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      calculationFormula: json['calculationFormula'] as String,
      calculationFormulaIndonesian:
          json['calculationFormulaIndonesian'] as String,
    );

Map<String, dynamic> _$ZakatTypeInfoToJson(ZakatTypeInfo instance) =>
    <String, dynamic>{
      'type': _$ZakatTypeEnumMap[instance.type]!,
      'name': instance.name,
      'nameIndonesian': instance.nameIndonesian,
      'description': instance.description,
      'descriptionIndonesian': instance.descriptionIndonesian,
      'nisabInGold': instance.nisabInGold,
      'zakatRate': instance.zakatRate,
      'requirements': instance.requirements,
      'requirementsIndonesian': instance.requirementsIndonesian,
      'calculationFormula': instance.calculationFormula,
      'calculationFormulaIndonesian': instance.calculationFormulaIndonesian,
    };

ZakatPaymentModel _$ZakatPaymentModelFromJson(Map<String, dynamic> json) =>
    ZakatPaymentModel(
      id: json['id'] as String,
      zakatId: json['zakatId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toDouble(),
      paymentMethod: json['paymentMethod'] as String,
      recipientName: json['recipientName'] as String?,
      recipientType: json['recipientType'] as String?,
      paidAt: DateTime.parse(json['paidAt'] as String),
      transactionId: json['transactionId'] as String?,
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$ZakatPaymentModelToJson(ZakatPaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'zakatId': instance.zakatId,
      'userId': instance.userId,
      'amount': instance.amount,
      'paymentMethod': instance.paymentMethod,
      'recipientName': instance.recipientName,
      'recipientType': instance.recipientType,
      'paidAt': instance.paidAt.toIso8601String(),
      'transactionId': instance.transactionId,
      'notes': instance.notes,
    };
