import 'package:drift/drift.dart';

import '../../domain/entities/evidence.dart';
import '../../domain/entities/evidence_status.dart';
import '../persistence/evidence_database.dart';

class EvidenceModel {
  const EvidenceModel({
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

  factory EvidenceModel.fromEntity(Evidence evidence) {
    return EvidenceModel(
      id: evidence.id,
      capturePointId: evidence.capturePointId,
      uploadedBy: evidence.uploadedBy,
      localImagePath: evidence.localImagePath,
      imageUrl: evidence.imageUrl,
      thumbnailUrl: evidence.thumbnailUrl,
      capturedAt: evidence.capturedAt,
      uploadedAt: evidence.uploadedAt,
      latitude: evidence.latitude,
      longitude: evidence.longitude,
      altitude: evidence.altitude,
      accuracyMeters: evidence.accuracyMeters,
      deviceModel: evidence.deviceModel,
      status: evidence.status,
      createdAt: evidence.createdAt,
    );
  }

  factory EvidenceModel.fromRow(EvidenceRecord row) {
    return EvidenceModel(
      id: row.id,
      capturePointId: row.capturePointId,
      uploadedBy: row.uploadedBy,
      localImagePath: row.localImagePath,
      imageUrl: row.imageUrl,
      thumbnailUrl: row.thumbnailUrl,
      capturedAt: row.capturedAt,
      uploadedAt: row.uploadedAt,
      latitude: row.latitude,
      longitude: row.longitude,
      altitude: row.altitude,
      accuracyMeters: row.accuracyMeters,
      deviceModel: row.deviceModel,
      status: EvidenceStatus.values.byName(row.status),
      createdAt: row.createdAt,
    );
  }

  Evidence toEntity() {
    return Evidence(
      id: id,
      capturePointId: capturePointId,
      uploadedBy: uploadedBy,
      localImagePath: localImagePath,
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
      capturedAt: capturedAt,
      uploadedAt: uploadedAt,
      latitude: latitude,
      longitude: longitude,
      altitude: altitude,
      accuracyMeters: accuracyMeters,
      deviceModel: deviceModel,
      status: status,
      createdAt: createdAt,
    );
  }

  EvidencesCompanion toCompanion() {
    return EvidencesCompanion.insert(
      id: id,
      capturePointId: capturePointId,
      uploadedBy: Value(uploadedBy),
      localImagePath: localImagePath,
      imageUrl: Value(imageUrl),
      thumbnailUrl: Value(thumbnailUrl),
      capturedAt: capturedAt,
      uploadedAt: Value(uploadedAt),
      latitude: Value(latitude),
      longitude: Value(longitude),
      altitude: Value(altitude),
      accuracyMeters: Value(accuracyMeters),
      deviceModel: deviceModel,
      status: status.name,
      createdAt: createdAt,
    );
  }
}