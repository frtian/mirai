import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'core/camera/camera_service.dart';
import 'core/camera/flutter_camera_service.dart';
import 'core/connectivity/flutter_connectivity_service.dart';
import 'core/device/flutter_device_info_service.dart';
import 'core/location/flutter_location_service.dart';
import 'core/storage/flutter_evidence_storage_service.dart';
import 'modules/authentication/presentation/pages/auth_page.dart';
import 'modules/evidences/data/datasources/evidence_local_data_source_impl.dart';
import 'modules/evidences/data/persistence/evidence_database.dart';
import 'modules/evidences/data/repositories/evidence_repository_impl.dart';
import 'modules/evidences/data/services/dio_evidence_upload_service.dart';
import 'modules/evidences/domain/usecases/capture_evidence_usecase.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final evidenceDatabase = EvidenceDatabase();
  final cameraService = FlutterCameraService();
  final locationService = FlutterLocationService();
  final deviceInfoService = FlutterDeviceInfoService();
  final connectivityService = FlutterConnectivityService();
  final evidenceStorageService = FlutterEvidenceStorageService();
  final evidenceLocalDataSource = EvidenceLocalDataSourceImpl(evidenceDatabase);
  final evidenceUploadService = DioEvidenceUploadService(
    dio: Dio(),
    uploadPath: '/evidences',
  );

  final captureEvidenceUseCase = CaptureEvidenceUseCase(
    cameraService: cameraService,
    locationService: locationService,
    deviceInfoService: deviceInfoService,
    connectivityService: connectivityService,
    evidenceStorageService: evidenceStorageService,
    evidenceRepository: EvidenceRepositoryImpl(
      localDataSource: evidenceLocalDataSource,
      uploadService: evidenceUploadService,
    ),
  );

  runApp(
    MiraiApp(
      cameraService: cameraService,
      captureEvidenceUseCase: captureEvidenceUseCase,
    ),
  );
}

class MiraiApp extends StatelessWidget {
  const MiraiApp({
    super.key,
    required this.cameraService,
    required this.captureEvidenceUseCase,
  });

  final CameraService cameraService;
  final CaptureEvidenceUseCase captureEvidenceUseCase;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mirai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      home: AuthPage(
        onCodeSubmitted: (_) async {
          return;
        },
      ),
    );
  }
}
