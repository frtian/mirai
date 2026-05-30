import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'evidence_storage_service.dart';

class FlutterEvidenceStorageService implements EvidenceStorageService {
  @override
  Future<String> saveImage({required File sourceFile, required String evidenceId}) async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final evidencesDirectory = Directory(path.join(documentsDirectory.path, 'evidences'));

    if (!await evidencesDirectory.exists()) {
      await evidencesDirectory.create(recursive: true);
    }

    final targetPath = path.join(evidencesDirectory.path, '$evidenceId.jpg');
    final compressedFile = await FlutterImageCompress.compressAndGetFile(
      sourceFile.path,
      targetPath,
      quality: 85,
      format: CompressFormat.jpeg,
    );

    if (compressedFile != null) {
      return compressedFile.path;
    }

    await sourceFile.copy(targetPath);
    return targetPath;
  }
}