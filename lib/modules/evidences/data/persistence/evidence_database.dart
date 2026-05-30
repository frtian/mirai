import 'package:drift/drift.dart';

import 'evidence_database_connection.dart';

part 'evidence_database.g.dart';

@DataClassName('EvidenceRecord')
class Evidences extends Table {
  TextColumn get id => text()();

  TextColumn get capturePointId => text()();

  TextColumn get uploadedBy => text().nullable()();

  TextColumn get localImagePath => text()();

  TextColumn get imageUrl => text().nullable()();

  TextColumn get thumbnailUrl => text().nullable()();

  DateTimeColumn get capturedAt => dateTime()();

  DateTimeColumn get uploadedAt => dateTime().nullable()();

  RealColumn get latitude => real().nullable()();

  RealColumn get longitude => real().nullable()();

  RealColumn get altitude => real().nullable()();

  RealColumn get accuracyMeters => real().nullable()();

  TextColumn get deviceModel => text()();

  TextColumn get status => text()();

  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [Evidences])
class EvidenceDatabase extends _$EvidenceDatabase {
  EvidenceDatabase() : super(openEvidenceConnection());

  @override
  int get schemaVersion => 1;

  Future<EvidenceRecord?> findEvidenceById(String id) {
    return (select(evidences)..where((table) => table.id.equals(id))).getSingleOrNull();
  }

  Future<void> insertOrUpdateEvidence(EvidencesCompanion companion) {
    return into(evidences).insertOnConflictUpdate(companion);
  }

  Future<int> updateEvidenceStatus(
    String id,
    String status, {
    DateTime? uploadedAt,
    String? imageUrl,
    String? thumbnailUrl,
  }) {
    return (update(evidences)..where((table) => table.id.equals(id))).write(
      EvidencesCompanion(
        status: Value(status),
        uploadedAt: Value(uploadedAt),
        imageUrl: Value(imageUrl),
        thumbnailUrl: Value(thumbnailUrl),
      ),
    );
  }
}
