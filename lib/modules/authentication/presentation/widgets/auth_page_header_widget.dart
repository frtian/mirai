import 'package:flutter/material.dart';
import '../../../../design_system/app_colors.dart';

class AuthPageHeaderWidget extends StatelessWidget {
  const AuthPageHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/images/logo.png',
          height: 100, // Reduzi um pouco a altura da logo também
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.eco,
            size: 80,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Acompanhamento Remoto de Áreas de Recuperação Ambiental',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
