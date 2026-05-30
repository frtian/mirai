import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/presentation/controllers/location_permission_provider.dart';

/// Dialog widget that requests user to enable location service
///
/// Shows when location permission is granted but GPS service is disabled
/// Uses 'location' package to show native Android dialog without leaving app
/// Monitors when user enables GPS and closes dialog automatically
class LocationServiceDialog extends ConsumerStatefulWidget {
  /// Callback when location service is enabled
  final VoidCallback? onServiceEnabled;

  /// Callback when user cancels or dialog times out
  final VoidCallback? onServiceDisabled;

  /// Maximum polling attempts before giving up (default: 30 = 60 seconds)
  final int maxPollingAttempts;

  /// Polling interval in seconds (default: 2 seconds)
  final int pollingIntervalSeconds;

  const LocationServiceDialog({
    super.key,
    this.onServiceEnabled,
    this.onServiceDisabled,
    this.maxPollingAttempts = 30,
    this.pollingIntervalSeconds = 2,
  });

  @override
  ConsumerState<LocationServiceDialog> createState() =>
      _LocationServiceDialogState();
}

class _LocationServiceDialogState extends ConsumerState<LocationServiceDialog> {
  bool _isWaitingForService = false;

  @override
  Widget build(BuildContext context) {
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
            // Large icon
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
            Navigator.of(context).pop();
            widget.onServiceDisabled?.call();
          },
          child: const Text('Cancelar'),
        ),
        Consumer(
          builder: (context, ref, _) {
            final requestState = ref.watch(requestLocationServiceProvider);

            return requestState.when(
              loading: () {
                // While waiting for native dialog response
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    ),
                  ),
                );
              },
              data: (enabled) {
                // Service was enabled or user closed dialog
                if (enabled && !_isWaitingForService) {
                  _isWaitingForService = true;
                  // Start polling to verify service is enabled
                  Future.microtask(() => _startServicePolling(ref));
                }

                if (enabled) {
                  return const SizedBox.shrink();
                }

                // User cancelled the native dialog
                Future.microtask(() {
                  if (mounted) {
                    Navigator.of(context).pop();
                    widget.onServiceDisabled?.call();
                  }
                });
                return const SizedBox.shrink();
              },
              error: (error, stackTrace) {
                return ElevatedButton(
                  onPressed: () => ref.refresh(requestLocationServiceProvider),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Tentar Novamente'),
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

  /// Start polling location service status
  ///
  /// Polls every 2 seconds to detect when user enables location service
  /// Automatically closes dialog when service is enabled
  void _startServicePolling(WidgetRef ref) {
    ref.listen(locationServiceStatusPollingProvider, (previous, next) {
      next.when(
        data: (status) {
          if (status.isEnabled && mounted) {
            _isWaitingForService = false;
            Navigator.of(context).pop();
            widget.onServiceEnabled?.call();
          }
        },
        error: (error, stackTrace) {
          // Polling stream ended without service being enabled
          if (mounted) {
            _isWaitingForService = false;
            Navigator.of(context).pop();
            widget.onServiceDisabled?.call();
          }
        },
        loading: () {
          // Polling in progress
        },
      );
    });
  }
}
