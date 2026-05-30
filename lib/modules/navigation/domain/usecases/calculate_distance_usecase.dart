import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/repositories/navigation_repository.dart';

/// Use case for calculating the distance between two locations.
///
/// Injects [NavigationRepository] to perform distance calculations
/// using geolocation data.
class CalculateDistanceUsecase {
  final NavigationRepository _navigationRepository;

  CalculateDistanceUsecase(this._navigationRepository);

  /// Executes the use case and calculates the distance to a target location.
  ///
  /// Takes the current [location] and target coordinates [targetLatitude] and [targetLongitude],
  /// and returns the distance in meters.
  ///
  /// Returns a [Future] that resolves to the distance in meters.
  ///
  /// Example:
  /// ```dart
  /// final usecase = CalculateDistanceUsecase(repository);
  /// final distance = await usecase(currentLocation, 37.7749, -122.4194);
  /// print('Distance to target: $distance meters');
  /// ```
  Future<double> call(
    LocationEntity location,
    double targetLatitude,
    double targetLongitude,
  ) {
    return _navigationRepository.calculateDistance(
      location,
      targetLatitude,
      targetLongitude,
    );
  }
}
