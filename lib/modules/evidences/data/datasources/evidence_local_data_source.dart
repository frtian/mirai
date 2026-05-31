import '../../domain/entities/evidence.dart';
import '../../domain/entities/evidence_status.dart';

abstract class EvidenceLocalDataSource {
  Future<Evidence> saveLocalEvidence(Evidence evidence);

  Future<Evidence?> getEvidenceById(String id);

  Future<Evidence?> updateStatus(
    String id,
    EvidenceStatus status, {
    DateTime? uploadedAt,
    String? imageUrl,
    String? thumbnailUrl,
  });
}