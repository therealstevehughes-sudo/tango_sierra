import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/document.dart';

abstract class DocumentRepository {
  Future<List<Document>> getForSite(int siteId);
  Future<Document> create({
    required int siteId,
    required String title,
    required DocumentCategory category,
    required String filePath,
    DateTime? expiryDate,
    required int uploadedByUserId,
  });
  Future<void> updateDetails(
    int id, {
    required String title,
    required DocumentCategory category,
    DateTime? expiryDate,
  });
  Future<void> setActive(int id, bool active);
}

class DriftDocumentRepository implements DocumentRepository {
  DriftDocumentRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Document>> getForSite(int siteId) async {
    final query = _db.select(_db.documents)
      ..where((d) => d.siteId.equals(siteId))
      ..orderBy([(d) => OrderingTerm.desc(d.uploadedAt)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Document> create({
    required int siteId,
    required String title,
    required DocumentCategory category,
    required String filePath,
    DateTime? expiryDate,
    required int uploadedByUserId,
  }) async {
    final now = DateTime.now();
    final id = await _db
        .into(_db.documents)
        .insert(
          DocumentsCompanion.insert(
            siteId: siteId,
            title: title,
            category: category.name,
            filePath: filePath,
            expiryDate: Value(expiryDate),
            uploadedByUserId: uploadedByUserId,
            uploadedAt: now,
          ),
        );
    final row = await (_db.select(
      _db.documents,
    )..where((d) => d.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> updateDetails(
    int id, {
    required String title,
    required DocumentCategory category,
    DateTime? expiryDate,
  }) {
    return (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(
        title: Value(title),
        category: Value(category.name),
        expiryDate: Value(expiryDate),
      ),
    );
  }

  @override
  Future<void> setActive(int id, bool active) {
    return (_db.update(_db.documents)..where((d) => d.id.equals(id))).write(
      DocumentsCompanion(active: Value(active)),
    );
  }

  Document _toModel(DocumentEntity row) => Document(
    id: row.id,
    siteId: row.siteId,
    title: row.title,
    category: DocumentCategory.values.byName(row.category),
    filePath: row.filePath,
    expiryDate: row.expiryDate,
    uploadedByUserId: row.uploadedByUserId,
    uploadedAt: row.uploadedAt,
    active: row.active,
  );
}
