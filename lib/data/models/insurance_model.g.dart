// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'insurance_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InsuranceModel _$InsuranceModelFromJson(Map<String, dynamic> json) =>
    InsuranceModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      duration: json['duration'] as String,
      coverage:
          (json['coverage'] as List<dynamic>).map((e) => e as String).toList(),
      benefits:
          (json['benefits'] as List<dynamic>).map((e) => e as String).toList(),
      provider: json['provider'] as String,
      rating: (json['rating'] as num).toDouble(),
      reviewCount: (json['reviewCount'] as num).toInt(),
      imageUrl: json['imageUrl'] as String,
      documents:
          (json['documents'] as List<dynamic>).map((e) => e as String).toList(),
      isRecommended: json['isRecommended'] as bool? ?? false,
      terms: json['terms'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$InsuranceModelToJson(InsuranceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': instance.type,
      'description': instance.description,
      'price': instance.price,
      'duration': instance.duration,
      'coverage': instance.coverage,
      'benefits': instance.benefits,
      'provider': instance.provider,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'imageUrl': instance.imageUrl,
      'documents': instance.documents,
      'isRecommended': instance.isRecommended,
      'terms': instance.terms,
    };

InsuranceClaimModel _$InsuranceClaimModelFromJson(Map<String, dynamic> json) =>
    InsuranceClaimModel(
      id: json['id'] as String,
      insuranceId: json['insuranceId'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: json['status'] as String,
      claimDate: DateTime.parse(json['claimDate'] as String),
      processedDate: json['processedDate'] == null
          ? null
          : DateTime.parse(json['processedDate'] as String),
      attachments: (json['attachments'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      notes: json['notes'] as String?,
      details: json['details'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$InsuranceClaimModelToJson(
        InsuranceClaimModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'insuranceId': instance.insuranceId,
      'userId': instance.userId,
      'type': instance.type,
      'description': instance.description,
      'amount': instance.amount,
      'status': instance.status,
      'claimDate': instance.claimDate.toIso8601String(),
      'processedDate': instance.processedDate?.toIso8601String(),
      'attachments': instance.attachments,
      'notes': instance.notes,
      'details': instance.details,
    };
