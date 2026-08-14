import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/supplier.dart';
import '../models/supplier_category.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getForSite(int siteId);
  Future<Supplier> create({
    required String name,
    String? contact,
    required SupplierCategory category,
    String? customCategoryTitle,
    required SupplierApprovalStatus approvalStatus,
    String? approvalNote,
    required int siteId,
  });
  Future<void> updateDetails(
    int id, {
    required String name,
    String? contact,
    required SupplierCategory category,
    String? customCategoryTitle,
  });
  Future<void> setApprovalStatus(
    int id,
    SupplierApprovalStatus status, {
    String? approvalNote,
  });
  Future<void> setActive(int id, bool active);
}

class DriftSupplierRepository implements SupplierRepository {
  DriftSupplierRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<Supplier>> getForSite(int siteId) async {
    final query = _db.select(_db.suppliers)
      ..where((s) => s.siteId.equals(siteId))
      ..orderBy([(s) => OrderingTerm.asc(s.name)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<Supplier> create({
    required String name,
    String? contact,
    required SupplierCategory category,
    String? customCategoryTitle,
    required SupplierApprovalStatus approvalStatus,
    String? approvalNote,
    required int siteId,
  }) async {
    final id = await _db
        .into(_db.suppliers)
        .insert(
          SuppliersCompanion.insert(
            name: name,
            contact: Value(contact),
            category: category.name,
            customCategoryTitle: Value(customCategoryTitle),
            approvalStatus: approvalStatus.name,
            approvalNote: Value(approvalNote),
            siteId: Value(siteId),
            createdAt: DateTime.now(),
          ),
        );
    final row = await (_db.select(
      _db.suppliers,
    )..where((s) => s.id.equals(id))).getSingle();
    return _toModel(row);
  }

  @override
  Future<void> updateDetails(
    int id, {
    required String name,
    String? contact,
    required SupplierCategory category,
    String? customCategoryTitle,
  }) {
    return (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
      SuppliersCompanion(
        name: Value(name),
        contact: Value(contact),
        category: Value(category.name),
        customCategoryTitle: Value(customCategoryTitle),
      ),
    );
  }

  @override
  Future<void> setApprovalStatus(
    int id,
    SupplierApprovalStatus status, {
    String? approvalNote,
  }) {
    return (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
      SuppliersCompanion(
        approvalStatus: Value(status.name),
        approvalNote: Value(approvalNote),
      ),
    );
  }

  @override
  Future<void> setActive(int id, bool active) {
    return (_db.update(_db.suppliers)..where((s) => s.id.equals(id))).write(
      SuppliersCompanion(active: Value(active)),
    );
  }

  Supplier _toModel(SupplierEntity row) {
    return Supplier(
      id: row.id,
      name: row.name,
      contact: row.contact,
      category: SupplierCategory.values.byName(row.category),
      customCategoryTitle: row.customCategoryTitle,
      approvalStatus: SupplierApprovalStatus.values.byName(
        row.approvalStatus,
      ),
      approvalNote: row.approvalNote,
      siteId: row.siteId!,
      active: row.active,
      createdAt: row.createdAt,
    );
  }
}
