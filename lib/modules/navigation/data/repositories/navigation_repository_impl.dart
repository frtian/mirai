import 'dart:math' as math;
import 'package:mirai/modules/navigation/data/datasources/navigation_api_datasource.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/repositories/navigation_repository.dart';

/// Exception for navigation repository operations
class NavigationRepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  NavigationRepositoryException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'NavigationRepositoryException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Implementation of NavigationRepository
///
/// Responsible for:
/// - Calculating bearing and distance between locations
/// - Converting API responses to domain entities
/// - Implementing navigation business logic
class NavigationRepositoryImpl implements NavigationRepository {
  /// Navigator API datasource for future extension (e.g., fetching targets from API)
  final NavigationApiDatasource _datasource;

  NavigationRepositoryImpl({required NavigationApiDatasource datasource})
    : _datasource = datasource;

  @override
  Future<double> calculateBearing(
    LocationEntity location,
    double targetLatitude,
    double targetLongitude,
  ) async {
    try {
      // Calculate bearing using spherical geometry
      final bearing = _calculateBearingBetween(
        location.latitude,
        location.longitude,
        targetLatitude,
        targetLongitude,
      );

      return bearing;
    } catch (e) {
      throw NavigationRepositoryException(
        message: 'Failed to calculate bearing',
        code: 'BEARING_CALCULATION_ERROR',
        originalException: e,
      );
    }
  }

  @override
  Future<double> calculateDistance(
    LocationEntity location,
    double targetLatitude,
    double targetLongitude,
  ) async {
    try {
      // Calculate distance using Haversine formula
      final distance = _calculateDistanceBetween(
        location.latitude,
        location.longitude,
        targetLatitude,
        targetLongitude,
      );

      return distance;
    } catch (e) {
      throw NavigationRepositoryException(
        message: 'Failed to calculate distance',
        code: 'DISTANCE_CALCULATION_ERROR',
        originalException: e,
      );
    }
  }

  /// Calculate bearing between two coordinates
  /// Returns bearing in degrees (0-360), where:
  /// - 0° = North
  /// - 90° = East
  /// - 180° = South
  /// - 270° = West
  double _calculateBearingBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);
    final dLon = _toRadians(lon2 - lon1);

    final y = math.sin(dLon) * math.cos(lat2Rad);
    final x =
        math.cos(lat1Rad) * math.sin(lat2Rad) -
        math.sin(lat1Rad) * math.cos(lat2Rad) * math.cos(dLon);

    final bearing = (_toDegrees(math.atan2(y, x)) + 360) % 360;
    return bearing;
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in meters
  double _calculateDistanceBetween(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const earthRadiusMeters = 6371000.0; // Earth's radius in meters

    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);
    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    final distance = earthRadiusMeters * c;

    return distance;
  }

  /// Convert degrees to radians
  double _toRadians(double degrees) {
    return degrees * math.pi / 180;
  }

  /// Convert radians to degrees
  double _toDegrees(double radians) {
    return radians * 180 / math.pi;
  }
}
