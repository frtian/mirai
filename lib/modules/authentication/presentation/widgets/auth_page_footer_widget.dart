import 'package:flutter/material.dart';
import '../../../../design_system/app_colors.dart';

class AuthPageFooterWidget extends StatelessWidget {
  const AuthPageFooterWidget({super.key});

  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suporte e Cadastro'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Para realizar seu cadastro ou obter ajuda com o acesso, entre em contato com a SEMARH:',
            ),
            const SizedBox(height: 16),
            const Text(
              'CAR: (63) 99936-0079',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const Text(
              'E-mail: car@semarh.to.gov.br',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'O código de acesso (OTP) é enviado para o seu dispositivo após a validação dos seus dados junto à secretaria.',
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('FECHAR'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextButton(
          onPressed: () => _showSupportDialog(context),
          child: const Text(
            'Precisa de ajuda ou não tem cadastro?',
            style: TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          'Arara 2026₢',
          style: TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
            letterSpacing: 1.1,
          ),
        ),
      ],
    );
  }
}
