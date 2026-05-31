import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_instruction_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_target_entity.dart';
import 'package:mirai/modules/navigation/presentation/widgets/navigation_compass_widget.dart';
import '../controllers/geolocation_provider.dart';
import '../controllers/navigation_calculation_provider.dart';
import '../controllers/navigation_instruction_provider.dart';
import '../controllers/navigation_target_provider.dart';

/// Main navigation page using Riverpod providers
///
/// Displays:
/// - Current location (latitude, longitude)
/// - Navigation target information
/// - Distance to target
/// - Bearing to target
/// - Voice instruction
///
/// All data flows through composable Riverpod providers that handle
/// location streaming, calculations, and instruction generation.
class NavigationPage extends ConsumerStatefulWidget {
  const NavigationPage({super.key});

  @override
  ConsumerState<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends ConsumerState<NavigationPage> {
  final NavigationCompassController _compassController = NavigationCompassController();
  ({double bearing, double distance})? _lastCalculation;
  NavigationInstructionEntity? _lastInstruction;
  NavigationTargetEntity? _lastTarget;
  LocationEntity? _lastLocation;
  bool _listenersInitialized = false;

  @override
  Widget build(BuildContext context) {
    if (!_listenersInitialized) {
      _listenersInitialized = true;

      ref.listen(navigationCalculationProvider, (previous, next) {
        final value = next.asData?.value;
        if (value != null && mounted) {
          setState(() {
            _lastCalculation = value;
          });
          // Update the Flame game directly for smooth, immediate rotation without
          // rebuilding the entire widget tree.
          _compassController.setBearing(value.bearing);
        }
      });

      ref.listen(navigationInstructionStreamProvider, (previous, next) {
        final value = next.asData?.value;
        if (value != null && mounted) {
          setState(() {
            _lastInstruction = value;
          });
        }
      });

      ref.listen(navigationTargetProvider, (previous, next) {
        final value = next.asData?.value;
        if (value != null && mounted) {
          setState(() {
            _lastTarget = value;
          });
        }
      });

      ref.listen(geolocationStreamProvider, (previous, next) {
        final value = next.asData?.value;
        if (value != null && mounted) {
          setState(() {
            _lastLocation = value;
          });
        }
      });
    }

    final calculationAsync = ref.watch(navigationCalculationProvider);
    final instructionAsync = ref.watch(navigationInstructionStreamProvider);
    final targetAsync = ref.watch(navigationTargetProvider);
    final locationAsync = ref.watch(geolocationStreamProvider);

    final calculationValue = calculationAsync.asData?.value ?? _lastCalculation;
    final instructionValue = instructionAsync.asData?.value ?? _lastInstruction;
    final targetValue = targetAsync.asData?.value ?? _lastTarget;
    final locationValue = locationAsync.asData?.value ?? _lastLocation;

    return Scaffold(
      appBar: AppBar(title: const Text('Navegação'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: _CompassCard(
                calculation: calculationValue,
                target: targetValue,
                location: locationValue,
              ),
            ),
            const SizedBox(height: 20),
            _InstructionPanel(instruction: instructionValue),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.pushNamed('camera'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0F766E),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('Capturar Evidência'),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstructionPanel extends StatelessWidget {
  final NavigationInstructionEntity? instruction;

  const _InstructionPanel({required this.instruction});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        instruction?.text ?? 'Aguardando direção...',
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CompassCard extends StatelessWidget {
  final ({double bearing, double distance})? calculation;
  final NavigationTargetEntity? target;
  final LocationEntity? location;

  const _CompassCard({
    required this.calculation,
    required this.target,
    required this.location,
  });

  @override
  Widget build(BuildContext context) {
    final distanceLabel = calculation == null
        ? '--|metros'
        : _distanceLabel(calculation!.distance);
    final bearing = calculation?.bearing ?? 0;
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
          _DistanceHeader(distanceLabel: distanceLabel),
          const SizedBox(height: 14),
          Center(
            child: SizedBox(
              height: 180,
              width: 180,
              child: NavigationCompass(bearing: bearing, controller: _compassController),
            ),
          ),
          const SizedBox(height: 14),
          _TargetName(target: target),
          const SizedBox(height: 8),
          _AccuracyChip(location: location),
        ],
      ),
    );
  }
}

class _DistanceHeader extends StatelessWidget {
  final String distanceLabel;

  const _DistanceHeader({required this.distanceLabel});

  @override
  Widget build(BuildContext context) {
    final parts = distanceLabel.split('|');
    final value = parts.first;
    final unit = parts.last;

    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
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
}

class _TargetName extends StatelessWidget {
  final NavigationTargetEntity? target;

  const _TargetName({required this.target});

  @override
  Widget build(BuildContext context) {
    final label = target?.name ?? 'Carregando ponto...';
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }
}

class _AccuracyChip extends StatelessWidget {
  final LocationEntity? location;

  const _AccuracyChip({required this.location});

  @override
  Widget build(BuildContext context) {
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
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

String _distanceLabel(double distance) {
  if (distance < 1000) {
    return '${distance.toStringAsFixed(0)}|metros';
  }
  final km = distance / 1000;
  return '${km.toStringAsFixed(1)}|km';
}

class _NavigationErrorState extends StatelessWidget {
  final String message;
  final String details;

  const _NavigationErrorState({
    required this.message,
    required this.details,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            message,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            details,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
