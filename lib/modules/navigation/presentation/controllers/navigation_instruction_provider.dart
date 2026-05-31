import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_instruction_entity.dart';
import 'navigation_calculation_provider.dart';

/// Provides navigation voice instructions
///
/// This [FutureProvider] generates human-readable voice instructions
/// based on the current bearing and distance to the target.
///
/// Instructions include:
/// - Cardinal direction (North, Northeast, East, etc.)
/// - Distance in a human-readable format (meters or kilometers)
/// - Guidance on whether to turn or continue straight
///
/// Depends on:
/// - [navigationCalculationProvider] for bearing and distance
///
/// Usage:
/// ```dart
/// final instruction = ref.watch(navigationInstructionProvider);
/// instruction.when(
///   data: (instr) => Text(instr.text),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final navigationInstructionProvider =
    FutureProvider.autoDispose<NavigationInstructionEntity>((ref) async {
      final calculation = await ref.watch(navigationCalculationProvider.future);
      final bearing = calculation.bearing;
      final distance = calculation.distance;

      // Generate instruction text based on bearing and distance
      final distanceText = _formatDistance(distance);

      // Determine instruction type based on bearing
      final instructionType = _getInstructionType(bearing);

      // Generate human-readable instruction
      final instructionText = _generateInstructionText(
        distanceText,
        instructionType,
      );

      return NavigationInstructionEntity(
        text: instructionText,
        distance: distance,
        bearing: bearing,
        instructionType: instructionType,
      );
    });

/// Provides navigation instruction with automatic refresh
///
/// This is similar to [navigationInstructionProvider] but refreshes
/// more frequently to provide up-to-date instructions as the user moves.
/// Use this for real-time navigation guidance.
///
/// The provider refreshes every 5 seconds or when location changes significantly.
final navigationInstructionStreamProvider =
    StreamProvider.autoDispose<NavigationInstructionEntity>((ref) async* {
      // Emit instruction updates every 5 seconds
      final stream = Stream.periodic(const Duration(seconds: 5));

      await for (final _ in stream) {
        try {
          final instruction = await ref.watch(
            navigationInstructionProvider.future,
          );
          yield instruction;
        } catch (e) {
          // Continue stream even on error - next iteration will retry
          continue;
        }
      }
    });

/// Formats distance in a human-readable way
///
/// - Less than 1 km: shows in meters (e.g., "150 m")
/// - 1 km or more: shows in kilometers (e.g., "2.5 km")
String _formatDistance(double distanceInMeters) {
  if (distanceInMeters < 1000) {
    return '${distanceInMeters.toStringAsFixed(0)} m';
  } else {
    final km = distanceInMeters / 1000;
    return '${km.toStringAsFixed(1)} km';
  }
}

/// Determines instruction type based on bearing relative to device orientation
///
/// Returns an [InstructionType] based on the target bearing.
/// This assumes the device is oriented to North (0 degrees).
InstructionType _getInstructionType(double bearing) {
  final normalizedBearing = bearing % 360;

  // Check if target is roughly straight ahead (within ±30 degrees)
  if ((normalizedBearing >= 330 && normalizedBearing <= 360) ||
      (normalizedBearing >= 0 && normalizedBearing <= 30)) {
    return InstructionType.straight;
  }
  // Check if target is to the left (270-330 degrees)
  else if (normalizedBearing >= 270 && normalizedBearing < 330) {
    return InstructionType.turnLeft;
  }
  // Check if target is to the right (30-90 degrees)
  else if (normalizedBearing > 30 && normalizedBearing <= 90) {
    return InstructionType.turnRight;
  }
  // Check if target is behind (120-240 degrees)
  else if (normalizedBearing > 120 && normalizedBearing < 240) {
    return InstructionType.uTurn;
  } else {
    return InstructionType.straight;
  }
}

/// Generates human-readable instruction text
///
/// Combines distance and instruction type into
/// a natural language instruction suitable for display.
String _generateInstructionText(
  String distance,
  InstructionType instructionType,
) {
  switch (instructionType) {
    case InstructionType.straight:
      return 'Siga nessa direção por $distance';
    case InstructionType.turnLeft:
      return 'Vire à esquerda e siga por $distance';
    case InstructionType.turnRight:
      return 'Vire à direita e siga por $distance';
    case InstructionType.uTurn:
      return 'Faça o retorno e siga por $distance';
    case InstructionType.exit:
      return 'Saia e siga por $distance';
    case InstructionType.enterHighway:
      return 'Acesse a via e siga por $distance';
    case InstructionType.leaveHighway:
      return 'Saia da via e siga por $distance';
    case InstructionType.roundabout:
      return 'Entre na rotatória e siga por $distance';
    case InstructionType.arrive:
      return 'Você chegou ao ponto de captura';
  }
}

/// Exception class for navigation instruction errors
class NavigationInstructionException implements Exception {
  final String message;
  final dynamic originalError;

  NavigationInstructionException({required this.message, this.originalError});

  @override
  String toString() => 'NavigationInstructionException: $message';
}
