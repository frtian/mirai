import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import '../../../../design_system/app_colors.dart';
import '../controller/auth_page_contrller.dart';

class AuthPageCodeFieldWidget extends StatelessWidget {
  const AuthPageCodeFieldWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
  });

  final AuthPageContrller controller;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 45,
      height: 50,
      textStyle: const TextStyle(
        fontSize: 20,
        color: AppColors.onSurface,
        fontWeight: FontWeight.bold,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.outlineVariant),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: AppColors.primary, width: 2),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Código de Acesso (OTP)',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 16),
        Pinput(
          length: 6,
          controller: controller.codeController,
          defaultPinTheme: defaultPinTheme,
          focusedPinTheme: focusedPinTheme,
          separatorBuilder: (index) => const SizedBox(width: 8),
          hapticFeedbackType: HapticFeedbackType.lightImpact,
          onCompleted: (pin) {
            controller.codeController.text = pin;
            onSubmitted();
          },
          onChanged: (pin) {
            controller.codeController.text = pin;
          },
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
