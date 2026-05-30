import 'dart:io';

abstract class EvidenceStorageService {
  Future<String> saveImage({required File sourceFile, required String evidenceId});
}