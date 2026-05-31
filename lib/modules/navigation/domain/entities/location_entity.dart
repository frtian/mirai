import 'package:equatable/equatable.dart';

/// Represents a geographic location with coordinates and metadata.
class LocationEntity extends Equatable {
  final double latitude;
  final double longitude;
  final double? accuracy;
  final double? heading;
  final DateTime timestamp;

  const LocationEntity({
    required this.latitude,
    required this.longitude,
    this.accuracy,
    this.heading,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [latitude, longitude, accuracy, heading, timestamp];

  @override
  String toString() =>
      'LocationEntity('
      'latitude: $latitude, '
      'longitude: $longitude, '
      'accuracy: $accuracy, '
      'heading: $heading, '
      'timestamp: $timestamp'
      ')';
}
