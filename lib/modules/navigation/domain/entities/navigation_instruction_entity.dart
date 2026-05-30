import 'package:equatable/equatable.dart';

/// Enum for navigation instruction types.
enum InstructionType {
  straight,
  turnLeft,
  turnRight,
  uTurn,
  exit,
  enterHighway,
  leaveHighway,
  roundabout,
  arrive,
}

/// Represents a navigation instruction with route guidance information.
class NavigationInstructionEntity extends Equatable {
  final String text;
  final double distance;
  final double bearing;
  final InstructionType instructionType;

  const NavigationInstructionEntity({
    required this.text,
    required this.distance,
    required this.bearing,
    required this.instructionType,
  });

  @override
  List<Object?> get props => [text, distance, bearing, instructionType];

  @override
  String toString() =>
      'NavigationInstructionEntity('
      'text: $text, '
      'distance: $distance, '
      'bearing: $bearing, '
      'instructionType: ${instructionType.name}'
      ')';
}
