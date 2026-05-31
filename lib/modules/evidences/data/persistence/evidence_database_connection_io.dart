import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

QueryExecutor openEvidenceConnection() {
  return LazyDatabase(() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbFolder = Directory(path.join(documentsDirectory.path, 'db'));
    if (!await dbFolder.exists()) {
      await dbFolder.create(recursive: true);
    }

    final file = File(path.join(dbFolder.path, 'evidences.sqlite'));
    return NativeDatabase(file);
  });
}