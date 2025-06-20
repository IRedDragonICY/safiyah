import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/voucher_model.dart';

class VoucherHistoryService {
  static const String _historyKey = 'voucher_history';
  static const String _lastCleanupKey = 'voucher_history_last_cleanup';
  
  static VoucherHistoryService? _instance;
  static VoucherHistoryService get instance => _instance ??= VoucherHistoryService._();
  
  VoucherHistoryService._();

  // Get all voucher history
  Future<List<VoucherModel>> getVoucherHistory() async {
    await _performCleanupIfNeeded();
    
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    
    return historyJson.map((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return _mapToVoucherModel(map);
    }).where((voucher) => !voucher.shouldRemoveFromHistory).toList();
  }

  // Get used vouchers only
  Future<List<VoucherModel>> getUsedVouchers() async {
    final history = await getVoucherHistory();
    return history.where((v) => v.status == VoucherStatus.used && v.usedDateTime != null).toList()
      ..sort((a, b) => b.usedDateTime!.compareTo(a.usedDateTime!));
  }

  // Get expired vouchers only
  Future<List<VoucherModel>> getExpiredVouchers() async {
    final history = await getVoucherHistory();
    return history.where((v) => v.status == VoucherStatus.expired || v.isExpired).toList()
      ..sort((a, b) => b.expiryDateTime.compareTo(a.expiryDateTime));
  }

  // Add voucher to history when used
  Future<void> markVoucherAsUsed(VoucherModel voucher, {
    String? usageDetails,
    double? savedAmount,
  }) async {
    final usedVoucher = voucher.copyWith(
      status: VoucherStatus.used,
      usedDateTime: DateTime.now(),
      usedCount: voucher.usedCount + 1,
      usageDetails: usageDetails,
      savedAmount: savedAmount,
    );
    
    await _addToHistory(usedVoucher);
  }

  // Add voucher to history when expired
  Future<void> markVoucherAsExpired(VoucherModel voucher) async {
    final expiredVoucher = voucher.copyWith(
      status: VoucherStatus.expired,
    );
    
    await _addToHistory(expiredVoucher);
  }

  // Remove voucher from history
  Future<void> removeFromHistory(String voucherId) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    
    historyJson.removeWhere((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map['id'] == voucherId;
    });
    
