import 'package:geolocator/geolocator.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';

/// Data layer model that extends the domain layer LocationEntity
/// Adds conversion methods and data layer-specific functionality
class LocationModel extends LocationEntity {
  const LocationModel({
    required super.latitude,
    required super.longitude,
    super.accuracy,
    required super.timestamp,
  });

  /// Factory constructor to create LocationModel from geolocator Position
  factory LocationModel.fromPosition(Position position) {
    return LocationModel(
      latitude: position.latitude,
      longitude: position.longitude,
      accuracy: position.accuracy,
      timestamp: position.timestamp,
    );
  }

  /// Convert LocationModel to LocationEntity
  /// Useful for explicit conversions between layers
  LocationEntity toEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      timestamp: timestamp,
    );
  }
}
