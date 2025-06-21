// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransactionModel _$TransactionModelFromJson(Map<String, dynamic> json) =>
    TransactionModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      status: $enumDecode(_$TransactionStatusEnumMap, json['status']),
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      paymentMethod:
          PaymentMethod.fromJson(json['paymentMethod'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      details:
          TransactionDetails.fromJson(json['details'] as Map<String, dynamic>),
      refundInfo: json['refundInfo'] == null
          ? null
          : RefundInfo.fromJson(json['refundInfo'] as Map<String, dynamic>),
      history: (json['history'] as List<dynamic>)
          .map((e) => TransactionHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
      referenceNumber: json['referenceNumber'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TransactionModelToJson(TransactionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'status': _$TransactionStatusEnumMap[instance.status]!,
      'amount': instance.amount,
      'currency': instance.currency,
      'paymentMethod': instance.paymentMethod,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
      'details': instance.details,
      'refundInfo': instance.refundInfo,
      'history': instance.history,
      'referenceNumber': instance.referenceNumber,
      'metadata': instance.metadata,
    };

const _$TransactionTypeEnumMap = {
  TransactionType.flight: 'flight',
  TransactionType.train: 'train',
  TransactionType.bus: 'bus',
  TransactionType.hotel: 'hotel',
  TransactionType.hajjUmroh: 'hajjUmroh',
  TransactionType.insurance: 'insurance',
  TransactionType.holidayPackage: 'holidayPackage',
  TransactionType.food: 'food',
  TransactionType.voucher: 'voucher',
  TransactionType.event: 'event',
  TransactionType.guideTour: 'guideTour',
  TransactionType.rental: 'rental',
  TransactionType.ride: 'ride',
  TransactionType.other: 'other',
};

const _$TransactionStatusEnumMap = {
  TransactionStatus.pending: 'pending',
  TransactionStatus.processing: 'processing',
  TransactionStatus.completed: 'completed',
  TransactionStatus.failed: 'failed',
  TransactionStatus.cancelled: 'cancelled',
  TransactionStatus.refunded: 'refunded',
  TransactionStatus.refundable: 'refundable',
  TransactionStatus.partiallyRefunded: 'partiallyRefunded',
};

TransactionDetails _$TransactionDetailsFromJson(Map<String, dynamic> json) =>
    TransactionDetails(
      title: json['title'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String?,
      itemDetails: json['itemDetails'] as Map<String, dynamic>,
      merchantName: json['merchantName'] as String?,
      merchantId: json['merchantId'] as String?,
      departureDate: json['departureDate'] == null
          ? null
          : DateTime.parse(json['departureDate'] as String),
      arrivalDate: json['arrivalDate'] == null
          ? null
          : DateTime.parse(json['arrivalDate'] as String),
      origin: json['origin'] as String?,
      destination: json['destination'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      passengerNames: (json['passengerNames'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$TransactionDetailsToJson(TransactionDetails instance) =>
    <String, dynamic>{
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'itemDetails': instance.itemDetails,
      'merchantName': instance.merchantName,
      'merchantId': instance.merchantId,
      'departureDate': instance.departureDate?.toIso8601String(),
      'arrivalDate': instance.arrivalDate?.toIso8601String(),
      'origin': instance.origin,
      'destination': instance.destination,
      'quantity': instance.quantity,
      'passengerNames': instance.passengerNames,
    };

PaymentMethod _$PaymentMethodFromJson(Map<String, dynamic> json) =>
    PaymentMethod(
      type: $enumDecode(_$PaymentTypeEnumMap, json['type']),
      cardLast4: json['cardLast4'] as String?,
      cardBrand: json['cardBrand'] as String?,
      bankName: json['bankName'] as String?,
      accountNumber: json['accountNumber'] as String?,
      walletType: json['walletType'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$PaymentMethodToJson(PaymentMethod instance) =>
    <String, dynamic>{
      'type': _$PaymentTypeEnumMap[instance.type]!,
      'cardLast4': instance.cardLast4,
      'cardBrand': instance.cardBrand,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'walletType': instance.walletType,
      'additionalInfo': instance.additionalInfo,
    };

const _$PaymentTypeEnumMap = {
  PaymentType.creditCard: 'creditCard',
  PaymentType.debitCard: 'debitCard',
  PaymentType.bankTransfer: 'bankTransfer',
  PaymentType.digitalWallet: 'digitalWallet',
  PaymentType.qris: 'qris',
  PaymentType.cash: 'cash',
  PaymentType.applePay: 'applePay',
  PaymentType.googlePay: 'googlePay',
  PaymentType.alipay: 'alipay',
  PaymentType.touchNGo: 'touchNGo',
  PaymentType.grabPay: 'grabPay',
  PaymentType.shopeePay: 'shopeePay',
  PaymentType.dana: 'dana',
  PaymentType.gopay: 'gopay',
  PaymentType.ovo: 'ovo',
  PaymentType.linkAja: 'linkAja',
  PaymentType.paypal: 'paypal',
  PaymentType.visa: 'visa',
  PaymentType.mastercard: 'mastercard',
  PaymentType.amex: 'amex',
  PaymentType.jcb: 'jcb',
  PaymentType.unionPay: 'unionPay',
  PaymentType.discover: 'discover',
};

RefundInfo _$RefundInfoFromJson(Map<String, dynamic> json) => RefundInfo(
      refundPolicy:
          RefundPolicy.fromJson(json['refundPolicy'] as Map<String, dynamic>),
      departureDate: json['departureDate'] == null
          ? null
          : DateTime.parse(json['departureDate'] as String),
      requestedAt: DateTime.parse(json['requestedAt'] as String),
      status: $enumDecode(_$RefundStatusEnumMap, json['status']),
      refundAmount: (json['refundAmount'] as num?)?.toDouble(),
      reason: json['reason'] as String?,
      processedBy: json['processedBy'] as String?,
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$RefundInfoToJson(RefundInfo instance) =>
    <String, dynamic>{
      'refundPolicy': instance.refundPolicy,
      'departureDate': instance.departureDate?.toIso8601String(),
      'requestedAt': instance.requestedAt.toIso8601String(),
      'status': _$RefundStatusEnumMap[instance.status]!,
      'refundAmount': instance.refundAmount,
      'reason': instance.reason,
      'processedBy': instance.processedBy,
      'processedAt': instance.processedAt?.toIso8601String(),
      'notes': instance.notes,
    };

const _$RefundStatusEnumMap = {
  RefundStatus.requested: 'requested',
  RefundStatus.approved: 'approved',
  RefundStatus.rejected: 'rejected',
  RefundStatus.processing: 'processing',
  RefundStatus.completed: 'completed',
};

RefundPolicy _$RefundPolicyFromJson(Map<String, dynamic> json) => RefundPolicy(
      name: json['name'] as String,
      tiers: (json['tiers'] as List<dynamic>)
          .map((e) => RefundTier.fromJson(e as Map<String, dynamic>))
          .toList(),
      description: json['description'] as String?,
      conditions: (json['conditions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$RefundPolicyToJson(RefundPolicy instance) =>
    <String, dynamic>{
      'name': instance.name,
      'tiers': instance.tiers,
      'description': instance.description,
      'conditions': instance.conditions,
    };

RefundTier _$RefundTierFromJson(Map<String, dynamic> json) => RefundTier(
      daysBeforeDeparture: (json['daysBeforeDeparture'] as num).toInt(),
      refundPercentage: (json['refundPercentage'] as num).toDouble(),
      flatFee: (json['flatFee'] as num?)?.toDouble(),
      description: json['description'] as String?,
    );

Map<String, dynamic> _$RefundTierToJson(RefundTier instance) =>
    <String, dynamic>{
      'daysBeforeDeparture': instance.daysBeforeDeparture,
      'refundPercentage': instance.refundPercentage,
      'flatFee': instance.flatFee,
      'description': instance.description,
    };

TransactionHistory _$TransactionHistoryFromJson(Map<String, dynamic> json) =>
    TransactionHistory(
      action: json['action'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      performedBy: json['performedBy'] as String?,
      details: json['details'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$TransactionHistoryToJson(TransactionHistory instance) =>
    <String, dynamic>{
      'action': instance.action,
      'timestamp': instance.timestamp.toIso8601String(),
      'performedBy': instance.performedBy,
      'details': instance.details,
    };
