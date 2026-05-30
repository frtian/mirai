import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/presentation/controllers/location_permission_provider.dart';
import 'package:mirai/modules/navigation/presentation/widgets/location_permission_dialog.dart';
import 'package:mirai/modules/navigation/presentation/widgets/location_service_dialog.dart';

class LocationPermissionGuardPage extends ConsumerStatefulWidget {
  final Widget? navigationPage;
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
  late _GuardStage _currentStage;
  bool _serviceDialogShown = false;
  int _retryCount = 0;
  static const int _maxRetries = 3;

  @override
  void initState() {
    super.initState();
    _currentStage = _GuardStage.checkingPermission;
    _checkLocationStatus();
  }

  Future<void> _checkLocationStatus() async {
    if (!mounted) return;

    try {
      ref.invalidate(locationPermissionProvider);
      ref.invalidate(locationServiceStatusProvider);

      final permission = await ref.read(locationPermissionProvider.future);
      final serviceStatus = await ref.read(
        locationServiceStatusProvider.future,
      );

      if (!mounted) return;

      _retryCount = 0;

      setState(() {
        if (!permission.isGranted) {
          _currentStage = _GuardStage.requestingPermission;
        } else if (!serviceStatus.isEnabled) {
          _currentStage = _GuardStage.requestingService;
          _serviceDialogShown = false;
        } else {
          _currentStage = _GuardStage.ready;
        }
      });

      if (_currentStage == _GuardStage.ready) {
        _proceedToNavigation();
      }
    } catch (e) {
      if (!mounted) return;

      if (_retryCount < _maxRetries) {
        _retryCount++;
        await Future.delayed(Duration(milliseconds: 500 * _retryCount));
        if (mounted) {
          _checkLocationStatus();
        }
      } else {
        setState(() {
          _currentStage = _GuardStage.checkingPermission;
        });
      }
    }
  }

  void _proceedToNavigation() {
    widget.onLocationReady?.call();

    if (widget.navigationPage != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => widget.navigationPage!),
      );
    } else {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _showServiceDialog() async {
    if (_serviceDialogShown) return;
    _serviceDialogShown = true;

    final result = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => LocationServiceDialog(
        onServiceDisabled: () {
          Navigator.of(context).pop('cancelled');
        },
      ),
    );

    if (!mounted) return;

    if (result == 'success') {
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        _retryCount = 0;
        _checkLocationStatus();
      }
    } else {
      _serviceDialogShown = false;
      if (mounted) {
        setState(() {
          _currentStage = _GuardStage.checkingPermission;
        });
        _retryCount = 0;
        _checkLocationStatus();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_currentStage == _GuardStage.requestingService &&
        !_serviceDialogShown) {
      Future.microtask(() => _showServiceDialog());
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificando Localização'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(child: _buildContent()),
    );
  }

  Widget _buildContent() {
    switch (_currentStage) {
      case _GuardStage.checkingPermission:
        return _buildLoadingState(
          _retryCount > 0
              ? 'Tentando novamente... ($_retryCount/$_maxRetries)'
              : 'Verificando permissões...',
        );
      case _GuardStage.requestingPermission:
        return _buildPermissionDialog();
      case _GuardStage.requestingService:
        return _buildLoadingState('Abrindo configurações...');
      case _GuardStage.ready:
        return _buildReadyState();
    }
  }

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

  Widget _buildPermissionDialog() {
    return LocationPermissionDialog(
      onPermissionGranted: () {
        _retryCount = 0;
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
        _retryCount = 0;
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
}

enum _GuardStage {
  checkingPermission,
  requestingPermission,
  requestingService,
  ready,
}
