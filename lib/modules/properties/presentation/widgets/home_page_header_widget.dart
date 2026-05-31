import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_text_styles.dart';
import '../controller/home_page_controller.dart';

class HomePageHeaderWidget extends StatelessWidget {
  const HomePageHeaderWidget({super.key, required this.data});

  final HomePageViewData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data.greeting,
            style: AppTextStyles.body.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.82),
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.ownerName,
            style: AppTextStyles.pageTitle.copyWith(
              color: AppColors.onPrimary,
              fontSize: 30,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.ownerRegion,
            style: AppTextStyles.pageDescription.copyWith(
              color: AppColors.onPrimary.withValues(alpha: 0.84),
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.onPrimary.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: AppColors.onPrimary.withValues(alpha: 0.18)),
            ),
            child: Text(
              data.highlightLabel,
              style: AppTextStyles.link.copyWith(
                color: AppColors.onPrimary,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}