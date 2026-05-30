import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../core/camera/camera_service.dart';
import '../../domain/entities/evidence.dart';
import '../../domain/usecases/capture_evidence_usecase.dart';

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
  Evidence? _lastEvidence;
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

      setState(() {
        _lastEvidence = evidence;
      });
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
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            CameraPreview(controller),
                            Positioned(
                              left: 16,
                              right: 16,
                              bottom: 16,
                              child: _StatusCard(
                                evidence: _lastEvidence,
                                errorMessage: _errorMessage,
                              ),
                            ),
                          ],
                        ),
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.evidence,
    required this.errorMessage,
  });

  final Evidence? evidence;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final text = errorMessage != null
        ? errorMessage!
        : evidence == null
            ? 'Pronto para capturar uma evidência.'
            : 'Evidência ${evidence!.id} • ${evidence!.status.name}';

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text(text),
      ),
    );
  }
}