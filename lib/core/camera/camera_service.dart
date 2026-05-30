import 'package:camera/camera.dart';

abstract class CameraService {
  CameraController? get controller;

  bool get isInitialized;

  Future<void> initialize();

  Future<XFile> takePicture();

  Future<void> dispose();
}