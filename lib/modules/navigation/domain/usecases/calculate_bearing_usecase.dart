import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/repositories/navigation_repository.dart';

/// Use case for calculating the bearing (direction) between two locations.
///
/// Injects [NavigationRepository] to perform bearing calculations
/// using geolocation data.
class CalculateBearingUsecase {
  final NavigationRepository _navigationRepository;

  CalculateBearingUsecase(this._navigationRepository);

  /// Executes the use case and calculates the bearing to a target location.
  ///
  /// Takes the current [location] and target coordinates [targetLatitude] and [targetLongitude],
  /// and returns the bearing as degrees (0-360 where 0° is North, 90° is East, etc.).
  ///
  /// Returns a [Future] that resolves to the bearing in degrees.
  ///
  /// Example:
  /// ```dart
  /// final usecase = CalculateBearingUsecase(repository);
  /// final bearing = await usecase(currentLocation, 37.7749, -122.4194);
  /// print('Direction to target: $bearing degrees');
  /// ```
  Future<double> call(
    LocationEntity location,
    double targetLatitude,
    double targetLongitude,
  ) {
    return _navigationRepository.calculateBearing(
      location,
      targetLatitude,
      targetLongitude,
    );
  }
}
