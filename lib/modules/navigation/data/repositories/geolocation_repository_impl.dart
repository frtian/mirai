import 'package:mirai/modules/navigation/data/datasources/geolocation_local_datasource.dart';
import 'package:mirai/modules/navigation/data/models/location_model.dart'
    as models;
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';
import 'package:mirai/modules/navigation/domain/repositories/geolocation_repository.dart';

/// Exception for geolocation repository operations
class GeolocationRepositoryException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  GeolocationRepositoryException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'GeolocationRepositoryException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Implementation of GeolocationRepository
///
/// Responsible for:
/// - Converting Data Layer Models to Domain Layer Entities
/// - Converting datasource exceptions to repository exceptions
/// - Implementing business logic and rules
class GeolocationRepositoryImpl implements GeolocationRepository {
  final GeolocationLocalDatasource _datasource;

  GeolocationRepositoryImpl({required GeolocationLocalDatasource datasource})
    : _datasource = datasource;

  @override
  Stream<LocationEntity> getLocationStream() async* {
    try {
      await for (final locationModel in _datasource.getLocationStream()) {
        // Convert model to entity
        yield _modelToEntity(locationModel);
      }
    } on GeolocationLocalDatasourceException catch (e) {
      throw GeolocationRepositoryException(
        message: e.message,
        code: e.code,
        originalException: e.originalException,
      );
    } catch (e) {
      throw GeolocationRepositoryException(
        message: 'Unexpected error while getting location stream',
        originalException: e,
      );
    }
  }

  /// Convert LocationModel to LocationEntity
  LocationEntity _modelToEntity(models.LocationModel model) {
    return LocationEntity(
      latitude: model.latitude,
      longitude: model.longitude,
      accuracy: model.accuracy,
      timestamp: model.timestamp,
    );
  }
}
