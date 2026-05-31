import 'package:mirai/modules/properties/domain/entities/capture_point_entity.dart';

class CapturePointModel extends CapturePointEntity {
  const CapturePointModel({
    required super.id,
    required super.name,
    super.propertyName,
    super.nextCaptureAt,
    required super.hasEvidences,
    required super.evidencesCount,
  });

  factory CapturePointModel.fromMap(Map<String, dynamic> map) {
    DateTime? next;
    final nextRaw = map['nextCaptureAt'] ?? map['next_capture_at'];
    if (nextRaw is String && nextRaw.isNotEmpty) {
      try {
        next = DateTime.parse(nextRaw).toLocal();
      } catch (_) {
        next = null;
      }
    }

    return CapturePointModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      propertyName: (map['propertyName'] as String?) ?? (map['property_name'] as String?),
      nextCaptureAt: next,
      hasEvidences: map['hasEvidences'] as bool? ?? map['has_evidences'] as bool? ?? false,
      evidencesCount: (map['evidencesCount'] as int?) ?? (map['evidences_count'] as int?) ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'propertyName': propertyName,
      'nextCaptureAt': nextCaptureAt?.toIso8601String(),
      'hasEvidences': hasEvidences,
      'evidencesCount': evidencesCount,
    };
  }
}
