import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_text_styles.dart';

class AuthPageFooterWidget extends StatelessWidget {
  const AuthPageFooterWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Divider(color: AppColors.divider, thickness: 1),
        SizedBox(height: 18),
        Text(
          'Dados protegidos por criptografia de nível militar em\nconformidade com as normas ambientais vigentes.',
          textAlign: TextAlign.center,
          style: AppTextStyles.body,
        ),
        SizedBox(height: 24),
        Divider(color: AppColors.divider, thickness: 1),
        SizedBox(height: 18),
        Text('MIRAI', style: AppTextStyles.footerBrand),
        SizedBox(height: 12),
        Text('© 2026 SEMARH MIRAI. All rights reserved.', textAlign: TextAlign.center, style: AppTextStyles.footerText),
        SizedBox(height: 14),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 18,
          runSpacing: 8,
          children: [
            Text('Support', style: AppTextStyles.footerLink),
            Text('Privacy Policy', style: AppTextStyles.footerLink),
            Text('Terms of Service', style: AppTextStyles.footerLink),
          ],
        ),
      ],
    );
  }
}