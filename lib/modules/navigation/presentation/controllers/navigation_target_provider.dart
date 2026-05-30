import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mirai/modules/navigation/data/datasources/navigation_api_datasource.dart';
import 'package:mirai/modules/navigation/domain/entities/navigation_target_entity.dart';

/// Provides the navigation API datasource
final navigationApiDatasourceProvider = Provider<NavigationApiDatasource>(
  (ref) => NavigationApiDatasource(),
);

/// Provides the navigation target from API
///
/// This is a [FutureProvider] that fetches the navigation target once and caches the result.
/// The target represents the destination point for navigation.
///
/// Usage:
/// ```dart
/// final target = ref.watch(navigationTargetProvider);
/// target.when(
///   data: (target) => Text('${target.name} (${target.description})'),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final navigationTargetProvider =
    FutureProvider.autoDispose<NavigationTargetEntity>((ref) async {
      final datasource = ref.watch(navigationApiDatasourceProvider);

      try {
        final targetModel = await datasource.getNavigationTarget();

        return NavigationTargetEntity(
          id: targetModel.id,
          latitude: targetModel.latitude,
          longitude: targetModel.longitude,
          name: targetModel.name,
          description: targetModel.description,
        );
      } catch (e) {
        throw NavigationTargetProviderException(
          message: 'Failed to load navigation target',
          originalError: e,
        );
      }
    });

/// Provides the navigation target by ID
///
/// This is a [FutureProvider.family] that allows fetching a specific target by its ID.
/// Use this when you need to switch between different navigation targets.
///
/// Usage:
/// ```dart
/// final target = ref.watch(navigationTargetByIdProvider('target_001'));
/// target.when(
///   data: (target) => Text(target.name),
///   loading: () => CircularProgressIndicator(),
///   error: (error, stack) => Text('Error: $error'),
/// );
/// ```
final navigationTargetByIdProvider = FutureProvider.family
    .autoDispose<NavigationTargetEntity, String>((ref, targetId) async {
      final datasource = ref.watch(navigationApiDatasourceProvider);

      try {
        final targetModel = await datasource.getNavigationTargetById(targetId);

        return NavigationTargetEntity(
          id: targetModel.id,
          latitude: targetModel.latitude,
          longitude: targetModel.longitude,
          name: targetModel.name,
          description: targetModel.description,
        );
      } catch (e) {
        throw NavigationTargetProviderException(
          message: 'Failed to load navigation target: $targetId',
          originalError: e,
        );
      }
    });

/// Exception class for navigation target errors
class NavigationTargetProviderException implements Exception {
  final String message;
  final dynamic originalError;

  NavigationTargetProviderException({
    required this.message,
    this.originalError,
  });

  @override
  String toString() => 'NavigationTargetProviderException: $message';
}
