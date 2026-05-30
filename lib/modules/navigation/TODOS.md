# 📋 NAVIGATION FEATURE - IMPLEMENTATION TODOS

## PHASE 1: LOCATION PERMISSION & SERVICE DIALOG (CRITICAL PATH)

### TODO 1.1: Domain Layer - Location Service Exception
- [ ] Create `lib/modules/navigation/domain/entities/location_service_exception.dart`
  - Define custom exception for location service errors
  - Use for location permission denied, service disabled, etc.

### TODO 1.2: Domain Layer - Location Permission Entity
- [ ] Create `lib/modules/navigation/domain/entities/location_permission_entity.dart`
  - Fields: `isGranted` (bool), `isDenied` (bool), `isDeniedForever` (bool)
  - Use Equatable for value equality

### TODO 1.3: Domain Layer - Location Service Status Entity
- [ ] Create `lib/modules/navigation/domain/entities/location_service_status_entity.dart`
  - Fields: `isEnabled` (bool), `lastChecked` (DateTime)
  - Use Equatable for value equality

### TODO 1.4: Domain Layer - Location Permission Repository (Abstract)
- [ ] Create `lib/modules/navigation/domain/repositories/location_permission_repository.dart`
  - Method: `Future<LocationPermissionEntity> checkPermission()`
  - Method: `Future<LocationPermissionEntity> requestPermission()`
  - Method: `Future<LocationServiceStatusEntity> checkLocationServiceStatus()`
  - Method: `Future<bool> requestLocationService()` - triggers native dialog

### TODO 1.5: Data Layer - Location Permission Datasource
- [ ] Create `lib/modules/navigation/data/datasources/location_permission_datasource.dart`
  - Use `geolocator` package for permission checks
  - Use `location` package ONLY for `requestLocationService()` native dialog
  - Implement methods matching repository interface

### TODO 1.6: Data Layer - Location Permission Repository Implementation
- [ ] Create `lib/modules/navigation/data/repositores/location_permission_repository_impl.dart`
  - Inject `LocationPermissionDatasource`
  - Delegate calls to datasource
  - Handle exceptions and convert to domain layer exceptions

### TODO 1.7: Presentation Layer - Location Permission Riverpod Provider
- [ ] Create `lib/modules/navigation/presentation/controllers/location_permission_provider.dart`
  - Provider: `locationPermissionProvider` - checks current permission status
  - Provider: `locationServiceStatusProvider` - checks if GPS is enabled
  - FutureProvider: `requestLocationPermissionProvider` - requests permission
  - FutureProvider: `requestLocationServiceProvider` - triggers native dialog

### TODO 1.8: Presentation Layer - Location Permission Dialog Widget
- [ ] Create `lib/modules/navigation/presentation/widgets/location_permission_dialog.dart`
  - Shows when permission is not granted
  - Button: "Permitir" - calls `requestLocationPermission`
  - Handles loading state while requesting

### TODO 1.9: Presentation Layer - Location Service Dialog Widget
- [ ] Create `lib/modules/navigation/presentation/widgets/location_service_dialog.dart`
  - Shows when GPS is disabled
  - Shows warning message about location service being required
  - Button: "Ativar Localização" - calls `requestLocationService()` from `location` package
  - This will show native Android dialog WITHOUT leaving app
  - Monitors when user enables location (polling every 2s)

### TODO 1.10: Presentation Layer - Location Guard Page
- [ ] Create `lib/modules/navigation/presentation/pages/location_permission_guard_page.dart`
  - Orchestrates TODO 1.8 and 1.9
  - On init: check permission status
  - If denied: show TODO 1.8 dialog
  - If permission granted but service disabled: show TODO 1.9 dialog
  - If all OK: navigate to navigation_page or callback

### TODO 1.11: Update Navigation Main Page
- [ ] Create/Update `lib/modules/navigation/presentation/pages/navigation_page.dart`
  - This is the main navigation page (after permissions OK)
  - For now: placeholder with "Location OK" message
  - Will add compass + instructions in later phases

---

