import 'package:flutter/material.dart';

enum VoucherType { food, transport, hotel, tour, all }

class VoucherModel {
  final String id;
  final String title;
  final String description;
  final String discountText;
  final String expiryDate;
  final String imageUrl;
  final String brandLogoUrl;
  final String brandName;
  final VoucherType type;
  final bool isNewUserVoucher;
  final Color brandColor;

  const VoucherModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountText,
    required this.expiryDate,
    required this.imageUrl,
    required this.brandLogoUrl,
    required this.brandName,
    required this.type,
    this.isNewUserVoucher = false,
    required this.brandColor,
  });
}