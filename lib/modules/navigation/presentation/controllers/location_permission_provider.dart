import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/data/datasources/location_permission_datasource.dart';
import 'package:mirai/modules/navigation/data/repositores/location_permission_repository_impl.dart';
import 'package:mirai/modules/navigation/domain/entities/location_permission_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_exception.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_status_entity.dart';

// ============================================================================
// DEPENDENCY INJECTION PROVIDERS
// ============================================================================

/// Provider for LocationPermissionDatasource (singleton)
final locationPermissionDatasourceProvider =
    Provider<LocationPermissionDatasource>((ref) {
      return LocationPermissionDatasource();
    });

/// Provider for LocationPermissionRepository (singleton)
final locationPermissionRepositoryProvider =
    Provider<LocationPermissionRepositoryImpl>((ref) {
      final datasource = ref.watch(locationPermissionDatasourceProvider);
      return LocationPermissionRepositoryImpl(datasource: datasource);
    });

// ============================================================================
// LOCATION PERMISSION PROVIDERS
// ============================================================================

/// Check current location permission status
///
/// Returns the current permission state without changing anything
/// Use this to display the current state in UI
final locationPermissionProvider = FutureProvider<LocationPermissionEntity>((
  ref,
) async {
  final repository = ref.watch(locationPermissionRepositoryProvider);
  return repository.checkPermission();
});

/// Request location permission from user
///
/// Triggers system permission dialog
/// Throws LocationPermissionDeniedException if user denies
/// Throws LocationPermissionDeniedForeverException if permanently denied
final requestLocationPermissionProvider =
    FutureProvider.autoDispose<LocationPermissionEntity>((ref) async {
      final repository = ref.watch(locationPermissionRepositoryProvider);
      return repository.requestPermission();
    });

// ============================================================================
// LOCATION SERVICE STATUS PROVIDERS
// ============================================================================

/// Check if location service is enabled
///
/// Returns the current GPS service status without changing anything
/// Use this to determine if user needs to enable location service
final locationServiceStatusProvider =
    FutureProvider<LocationServiceStatusEntity>((ref) async {
      final repository = ref.watch(locationPermissionRepositoryProvider);
      return repository.checkLocationServiceStatus();
    });

/// Request to enable location service
///
/// Shows native Android dialog (without leaving app) to enable GPS
/// Returns true if location service was enabled, false if user cancelled
final requestLocationServiceProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final repository = ref.watch(locationPermissionRepositoryProvider);
  return repository.requestLocationService();
});

// ============================================================================
// POLLING PROVIDER FOR LOCATION SERVICE STATUS
// ============================================================================

/// Stream provider that polls location service status
///
/// Useful for monitoring when user enables location service after the dialog
/// Emits status every 2 seconds (default), up to 30 attempts (default)
/// Automatically stops when service is enabled or max attempts reached
final locationServiceStatusPollingProvider =
    StreamProvider.autoDispose<LocationServiceStatusEntity>((ref) {
      final datasource = ref.watch(locationPermissionDatasourceProvider);
      return datasource.pollLocationServiceStatus().map((model) {
        return LocationServiceStatusEntity(
          isEnabled: model.isEnabled,
          lastChecked: model.lastChecked,
        );
      });
    });

// ============================================================================
// COMBINED STATUS PROVIDER
// ============================================================================

/// Combined check: is permission granted AND is service enabled?
///
/// Returns true only if both permission and service are active
/// Useful for guarding the navigation page
final isLocationReadyProvider = FutureProvider<bool>((ref) async {
  try {
    final permission = await ref.watch(locationPermissionProvider.future);
    final serviceStatus = await ref.watch(locationServiceStatusProvider.future);

    return permission.isGranted && serviceStatus.isEnabled;
  } catch (e) {
    return false;
  }
});

// ============================================================================
// ERROR HANDLING PROVIDER
// ============================================================================

/// Get detailed error message from location service exceptions
///
/// Use in UI to show user-friendly error messages
final locationPermissionErrorProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  try {
    await ref.watch(locationPermissionProvider.future);
    return null; // No error
  } on LocationPermissionDeniedForeverException {
    return 'Location permission permanently denied. Please enable it in app settings.';
  } on LocationPermissionDeniedException {
    return 'Location permission denied. Please try again.';
  } on LocationServiceDisabledException {
    return 'Location service is disabled. Please enable it.';
  } on LocationServiceException catch (e) {
    return 'Location error: ${e.message}';
  } catch (e) {
    return 'Unexpected error checking location';
  }
});
