import 'package:geolocator/geolocator.dart';
import 'package:mirai/modules/navigation/data/models/location_model.dart';

/// Exception thrown when geolocation operation fails
class GeolocationLocalDatasourceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  GeolocationLocalDatasourceException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'GeolocationLocalDatasourceException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Datasource for real-time geolocation using geolocator
/// Pure data layer - no domain knowledge
class GeolocationLocalDatasource {
  /// Gets a stream of location updates from device GPS
  ///
  /// Uses [geolocator.getPositionStream()] with a 5-meter distance filter
  /// to avoid excessive location updates while preserving accuracy.
  ///
  /// Emits [LocationModel] objects as the device location changes.
  /// Throws [GeolocationLocalDatasourceException] if stream cannot be established.
  Stream<LocationModel> getLocationStream() async* {
    try {
      final positionStream = Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          distanceFilter: 5, // Minimum 5 meters between updates
          timeLimit: Duration(seconds: 5), // Timeout for single update
        ),
      );

      await for (final position in positionStream) {
        yield LocationModel.fromPosition(position);
      }
    } catch (e) {
      throw GeolocationLocalDatasourceException(
        message: 'Failed to get location stream',
        code: 'LOCATION_STREAM_ERROR',
        originalException: e,
      );
    }
  }

  /// Gets the current single location update
  ///
  /// Throws [GeolocationLocalDatasourceException] if location cannot be determined.
  Future<LocationModel> getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.best,
          timeLimit: Duration(seconds: 10),
        ),
      );
      return LocationModel.fromPosition(position);
    } catch (e) {
      throw GeolocationLocalDatasourceException(
        message: 'Failed to get current location',
        code: 'GET_LOCATION_ERROR',
        originalException: e,
      );
    }
  }
}
