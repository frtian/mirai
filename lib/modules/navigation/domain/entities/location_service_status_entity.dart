import 'package:equatable/equatable.dart';

/// Entity representing the current location service status
class LocationServiceStatusEntity extends Equatable {
  /// Whether location service is enabled on the device
  final bool isEnabled;

  /// Timestamp of when this status was checked
  final DateTime lastChecked;

  const LocationServiceStatusEntity({
    required this.isEnabled,
    required this.lastChecked,
  });

  /// Returns true if service status is stale (older than 5 seconds)
  bool get isStale {
    final now = DateTime.now();
    final difference = now.difference(lastChecked);
    return difference.inSeconds > 5;
  }

  @override
  List<Object?> get props => [isEnabled, lastChecked];

  @override
  String toString() =>
      'LocationServiceStatusEntity('
      'isEnabled: $isEnabled, '
      'lastChecked: $lastChecked)';
}
