import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/data/repositories/navigation_repository_impl.dart';
import 'geolocation_provider.dart';
import 'navigation_target_provider.dart';

/// Provides the navigation repository
final navigationRepositoryProvider = Provider<NavigationRepositoryImpl>((ref) {
  final datasource = ref.watch(navigationApiDatasourceProvider);
  return NavigationRepositoryImpl(datasource: datasource);
});

/// Provides the bearing (direction) from current location to target
///
/// This [FutureProvider] composes both location and target providers to calculate
/// the bearing (compass direction) needed to point at the navigation target.
/// Bearing is in degrees: 0° = North, 90° = East, 180° = South, 270° = West.
///
/// Depends on:
/// - [geolocationStreamProvider] for current location
/// - [navigationTargetProvider] for target location
///
/// Usage:
/// ```dart
/// final bearing = ref.watch(bearingProvider);
/// bearing.when(
///   data: (bearing) => Text('Bearing: ${bearing.toStringAsFixed(1)}°'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final bearingProvider = FutureProvider.autoDispose<double>((ref) async {
  final repository = ref.watch(navigationRepositoryProvider);

  // Watch location stream and get the latest value
  final locationAsync = ref.watch(geolocationStreamProvider);
  // Watch navigation target
  final targetAsync = ref.watch(navigationTargetProvider);

  // Extract values from AsyncValue
  final location = await locationAsync.when(
    data: (loc) => Future.value(loc),
    loading: () => throw NavigationCalculationException(
      message: 'Location stream not ready',
    ),
    error: (error, stack) => Future.error(error),
  );

  final target = await targetAsync.when(
    data: (t) => Future.value(t),
    loading: () =>
        throw NavigationCalculationException(message: 'Target not ready'),
    error: (error, stack) => Future.error(error),
  );

  try {
    final bearingToTarget = await repository.calculateBearing(
      location,
      target.latitude,
      target.longitude,
    );
    final heading = location.heading;
    if (heading == null) {
      return _normalizeBearing(bearingToTarget);
    }
    return _normalizeBearing(bearingToTarget - heading);
  } catch (e) {
    throw NavigationCalculationException(
      message: 'Failed to calculate bearing',
      originalError: e,
    );
  }
});

/// Provides the distance from current location to target
///
/// This [FutureProvider] composes both location and target providers to calculate
/// the distance (in meters) from the current location to the navigation target.
///
/// Depends on:
/// - [geolocationStreamProvider] for current location
/// - [navigationTargetProvider] for target location
///
/// Usage:
/// ```dart
/// final distance = ref.watch(distanceProvider);
/// distance.when(
///   data: (distance) => Text('Distance: ${(distance / 1000).toStringAsFixed(2)} km'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final distanceProvider = FutureProvider.autoDispose<double>((ref) async {
  final repository = ref.watch(navigationRepositoryProvider);

  // Watch location stream and get the latest value
  final locationAsync = ref.watch(geolocationStreamProvider);
  // Watch navigation target
  final targetAsync = ref.watch(navigationTargetProvider);

  // Extract values from AsyncValue
  final location = await locationAsync.when(
    data: (loc) => Future.value(loc),
    loading: () => throw NavigationCalculationException(
      message: 'Location stream not ready',
    ),
    error: (error, stack) => Future.error(error),
  );

  final target = await targetAsync.when(
    data: (t) => Future.value(t),
    loading: () =>
        throw NavigationCalculationException(message: 'Target not ready'),
    error: (error, stack) => Future.error(error),
  );

  try {
    final distance = await repository.calculateDistance(
      location,
      target.latitude,
      target.longitude,
    );
    return distance;
  } catch (e) {
    throw NavigationCalculationException(
      message: 'Failed to calculate distance',
      originalError: e,
    );
  }
});

/// Provides both bearing and distance as a combined value
///
/// This is a convenience provider that combines [bearingProvider] and
/// [distanceProvider] into a single [AsyncValue]. Useful when you need
/// both values simultaneously to reduce rebuild overhead.
///
/// Returns a record with named fields: (bearing: double, distance: double)
///
/// Usage:
/// ```dart
/// final calculation = ref.watch(navigationCalculationProvider);
/// calculation.when(
///   data: ((bearing: bearing, distance: distance)) {
///     return Text('${bearing}° - ${distance}m');
///   },
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final navigationCalculationProvider =
    FutureProvider.autoDispose<({double bearing, double distance})>((
      ref,
    ) async {
      final bearing = await ref.watch(bearingProvider.future);
      final distance = await ref.watch(distanceProvider.future);

      return (bearing: bearing, distance: distance);
    });

/// Exception class for navigation calculation errors
class NavigationCalculationException implements Exception {
  final String message;
  final dynamic originalError;

  NavigationCalculationException({required this.message, this.originalError});

  @override
  String toString() => 'NavigationCalculationException: $message';
}

double _normalizeBearing(double bearing) {
  final normalized = bearing % 360;
  return normalized < 0 ? normalized + 360 : normalized;
}
