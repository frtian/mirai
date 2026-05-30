import '../entities/evidence.dart';
import '../entities/evidence_status.dart';

abstract class EvidenceRepository {
  Future<Evidence> saveLocalEvidence(Evidence evidence);

  Future<Evidence?> getEvidenceById(String id);

  Future<Evidence> uploadEvidence(Evidence evidence);

  Future<Evidence?> updateStatus(
    String id,
    EvidenceStatus status, {
    DateTime? uploadedAt,
    String? imageUrl,
    String? thumbnailUrl,
  });
}