import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_text_styles.dart';
import '../controller/home_page_controller.dart';

class HomePagePropertiesWidget extends StatelessWidget {
  const HomePagePropertiesWidget({
    super.key,
    required this.properties,
  });

  final List<HomePropertyCardData> properties;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Propriedades vinculadas', style: AppTextStyles.appBarTitle),
        const SizedBox(height: 14),
        ...properties.map((property) => _HomePropertyCard(property: property)),
      ],
    );
  }
}

class _HomePropertyCard extends StatelessWidget {
  const _HomePropertyCard({required this.property});

  final HomePropertyCardData property;

  @override
  Widget build(BuildContext context) {
    final alertLabel = property.alertCount == 0
        ? 'Sem alertas'
        : '${property.alertCount} alertas ativos';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(property.name, style: AppTextStyles.link.copyWith(color: AppColors.headline, fontSize: 16)),
                    const SizedBox(height: 6),
                    Text(property.location, style: AppTextStyles.body),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.inputFill,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(property.areaLabel, style: AppTextStyles.sectionLabel),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(property.statusLabel, style: AppTextStyles.footerText.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: property.progressValue,
              backgroundColor: AppColors.inputFill,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primarySoft),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: Text(property.progressLabel, style: AppTextStyles.body)),
              Text(alertLabel, style: AppTextStyles.body.copyWith(color: AppColors.bodyStrong)),
            ],
          ),
        ],
      ),
    );
  }
}