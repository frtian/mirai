import 'dart:io';

import 'package:uuid/uuid.dart';

import '../../../../core/camera/camera_service.dart';
import '../../../../core/connectivity/connectivity_service.dart';
import '../../../../core/device/device_info_service.dart';
import '../../../../core/location/location_service.dart';
import '../../../../core/storage/evidence_storage_service.dart';
import '../entities/evidence.dart';
import '../entities/evidence_status.dart';
import '../repositories/evidence_repository.dart';

class CaptureEvidenceUseCase {
  CaptureEvidenceUseCase({
    required this._cameraService,
    required this._locationService,
    required this._deviceInfoService,
    required this._connectivityService,
    required this._evidenceStorageService,
    required this._evidenceRepository,
  });

  final CameraService _cameraService;
  final LocationService _locationService;
  final DeviceInfoService _deviceInfoService;
  final ConnectivityService _connectivityService;
  final EvidenceStorageService _evidenceStorageService;
  final EvidenceRepository _evidenceRepository;

  Future<Evidence> call({
    required String capturePointId,
    required String uploadedBy,
  }) async {
    print('Starting evidence capture process...');
    await _cameraService.initialize();
    print('Camera initialized.');
    final capturedFile = await _cameraService.takePicture();
    final now = DateTime.now().toUtc();
    final evidenceId = const Uuid().v4();

    final position = await _locationService.getCurrentPosition();
    final deviceModel = await _deviceInfoService.getDeviceModel();
    final localImagePath = await _evidenceStorageService.saveImage(
      sourceFile: File(capturedFile.path),
      evidenceId: evidenceId,
    );

    final evidence = Evidence(
      id: evidenceId,
      capturePointId: capturePointId,
      uploadedBy: uploadedBy,
      localImagePath: localImagePath,
      capturedAt: now,
      uploadedAt: null,
      latitude: position?.latitude,
      longitude: position?.longitude,
      altitude: position?.altitude,
      accuracyMeters: position?.accuracy,
      deviceModel: deviceModel,
      status: EvidenceStatus.pending,
      createdAt: now,
    );
    print('Evidence created: $evidence');
    await _evidenceRepository.saveLocalEvidence(evidence);

    final hasConnection = await _connectivityService.hasConnection();
    print('Has connection: $hasConnection');
    if (!hasConnection) {
      return evidence;
    }

    await _evidenceRepository.updateStatus(
      evidence.id,
      EvidenceStatus.uploading,
    );

    try {
      print('Uploading evidence: $evidence');
      return await _evidenceRepository.uploadEvidence(evidence);
    } catch (e) {
      print('Upload failed for evidence ${evidence.id}: $e');
      await _evidenceRepository.updateStatus(
        evidence.id,
        EvidenceStatus.failed,
      );
      throw Exception(
        'Falha ao enviar evidência para o servidor. '
        'A captura foi salva localmente e poderá ser reenviada depois. '
        'Erro original: $e',
      );
    }
  }
}
