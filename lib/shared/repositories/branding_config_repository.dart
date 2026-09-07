import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/branding_config.dart';

abstract class BrandingConfigRepository {
  Future<List<BrandingConfig>> getVersionHistory(int configGroupId);
  Future<BrandingConfig?> getCurrent(int organisationId);
  Stream<BrandingConfig?> watchCurrent(int organisationId);
  Future<BrandingConfig> saveNewVersion({
    int? configGroupId,
    required int organisationId,
    String? companyName,
    required int primaryColorArgb,
    String? contactPhone,
    String? contactEmail,
    required int setByUserId,
    String? logoPath,
  });
}

class DriftBrandingConfigRepository implements BrandingConfigRepository {
  DriftBrandingConfigRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<BrandingConfig>> getVersionHistory(int configGroupId) async {
    final query = _db.select(_db.brandingConfigs)
      ..where((b) => b.configGroupId.equals(configGroupId))
      ..orderBy([(b) => OrderingTerm.asc(b.versionNumber)]);
    final rows = await query.get();
    return rows.map(_toModel).toList();
  }

  @override
  Future<BrandingConfig?> getCurrent(int organisationId) async {
    final query = _db.select(_db.brandingConfigs)
      ..where((b) => b.organisationId.equals(organisationId));
    final rows = await query.get();
    return _resolveCurrent(rows);
  }

  @override
  Stream<BrandingConfig?> watchCurrent(int organisationId) {
    final query = _db.select(_db.brandingConfigs)
      ..where((b) => b.organisationId.equals(organisationId));
    return query.watch().map(_resolveCurrent);
  }

  // Same "not referenced as anyone's previousVersionId" resolution as
  // NotificationRuleRepository._currentVersionIds — only ever one live
  // config chain per organisation in practice, but the resolution logic
  // is identical either way.
  BrandingConfig? _resolveCurrent(List<BrandingConfigEntity> rows) {
    if (rows.isEmpty) return null;
    final referencedAsPrevious = rows
        .map((r) => r.previousVersionId)
        .whereType<int>()
        .toSet();
    final current = rows.firstWhere(
      (r) => !referencedAsPrevious.contains(r.id),
      orElse: () => rows.last,
    );
    return _toModel(current);
  }

  @override
  Future<BrandingConfig> saveNewVersion({
    int? configGroupId,
    required int organisationId,
    String? companyName,
    required int primaryColorArgb,
    String? contactPhone,
    String? contactEmail,
    required int setByUserId,
    String? logoPath,
  }) async {
    int? previousVersionId;
    var nextVersionNumber = 1;

    if (configGroupId != null) {
      final history = await getVersionHistory(configGroupId);
      if (history.isNotEmpty) {
        final current = history.last;
        previousVersionId = current.id;
        nextVersionNumber = current.versionNumber + 1;
      }
    }

    final insertedId = await _db
        .into(_db.brandingConfigs)
        .insert(
          BrandingConfigsCompanion.insert(
            configGroupId: configGroupId ?? 0,
            versionNumber: nextVersionNumber,
            previousVersionId: Value(previousVersionId),
            organisationId: organisationId,
            companyName: Value(companyName),
            primaryColorArgb: primaryColorArgb,
            contactPhone: Value(contactPhone),
            contactEmail: Value(contactEmail),
            setByUserId: setByUserId,
            createdAt: DateTime.now(),
            logoPath: Value(logoPath),
          ),
        );

    if (configGroupId == null) {
      await (_db.update(
        _db.brandingConfigs,
      )..where((b) => b.id.equals(insertedId))).write(
        BrandingConfigsCompanion(configGroupId: Value(insertedId)),
      );
    }

    final savedRow = await (_db.select(
      _db.brandingConfigs,
    )..where((b) => b.id.equals(insertedId))).getSingle();
    return _toModel(savedRow);
  }

  BrandingConfig _toModel(BrandingConfigEntity row) => BrandingConfig(
    id: row.id,
    configGroupId: row.configGroupId,
    versionNumber: row.versionNumber,
    previousVersionId: row.previousVersionId,
    organisationId: row.organisationId,
    companyName: row.companyName,
    primaryColorArgb: row.primaryColorArgb,
    contactPhone: row.contactPhone,
    contactEmail: row.contactEmail,
    setByUserId: row.setByUserId,
    createdAt: row.createdAt,
    logoPath: row.logoPath,
  );
}
