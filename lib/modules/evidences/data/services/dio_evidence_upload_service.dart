import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;

import '../../domain/entities/evidence.dart';
import 'evidence_upload_service.dart';

class DioEvidenceUploadService implements EvidenceUploadService {
  DioEvidenceUploadService({
    required this._dio,
    required this._uploadPath,
  });

  final Dio _dio;
  final String _uploadPath;

  @override
  Future<EvidenceUploadResult> uploadEvidence(Evidence evidence) async {
    final multipartFile = await MultipartFile.fromFile(
      evidence.localImagePath,
      filename: path.basename(evidence.localImagePath),
    );

    final formData = FormData.fromMap({
      'image': multipartFile,
      'capturePointId': evidence.capturePointId,
      'capturedAt': evidence.capturedAt.toIso8601String(),
      'latitude': evidence.latitude,
      'longitude': evidence.longitude,
      'altitude': evidence.altitude,
      'accuracyMeters': evidence.accuracyMeters,
      'deviceModel': evidence.deviceModel,
      'uploadedBy': evidence.uploadedBy,
    });

    final response = await _dio.post<dynamic>(
      _uploadPath,
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );

    final data = response.data;
    if (data is Map<String, dynamic>) {
      return EvidenceUploadResult(
        imageUrl: data['imageUrl'] as String?,
        thumbnailUrl: data['thumbnailUrl'] as String?,
      );
    }

    return EvidenceUploadResult();
  }
}