import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/camera/camera_service.dart';
import '../../domain/entities/evidence.dart';
import '../../domain/usecases/capture_evidence_usecase.dart';
import 'evidence_test_page.dart';

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
        return;
      }

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => EvidenceTestPage(evidence: evidence),
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
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isCapturing ? null : _captureEvidence,
                  icon: _isCapturing
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.camera_alt),
                  label: Text(_isCapturing ? 'Capturando...' : 'Capturar evidência'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
