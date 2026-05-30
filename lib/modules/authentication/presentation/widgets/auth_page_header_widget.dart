import 'package:flutter/material.dart';

import '../../../../design_system/app_text_styles.dart';

class AuthPageHeaderWidget extends StatelessWidget {
  const AuthPageHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('MIRAI', style: AppTextStyles.brand),
        SizedBox(height: 22),
        Text('Monitoramento Ambiental', textAlign: TextAlign.center, style: AppTextStyles.pageTitle),
        SizedBox(height: 8),
        Text(
          'Acesse sua conta para monitorar suas\npropriedades.',
          textAlign: TextAlign.center,
          style: AppTextStyles.pageDescription,
        ),
      ],
    );
  }
}