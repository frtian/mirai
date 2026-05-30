import 'package:flutter/material.dart';

import '../../../../design_system/app_colors.dart';
import '../../../../design_system/app_text_styles.dart';
import '../../domain/entities/evidence.dart';
import '../../domain/entities/evidence_status.dart';

class CaptureSuccessPage extends StatelessWidget {
  const CaptureSuccessPage({super.key, required this.evidence});

  final Evidence evidence;

  @override
  Widget build(BuildContext context) {
    final isPendingSync = evidence.status == EvidenceStatus.pending;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text('Captura concluida', style: AppTextStyles.appBarTitle),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 66,
                      height: 66,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: AppColors.onPrimary,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Evidencia anexada com sucesso',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.appBarTitle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isPendingSync
                          ? 'Sua evidencia foi salva localmente e sera sincronizada quando a internet voltar.'
                          : 'Sua evidencia foi enviada e registrada no monitoramento.',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.pageDescription,
                    ),
                    const SizedBox(height: 18),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: AppColors.inputFill,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Ponto: ${evidence.capturePointId}',
                        style: AppTextStyles.inputHint,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text('Voltar para captura', style: AppTextStyles.action),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
