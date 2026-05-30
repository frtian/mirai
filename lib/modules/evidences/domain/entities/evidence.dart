import 'evidence_status.dart';

class Evidence {
  const Evidence({
    required this.id,
    required this.capturePointId,
    required this.localImagePath,
    required this.capturedAt,
    required this.deviceModel,
    required this.status,
    required this.createdAt,
    this.uploadedBy,
    this.imageUrl,
    this.thumbnailUrl,
    this.uploadedAt,
    this.latitude,
    this.longitude,
    this.altitude,
    this.accuracyMeters,
  });

  final String id;
  final String capturePointId;
  final String? uploadedBy;
  final String localImagePath;
  final String? imageUrl;
  final String? thumbnailUrl;
  final DateTime capturedAt;
  final DateTime? uploadedAt;
  final double? latitude;
  final double? longitude;
  final double? altitude;
  final double? accuracyMeters;
  final String deviceModel;
  final EvidenceStatus status;
  final DateTime createdAt;

  Evidence copyWith({
    String? id,
    String? capturePointId,
    String? uploadedBy,
    String? localImagePath,
    String? imageUrl,
    String? thumbnailUrl,
    DateTime? capturedAt,
    DateTime? uploadedAt,
    double? latitude,
    double? longitude,
    double? altitude,
    double? accuracyMeters,
    String? deviceModel,
    EvidenceStatus? status,
    DateTime? createdAt,
  }) {
    return Evidence(
      id: id ?? this.id,
      capturePointId: capturePointId ?? this.capturePointId,
      uploadedBy: uploadedBy ?? this.uploadedBy,
      localImagePath: localImagePath ?? this.localImagePath,
      imageUrl: imageUrl ?? this.imageUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      capturedAt: capturedAt ?? this.capturedAt,
      uploadedAt: uploadedAt ?? this.uploadedAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      altitude: altitude ?? this.altitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      deviceModel: deviceModel ?? this.deviceModel,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}