import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_target_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_instruction_entity.dart';
import '../controllers/geolocation_provider.dart';
import '../controllers/navigation_target_provider.dart';
import '../controllers/navigation_calculation_provider.dart';
import '../controllers/navigation_instruction_provider.dart';

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
class NavigationPage extends ConsumerWidget {
  const NavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the location stream
    final locationAsync = ref.watch(geolocationStreamProvider);
    // Watch the navigation target
    final targetAsync = ref.watch(navigationTargetProvider);
    // Watch the calculation (bearing and distance)
    final calculationAsync = ref.watch(navigationCalculationProvider);
    // Watch the instruction
    final instructionAsync = ref.watch(navigationInstructionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Navegação'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Current Location Section
              _CurrentLocationSection(locationAsync: locationAsync),
              const SizedBox(height: 24),

              // Target Information Section
              _TargetInfoSection(targetAsync: targetAsync),
              const SizedBox(height: 24),

              // Navigation Calculation Section
              _NavigationCalculationSection(calculationAsync: calculationAsync),
              const SizedBox(height: 24),

              // Voice Instruction Section
              _VoiceInstructionSection(instructionAsync: instructionAsync),
              const SizedBox(height: 32),

              // Action Button
              ElevatedButton(
                onPressed: () => context.pushNamed('camera'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
      ),
    );
  }
}

/// Widget that displays current location information
class _CurrentLocationSection extends StatelessWidget {
  final AsyncValue<LocationEntity> locationAsync;

  const _CurrentLocationSection({required this.locationAsync});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Localização Atual',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            locationAsync.when(
              data: (location) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(
                    label: 'Latitude',
                    value: location.latitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Longitude',
                    value: location.longitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Precisão',
                    value: '${(location.accuracy ?? 0).toStringAsFixed(1)} m',
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Timestamp',
                    value: location.timestamp.toString().split('.')[0],
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erro ao obter localização',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        error.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays target information
class _TargetInfoSection extends StatelessWidget {
  final AsyncValue<NavigationTargetEntity> targetAsync;

  const _TargetInfoSection({required this.targetAsync});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alvo de Navegação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            targetAsync.when(
              data: (target) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoRow(label: 'Nome', value: target.name),
                  const SizedBox(height: 8),
                  Text(
                    target.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Latitude',
                    value: target.latitude.toStringAsFixed(6),
                  ),
                  const SizedBox(height: 8),
                  _InfoRow(
                    label: 'Longitude',
                    value: target.longitude.toStringAsFixed(6),
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erro ao carregar alvo',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays navigation calculations (bearing and distance)
class _NavigationCalculationSection extends StatelessWidget {
  final AsyncValue<({double bearing, double distance})> calculationAsync;

  const _NavigationCalculationSection({required this.calculationAsync});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cálculos de Navegação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            calculationAsync.when(
              data: (calculation) => Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bearing',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${calculation.bearing.toStringAsFixed(1)}°',
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Distância',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          calculation.distance < 1000
                              ? '${calculation.distance.toStringAsFixed(0)} m'
                              : '${(calculation.distance / 1000).toStringAsFixed(2)} km',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erro ao calcular',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget that displays voice instruction
class _VoiceInstructionSection extends StatelessWidget {
  final AsyncValue<NavigationInstructionEntity> instructionAsync;

  const _VoiceInstructionSection({required this.instructionAsync});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      color: Colors.amber[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instrução de Navegação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            instructionAsync.when(
              data: (instruction) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amber[200]!, width: 1),
                    ),
                    child: Text(
                      instruction.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _InfoRow(
                    label: 'Tipo',
                    value: instruction.instructionType.name,
                  ),
                ],
              ),
              loading: () => const Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
              error: (error, stack) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: Colors.red,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Erro ao gerar instrução',
                        style: TextStyle(
                          color: Colors.red[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget to display key-value information
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
