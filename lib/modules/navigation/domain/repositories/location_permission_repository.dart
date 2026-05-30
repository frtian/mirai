import 'package:mirai/modules/navigation/domain/entities/location_permission_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_status_entity.dart';

/// Abstract repository for managing location permissions and service status
abstract class LocationPermissionRepository {
  /// Check the current location permission status
  ///
  /// Returns a [LocationPermissionEntity] with the current permission state
  Future<LocationPermissionEntity> checkPermission();

  /// Request location permission from the user
  ///
  /// Prompts the user with a system dialog to grant location permission
  /// Returns a [LocationPermissionEntity] with the result
  Future<LocationPermissionEntity> requestPermission();

  /// Check if location service is currently enabled
  ///
  /// Returns a [LocationServiceStatusEntity] with the service status
  Future<LocationServiceStatusEntity> checkLocationServiceStatus();

  /// Request to enable location service
  ///
  /// Shows a native Android dialog (without leaving the app) that allows
  /// the user to enable location service directly from the app.
  ///
  /// Returns true if location service was enabled, false if user cancelled
  ///
  /// Note: This uses the 'location' package native dialog on Android
  Future<bool> requestLocationService();
}
