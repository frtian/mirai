import 'package:mirai/modules/navigation/domain/entities/navigation_target_entity.dart';

/// Data layer model that extends the domain layer NavigationTargetEntity
/// Adds conversion methods and data layer-specific functionality
class NavigationTargetModel extends NavigationTargetEntity {
  const NavigationTargetModel({
    required super.id,
    required super.latitude,
    required super.longitude,
    required super.name,
    required super.description,
  });

  /// Factory constructor to create NavigationTargetModel from JSON
  /// Useful for API responses
  factory NavigationTargetModel.fromJson(Map<String, dynamic> json) {
    return NavigationTargetModel(
      id: json['id'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      name: json['name'] as String,
      description: json['description'] as String,
    );
  }

  /// Convert NavigationTargetModel to NavigationTargetEntity
  /// Useful for explicit conversions between layers
  NavigationTargetEntity toEntity() {
    return NavigationTargetEntity(
      id: id,
      latitude: latitude,
      longitude: longitude,
      name: name,
      description: description,
    );
  }

  /// Convert NavigationTargetModel to JSON
  /// Useful for API requests or local storage
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'description': description,
    };
  }
}
