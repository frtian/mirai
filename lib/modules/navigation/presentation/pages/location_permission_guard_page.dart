import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/presentation/controllers/location_permission_provider.dart';
import 'package:mirai/modules/navigation/presentation/widgets/location_permission_dialog.dart';
import 'package:mirai/modules/navigation/presentation/widgets/location_service_dialog.dart';

/// Guard page that orchestrates location permission and service checks
///
/// Shows appropriate dialogs based on permission/service status:
/// - If permission not granted: shows LocationPermissionDialog
/// - If permission granted but service disabled: shows LocationServiceDialog
/// - If both OK: calls onLocationReady callback or navigates to navigation page
///
/// Must be wrapped with ConsumerWidget to use Riverpod
class LocationPermissionGuardPage extends ConsumerStatefulWidget {
  /// Widget to show when location is ready (permission + service enabled)
  /// If null, will navigate back with success result
  final Widget? navigationPage;

  /// Callback when location is fully ready
  final VoidCallback? onLocationReady;

  const LocationPermissionGuardPage({
    super.key,
    this.navigationPage,
    this.onLocationReady,
  });

  @override
  ConsumerState<LocationPermissionGuardPage> createState() =>
      _LocationPermissionGuardPageState();
}

class _LocationPermissionGuardPageState
    extends ConsumerState<LocationPermissionGuardPage> {
  /// Current guard stage
  late _GuardStage _currentStage;

  @override
  void initState() {
    super.initState();
    _currentStage = _GuardStage.checkingPermission;
    _checkLocationStatus();
  }

  /// Check location permission and service status
  Future<void> _checkLocationStatus() async {
    if (!mounted) return;

    try {
      final permission = await ref.read(locationPermissionProvider.future);
      final serviceStatus = await ref.read(
        locationServiceStatusProvider.future,
      );

      if (!mounted) return;

      setState(() {
        if (!permission.isGranted) {
          _currentStage = _GuardStage.requestingPermission;
        } else if (!serviceStatus.isEnabled) {
          _currentStage = _GuardStage.requestingService;
        } else {
          _currentStage = _GuardStage.ready;
        }
      });

      // If already ready, proceed
      if (_currentStage == _GuardStage.ready) {
        _proceedToNavigation();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentStage = _GuardStage.error;
        });
      }
    }
  }

  /// Proceed to navigation page or call callback
  void _proceedToNavigation() {
    widget.onLocationReady?.call();

    if (widget.navigationPage != null) {
      // Navigate to provided navigation page
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.navigationPage!),
      );
    } else {
      // Go back with success result
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificando Localização'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(child: _buildContent()),
    );
  }

  /// Build content based on current guard stage
  Widget _buildContent() {
    switch (_currentStage) {
      case _GuardStage.checkingPermission:
        return _buildLoadingState('Verificando permissões...');

      case _GuardStage.requestingPermission:
        return _buildPermissionDialog();

      case _GuardStage.requestingService:
        return _buildServiceDialog();

      case _GuardStage.ready:
        return _buildReadyState();

      case _GuardStage.error:
        return _buildErrorState();
    }
  }

  /// Loading state UI
  Widget _buildLoadingState(String message) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        Text(message, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }

  /// Permission dialog
  Widget _buildPermissionDialog() {
    return LocationPermissionDialog(
      onPermissionGranted: () {
        setState(() {
          _currentStage = _GuardStage.checkingPermission;
        });
        _checkLocationStatus();
      },
      onPermissionDenied: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Permissão de localização necessária'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _currentStage = _GuardStage.checkingPermission;
        });
        _checkLocationStatus();
      },
      onPermissionDeniedForever: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Permissão permanentemente negada. Ative nas configurações do app.',
            ),
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop(false);
      },
    );
  }

  /// Service dialog
  Widget _buildServiceDialog() {
    return LocationServiceDialog(
      onServiceEnabled: () {
        setState(() {
          _currentStage = _GuardStage.ready;
        });
        _proceedToNavigation();
      },
      onServiceDisabled: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Serviço de localização necessário'),
            duration: Duration(seconds: 2),
          ),
        );
        setState(() {
          _currentStage = _GuardStage.checkingPermission;
        });
        _checkLocationStatus();
      },
    );
  }

  /// Ready state UI
  Widget _buildReadyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.check_circle, size: 40, color: Colors.green),
        ),
        const SizedBox(height: 20),
        Text(
          'Localização Ativada',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text(
          'Preparando para navegar...',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// Error state UI
  Widget _buildErrorState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.red.shade100,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.error_outline, size: 40, color: Colors.red),
        ),
        const SizedBox(height: 20),
        Text(
          'Erro ao Verificar Localização',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Text('Tente novamente', style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            setState(() {
              _currentStage = _GuardStage.checkingPermission;
            });
            _checkLocationStatus();
          },
          child: const Text('Tentar Novamente'),
        ),
      ],
    );
  }
}

/// Stages of location permission and service guard
enum _GuardStage {
  /// Initial stage: checking permission and service status
  checkingPermission,

  /// Permission not granted: showing permission dialog
  requestingPermission,

  /// Permission granted but service disabled: showing service dialog
  requestingService,

  /// Both permission and service are ready
  ready,

  /// Error occurred during checks
  error,
}
