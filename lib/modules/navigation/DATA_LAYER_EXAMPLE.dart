// Example: Using the Data Layer

import 'package:mirai/modules/navigation/data/datasources/geolocation_local_datasource.dart';
import 'package:mirai/modules/navigation/data/datasources/navigation_api_datasource.dart';
import 'package:mirai/modules/navigation/data/repositories/geolocation_repository_impl.dart';
import 'package:mirai/modules/navigation/data/repositories/navigation_repository_impl.dart';
import 'package:mirai/modules/navigation/domain/entities/location_entity.dart';

void exampleDataLayerUsage() async {
  // ============================================
  // 1. Initialize Datasources
  // ============================================
  final geolocator = GeolocationLocalDatasource();
  final apiDatasource = NavigationApiDatasource();

  // ============================================
  // 2. Initialize Repositories
  // ============================================
  final geolocationRepo = GeolocationRepositoryImpl(datasource: geolocator);
  final navigationRepo = NavigationRepositoryImpl(datasource: apiDatasource);

  // ============================================
  // 3. Get Location Stream (Real-time GPS)
  // ============================================
  // Listen to continuous GPS updates with 5m filter
  geolocationRepo.getLocationStream().listen(
    (LocationEntity location) {
      print('Current Location: ${location.latitude}, ${location.longitude}');
      print('Accuracy: ${location.accuracy}m');
    },
    onError: (e) {
      print('Error getting location: $e');
    },
  );

  // ============================================
  // 4. Calculate Navigation Data
  // ============================================
  // Example: Calculate bearing and distance to target
  final userLocation = LocationEntity(
    latitude: -10.0,
    longitude: -48.0,
    accuracy: 10.0,
    heading: 0,
    timestamp: DateTime.now(),
  );

  final targetLatitude = -10.191056;
  final targetLongitude = -48.316806;

  try {
    final bearing = await navigationRepo.calculateBearing(
      userLocation,
      targetLatitude,
      targetLongitude,
    );
    print('Bearing to target: ${bearing.toStringAsFixed(2)}°');

    final distance = await navigationRepo.calculateDistance(
      userLocation,
      targetLatitude,
      targetLongitude,
    );
    print('Distance to target: ${(distance / 1000).toStringAsFixed(2)}km');
  } catch (e) {
    print('Error calculating navigation: $e');
  }

  // ============================================
  // 5. Get Navigation Target
  // ============================================
  try {
    final target = await apiDatasource.getNavigationTarget();
    print('Target: ${target.name} (${target.latitude}, ${target.longitude})');
  } catch (e) {
    print('Error getting target: $e');
  }
}

// ============================================
// Data Flow
// ============================================
/*
 * GEOLOCATION FLOW:
 *
 *   geolocator.getPositionStream()
 *   ↓ (Position)
 *   GeolocationLocalDatasource
 *   ↓ (LocationModel)
 *   GeolocationRepositoryImpl
 *   ↓ (LocationEntity)
 *   Domain Layer / Use Cases
 *
 * NAVIGATION FLOW:
 *
 *   NavigationApiDatasource.getNavigationTarget()
 *   ↓ (NavigationTargetModel)
 *   NavigationRepositoryImpl
 *   ↓ calculateBearing() / calculateDistance()
 *   Bearing (degrees) / Distance (meters)
 *   ↓
 *   Domain Layer / Use Cases
 */
