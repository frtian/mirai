import 'package:mirai/modules/navigation/domain/entities/location_permission_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_exception.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_status_entity.dart';
import 'package:mirai/modules/navigation/domain/repositories/location_permission_repository.dart';

import '../datasources/location_permission_datasource.dart';

/// Implementation of LocationPermissionRepository using LocationPermissionDatasource
///
/// Responsible for:
/// - Converting Data Layer Models to Domain Layer Entities
/// - Converting datasource exceptions to domain exceptions
/// - Implementing business logic and rules
class LocationPermissionRepositoryImpl implements LocationPermissionRepository {
  final LocationPermissionDatasource _datasource;

  LocationPermissionRepositoryImpl({required this._datasource});

  @override
  Future<LocationPermissionEntity> checkPermission() async {
    try {
      final model = await _datasource.checkPermission();
      return _modelToEntity(model);
    } on LocationPermissionDatasourceException catch (e) {
      throw LocationServiceException(
        message: e.message,
        code: e.code,
        originalException: e.originalException,
      );
    } catch (e) {
      throw LocationServiceException(
        message: 'Unexpected error while checking permission',
        originalException: e,
      );
    }
  }

  @override
  Future<LocationPermissionEntity> requestPermission() async {
    try {
      final model = await _datasource.requestPermission();
      final entity = _modelToEntity(model);

      // Business logic: Check if permission is permanently denied
      if (entity.isDeniedForever) {
        throw LocationPermissionDeniedForeverException(
          message:
              'Location permission permanently denied. Open app settings to enable.',
        );
      }

      // Business logic: Check if permission was denied
      if (entity.isDenied || !entity.isGranted) {
        throw LocationPermissionDeniedException(
          message: 'Location permission denied by user',
        );
      }

      return entity;
    } on LocationServiceException {
      rethrow;
    } on LocationPermissionDatasourceException catch (e) {
      throw LocationServiceException(
        message: e.message,
        code: e.code,
        originalException: e.originalException,
      );
    } catch (e) {
      throw LocationServiceException(
        message: 'Unexpected error while requesting permission',
        originalException: e,
      );
    }
  }

  @override
  Future<LocationServiceStatusEntity> checkLocationServiceStatus() async {
    try {
      final model = await _datasource.checkLocationServiceStatus();
      return _statusModelToEntity(model);
    } on LocationPermissionDatasourceException catch (e) {
      throw LocationServiceException(
        message: e.message,
        code: e.code,
        originalException: e.originalException,
      );
    } catch (e) {
      throw LocationServiceException(
        message: 'Unexpected error while checking location service status',
        originalException: e,
      );
    }
  }

  @override
  Future<bool> requestLocationService() async {
    try {
      return await _datasource.requestLocationService();
    } on LocationPermissionDatasourceException catch (e) {
      throw LocationServiceDisabledException(message: e.message);
    } catch (e) {
      throw LocationServiceException(
        message: 'Unexpected error while requesting location service',
        originalException: e,
      );
    }
  }

  /// Convert LocationPermissionModel to LocationPermissionEntity
  LocationPermissionEntity _modelToEntity(LocationPermissionModel model) {
    return LocationPermissionEntity(
      isGranted: model.isGranted,
      isDenied: model.isDenied,
      isDeniedForever: model.isDeniedForever,
      checkedAt: model.checkedAt,
    );
  }

  /// Convert LocationServiceStatusModel to LocationServiceStatusEntity
  LocationServiceStatusEntity _statusModelToEntity(
    LocationServiceStatusModel model,
  ) {
    return LocationServiceStatusEntity(
      isEnabled: model.isEnabled,
      lastChecked: model.lastChecked,
    );
  }
}