## PHASE 2: DOMAIN LAYER - ENTITIES & REPOSITORIES

### TODO 2.1: Location Entity
- [ ] Create `lib/modules/navigation/domain/entities/location_entity.dart`
  - Fields: `latitude` (double), `longitude` (double), `accuracy` (double), `timestamp` (DateTime)
  - Use Equatable for value equality

### TODO 2.2: Navigation Target Entity
- [ ] Create `lib/modules/navigation/domain/entities/navigation_target_entity.dart`
  - Fields: `id` (String), `latitude` (double), `longitude` (double), `name` (String), `description` (String)
  - Use Equatable for value equality

### TODO 2.3: Navigation Instruction Entity
- [ ] Create `lib/modules/navigation/domain/entities/navigation_instruction_entity.dart`
  - Fields: `text` (String), `distance` (double), `bearing` (double), `instructionType` (enum: TURN_LEFT, TURN_RIGHT, CONTINUE, ARRIVED)
  - Use Equatable for value equality

### TODO 2.4: Geolocation Repository (Abstract)
- [ ] Create `lib/modules/navigation/domain/repositories/geolocation_repository.dart`
  - Method: `Stream<LocationEntity> getLocationStream()` - continuous GPS updates
  - Method: `Future<LocationEntity> getCurrentLocation()` - one-time location

### TODO 2.5: Navigation Repository (Abstract)
- [ ] Create `lib/modules/navigation/domain/repositories/navigation_repository.dart`
  - Method: `Future<NavigationTargetEntity> getNavigationTarget()` - from mock API
  - Method: `Stream<NavigationInstructionEntity> getNavigationInstructions(LocationEntity current, NavigationTargetEntity target)` - calculates bearing + distance

---

## PHASE 3: DOMAIN LAYER - USE CASES

### TODO 3.1: Get Current Location UseCase
- [ ] Create `lib/modules/navigation/domain/usecases/get_current_location_usecase.dart`
  - Inject `GeolocationRepository`
  - Execute: returns `Future<LocationEntity>`

### TODO 3.2: Get Location Stream UseCase
- [ ] Create `lib/modules/navigation/domain/usecases/get_location_stream_usecase.dart`
  - Inject `GeolocationRepository`
  - Execute: returns `Stream<LocationEntity>`

### TODO 3.3: Calculate Bearing UseCase
- [ ] Create `lib/modules/navigation/domain/usecases/calculate_bearing_usecase.dart`
  - Inject `qibla` package
  - Params: `from` (LocationEntity), `to` (NavigationTargetEntity)
  - Execute: returns `Future<double>` (bearing in degrees 0-360)

### TODO 3.4: Calculate Distance UseCase
- [ ] Create `lib/modules/navigation/domain/usecases/calculate_distance_usecase.dart`
  - Inject `qibla` or `haversine_distance` package
  - Params: `from` (LocationEntity), `to` (NavigationTargetEntity)
  - Execute: returns `Future<double>` (distance in meters)

### TODO 3.5: Navigate to Target UseCase
- [ ] Create `lib/modules/navigation/domain/usecases/navigate_to_target_usecase.dart`
  - Inject `GeolocationRepository`, `NavigationRepository`
  - Execute: returns `Stream<NavigationInstructionEntity>`
  - Combines location stream + bearing/distance calculations

---

## PHASE 4: DATA LAYER - DATASOURCES

### TODO 4.1: Geolocation Local Datasource
- [ ] Create `lib/modules/navigation/data/datasources/geolocation_local_datasource.dart`
  - Use `geolocator` package
  - Method: `Stream<Position> getLocationStream()` with distanceFilter=5m, accuracy=high
  - Method: `Future<Position> getCurrentLocation()`
  - Handle permission checks before returning streams

### TODO 4.2: Navigation Mock API Datasource
- [ ] Create `lib/modules/navigation/data/datasources/navigation_api_datasource.dart`
  - Mock API with hardcoded navigation targets
  - Method: `Future<NavigationTargetModel> getNavigationTarget()`
  - Return: target with specific lat/lng for testing
  - Example: Lat: -23.5505, Lng: -46.6333 (São Paulo)

