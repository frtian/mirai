import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/data/datasources/geolocation_local_datasource.dart';
import 'package:mirai/modules/navigation/data/repositories/geolocation_repository_impl.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';

/// Provides the geolocation datasource
final geolocationDatasourceProvider = Provider<GeolocationLocalDatasource>(
  (ref) => GeolocationLocalDatasource(),
);

/// Provides the geolocation repository
final geolocationRepositoryProvider = Provider<GeolocationRepositoryImpl>((
  ref,
) {
  final datasource = ref.watch(geolocationDatasourceProvider);
  return GeolocationRepositoryImpl(datasource: datasource);
});

/// Provides a continuous stream of location updates
///
/// This is a [StreamProvider] that emits location updates as the device
/// moves. The stream uses a 5-meter distance filter to avoid excessive updates
/// while maintaining accuracy.
///
/// Usage:
/// ```dart
/// final location = ref.watch(geolocationStreamProvider);
/// location.when(
///   data: (location) => Text('${location.latitude}, ${location.longitude}'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final geolocationStreamProvider = StreamProvider.autoDispose<LocationEntity>((
  ref,
) {
  final repository = ref.watch(geolocationRepositoryProvider);
  return repository.getLocationStream();
});

/// Provides the current location (single update)
///
/// This is a [FutureProvider] that retrieves the device's current location.
/// Use this when you need a single location update instead of a continuous stream.
///
/// Usage:
/// ```dart
/// final location = ref.watch(currentLocationProvider);
/// location.when(
///   data: (location) => Text('Current: ${location.latitude}'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final currentLocationProvider = FutureProvider.autoDispose<LocationEntity>((
  ref,
) async {
  final datasource = ref.watch(geolocationDatasourceProvider);
  // Use datasource directly for single location retrieval
  final locationModel = await datasource.getCurrentLocation();
  return LocationEntity(
    latitude: locationModel.latitude,
    longitude: locationModel.longitude,
    accuracy: locationModel.accuracy,
    timestamp: locationModel.timestamp,
  );
});

/// Exception class for geolocation errors
class GeolocationProviderException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  GeolocationProviderException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'GeolocationProviderException: $message';
}
