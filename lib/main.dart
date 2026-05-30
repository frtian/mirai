import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/router.dart';
import 'core/camera/camera_service.dart';
import 'core/camera/flutter_camera_service.dart';
import 'core/connectivity/flutter_connectivity_service.dart';
import 'core/device/flutter_device_info_service.dart';
import 'core/location/flutter_location_service.dart';
import 'core/storage/flutter_evidence_storage_service.dart';
import 'modules/evidences/data/datasources/evidence_local_data_source_impl.dart';
import 'modules/evidences/data/persistence/evidence_database.dart';
import 'modules/evidences/data/repositories/evidence_repository_impl.dart';
import 'modules/evidences/data/services/dio_evidence_upload_service.dart';
import 'modules/evidences/domain/usecases/capture_evidence_usecase.dart';
import 'modules/evidences/presentation/pages/capture_evidence_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar apenas o essencial: database (rápido)
  final evidenceDatabase = EvidenceDatabase();

  // Camera service será lazy-loaded quando necessário
  // Todos os outros services serão criados sob demanda

  runApp(ProviderScope(child: MiraiApp(evidenceDatabase: evidenceDatabase)));
}

class MiraiApp extends StatelessWidget {
  const MiraiApp({super.key, required this.evidenceDatabase});

  final EvidenceDatabase evidenceDatabase;

  @override
  Widget build(BuildContext context) {
    final router = createAppRouter(cameraPageBuilder: _buildCameraPage);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Mirai',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0F766E)),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }

  /// Build camera page on-demand (lazy loading)
  Widget _buildCameraPage() {
    // Inicializar services apenas quando a página de câmera é acessada
    final cameraService = FlutterCameraService();
    final locationService = FlutterLocationService();
    final deviceInfoService = FlutterDeviceInfoService();
    final connectivityService = FlutterConnectivityService();
    final evidenceStorageService = FlutterEvidenceStorageService();
    final evidenceLocalDataSource = EvidenceLocalDataSourceImpl(
      evidenceDatabase,
    );
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

    return CaptureEvidencePage(
      cameraService: cameraService,
      captureEvidenceUseCase: captureEvidenceUseCase,
    );
  }
}