### TODO 4.3: Magnetometer Datasource (Optional - for Phase 5)
- [ ] Create `lib/modules/navigation/data/datasources/magnetometer_datasource.dart`
  - Use `sensors_plus` package
  - Method: `Stream<double> getBearingStream()` - device heading from magnetometer
  - Convert magnetometer data to bearing (0-360)

---

## PHASE 5: DATA LAYER - MODELS & REPOSITORY IMPLEMENTATIONS

### TODO 5.1: Location Model
- [ ] Create `lib/modules/navigation/data/models/location_model.dart`
  - Extends `LocationEntity`
  - Add `fromPosition()` factory constructor (from geolocator Position)
  - Add `toJson()` / `fromJson()` for serialization

### TODO 5.2: Navigation Target Model
- [ ] Create `lib/modules/navigation/data/models/navigation_target_model.dart`
  - Extends `NavigationTargetEntity`
  - Add `fromJson()` factory for API responses

### TODO 5.3: Navigation Instruction Model
- [ ] Create `lib/modules/navigation/data/models/navigation_instruction_model.dart`
  - Extends `NavigationInstructionEntity`

### TODO 5.4: Geolocation Repository Implementation
- [ ] Create `lib/modules/navigation/data/repositores/geolocation_repository_impl.dart`
  - Inject `GeolocationLocalDatasource`
  - Implement `getLocationStream()` - wrap datasource stream
  - Implement `getCurrentLocation()` - wrap datasource call
  - Convert Position → LocationModel → LocationEntity

### TODO 5.5: Navigation Repository Implementation
- [ ] Create `lib/modules/navigation/data/repositores/navigation_repository_impl.dart`
  - Inject `NavigationApiDatasource`
  - Implement `getNavigationTarget()` - call mock API
  - Implement `getNavigationInstructions()` - combine bearing + distance streams

---

## PHASE 6: PRESENTATION LAYER - STATE MANAGEMENT (RIVERPOD)

### TODO 6.1: Geolocation Providers
- [ ] Create `lib/modules/navigation/presentation/controllers/geolocation_provider.dart`
  - Provider: `geolocationRepositoryProvider` - dependency injection
  - StreamProvider: `currentLocationProvider` - continuous location updates
  - FutureProvider: `currentLocationOnceProvider` - one-time location

### TODO 6.2: Navigation Target Provider
- [ ] Create `lib/modules/navigation/presentation/controllers/navigation_target_provider.dart`
  - Provider: `navigationRepositoryProvider` - dependency injection
  - FutureProvider: `navigationTargetProvider` - get mock target

### TODO 6.3: Bearing & Distance Providers
- [ ] Create `lib/modules/navigation/presentation/controllers/navigation_calculation_provider.dart`
  - Provider: `bearingProvider(LocationEntity, NavigationTargetEntity)` - calculate bearing
  - Provider: `distanceProvider(LocationEntity, NavigationTargetEntity)` - calculate distance
  - Provider: `navigationInstructionProvider(bearing, distance)` - generate instruction text

### TODO 6.4: Navigation Instruction Provider
- [ ] Create `lib/modules/navigation/presentation/controllers/navigation_instruction_provider.dart`
  - StreamProvider: `navigationInstructionStreamProvider` - combines location + target
  - Generates voice instruction text based on bearing + distance

---

## PHASE 7: PRESENTATION LAYER - WIDGETS

### TODO 7.1: Distance Display Widget
- [ ] Create `lib/modules/navigation/presentation/widgets/distance_display_widget.dart`
  - Shows distance in meters/km
  - Updates from provider in real-time
  - Format: "250 m" or "1.2 km"

### TODO 7.2: Navigation Instruction Widget
- [ ] Create `lib/modules/navigation/presentation/widgets/navigation_instruction_widget.dart`
  - Shows current instruction text
  - Updates from provider in real-time
  - Example: "Siga por 250 metros nessa direção"

