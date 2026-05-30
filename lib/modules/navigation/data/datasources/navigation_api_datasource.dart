/// Exception thrown when API operation fails
class NavigationApiDatasourceException implements Exception {
  final String message;
  final String? code;
  final dynamic originalException;

  NavigationApiDatasourceException({
    required this.message,
    this.code,
    this.originalException,
  });

  @override
  String toString() =>
      'NavigationApiDatasourceException: $message${code != null ? ' (code: $code)' : ''}';
}

/// Model for navigation target (data layer only)
class NavigationTargetModel {
  final String id;
  final double latitude;
  final double longitude;
  final String name;
  final String description;

  NavigationTargetModel({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.description,
  });

  @override
  String toString() =>
      'NavigationTargetModel('
      'id: $id, '
      'latitude: $latitude, '
      'longitude: $longitude, '
      'name: $name, '
      'description: $description'
      ')';
}

/// Mock API datasource for navigation targets
/// Pure data layer - no domain knowledge
/// Returns fixed navigation targets (mock implementation)
class NavigationApiDatasource {
  /// Gets the fixed navigation target
  ///
  /// In a real application, this would make an HTTP request to an API.
  /// For now, returns a mock target with coordinates:
  /// - latitude: -10.191056
  /// - longitude: -48.316806
  Future<NavigationTargetModel> getNavigationTarget() async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 100));

      // Return mock target
      return NavigationTargetModel(
        id: 'target_001',
        latitude: -10.191056,
        longitude: -48.316806,
        name: 'Araguaia Region',
        description: 'Environmental recovery area in the Araguaia region',
      );
    } catch (e) {
      throw NavigationApiDatasourceException(
        message: 'Failed to get navigation target',
        code: 'API_ERROR',
        originalException: e,
      );
    }
  }

  /// Gets navigation target by ID
  ///
  /// For the mock implementation, only 'target_001' is available.
  Future<NavigationTargetModel> getNavigationTargetById(String id) async {
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 100));

      if (id != 'target_001') {
        throw NavigationApiDatasourceException(
          message: 'Target not found: $id',
          code: 'NOT_FOUND',
        );
      }

      return NavigationTargetModel(
        id: 'target_001',
        latitude: -10.191056,
        longitude: -48.316806,
        name: 'Araguaia Region',
        description: 'Environmental recovery area in the Araguaia region',
      );
    } catch (e) {
      if (e is NavigationApiDatasourceException) rethrow;
      throw NavigationApiDatasourceException(
        message: 'Failed to get navigation target',
        code: 'API_ERROR',
        originalException: e,
      );
    }
  }
}
