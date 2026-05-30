import 'package:equatable/equatable.dart';

/// Represents a geographic location with coordinates and metadata.
class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final DateTime timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy, timestamp];

  @override
  String toString() =>
      'LocationEntity('
      'latitude: $latitude, '
      'longitude: $longitude, '
      'accuracy: $accuracy, '
      'timestamp: $timestamp'
      ')';
}
