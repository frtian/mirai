import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/presentation/controllers/location_permission_provider.dart';

/// Dialog widget that requests location permission from user
///
/// Shows when location permission is not granted
/// Provides "Permitir" button to request permission and "Cancelar" to dismiss
class LocationPermissionDialog extends ConsumerWidget {
  /// Callback when permission is granted
  final VoidCallback? onPermissionGranted;

  /// Callback when permission is denied
  final VoidCallback? onPermissionDenied;

  /// Callback when permission is permanently denied
  final VoidCallback? onPermissionDeniedForever;

  const LocationPermissionDialog({
    super.key,
    this.onPermissionGranted,
    this.onPermissionDenied,
    this.onPermissionDeniedForever,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AlertDialog(
      title: const Text(
        'Localização Necessária',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      content: const SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Esta aplicação precisa de permissão para acessar sua localização em tempo real.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            SizedBox(height: 16),
            Text(
              'Usaremos sua localização para:',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.only(left: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Guiar você até pontos de captura'),
                  Text('• Calcular distância e direção em tempo real'),
                  Text('• Fornecer instruções de navegação precisas'),
                ],
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Sua privacidade é importante. A localização é usada apenas durante a navegação.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            onPermissionDenied?.call();
          },
          child: const Text('Cancelar'),
        ),
        Consumer(
          builder: (context, ref, _) {
            final requestState = ref.watch(requestLocationPermissionProvider);

            return requestState.when(
              loading: () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
              data: (_) {
                // If we get here, permission was granted
                Future.microtask(() {
                  Navigator.of(context).pop();
                  onPermissionGranted?.call();
                });
                return const SizedBox.shrink();
              },
              error: (error, stackTrace) {
                // Handle error on next frame to avoid build context issues
                Future.microtask(() {
                  if (error.toString().contains('permanently denied')) {
                    Navigator.of(context).pop();
                    onPermissionDeniedForever?.call();
                  } else {
                    // Show error and allow retry
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Erro: ${error.toString()}'),
                        duration: Duration(seconds: 3),
                      ),
                    );
                  }
                });
                return ElevatedButton(
                  onPressed: () =>
                      ref.refresh(requestLocationPermissionProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Permitir'),
                );
              },
            );
          },
        ),
      ],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: Colors.white,
    );
  }
}