### TODO 7.3: Compass 3D Widget (PHASE 7A - CustomPaint Version)
- [ ] Create `lib/modules/navigation/presentation/widgets/compass_3d_widget.dart`
  - Use CustomPaint (lighter than Flame for MVP)
  - Draw compass circle with cardinal directions (N, S, E, W)
  - Draw rotating arrow pointing to bearing (0-360°)
  - Update bearing from provider in real-time
  - Smooth animation using AnimationController

---

## PHASE 8: PRESENTATION LAYER - PAGES

### TODO 8.1: Navigation Main Page (Complete)
- [ ] Update `lib/modules/navigation/presentation/pages/navigation_page.dart`
  - Wrap in `ConsumerWidget` for Riverpod
  - Show TODO 7.1 (distance)
  - Show TODO 7.2 (instruction)
  - Show TODO 7.3 (compass)
  - Scaffold with AppBar + safe area
  - Handle loading/error states from providers

---

## PHASE 9: TEXT-TO-SPEECH INTEGRATION

### TODO 9.1: TTS Controller
- [ ] Create `lib/modules/navigation/presentation/controllers/tts_controller.dart`
  - Use `flutter_tts` package
  - Method: `speak(String text)` - speaks instruction
  - Method: `stop()` - stops speaking
  - Handle language setup (pt-BR)

### TODO 9.2: TTS Provider
- [ ] Create `lib/modules/navigation/presentation/controllers/tts_provider.dart`
  - Provider: `ttsProvider` - singleton instance
  - Listen to navigation instruction provider
  - Auto-speak when instruction changes (debounced)

---

## PHASE 10: TESTING & REFINEMENT

### TODO 10.1: Unit Tests - Domain Layer
- [ ] Create tests for usecases (mocking repositories)
- [ ] Create tests for entities (value equality)

### TODO 10.2: Unit Tests - Data Layer
- [ ] Mock geolocator Position
- [ ] Test datasource conversions to models/entities

### TODO 10.3: Integration Tests
- [ ] Test full flow: permission → location stream → bearing calculation → UI update

---

## QUICK REFERENCE: PACKAGE VERSIONS TO ADD

```yaml
dependencies:
  geolocator: ^11.1.0           # Location streaming + permissions
  location: ^5.0.0              # Native dialog for location service (DO NOT use for streaming)
  flutter_tts: ^8.2.0           # Text-to-speech
  sensors_plus: ^7.0.0          # Magnetometer for bearing
  qibla: ^1.0.1                 # Bearing + distance calculation
  flutter_riverpod: ^2.4.0      # State management
  equatable: ^2.0.5             # Value equality for entities
  flame: ^1.22.0                # 2D rendering (Phase 7B+)
```

---

## EXECUTION ORDER

1. **TODO 1.1 - 1.11** (Permission & Location Service Dialog) ← START HERE
2. **TODO 2.1 - 2.5** (Domain entities + repositories)
3. **TODO 3.1 - 3.5** (Domain use cases)
4. **TODO 4.1 - 4.3** (Data datasources)
5. **TODO 5.1 - 5.5** (Data models + repository impl)
6. **TODO 6.1 - 6.4** (Riverpod providers)
7. **TODO 7.1 - 7.3** (Widgets)
8. **TODO 8.1** (Main navigation page)
9. **TODO 9.1 - 9.2** (TTS integration)
10. **TODO 10.1 - 10.3** (Testing)

---

## KEY DECISIONS

✅ Use `location` package ONLY for `requestService()` native dialog
✅ Use `geolocator` for all location streaming and permission checks
✅ CustomPaint for compass (Phase 7A - MVP), Flame later (Phase 7B)
✅ Riverpod StreamProviders for real-time location/bearing updates
✅ Equatable for entity value equality in comparisons
✅ Clean Architecture: Datasource → Model → Entity → Provider → Widget

---

## NOTES

- Location service dialog will show NATIVE Android dialog without leaving app
- User can enable GPS from that dialog and return to app automatically
- Dialog polls every 2 seconds to detect when GPS is enabled
- All streams use distanceFilter=5m to avoid constant UI updates
- TTS uses debouncing to avoid speaking every location update
