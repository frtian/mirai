import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_text_styles.dart';
import '../controller/auth_page_contrller.dart';

class AuthPageActionsWidget extends StatelessWidget {
  const AuthPageActionsWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final AuthPageContrller controller;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primarySoft,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text('Esqueci meu código'),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 48,
          child: FilledButton(
            onPressed: controller.isSubmitting ? null : onSubmit,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: controller.isSubmitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.onPrimary),
                  )
                : const Text('Entrar', style: AppTextStyles.action),
          ),
        ),
        if (controller.submissionError != null) ...[
          const SizedBox(height: 12),
          Text(
            controller.submissionError!,
            textAlign: TextAlign.center,
            style: AppTextStyles.body.copyWith(color: Colors.redAccent),
          ),
        ],
        const SizedBox(height: 16),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Não possui conta? ', style: TextStyle(color: AppColors.bodyStrong, fontSize: 14)),
            Text('Solicitar Acesso', style: AppTextStyles.link),
          ],
        ),
      ],
    );
  }
}