import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTextStyles {
  static const brand = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
    letterSpacing: 0.8,
  );

  static const pageTitle = TextStyle(
    fontSize: 29,
    fontWeight: FontWeight.w700,
    color: AppColors.headline,
    height: 1.1,
  );

  static const pageDescription = TextStyle(
    fontSize: 15,
    color: AppColors.body,
    height: 1.35,
  );

  static const sectionLabel = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    color: Color(0xFF5B6658),
  );

  static const inputHint = TextStyle(
    fontSize: 14,
    color: AppColors.bodyStrong,
  );

  static const link = TextStyle(
    fontSize: 14,
    color: AppColors.primarySoft,
    fontWeight: FontWeight.w700,
  );

  static const body = TextStyle(
    fontSize: 13,
    color: AppColors.muted,
    height: 1.35,
  );

  static const footerBrand = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.headline,
  );

  static const footerText = TextStyle(
    fontSize: 14,
    color: AppColors.footerText,
  );

  static const footerLink = TextStyle(
    fontSize: 14,
    color: AppColors.footerText,
  );

  static const action = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.onPrimary,
  );
}