    await prefs.setStringList(_historyKey, historyJson);
  }

  // Clear all history
  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
    await prefs.remove(_lastCleanupKey);
  }

  // Get statistics
  Future<VoucherHistoryStats> getStatistics() async {
    final usedVouchers = await getUsedVouchers();
    final expiredVouchers = await getExpiredVouchers();
    
    double totalSaved = 0;
    int totalUsed = usedVouchers.length;
    int totalExpired = expiredVouchers.length;
    
    for (final voucher in usedVouchers) {
      totalSaved += voucher.savedAmount ?? 0;
    }
    
    // Get this month's stats
    final thisMonth = DateTime.now();
    final startOfMonth = DateTime(thisMonth.year, thisMonth.month, 1);
    
    final thisMonthUsed = usedVouchers.where((v) => 
      v.usedDateTime!.isAfter(startOfMonth)
    ).length;
    
    final thisMonthSaved = usedVouchers
      .where((v) => v.usedDateTime!.isAfter(startOfMonth))
      .fold<double>(0, (sum, v) => sum + (v.savedAmount ?? 0));
    
    return VoucherHistoryStats(
      totalUsed: totalUsed,
      totalExpired: totalExpired,
      totalSaved: totalSaved,
      thisMonthUsed: thisMonthUsed,
      thisMonthSaved: thisMonthSaved,
    );
  }

  // Private helper methods
  Future<void> _addToHistory(VoucherModel voucher) async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    
    // Remove existing entry if exists
    historyJson.removeWhere((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return map['id'] == voucher.id;
    });
    
    // Add new entry
    historyJson.add(jsonEncode(_voucherModelToMap(voucher)));
    
    await prefs.setStringList(_historyKey, historyJson);
  }

  Future<void> _performCleanupIfNeeded() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCleanup = prefs.getInt(_lastCleanupKey) ?? 0;
    final lastCleanupDate = DateTime.fromMillisecondsSinceEpoch(lastCleanup);
    
    // Perform cleanup once a day
    if (DateTime.now().difference(lastCleanupDate).inDays >= 1) {
      await _cleanupOldHistory();
      await prefs.setInt(_lastCleanupKey, DateTime.now().millisecondsSinceEpoch);
    }
  }

  Future<void> _cleanupOldHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final historyJson = prefs.getStringList(_historyKey) ?? [];
    
    final filteredHistory = historyJson.where((json) {
      final map = jsonDecode(json) as Map<String, dynamic>;
      final voucher = _mapToVoucherModel(map);
      
      // Keep if not older than 1 month
      return !voucher.shouldRemoveFromHistory;
    }).toList();
    
    await prefs.setStringList(_historyKey, filteredHistory);
  }

  Map<String, dynamic> _voucherModelToMap(VoucherModel voucher) {
    return {
      'id': voucher.id,
      'title': voucher.title,
      'description': voucher.description,
      'discountText': voucher.discountText,
      'discountValue': voucher.discountValue,
      'discountType': voucher.discountType.name,
      'minPurchase': voucher.minPurchase,
      'maxDiscount': voucher.maxDiscount,
      'expiryDate': voucher.expiryDate,
      'expiryDateTime': voucher.expiryDateTime.millisecondsSinceEpoch,
      'usedDateTime': voucher.usedDateTime?.millisecondsSinceEpoch,
      'claimedDateTime': voucher.claimedDateTime?.millisecondsSinceEpoch,
      'imageUrl': voucher.imageUrl,
      'brandLogoUrl': voucher.brandLogoUrl,
      'brandName': voucher.brandName,
      'type': voucher.type.name,
      'status': voucher.status.name,
      'isNewUserVoucher': voucher.isNewUserVoucher,
      'isFeatured': voucher.isFeatured,
      'isPopular': voucher.isPopular,
      'brandColor': voucher.brandColor.value,
      'terms': voucher.terms,
      'code': voucher.code,
      'usageLimit': voucher.usageLimit,
      'usedCount': voucher.usedCount,
      'rating': voucher.rating,
      'reviewCount': voucher.reviewCount,
      'locations': voucher.locations,
      'isTransferable': voucher.isTransferable,
      'partnershipInfo': voucher.partnershipInfo,
      'usageDetails': voucher.usageDetails,
      'savedAmount': voucher.savedAmount,
    };
  }

  VoucherModel _mapToVoucherModel(Map<String, dynamic> map) {
    return VoucherModel(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      discountText: map['discountText'],
      discountValue: map['discountValue']?.toDouble(),
      discountType: DiscountType.values.firstWhere(
        (e) => e.name == map['discountType'],
        orElse: () => DiscountType.percentage,
      ),
      minPurchase: map['minPurchase']?.toDouble(),
      maxDiscount: map['maxDiscount']?.toDouble(),
      expiryDate: map['expiryDate'],
      expiryDateTime: DateTime.fromMillisecondsSinceEpoch(map['expiryDateTime']),
      usedDateTime: map['usedDateTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['usedDateTime'])
          : null,
      claimedDateTime: map['claimedDateTime'] != null 
          ? DateTime.fromMillisecondsSinceEpoch(map['claimedDateTime'])
          : null,
      imageUrl: map['imageUrl'],
      brandLogoUrl: map['brandLogoUrl'],
      brandName: map['brandName'],
      type: VoucherType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => VoucherType.all,
      ),
      status: VoucherStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => VoucherStatus.active,
      ),
      isNewUserVoucher: map['isNewUserVoucher'] ?? false,
      isFeatured: map['isFeatured'] ?? false,
      isPopular: map['isPopular'] ?? false,
      brandColor: Color(map['brandColor']),
      terms: List<String>.from(map['terms'] ?? []),
      code: map['code'],
      usageLimit: map['usageLimit'] ?? 1,
      usedCount: map['usedCount'] ?? 0,
      rating: map['rating']?.toDouble() ?? 0.0,
      reviewCount: map['reviewCount'] ?? 0,
      locations: List<String>.from(map['locations'] ?? []),
      isTransferable: map['isTransferable'] ?? false,
      partnershipInfo: map['partnershipInfo'],
      usageDetails: map['usageDetails'],
      savedAmount: map['savedAmount']?.toDouble(),
    );
  }
}

class VoucherHistoryStats {
  final int totalUsed;
  final int totalExpired;
  final double totalSaved;
  final int thisMonthUsed;
  final double thisMonthSaved;

  const VoucherHistoryStats({
    required this.totalUsed,
    required this.totalExpired,
    required this.totalSaved,
    required this.thisMonthUsed,
    required this.thisMonthSaved,
  });
} 