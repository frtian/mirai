import '../../domain/entities/evidence.dart';
import '../../domain/entities/evidence_status.dart';
import '../models/evidence_model.dart';
import '../persistence/evidence_database.dart';
import 'evidence_local_data_source.dart';

class EvidenceLocalDataSourceImpl implements EvidenceLocalDataSource {
  EvidenceLocalDataSourceImpl(this._database);

  final EvidenceDatabase _database;

  @override
  Future<Evidence> saveLocalEvidence(Evidence evidence) async {
    final model = EvidenceModel.fromEntity(evidence);
    await _database.insertOrUpdateEvidence(model.toCompanion());
    return model.toEntity();
  }

  @override
  Future<Evidence?> getEvidenceById(String id) async {
    final row = await _database.findEvidenceById(id);
    if (row == null) {
      return null;
    }

    return EvidenceModel.fromRow(row).toEntity();
  }

  @override
  Future<Evidence?> updateStatus(
    String id,
    EvidenceStatus status, {
    DateTime? uploadedAt,
    String? imageUrl,
    String? thumbnailUrl,
  }) async {
    final row = await _database.findEvidenceById(id);
    if (row == null) {
      return null;
    }

    await _database.updateEvidenceStatus(
      id,
      status.name,
      uploadedAt: uploadedAt,
      imageUrl: imageUrl,
      thumbnailUrl: thumbnailUrl,
    );

    final updatedRow = await _database.findEvidenceById(id);
    if (updatedRow == null) {
      return null;
    }

    return EvidenceModel.fromRow(updatedRow).toEntity();
  }
}