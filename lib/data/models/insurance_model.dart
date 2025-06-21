import 'package:json_annotation/json_annotation.dart';

part 'insurance_model.g.dart';

@JsonSerializable()
class InsuranceModel {
  final String id;
  final String name;
  final String type; // travel, health, vehicle, etc.
  final String description;
  final double price;
  final String duration;
  final List<String> coverage;
  final List<String> benefits;
  final String provider;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final List<String> documents;
  final bool isRecommended;
  final Map<String, dynamic> terms;

  const InsuranceModel({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.price,
    required this.duration,
    required this.coverage,
    required this.benefits,
    required this.provider,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.documents,
    this.isRecommended = false,
    required this.terms,
  });

  factory InsuranceModel.fromJson(Map<String, dynamic> json) => _$InsuranceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsuranceModelToJson(this);
}

@JsonSerializable()
class InsuranceClaimModel {
  final String id;
  final String insuranceId;
  final String userId;
  final String type;
  final String description;
  final double amount;
  final String status; // pending, approved, rejected, processing
  final DateTime claimDate;
  final DateTime? processedDate;
  final List<String> attachments;
  final String? notes;
  final Map<String, dynamic> details;

  const InsuranceClaimModel({
    required this.id,
    required this.insuranceId,
    required this.userId,
    required this.type,
    required this.description,
    required this.amount,
    required this.status,
    required this.claimDate,
    this.processedDate,
    required this.attachments,
    this.notes,
    required this.details,
  });

  factory InsuranceClaimModel.fromJson(Map<String, dynamic> json) => _$InsuranceClaimModelFromJson(json);

  Map<String, dynamic> toJson() => _$InsuranceClaimModelToJson(this);
}

enum InsuranceType {
  travel,
  health,
  vehicle,
  property,
  life,
}

enum ClaimStatus {
  pending,
  approved,
  rejected,
  processing,
} 