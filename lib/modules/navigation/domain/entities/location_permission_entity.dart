import 'package:equatable/equatable.dart';

/// Entity representing the current location permission status
class LocationPermissionEntity extends Equatable {
  /// Whether location permission has been granted
  final bool isGranted;

  /// Whether location permission has been denied
  final bool isDenied;

  /// Whether location permission has been permanently denied (user won't be prompted again)
  final bool isDeniedForever;

  /// Timestamp of when this permission status was checked
  final DateTime checkedAt;

  const LocationPermissionEntity({
    required this.isGranted,
    required this.isDenied,
    required this.isDeniedForever,
    required this.checkedAt,
  });

  /// Returns true if permission is in a usable state
  bool get canRequest => !isDeniedForever;

  /// Returns true if permission was never asked or denied
  bool get needsRequest => isDenied || (!isGranted && !isDenied);

  @override
  List<Object?> get props => [isGranted, isDenied, isDeniedForever, checkedAt];

  @override
  String toString() =>
      'LocationPermissionEntity('
      'isGranted: $isGranted, '
      'isDenied: $isDenied, '
      'isDeniedForever: $isDeniedForever, '
      'checkedAt: $checkedAt)';
}
