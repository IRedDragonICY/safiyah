import 'package:json_annotation/json_annotation.dart';

part 'transaction_model.g.dart';

@JsonSerializable()
class TransactionModel {
  final String id;
  final String userId;
  final TransactionType type;
  final TransactionStatus status;
  final double amount;
  final String currency;
  final PaymentMethod paymentMethod;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? completedAt;
  final TransactionDetails details;
  final RefundInfo? refundInfo;
  final List<TransactionHistory> history;
  final String? referenceNumber;
  final Map<String, dynamic>? metadata;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.status,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.createdAt,
    this.updatedAt,
    this.completedAt,
    required this.details,
    this.refundInfo,
    required this.history,
    this.referenceNumber,
    this.metadata,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      _$TransactionModelFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionModelToJson(this);

  // Calculate refund amount based on cancellation policy
  double calculateRefundAmount() {
    if (refundInfo == null || status != TransactionStatus.refundable) {
      return 0.0;
    }

    final daysUntilDeparture = refundInfo!.calculateDaysUntilDeparture();
    final policy = refundInfo!.refundPolicy;
    
    for (final tier in policy.tiers) {
      if (daysUntilDeparture >= tier.daysBeforeDeparture) {
        return amount * (tier.refundPercentage / 100);
      }
    }
    
    return 0.0;
  }
}

enum TransactionType {
  flight,
  train,
  bus,
  hotel,
  hajjUmroh,
  insurance,
  holidayPackage,
  food,
  voucher,
  event,
  guideTour,
  rental,
  ride,
  other,
}

enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
  refundable,
  partiallyRefunded,
}

@JsonSerializable()
class TransactionDetails {
  final String title;
  final String description;
  final String? imageUrl;
  final Map<String, dynamic> itemDetails;
  final String? merchantName;
  final String? merchantId;
  final DateTime? departureDate;
  final DateTime? arrivalDate;
  final String? origin;
  final String? destination;
  final int? quantity;
  final List<String>? passengerNames;
  
  TransactionDetails({
    required this.title,
    required this.description,
    this.imageUrl,
    required this.itemDetails,
    this.merchantName,
    this.merchantId,
    this.departureDate,
    this.arrivalDate,
    this.origin,
    this.destination,
    this.quantity,
    this.passengerNames,
  });

  factory TransactionDetails.fromJson(Map<String, dynamic> json) =>
      _$TransactionDetailsFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionDetailsToJson(this);
}

@JsonSerializable()
class PaymentMethod {
  final PaymentType type;
  final String? cardLast4;
  final String? cardBrand;
  final String? bankName;
  final String? accountNumber;
  final String? walletType;
  final Map<String, dynamic>? additionalInfo;
  
  PaymentMethod({
    required this.type,
    this.cardLast4,
    this.cardBrand,
    this.bankName,
    this.accountNumber,
    this.walletType,
    this.additionalInfo,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) =>
      _$PaymentMethodFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodToJson(this);

  String get displayName {
    switch (type) {
      case PaymentType.creditCard:
      case PaymentType.debitCard:
        return '${cardBrand ?? 'Card'} •••• ${cardLast4 ?? ''}';
      case PaymentType.bankTransfer:
        return '${bankName ?? 'Bank'} •••• ${accountNumber?.substring(accountNumber!.length - 4) ?? ''}';
      case PaymentType.digitalWallet:
        return walletType ?? 'Digital Wallet';
      case PaymentType.qris:
        return 'QRIS';
      default:
        return type.name;
    }
  }
}

enum PaymentType {
  creditCard,
  debitCard,
  bankTransfer,
  digitalWallet,
  qris,
  cash,
  applePay,
  googlePay,
  alipay,
  touchNGo,
  grabPay,
  shopeePay,
  dana,
  gopay,
  ovo,
  linkAja,
  paypal,
  visa,
  mastercard,
  amex,
  jcb,
  unionPay,
  discover,
}

@JsonSerializable()
class RefundInfo {
  final RefundPolicy refundPolicy;
  final DateTime? departureDate;
  final DateTime requestedAt;
  final RefundStatus status;
  final double? refundAmount;
  final String? reason;
  final String? processedBy;
  final DateTime? processedAt;
  final String? notes;
  
  RefundInfo({
    required this.refundPolicy,
    this.departureDate,
    required this.requestedAt,
    required this.status,
    this.refundAmount,
    this.reason,
    this.processedBy,
    this.processedAt,
    this.notes,
  });

  factory RefundInfo.fromJson(Map<String, dynamic> json) =>
      _$RefundInfoFromJson(json);
  Map<String, dynamic> toJson() => _$RefundInfoToJson(this);

  int calculateDaysUntilDeparture() {
    if (departureDate == null) return 0;
    return departureDate!.difference(DateTime.now()).inDays;
  }
}

enum RefundStatus {
  requested,
  approved,
  rejected,
  processing,
  completed,
}

@JsonSerializable()
class RefundPolicy {
  final String name;
  final List<RefundTier> tiers;
  final String? description;
  final List<String>? conditions;
  
  RefundPolicy({
    required this.name,
    required this.tiers,
    this.description,
    this.conditions,
  });

  factory RefundPolicy.fromJson(Map<String, dynamic> json) =>
      _$RefundPolicyFromJson(json);
  Map<String, dynamic> toJson() => _$RefundPolicyToJson(this);
}

@JsonSerializable()
class RefundTier {
  final int daysBeforeDeparture;
  final double refundPercentage;
  final double? flatFee;
  final String? description;
  
  RefundTier({
    required this.daysBeforeDeparture,
    required this.refundPercentage,
    this.flatFee,
    this.description,
  });

  factory RefundTier.fromJson(Map<String, dynamic> json) =>
      _$RefundTierFromJson(json);
  Map<String, dynamic> toJson() => _$RefundTierToJson(this);
}

@JsonSerializable()
class TransactionHistory {
  final String action;
  final DateTime timestamp;
  final String? performedBy;
  final Map<String, dynamic>? details;
  
  TransactionHistory({
    required this.action,
    required this.timestamp,
    this.performedBy,
    this.details,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      _$TransactionHistoryFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionHistoryToJson(this);
} 