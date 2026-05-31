import 'package:flutter/material.dart';
import '../../../../design_system/app_colors.dart';
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
    return ElevatedButton(
      onPressed: controller.isSubmitting ? null : onSubmit,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
      ),
      child: controller.isSubmitting
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.onPrimary,
              ),
            )
          : const Text(
              'ENTRAR',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
    );
  }
}
