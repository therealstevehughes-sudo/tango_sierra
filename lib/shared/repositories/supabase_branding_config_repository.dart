import 'dart:async';

import '../../core/network/backend_rest_client.dart';
import '../models/branding_config.dart';
import 'branding_config_repository.dart';

// Phase B4 — backend-hosted BrandingConfigs. Org-scoped (not site), via
// the new can_access_organisation() function — proven via curl before
// this class was written, including that every version in a config chain
// stays the same tenant's (organisationId never changes mid-chain, so
// per-row RLS is safe with no chain-aware logic needed).
//
// logoPath is a known limitation carried over unchanged from the original
// branding decision: a local file path, meaningless across devices/server
// without real file storage (not built here or anywhere yet).
//
// watchCurrent() has no server push available without Supabase Realtime
// (a bigger capability than this cluster's scope) — implemented as a
// simple 30s poll instead, which is a real, working stream (values only
// emitted on change, not every tick), not a broken stand-in. Good enough
// for "mostly online" branding, which changes rarely.
class SupabaseBrandingConfigRepository implements BrandingConfigRepository {
  SupabaseBrandingConfigRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<BrandingConfig>> getVersionHistory(int configGroupId) async {
    final rows = await _client.select(
      'branding_configs',
      query: 'config_group_id=eq.$configGroupId&order=version_number.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<BrandingConfig?> getCurrent(int organisationId) async {
    final rows = await _client.select(
      'branding_configs',
      query: 'organisation_id=eq.$organisationId',
    );
    return _resolveCurrent(rows);
  }

  @override
  Stream<BrandingConfig?> watchCurrent(int organisationId) {
    late final StreamController<BrandingConfig?> controller;
    Timer? timer;
    BrandingConfig? lastEmitted;
    var lastEmittedSet = false;

    Future<void> poll() async {
      final current = await getCurrent(organisationId);
      final changed =
          !lastEmittedSet ||
          current?.id != lastEmitted?.id ||
          current?.versionNumber != lastEmitted?.versionNumber;
      if (changed) {
        lastEmitted = current;
        lastEmittedSet = true;
        controller.add(current);
      }
    }

    controller = StreamController<BrandingConfig?>(
      onListen: () {
        poll();
        timer = Timer.periodic(const Duration(seconds: 30), (_) => poll());
      },
      onCancel: () => timer?.cancel(),
    );
    return controller.stream;
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

    final row = await _client.insertOne('branding_configs', {
      'config_group_id': configGroupId ?? 0,
      'version_number': nextVersionNumber,
      'previous_version_id': previousVersionId,
      'organisation_id': organisationId,
      'company_name': companyName,
      'primary_color_argb': primaryColorArgb,
      'contact_phone': contactPhone,
      'contact_email': contactEmail,
      'set_by_user_id': setByUserId,
      'logo_path': logoPath,
    });

    var insertedId = row['id'] as int;
    if (configGroupId == null) {
      await _client.update(
        'branding_configs',
        filter: 'id=eq.$insertedId',
        body: {'config_group_id': insertedId},
      );
    }

    final savedRows = await _client.select(
      'branding_configs',
      query: 'id=eq.$insertedId',
    );
    return _toModel(savedRows.first);
  }

  BrandingConfig? _resolveCurrent(List<Map<String, dynamic>> rows) {
    if (rows.isEmpty) return null;
    final referencedAsPrevious = rows
        .map((r) => r['previous_version_id'] as int?)
        .whereType<int>()
        .toSet();
    final current = rows.firstWhere(
      (r) => !referencedAsPrevious.contains(r['id'] as int),
      orElse: () => rows.last,
    );
    return _toModel(current);
  }

  BrandingConfig _toModel(Map<String, dynamic> row) => BrandingConfig(
    id: row['id'] as int,
    configGroupId: row['config_group_id'] as int,
    versionNumber: row['version_number'] as int,
    previousVersionId: row['previous_version_id'] as int?,
    organisationId: row['organisation_id'] as int,
    companyName: row['company_name'] as String?,
    primaryColorArgb: row['primary_color_argb'] as int,
    contactPhone: row['contact_phone'] as String?,
    contactEmail: row['contact_email'] as String?,
    setByUserId: row['set_by_user_id'] as int,
    createdAt: DateTime.parse(row['created_at'] as String),
    logoPath: row['logo_path'] as String?,
  );
}
