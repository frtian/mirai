import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';

/// Abstract repository for geolocation operations.
///
/// Defines contracts for location-related data operations.
abstract class GeolocationRepository {
  /// Gets a stream of location updates.
  ///
  /// Returns a continuous stream of [LocationEntity] objects as the device location changes.
  Stream<LocationEntity> getLocationStream();
}
