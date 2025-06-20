import 'package:flutter/material.dart';

enum VoucherType { 
  all, 
  food, 
  transport, 
  hotel, 
  tour, 
  shopping,
  entertainment,
  currency,
  health,
  beauty,
  education,
  lifestyle
}

enum VoucherStatus {
  active,
  expired,
  used,
  upcoming
}

enum DiscountType {
  percentage,
  fixed,
  buyOneGetOne,
  free
}

class VoucherModel {
  final String id;
  final String title;
  final String description;
  final String discountText;
  final double? discountValue;
  final DiscountType discountType;
  final double? minPurchase;
  final double? maxDiscount;
  final String expiryDate;
  final DateTime expiryDateTime;
  final DateTime? usedDateTime;
  final DateTime? claimedDateTime;
  final String imageUrl;
  final String brandLogoUrl;
  final String brandName;
  final VoucherType type;
  final VoucherStatus status;
  final bool isNewUserVoucher;
  final bool isFeatured;
  final bool isPopular;
  final Color brandColor;
  final List<String> terms;
  final String code;
  final int usageLimit;
  final int usedCount;
  final double rating;
  final int reviewCount;
  final List<String> locations;
  final bool isTransferable;
  final String? partnershipInfo;
  final String? usageDetails;
  final double? savedAmount;

  const VoucherModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    this.discountValue,
    required this.discountType,
    this.minPurchase,
    this.maxDiscount,
    required this.expiryDate,
    required this.expiryDateTime,
    this.usedDateTime,
    this.claimedDateTime,
    required this.imageUrl,
    required this.brandLogoUrl,
    required this.brandName,
    required this.type,
    this.status = VoucherStatus.active,
    this.isNewUserVoucher = false,
    this.isFeatured = false,
    this.isPopular = false,
    required this.brandColor,
    this.terms = const [],
    required this.code,
    this.usageLimit = 1,
    this.usedCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.locations = const [],
    this.isTransferable = false,
    this.partnershipInfo,
    this.usageDetails,
    this.savedAmount,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDateTime);
  bool get isUsed => usedCount >= usageLimit || status == VoucherStatus.used;
  bool get isValid => !isExpired && !isUsed && status == VoucherStatus.active;
  
  String get statusText {
    if (isExpired) return 'Expired';
    if (isUsed) return 'Used';
    return 'Available';
  }
  
  Color get statusColor {
    if (isExpired || isUsed) return Colors.red;
    return Colors.green;
  }
  
  String get typeDisplayName {
    switch (type) {
      case VoucherType.food:
        return 'Food & Dining';
      case VoucherType.transport:
        return 'Transportation';
      case VoucherType.hotel:
        return 'Hotels & Lodging';
      case VoucherType.tour:
        return 'Tours & Activities';
      case VoucherType.shopping:
        return 'Shopping';
      case VoucherType.entertainment:
        return 'Entertainment';
      case VoucherType.currency:
        return 'Money Transfer';
      case VoucherType.health:
        return 'Health & Wellness';
      case VoucherType.beauty:
        return 'Beauty & Spa';
      case VoucherType.education:
        return 'Education';
      case VoucherType.lifestyle:
        return 'Lifestyle';
      case VoucherType.all:
        return 'All Categories';
    }
  }

  // Create a copy with updated fields
  VoucherModel copyWith({
    String? id,
    String? title,
    String? description,
    String? discountText,
    double? discountValue,
    DiscountType? discountType,
    double? minPurchase,
    double? maxDiscount,
    String? expiryDate,
    DateTime? expiryDateTime,
    DateTime? usedDateTime,
    DateTime? claimedDateTime,
    String? imageUrl,
    String? brandLogoUrl,
    String? brandName,
    VoucherType? type,
    VoucherStatus? status,
    bool? isNewUserVoucher,
    bool? isFeatured,
    bool? isPopular,
    Color? brandColor,
    List<String>? terms,
    String? code,
    int? usageLimit,
    int? usedCount,
    double? rating,
    int? reviewCount,
    List<String>? locations,
    bool? isTransferable,
    String? partnershipInfo,
    String? usageDetails,
    double? savedAmount,
  }) {
    return VoucherModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      discountText: discountText ?? this.discountText,
      discountValue: discountValue ?? this.discountValue,
      discountType: discountType ?? this.discountType,
      minPurchase: minPurchase ?? this.minPurchase,
      maxDiscount: maxDiscount ?? this.maxDiscount,
      expiryDate: expiryDate ?? this.expiryDate,
      expiryDateTime: expiryDateTime ?? this.expiryDateTime,
      usedDateTime: usedDateTime ?? this.usedDateTime,
      claimedDateTime: claimedDateTime ?? this.claimedDateTime,
      imageUrl: imageUrl ?? this.imageUrl,
      brandLogoUrl: brandLogoUrl ?? this.brandLogoUrl,
      brandName: brandName ?? this.brandName,
      type: type ?? this.type,
      status: status ?? this.status,
      isNewUserVoucher: isNewUserVoucher ?? this.isNewUserVoucher,
      isFeatured: isFeatured ?? this.isFeatured,
      isPopular: isPopular ?? this.isPopular,
      brandColor: brandColor ?? this.brandColor,
      terms: terms ?? this.terms,
      code: code ?? this.code,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      locations: locations ?? this.locations,
      isTransferable: isTransferable ?? this.isTransferable,
      partnershipInfo: partnershipInfo ?? this.partnershipInfo,
      usageDetails: usageDetails ?? this.usageDetails,
      savedAmount: savedAmount ?? this.savedAmount,
    );
  }

  // Check if voucher should be removed from history (older than 1 month)
  bool get shouldRemoveFromHistory {
    final oneMonthAgo = DateTime.now().subtract(const Duration(days: 30));
    return (usedDateTime != null && usedDateTime!.isBefore(oneMonthAgo)) ||
           (isExpired && expiryDateTime.isBefore(oneMonthAgo));
  }

  // Get time since used/expired for display
  String get timeSinceAction {
    DateTime? actionDate = usedDateTime ?? (isExpired ? expiryDateTime : null);
    if (actionDate == null) return '';
    
    final difference = DateTime.now().difference(actionDate);
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    }
  }
}
