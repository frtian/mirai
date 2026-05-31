import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/camera/camera_service.dart';
import '../../../../design_system/app_colors.dart';
import '../../domain/entities/evidence.dart';
import '../../domain/usecases/capture_evidence_usecase.dart';
import 'capture_success_page.dart';

class CaptureEvidencePage extends StatefulWidget {
  const CaptureEvidencePage({
    super.key,
    required this.cameraService,
    required this.captureEvidenceUseCase,
  });

  final CameraService cameraService;
  final CaptureEvidenceUseCase captureEvidenceUseCase;

  @override
  State<CaptureEvidencePage> createState() => _CaptureEvidencePageState();
}

class _CaptureEvidencePageState extends State<CaptureEvidencePage> {
  bool _isLoading = true;
  bool _isCapturing = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      await widget.cameraService.initialize();
    } catch (error) {
      _errorMessage = error.toString();
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _captureEvidence() async {
    setState(() {
      _isCapturing = true;
      _errorMessage = null;
    });

    try {
      final evidence = await widget.captureEvidenceUseCase(
        capturePointId: 'default-capture-point',
        uploadedBy: 'local-user',
      );

      if (!mounted) {
        print('Evidence captured123: $evidence');
        return;
      }
      print('Evidence captured456: $evidence');
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => CaptureSuccessPage(evidence: evidence),
        ),
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          _errorMessage = error.toString();
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isCapturing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    widget.cameraService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.cameraService.controller;

    return Scaffold(
      appBar: AppBar(title: const Text('Captura de evidências')),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : controller == null || !controller.value.isInitialized
                  ? Center(child: Text(_errorMessage ?? 'Câmera indisponível.'))
                  : CameraPreview(controller),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isCapturing ? null : _captureEvidence,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  icon: _isCapturing
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.onPrimary,
                          ),
                        )
                      : const Icon(Icons.camera_alt),
                  label: Text(
                    _isCapturing ? 'CAPTURANDO...' : 'CAPTURAR EVIDÊNCIA',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
