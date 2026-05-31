import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mirai/design_system/app_colors.dart';
import 'package:mirai/modules/navigation/domain/entities/location_permission_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_status_entity.dart';
import 'package:mirai/modules/navigation/presentation/widgets/navigation_map_widget.dart';
import 'package:mirai/modules/navigation/presentation/widgets/location_permission_dialog.dart';
import 'package:mirai/modules/navigation/presentation/widgets/location_service_dialog.dart';

import '../controllers/location_permission_provider.dart';
import '../controllers/geolocation_provider.dart';
import '../controllers/navigation_calculation_provider.dart';
import '../controllers/navigation_instruction_provider.dart';
import '../controllers/navigation_target_provider.dart';

class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  bool _permissionDialogShown = false;
  bool _serviceDialogShown = false;
  bool _ensuringLocation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _ensureLocationAccess(),
    );
  }

  Future<void> _ensureLocationAccess() async {
    if (_ensuringLocation) return;
    _ensuringLocation = true;

    try {
      LocationPermissionEntity? permission;
      try {
        permission = await ref.read(locationPermissionProvider.future);
      } catch (_) {
        permission = null;
      }

      LocationServiceStatusEntity? serviceStatus;
      try {
        serviceStatus = await ref.read(locationServiceStatusProvider.future);
      } catch (_) {
        serviceStatus = null;
      }

      final hasPermission = permission?.isGranted ?? false;
      final serviceEnabled = serviceStatus?.isEnabled ?? false;

      if (!hasPermission && !_permissionDialogShown) {
        _permissionDialogShown = true;
        if (!mounted) return;
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (context) => LocationPermissionDialog(
            onPermissionGranted: () async {
              ref.invalidate(geolocationStreamProvider);
              ref.invalidate(navigationCalculationProvider);
              if (mounted) setState(() {});
            },
            onPermissionDenied: () {
              _permissionDialogShown = false;
              _ensureLocationAccess();
            },
            onPermissionDeniedForever: () {
              _permissionDialogShown = false;
            },
          ),
        );
      }

      if (hasPermission && !serviceEnabled && !_serviceDialogShown) {
        _serviceDialogShown = true;
        if (!mounted) return;
        final result = await showDialog<String>(
          context: context,
          barrierDismissible: false,
          builder: (context) => LocationServiceDialog(onServiceDisabled: () {}),
        );

        if (result == 'success') {
          ref.invalidate(geolocationStreamProvider);
          ref.invalidate(navigationCalculationProvider);
          if (mounted) setState(() {});
        }
        _serviceDialogShown = false;
      }
    } catch (e) {
      // Ignora erros — providers reportarão na UI
    } finally {
      _ensuringLocation = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Navegação'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Expanded(child: _CompassCard()),
            const SizedBox(height: 16),
            const _MapLegendPanel(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.pushNamed('camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Capturar Evidência',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapLegendPanel extends StatelessWidget {
  const _MapLegendPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _LegendItem(
            icon: Icons.my_location,
            color: Colors.blue,
            label: 'Você',
          ),
          Container(width: 1, height: 20, color: Colors.white24),
          _LegendItem(
            icon: Icons.location_on,
            color: Colors.red,
            label: 'Destino',
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;

  const _LegendItem({
    required this.icon,
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}

class _CompassCard extends StatelessWidget {
  const _CompassCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const _DistanceHeader(),
          const SizedBox(height: 14),
          Expanded(
            child: Stack(
              children: [
                const ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  child: NavigationMap(),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _RealtimeCompassOverlay(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          const _TargetName(),
          const SizedBox(height: 8),
          const _AccuracyChip(),
        ],
      ),
    );
  }
}

class _RealtimeCompassOverlay extends ConsumerWidget {
  const _RealtimeCompassOverlay();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usamos o bearingProvider que já considera a rotação do sensor
    final bearing = ref.watch(bearingProvider).value ?? 0.0;

    return Container(
      width: 70, // Um pouco maior para clareza
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Círculo decorativo de fundo
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            ),
          ),
          // Bússola animada
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: bearing),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Transform.rotate(
                angle: (value * (math.pi / 180)),
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Corpo da bússola (Seta Norte/Sul mas com Norte destacado)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Norte (Triângulo Vermelho)
                    _CompassPointer(color: Colors.red, isNorth: true),
                    // Sul (Triângulo Cinza)
                    _CompassPointer(
                      color: Colors.grey.shade400,
                      isNorth: false,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CompassPointer extends StatelessWidget {
  final Color color;
  final bool isNorth;

  const _CompassPointer({required this.color, required this.isNorth});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(18, 22),
      painter: _TrianglePainter(color: color, isNorth: isNorth),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final bool isNorth;

  _TrianglePainter({required this.color, required this.isNorth});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    if (isNorth) {
      path.moveTo(size.width / 2, 0);
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
    } else {
      path.moveTo(size.width / 2, size.height);
      path.lineTo(size.width, 0);
      path.lineTo(0, 0);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DistanceHeader extends ConsumerWidget {
  const _DistanceHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usando .value para reter a distância antiga durante o milissegundo de recarregamento
    final distance = ref.watch(navigationCalculationProvider).value?.distance;

    final distanceLabel = distance == null
        ? '--|metros'
        : _distanceLabel(distance);
    final parts = distanceLabel.split('|');
    final value = parts.first;
    final unit = parts.last;

    return Column(
      children: [
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w700),
        ),
        Text(
          unit,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  String _distanceLabel(double distance) {
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)}|metros';
    }
    final km = distance / 1000;
    return '${km.toStringAsFixed(1)}|km';
  }
}

class _TargetName extends ConsumerWidget {
  const _TargetName();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Aplicando .value aqui também
    final target = ref.watch(navigationTargetProvider).value;
    final label = target?.name ?? 'Carregando ponto...';

    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      textAlign: TextAlign.center,
    );
  }
}

class _AccuracyChip extends ConsumerWidget {
  const _AccuracyChip();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Aplicando .value aqui também
    final location = ref.watch(geolocationStreamProvider).value;
    final accuracy = location?.accuracy;

    final label = accuracy == null
        ? 'Precisão GPS: --'
        : 'Precisão GPS: ${accuracy.toStringAsFixed(0)} m';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F7FB),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFFB8860B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
