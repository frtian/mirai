import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

/// Exception thrown when location permission operation fails
class LocationPermissionDatasourceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  LocationPermissionDatasourceException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'LocationPermissionDatasourceException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Model for location permission status (data layer only)
class LocationPermissionModel {
  final bool isGranted;
  final bool isDenied;
  final bool isDeniedForever;
  final DateTime checkedAt;

  LocationPermissionModel({
    required this.isGranted,
    required this.isDenied,
    required this.isDeniedForever,
    required this.checkedAt,
  });

  @override
  String toString() =>
      'LocationPermissionModel('
      'isGranted: $isGranted, '
      'isDenied: $isDenied, '
      'isDeniedForever: $isDeniedForever, '
      'checkedAt: $checkedAt)';
}

/// Model for location service status (data layer only)
class LocationServiceStatusModel {
  final bool isEnabled;
  final DateTime lastChecked;

  LocationServiceStatusModel({
    required this.isEnabled,
    required this.lastChecked,
  });

  @override
  String toString() =>
      'LocationServiceStatusModel('
      'isEnabled: $isEnabled, '
      'lastChecked: $lastChecked)';
}

/// Datasource for location permission and service operations
/// Pure data layer - no domain knowledge
class LocationPermissionDatasource {
  final Location _locationService = Location();

  /// Check the current location permission status using geolocator
  Future<LocationPermissionModel> checkPermission() async {
    try {
      final permission = await Geolocator.checkPermission();
      final isGranted =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      final isDenied = permission == LocationPermission.denied;
      final isDeniedForever = permission == LocationPermission.deniedForever;

      return LocationPermissionModel(
        isGranted: isGranted,
        isDenied: isDenied,
        isDeniedForever: isDeniedForever,
        checkedAt: DateTime.now(),
      );
    } catch (e) {
      throw LocationPermissionDatasourceException(
        message: 'Failed to check permission',
        originalException: e,
      );
    }
  }

  /// Request location permission from user using geolocator
  Future<LocationPermissionModel> requestPermission() async {
    try {
      final permission = await Geolocator.requestPermission();
      final isGranted =
          permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always;
      final isDenied = permission == LocationPermission.denied;
      final isDeniedForever = permission == LocationPermission.deniedForever;

      return LocationPermissionModel(
        isGranted: isGranted,
        isDenied: isDenied,
        isDeniedForever: isDeniedForever,
        checkedAt: DateTime.now(),
      );
    } catch (e) {
      throw LocationPermissionDatasourceException(
        message: 'Failed to request permission',
        originalException: e,
      );
    }
  }

  /// Check if location service is enabled on device
  Future<LocationServiceStatusModel> checkLocationServiceStatus() async {
    try {
      final isEnabled = await Geolocator.isLocationServiceEnabled();

      return LocationServiceStatusModel(
        isEnabled: isEnabled,
        lastChecked: DateTime.now(),
      );
    } catch (e) {
      throw LocationPermissionDatasourceException(
        message: 'Failed to check location service status',
        originalException: e,
      );
    }
  }

  /// Request user to enable location service
  ///
  /// Uses the 'location' package to show native Android dialog
  /// that allows enabling location service without leaving the app
  Future<bool> requestLocationService() async {
    try {
      final result = await _locationService.requestService();
      return result;
    } catch (e) {
      throw LocationPermissionDatasourceException(
        message: 'Failed to request location service: ${e.toString()}',
        code: 'SERVICE_REQUEST_FAILED',
      );
    }
  }

  /// Poll location service status
  ///
  /// Emits status every [intervalSeconds] until service is enabled
  Stream<LocationServiceStatusModel> pollLocationServiceStatus({
    int intervalSeconds = 2,
    int maxAttempts = 30,
  }) async* {
    int attempts = 0;

    while (attempts < maxAttempts) {
      final status = await checkLocationServiceStatus();
      yield status;

      if (status.isEnabled) {
        break;
      }

      await Future.delayed(Duration(seconds: intervalSeconds));
      attempts++;
    }
  }
}
