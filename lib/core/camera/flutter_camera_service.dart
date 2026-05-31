import 'package:camera/camera.dart';

import 'camera_service.dart';

class FlutterCameraService implements CameraService {
  FlutterCameraService({this.lensDirection = CameraLensDirection.back});

  final CameraLensDirection lensDirection;
  CameraController? _controller;
  List<CameraDescription>? _availableCameras;
  Future<void>? _initializing;
  bool _initialized = false;
  bool _captureInProgress = false;

  @override
  CameraController? get controller => _controller;

  @override
  bool get isInitialized => _initialized;

  @override
  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    final initializing = _initializing;
    if (initializing != null) {
      return initializing;
    }

    final loading = _loadAndInitialize();
    _initializing = loading;
    try {
      await loading;
    } finally {
      _initializing = null;
    }
  }

  Future<void> _loadAndInitialize() async {
    final cameras = _availableCameras ?? await availableCameras();
    _availableCameras = cameras;

    if (cameras.isEmpty) {
      throw StateError('Nenhuma câmera disponível.');
    }

    final selectedCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == lensDirection,
      orElse: () => cameras.first,
    );

    final controller = CameraController(
      selectedCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await controller.initialize();
    _controller = controller;
    _initialized = true;
  }

  @override
  Future<XFile> takePicture() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      throw StateError('A câmera ainda não foi inicializada.');
    }

    if (_captureInProgress) {
      throw StateError('Uma captura já está em andamento.');
    }

    _captureInProgress = true;

    try {
      return await controller.takePicture();
    } on CameraException catch (error) {
      if (error.code == 'cameraNotReadable') {
        await _recoverCameraSession();
        final recoveredController = _controller;
        if (recoveredController == null || !recoveredController.value.isInitialized) {
          rethrow;
        }

        return recoveredController.takePicture();
      }

      rethrow;
    } finally {
      _captureInProgress = false;
    }
  }

  @override
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _initialized = false;
    _captureInProgress = false;
  }

  Future<void> _recoverCameraSession() async {
    final controller = _controller;
    if (controller != null) {
      await controller.dispose();
    }

    _controller = null;
    _initialized = false;

    await _loadAndInitialize();
  }
}