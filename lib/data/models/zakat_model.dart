import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'zakat_model.g.dart';

@JsonSerializable()
class ZakatModel extends Equatable {
  final String id;
  final String userId;
  final ZakatType type;
  final double amount;
  final double zakatDue;
  final DateTime calculatedAt;
  final DateTime? paymentDueDate;
  final ZakatStatus status;
  final String? notes;
  final ZakatCalculationDetails calculationDetails;

  const ZakatModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.zakatDue,
    required this.calculatedAt,
    this.paymentDueDate,
    required this.status,
    this.notes,
    required this.calculationDetails,
  });

  factory ZakatModel.fromJson(Map<String, dynamic> json) =>
      _$ZakatModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZakatModelToJson(this);

  ZakatModel copyWith({
    String? id,
    String? userId,
    ZakatType? type,
    double? amount,
    double? zakatDue,
    DateTime? calculatedAt,
    DateTime? paymentDueDate,
    ZakatStatus? status,
    String? notes,
    ZakatCalculationDetails? calculationDetails,
  }) {
    return ZakatModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      zakatDue: zakatDue ?? this.zakatDue,
      calculatedAt: calculatedAt ?? this.calculatedAt,
      paymentDueDate: paymentDueDate ?? this.paymentDueDate,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      calculationDetails: calculationDetails ?? this.calculationDetails,
    );
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        type,
        amount,
        zakatDue,
        calculatedAt,
        paymentDueDate,
        status,
        notes,
        calculationDetails,
      ];
}

@JsonSerializable()
class ZakatCalculationDetails extends Equatable {
  final double nisabAmount;
  final double zakatRate;
  final String currency;
  final double goldPricePerGram;
  final double silverPricePerGram;
  final Map<String, dynamic> additionalData;

  const ZakatCalculationDetails({
    required this.nisabAmount,
    required this.zakatRate,
    required this.currency,
    this.goldPricePerGram = 0.0,
    this.silverPricePerGram = 0.0,
    this.additionalData = const {},
  });

  factory ZakatCalculationDetails.fromJson(Map<String, dynamic> json) =>
      _$ZakatCalculationDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$ZakatCalculationDetailsToJson(this);

  @override
  List<Object?> get props => [
        nisabAmount,
        zakatRate,
        currency,
        goldPricePerGram,
        silverPricePerGram,
        additionalData,
      ];
}

enum ZakatType {
  @JsonValue('wealth')
  wealth, // Zakat Mal
  @JsonValue('fitrah')
  fitrah, // Zakat Fitrah
  @JsonValue('gold_silver')
  goldSilver, // Zakat Emas dan Perak
  @JsonValue('trade')
  trade, // Zakat Perdagangan
  @JsonValue('agriculture')
  agriculture, // Zakat Pertanian
  @JsonValue('livestock')
  livestock, // Zakat Peternakan
  @JsonValue('investment')
  investment, // Zakat Saham dan Investasi
  @JsonValue('profession')
  profession, // Zakat Profesi
  @JsonValue('savings')
  savings, // Zakat Tabungan
}

enum ZakatStatus {
  @JsonValue('pending')
  pending,
  @JsonValue('calculated')
  calculated,
  @JsonValue('paid')
  paid,
  @JsonValue('overdue')
  overdue,
}

@JsonSerializable()
class ZakatTypeInfo extends Equatable {
  final ZakatType type;
  final String name;
  final String nameIndonesian;
  final String description;
  final String descriptionIndonesian;
  final double nisabInGold; // dalam gram emas
  final double zakatRate; // dalam persen (2.5% = 0.025)
  final List<String> requirements;
  final List<String> requirementsIndonesian;
  final String calculationFormula;
  final String calculationFormulaIndonesian;

  const ZakatTypeInfo({
    required this.type,
    required this.name,
    required this.nameIndonesian,
    required this.description,
    required this.descriptionIndonesian,
    required this.nisabInGold,
    required this.zakatRate,
    required this.requirements,
    required this.requirementsIndonesian,
    required this.calculationFormula,
    required this.calculationFormulaIndonesian,
  });

  factory ZakatTypeInfo.fromJson(Map<String, dynamic> json) =>
      _$ZakatTypeInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ZakatTypeInfoToJson(this);

  @override
  List<Object?> get props => [
        type,
        name,
        nameIndonesian,
        description,
        descriptionIndonesian,
        nisabInGold,
        zakatRate,
        requirements,
        requirementsIndonesian,
        calculationFormula,
        calculationFormulaIndonesian,
      ];
}

@JsonSerializable()
class ZakatPaymentModel extends Equatable {
  final String id;
  final String zakatId;
  final String userId;
  final double amount;
  final String paymentMethod;
  final String? recipientName;
  final String? recipientType; // mosque, organization, individual
  final DateTime paidAt;
  final String? transactionId;
  final String? notes;

  const ZakatPaymentModel({
    required this.id,
    required this.zakatId,
    required this.userId,
    required this.amount,
    required this.paymentMethod,
    this.recipientName,
    this.recipientType,
    required this.paidAt,
    this.transactionId,
    this.notes,
  });

  factory ZakatPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$ZakatPaymentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ZakatPaymentModelToJson(this);

  ZakatPaymentModel copyWith({
    String? id,
    String? zakatId,
    String? userId,
    double? amount,
    String? paymentMethod,
    String? recipientName,
    String? recipientType,
    DateTime? paidAt,
    String? transactionId,
    String? notes,
  }) {
    return ZakatPaymentModel(
      id: id ?? this.id,
      zakatId: zakatId ?? this.zakatId,
      userId: userId ?? this.userId,
      amount: amount ?? this.amount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      recipientName: recipientName ?? this.recipientName,
      recipientType: recipientType ?? this.recipientType,
      paidAt: paidAt ?? this.paidAt,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
        id,
        zakatId,
        userId,
        amount,
        paymentMethod,
        recipientName,
        recipientType,
        paidAt,
        transactionId,
        notes,
      ];
} 