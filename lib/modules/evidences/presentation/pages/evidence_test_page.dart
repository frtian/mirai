import 'package:flutter/material.dart';

import '../../domain/entities/evidence.dart';

class EvidenceTestPage extends StatelessWidget {
  const EvidenceTestPage({super.key, required this.evidence});

  final Evidence evidence;

  @override
  Widget build(BuildContext context) {
    final fields = <MapEntry<String, String>>[
      MapEntry('id', evidence.id),
      MapEntry('capturePointId', evidence.capturePointId),
      MapEntry('uploadedBy', '${evidence.uploadedBy}'),
      MapEntry('localImagePath', evidence.localImagePath),
      MapEntry('imageUrl', '${evidence.imageUrl}'),
      MapEntry('thumbnailUrl', '${evidence.thumbnailUrl}'),
      MapEntry('capturedAt', evidence.capturedAt.toIso8601String()),
      MapEntry('uploadedAt', '${evidence.uploadedAt}'),
      MapEntry('latitude', '${evidence.latitude}'),
      MapEntry('longitude', '${evidence.longitude}'),
      MapEntry('altitude', '${evidence.altitude}'),
      MapEntry('accuracyMeters', '${evidence.accuracyMeters}'),
      MapEntry('deviceModel', evidence.deviceModel),
      MapEntry('status', evidence.status.name),
      MapEntry('createdAt', evidence.createdAt.toIso8601String()),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Evidence Test')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            for (final field in fields)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text('${field.key}: ${field.value}'),
              ),
          ],
        ),
      ),
    );
  }
}