/// Navigation Module - Presentation Layer Usage Examples
///
/// This file demonstrates how to use the Riverpod providers
/// from the presentation layer.

// ============================================================================
// EXAMPLE 1: Basic Navigation Page Usage
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/geolocation_provider.dart';
import 'controllers/navigation_target_provider.dart';
import 'controllers/navigation_calculation_provider.dart';
import 'controllers/navigation_instruction_provider.dart';

class SimpleNavigationPage extends ConsumerWidget {
  const SimpleNavigationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch all providers
    final location = ref.watch(geolocationStreamProvider);
    final target = ref.watch(navigationTargetProvider);
    final calculation = ref.watch(navigationCalculationProvider);
    final instruction = ref.watch(navigationInstructionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Navigation')),
      body: location.when(
        data: (loc) => Column(
          children: [
            Text('Current: ${loc.latitude}, ${loc.longitude}'),
            target.when(
              data: (t) => Text('Target: ${t.name}'),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            ),
            calculation.when(
              data: (calc) => Text(
                'Bearing: ${calc.bearing.toStringAsFixed(1)}° '
                'Distance: ${(calc.distance / 1000).toStringAsFixed(2)} km',
              ),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => Text('Error: $e'),
            ),
          ],
        ),
        loading: () => const CircularProgressIndicator(),
        error: (e, st) => Text('Location Error: $e'),
      ),
    );
  }
}
*/

// ============================================================================
// EXAMPLE 2: Using Individual Providers
// ============================================================================

/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/geolocation_provider.dart';

class LocationOnly extends ConsumerWidget {
  const LocationOnly({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Just watch location stream
    final location = ref.watch(geolocationStreamProvider);

    return location.when(
      data: (loc) => Column(
        children: [
          Text('Latitude: ${loc.latitude}'),
          Text('Longitude: ${loc.longitude}'),
          Text('Accuracy: ${loc.accuracy} m'),
          Text('Timestamp: ${loc.timestamp}'),
        ],
      ),
      loading: () => const Text('Getting location...'),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
*/

// ============================================================================
// EXAMPLE 3: Using Bearing Provider Only
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/navigation_calculation_provider.dart';

class BearingCompass extends ConsumerWidget {
  const BearingCompass({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bearing = ref.watch(bearingProvider);

    return bearing.when(
      data: (b) => Transform.rotate(
        angle: (b * 3.14159) / 180, // Convert to radians
        child: const Icon(Icons.arrow_upward, size: 64),
      ),
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => Text('Error: $e'),
    );
  }
}
*/

// ============================================================================
// EXAMPLE 4: Switching Between Targets
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/navigation_target_provider.dart';

class TargetSelector extends ConsumerWidget {
  const TargetSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use .family to fetch different targets
    final target1 = ref.watch(navigationTargetByIdProvider('target_001'));
    final target2 = ref.watch(navigationTargetByIdProvider('target_002'));

    return Column(
      children: [
        target1.when(
          data: (t) => Text('Target 1: ${t.name}'),
          loading: () => const Text('Loading...'),
          error: (e, st) => Text('Error: $e'),
        ),
        target2.when(
          data: (t) => Text('Target 2: ${t.name}'),
          loading: () => const Text('Loading...'),
          error: (e, st) => Text('Error: $e'),
        ),
      ],
    );
  }
}
*/

// ============================================================================
// EXAMPLE 5: Error Handling
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/navigation_instruction_provider.dart';

class InstructionWithErrorHandling extends ConsumerWidget {
  const InstructionWithErrorHandling({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final instruction = ref.watch(navigationInstructionProvider);

    return instruction.when(
      data: (instr) => Column(
        children: [
          const Text('Instruction:'),
          Text(instr.text),
          const SizedBox(height: 8),
          Text('Type: ${instr.instructionType.name}'),
        ],
      ),
      loading: () => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Generating instruction...'),
          ],
        ),
      ),
      error: (error, stackTrace) {
        String errorMessage = 'Unknown error';

        if (error is NavigationInstructionException) {
          errorMessage = error.message;
        } else {
          errorMessage = error.toString();
        }

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              Text('Error: $errorMessage'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Manual refresh by invalidating provider
                  ref.invalidate(navigationInstructionProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        );
      },
    );
  }
}
*/

// ============================================================================
// EXAMPLE 6: Combined Widget with All Information
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/geolocation_provider.dart';
import 'controllers/navigation_target_provider.dart';
import 'controllers/navigation_calculation_provider.dart';
import 'controllers/navigation_instruction_provider.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_instruction_entity.dart';

class FullNavigationDashboard extends ConsumerWidget {
  const FullNavigationDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(geolocationStreamProvider);
    final target = ref.watch(navigationTargetProvider);
    final calculation = ref.watch(navigationCalculationProvider);
    final instruction = ref.watch(navigationInstructionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Navigation Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 16,
          children: [
            // Location Card
            _buildLocationCard(location),

            // Target Card
            _buildTargetCard(target),

            // Compass & Distance
            calculation.when(
              data: (calc) => _buildCompassWidget(calc),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => const Text('Error calculating'),
            ),

            // Instruction Card
            instruction.when(
              data: (instr) => _buildInstructionCard(instr),
              loading: () => const CircularProgressIndicator(),
              error: (e, st) => const Text('Error generating instruction'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationCard(AsyncValue<LocationEntity> locationAsync) {
    return Card(
      child: locationAsync.when(
        data: (loc) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Current Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Lat: ${loc.latitude.toStringAsFixed(4)}'),
              Text('Lng: ${loc.longitude.toStringAsFixed(4)}'),
              Text('Accuracy: ${loc.accuracy?.toStringAsFixed(1) ?? 'N/A'} m'),
            ],
          ),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
        error: (e, st) => const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Error loading location'),
        ),
      ),
    );
  }

  Widget _buildTargetCard(AsyncValue<NavigationTargetEntity> targetAsync) {
    return Card(
      child: targetAsync.when(
        data: (target) => Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Target', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Name: ${target.name}'),
              Text('Description: ${target.description}'),
              Text('Lat: ${target.latitude.toStringAsFixed(4)}'),
              Text('Lng: ${target.longitude.toStringAsFixed(4)}'),
            ],
          ),
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(16),
          child: CircularProgressIndicator(),
        ),
        error: (e, st) => const Padding(
          padding: EdgeInsets.all(16),
          child: Text('Error loading target'),
        ),
      ),
    );
  }

