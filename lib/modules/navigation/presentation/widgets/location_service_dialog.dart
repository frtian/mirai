import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/presentation/controllers/location_permission_provider.dart';

class LocationServiceDialog extends ConsumerWidget {
  final VoidCallback? onServiceDisabled;

  const LocationServiceDialog({super.key, this.onServiceDisabled});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text(
        'Ativar Localização',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.location_off, size: 40, color: Colors.red),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Serviço de Localização Desativado',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Para guiá-lo até os pontos de captura, precisamos que você ative o serviço de localização do seu dispositivo.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'A caixa de diálogo nativa será aberta sem sair do aplicativo.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop('cancelled');
            onServiceDisabled?.call();
          },
          child: const Text('Cancelar'),
        ),
        Consumer(
          builder: (context, ref, _) {
            final requestState = ref.watch(requestLocationServiceProvider);

            return requestState.when(
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
              data: (enabled) {
                if (!enabled) {
                  Future.microtask(() {
                    if (context.mounted) {
                      Navigator.of(context).pop('cancelled');
                      onServiceDisabled?.call();
                    }
                  });
                  return const SizedBox.shrink();
                }
                Future.microtask(() {
                  if (context.mounted) {
                    Navigator.of(context).pop('success');
                  }
                });
                return const SizedBox.shrink();
              },
              error: (error, stackTrace) => ElevatedButton(
                onPressed: () => ref.refresh(requestLocationServiceProvider),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Tentar Novamente'),
              ),
            );
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
    );
  }
}
