import 'package:equatable/equatable.dart';

/// Represents a navigation target with location and metadata.
class NavigationTargetEntity extends Equatable {
  final String id;
  final double latitude;
  final double longitude;
  final String name;
  final String description;

  const NavigationTargetEntity({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
  });

  @override
  List<Object?> get props => [id, latitude, longitude, name, description];

  @override
  String toString() =>
      'NavigationTargetEntity('
      'id: $id, '
      'latitude: $latitude, '
      'longitude: $longitude, '
      'name: $name, '
      'description: $description'
      ')';
}