  Widget _buildCompassWidget(({double bearing, double distance}) calc) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                const Text('Bearing'),
                Text(
                  '${calc.bearing.toStringAsFixed(1)}°',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            Column(
              children: [
                const Text('Distance'),
                Text(
                  calc.distance < 1000
                      ? '${calc.distance.toStringAsFixed(0)} m'
                      : '${(calc.distance / 1000).toStringAsFixed(2)} km',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionCard(NavigationInstructionEntity instruction) {
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Instruction', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              instruction.text,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            Chip(label: Text(instruction.instructionType.name)),
          ],
        ),
      ),
    );
  }
}

import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_target_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_instruction_entity.dart';
*/

// ============================================================================
// EXAMPLE 7: Invalidating and Refreshing Providers
// ============================================================================

/*
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'controllers/navigation_target_provider.dart';
import 'controllers/navigation_instruction_provider.dart';

class RefreshExample extends ConsumerWidget {
  const RefreshExample({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
      onPressed: () {
        // Invalidate to force re-fetch
        ref.invalidate(navigationTargetProvider);

        // This will also invalidate dependent providers
        ref.invalidate(navigationInstructionProvider);
      },
      child: const Text('Refresh Navigation'),
    );
  }
}
*/

// ============================================================================
// EXAMPLE 8: Using instruction stream for voice guidance
// ============================================================================

/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'controllers/navigation_instruction_provider.dart';

class VoiceNavigationWidget extends ConsumerWidget {
  const VoiceNavigationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Use stream for continuous voice updates
    final instructionStream = ref.watch(navigationInstructionStreamProvider);
    final flutterTts = FlutterTts();

    return instructionStream.when(
      data: (instruction) {
        // Speak instruction
        flutterTts.speak(instruction.text);

        return Column(
          children: [
            const Icon(Icons.volume_up, size: 48),
            const SizedBox(height: 16),
            Text(instruction.text),
          ],
        );
      },
      loading: () => const CircularProgressIndicator(),
      error: (e, st) => const Text('Voice guidance unavailable'),
    );
  }
}
*/

// ============================================================================
// Summary of Provider Usage Patterns
// ============================================================================

/*
PATTERN 1: Watch single provider
  final data = ref.watch(provider);

PATTERN 2: Watch multiple providers
  final data1 = ref.watch(provider1);
  final data2 = ref.watch(provider2);

PATTERN 3: Handle AsyncValue
  data.when(
    data: (value) => successWidget,
    loading: () => loadingWidget,
    error: (e, st) => errorWidget,
  )

PATTERN 4: Use .family for parameterized providers
  final data = ref.watch(providerFamily(parameter));

PATTERN 5: Invalidate (force refresh)
  ref.invalidate(provider);

PATTERN 6: Access future value directly
  final value = await ref.watch(futureProvider.future);

PATTERN 7: Select specific part of async value
  final isLoading = data.isLoading;
  final hasError = data.hasError;
  final hasValue = data.hasValue;

PATTERN 8: Combine multiple providers
  final combined = ref.watch(provider1).when(
    data: (d1) => ref.watch(provider2).when(
      data: (d2) => processData(d1, d2),
      ...
    ),
    ...
  )
*/
