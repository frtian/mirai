import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_text_styles.dart';
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
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Código de acesso', style: AppTextStyles.sectionLabel),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller.codeController,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => onSubmitted(),
            validator: controller.validateCode,
            style: AppTextStyles.inputHint,
            decoration: const InputDecoration(
              hintText: 'Digite o código recebido',
              hintStyle: AppTextStyles.inputHint,
              filled: true,
              fillColor: AppColors.inputFill,
              prefixIcon: Icon(Icons.lock_outline, color: AppColors.inputIcon),
              contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 16),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(color: AppColors.inputBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(color: AppColors.inputBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(color: AppColors.primary, width: 1.4),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(2)),
                borderSide: BorderSide(color: Colors.redAccent, width: 1.4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}