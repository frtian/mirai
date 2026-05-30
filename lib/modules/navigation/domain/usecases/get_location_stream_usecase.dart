import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/repositories/geolocation_repository.dart';

/// Use case for retrieving a continuous stream of location updates.
///
/// Injects [GeolocationRepository] to get location data from the data layer
/// and provides a stream of [LocationEntity] objects.
class GetLocationStreamUsecase {
  final GeolocationRepository _geolocationRepository;

  GetLocationStreamUsecase(this._geolocationRepository);

  /// Executes the use case and returns a stream of location updates.
  ///
  /// Returns a [Stream] that emits [LocationEntity] objects as the device location changes.
  /// The stream is continuous and will emit updates until the stream is closed.
  ///
  /// Example:
  /// ```dart
  /// final usecase = GetLocationStreamUsecase(repository);
  /// usecase().listen((location) {
  ///   print('Current location: ${location.latitude}, ${location.longitude}');
  /// });
  /// ```
  Stream<LocationEntity> call() {
    return _geolocationRepository.getLocationStream();
  }
}
