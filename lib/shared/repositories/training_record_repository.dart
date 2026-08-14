import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/training_item.dart';
import '../models/training_record.dart';

abstract class TrainingRecordRepository {
  Future<int> add(TrainingRecord record);
  Future<List<TrainingRecord>> getForUser(int userId);

  // EHO export (Sprint 031) — every training record at a site, regardless
  // of user, for the export's training-summary line and expired-training
  // exceptions subsection. Site-scoped the same way TaskSubmission's own
  // export query is.
  Future<List<TrainingRecord>> getForSite(int siteId);
}

class DriftTrainingRecordRepository implements TrainingRecordRepository {
  DriftTrainingRecordRepository(this._db);

  final AppDatabase _db;

  @override
  Future<int> add(TrainingRecord record) {
    return _db
        .into(_db.trainingRecords)
        .insert(
          TrainingRecordsCompanion.insert(
            userId: record.userId,
            siteId: Value(record.siteId),
            itemType: record.itemType.name,
            customItemTitle: Value(record.customItemTitle),
            completedAt: record.completedAt,
            expiresAt: Value(record.expiresAt),
            signedOffByUserId: record.signedOffByUserId,
            certificateReference: Value(record.certificateReference),
            createdAt: record.createdAt,
          ),
        );
  }

  @override
  Future<List<TrainingRecord>> getForUser(int userId) async {
    final query = _db.select(_db.trainingRecords)
      ..where((t) => t.userId.equals(userId))
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<List<TrainingRecord>> getForSite(int siteId) async {
    final query = _db.select(_db.trainingRecords)
      ..where((t) => t.siteId.equals(siteId))
      ..orderBy([(t) => OrderingTerm.desc(t.completedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  TrainingRecord _toModel(TrainingRecordEntity row) {
    return TrainingRecord(
      id: row.id,
      userId: row.userId,
      siteId: row.siteId!,
      itemType: TrainingItemType.values.byName(row.itemType),
      customItemTitle: row.customItemTitle,
      completedAt: row.completedAt,
      expiresAt: row.expiresAt,
      signedOffByUserId: row.signedOffByUserId,
      certificateReference: row.certificateReference,
      createdAt: row.createdAt,
    );
  }
}
