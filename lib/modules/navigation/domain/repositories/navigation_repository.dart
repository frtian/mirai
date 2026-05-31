import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';

/// Abstract repository for navigation calculations.
///
/// Defines contracts for navigation-related calculations such as bearing and distance.
abstract class NavigationRepository {
  /// Calculates the bearing (direction) between two locations.
  ///
  /// Takes the current [location] and a [targetLatitude] and [targetLongitude] destination,
  /// and returns the bearing as degrees (0-360).
  ///
  /// Returns a [Future] that resolves to the bearing in degrees.
  Future<double> calculateBearing(
    LocationEntity location,
    double targetLatitude,
    double targetLongitude,
  );

  /// Calculates the distance between two locations.
  ///
  /// Takes the current [location] and a [targetLatitude] and [targetLongitude] destination,
  /// and returns the distance in meters.
  ///
  /// Returns a [Future] that resolves to the distance in meters.
  Future<double> calculateDistance(
    LocationEntity location,
    double targetLatitude,
    double targetLongitude,
  );
}
