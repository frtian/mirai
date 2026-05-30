import '../../domain/entities/evidence.dart';
import '../../domain/entities/evidence_status.dart';
import '../../domain/repositories/evidence_repository.dart';
import '../datasources/evidence_local_data_source.dart';
import '../services/evidence_upload_service.dart';

class EvidenceRepositoryImpl implements EvidenceRepository {
  EvidenceRepositoryImpl({
    required this._localDataSource,
    required this._uploadService,
  });

  final EvidenceLocalDataSource _localDataSource;
  final EvidenceUploadService _uploadService;

  @override
  Future<Evidence> saveLocalEvidence(Evidence evidence) {
    return _localDataSource.saveLocalEvidence(evidence);
  }

  @override
  Future<Evidence?> getEvidenceById(String id) {
    return _localDataSource.getEvidenceById(id);
  }

  @override
  Future<Evidence> uploadEvidence(Evidence evidence) async {
    final result = await _uploadService.uploadEvidence(evidence);

    final uploadedEvidence = evidence.copyWith(
      imageUrl: result.imageUrl ?? evidence.imageUrl,
      thumbnailUrl: result.thumbnailUrl ?? evidence.thumbnailUrl,
      uploadedAt: DateTime.now().toUtc(),
      status: EvidenceStatus.synced,
    );

    final updated = await _localDataSource.updateStatus(
      uploadedEvidence.id,
      EvidenceStatus.synced,
      uploadedAt: uploadedEvidence.uploadedAt,
      imageUrl: uploadedEvidence.imageUrl,
      thumbnailUrl: uploadedEvidence.thumbnailUrl,
    );

    return updated ?? uploadedEvidence;
  }

  @override
  Future<Evidence?> updateStatus(
    String id,
    EvidenceStatus status, {
    DateTime? uploadedAt,
    String? imageUrl,
    String? thumbnailUrl,
  }) {
    return _localDataSource.updateStatus(
      id,
      status,
      uploadedAt: uploadedAt,
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
    );
  }
}