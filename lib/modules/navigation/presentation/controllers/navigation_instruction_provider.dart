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
      final cardinalDirection = _getCardinalDirection(bearing);
      final distanceText = _formatDistance(distance);

      // Determine instruction type based on bearing
      final instructionType = _getInstructionType(bearing);

      // Generate human-readable instruction
      final instructionText = _generateInstructionText(
        cardinalDirection,
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

/// Converts bearing (degrees) to cardinal direction string
///
/// Returns one of: N, NE, E, SE, S, SW, W, NW
String _getCardinalDirection(double bearing) {
  // Normalize bearing to 0-360
  final normalizedBearing = bearing % 360;

  // Map bearing to cardinal directions (each direction covers 45 degrees)
  if (normalizedBearing >= 337.5 || normalizedBearing < 22.5) {
    return 'North';
  } else if (normalizedBearing >= 22.5 && normalizedBearing < 67.5) {
    return 'Northeast';
  } else if (normalizedBearing >= 67.5 && normalizedBearing < 112.5) {
    return 'East';
  } else if (normalizedBearing >= 112.5 && normalizedBearing < 157.5) {
    return 'Southeast';
  } else if (normalizedBearing >= 157.5 && normalizedBearing < 202.5) {
    return 'South';
  } else if (normalizedBearing >= 202.5 && normalizedBearing < 247.5) {
    return 'Southwest';
  } else if (normalizedBearing >= 247.5 && normalizedBearing < 292.5) {
    return 'West';
  } else {
    return 'Northwest';
  }
}

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
/// Combines cardinal direction, distance, and instruction type into
/// a natural language instruction suitable for voice output or display.
String _generateInstructionText(
  String direction,
  String distance,
  InstructionType instructionType,
) {
  final instructionVerb = _getInstructionVerb(instructionType);

  return '$instructionVerb towards the $direction. Distance: $distance';
}

/// Gets the appropriate verb for the instruction type
String _getInstructionVerb(InstructionType type) {
  switch (type) {
    case InstructionType.straight:
      return 'Continue straight';
    case InstructionType.turnLeft:
      return 'Turn left';
    case InstructionType.turnRight:
      return 'Turn right';
    case InstructionType.uTurn:
      return 'Make a U-turn';
    case InstructionType.exit:
      return 'Exit';
    case InstructionType.enterHighway:
      return 'Enter highway';
    case InstructionType.leaveHighway:
      return 'Leave highway';
    case InstructionType.roundabout:
      return 'Enter roundabout';
    case InstructionType.arrive:
      return 'You have arrived at';
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
