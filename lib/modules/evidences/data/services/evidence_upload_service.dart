import '../../domain/entities/evidence.dart';

class EvidenceUploadResult {
  EvidenceUploadResult({this.imageUrl, this.thumbnailUrl});

  final String? imageUrl;
  final String? thumbnailUrl;
}

abstract class EvidenceUploadService {
  Future<EvidenceUploadResult> uploadEvidence(Evidence evidence);
}