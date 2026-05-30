import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/data/datasources/location_permission_datasource.dart';
import 'package:mirai/modules/navigation/data/repositores/location_permission_repository_impl.dart';
import 'package:mirai/modules/navigation/domain/entities/location_permission_entity.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_exception.dart';
import 'package:mirai/modules/navigation/domain/entities/location_service_status_entity.dart';

final locationPermissionDatasourceProvider =
    Provider<LocationPermissionDatasource>((ref) {
      return LocationPermissionDatasource();
    });

final locationPermissionRepositoryProvider =
    Provider<LocationPermissionRepositoryImpl>((ref) {
      final datasource = ref.watch(locationPermissionDatasourceProvider);
      return LocationPermissionRepositoryImpl(datasource: datasource);
    });

/// Safe provider que nunca falha - retorna estado padrão se der erro
final locationPermissionProvider = FutureProvider<LocationPermissionEntity>((
  ref,
) async {
  try {
    final repository = ref.watch(locationPermissionRepositoryProvider);
    return await repository.checkPermission();
  } catch (e) {
    // Retorna estado padrão: sem permissão
    return LocationPermissionEntity(
      isGranted: false,
      isDenied: true,
      isDeniedForever: false,
      checkedAt: DateTime.now(),
    );
  }
});

final requestLocationPermissionProvider =
    FutureProvider.autoDispose<LocationPermissionEntity>((ref) async {
      final repository = ref.watch(locationPermissionRepositoryProvider);
      return repository.requestPermission();
    });

/// Safe provider que nunca falha
final locationServiceStatusProvider =
    FutureProvider<LocationServiceStatusEntity>((ref) async {
      try {
        final repository = ref.watch(locationPermissionRepositoryProvider);
        return await repository.checkLocationServiceStatus();
      } catch (e) {
        // Retorna estado padrão: serviço desativado
        return LocationServiceStatusEntity(
          isEnabled: false,
          lastChecked: DateTime.now(),
        );
      }
    });

final requestLocationServiceProvider = FutureProvider.autoDispose<bool>((
  ref,
) async {
  final repository = ref.watch(locationPermissionRepositoryProvider);
  return repository.requestLocationService();
});

final locationServiceStatusStreamProvider =
    StreamProvider.autoDispose<LocationServiceStatusEntity>((ref) {
      final datasource = ref.watch(locationPermissionDatasourceProvider);
      return Stream.fromFuture(
        datasource.checkLocationServiceStatus().then((model) {
          return LocationServiceStatusEntity(
            isEnabled: model.isEnabled,
            lastChecked: model.lastChecked,
          );
        }),
      );
    });

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

final isLocationReadyProvider = FutureProvider<bool>((ref) async {
  try {
    final permission = await ref.watch(locationPermissionProvider.future);
    final serviceStatus = await ref.watch(locationServiceStatusProvider.future);

    return permission.isGranted && serviceStatus.isEnabled;
  } catch (e) {
    return false;
  }
});

final locationPermissionErrorProvider = FutureProvider.autoDispose<String?>((
  ref,
) async {
  try {
    await ref.watch(locationPermissionProvider.future);
    return null;
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
