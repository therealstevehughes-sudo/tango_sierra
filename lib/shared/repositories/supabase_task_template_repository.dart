import '../../core/network/backend_rest_client.dart';
import '../models/job_role.dart';
import '../models/task_template.dart';
import '../models/user.dart';
import 'task_template_repository.dart';

// Phase B4 — backend-hosted TaskTemplates. RLS: null organisation_id is
// the shared baseline library (~150 tasks), non-null is a tenant's own
// private template or fork — same pattern as B2's VenueTypes/EquipmentTypes.
//
// THE FORK RULE (the real wrinkle this cluster found): editing an existing
// chain via saveNewVersion({templateGroupId: <existing>, ...}) must NOT
// extend a chain that's currently shared (organisation_id null) — doing so
// would retag the ENTIRE chain (including every earlier shared version)
// as this tenant's private property, silently taking it away from every
// other tenant reading the same chain. So: whenever the existing chain's
// current head is shared, this class forks — starts a brand-new
// templateGroupId under the caller's own organisation_id, exactly like a
// templateGroupId: null create — leaving the shared chain completely
// untouched. Only a chain that's ALREADY private to this same tenant gets
// extended in place. Proven via curl (edit-a-shared-task test) before this
// class was written; also proven at this exact layer by the Dart
// integration test.
class SupabaseTaskTemplateRepository implements TaskTemplateRepository {
  SupabaseTaskTemplateRepository(this._client, this._organisationId);

  final BackendRestClient _client;
  final int Function() _organisationId;

  @override
  Future<List<TaskTemplate>> getAllCurrentVersions() async {
    final rows = await _client.select('task_templates');
    final currentIds = _currentVersionIds(rows);
    return rows
        .where((row) => currentIds.contains(row['id'] as int))
        .map(_toModel)
        .toList();
  }

  @override
  Future<List<TaskTemplate>> getVersionHistory(int templateGroupId) async {
    final rows = await _client.select(
      'task_templates',
      query: 'template_group_id=eq.$templateGroupId&order=version_number.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<TaskTemplateSaveResult> saveNewVersion({
    int? templateGroupId,
    required String title,
    required String segment,
    required List<RoleTier> applicableRoleTiers,
    required String method,
    required bool requiresPhoto,
    required bool requiresNotes,
    String? customFieldsJson,
    double? minLimit,
    double? maxLimit,
    String? unit,
    String? legalLimitCategory,
    required TaskPriority priority,
    required bool requiresCorrectiveActionOnFail,
    String? fixInstructions,
    int? equipmentTypeId,
    required int createdByUserId,
  }) async {
    final myOrgId = _organisationId();

    int? previousVersionId;
    var nextVersionNumber = 1;
    var effectiveGroupId = templateGroupId;

    if (templateGroupId != null) {
      final history = await getVersionHistory(templateGroupId);
      if (history.isNotEmpty) {
        final current = history.last;
        // THE FORK: the existing chain's current head belongs to no one
        // (shared baseline) or to a DIFFERENT tenant than us (shouldn't be
        // reachable under RLS at all, but checked explicitly rather than
        // assumed) — either way, don't extend it. Start a fresh chain
        // instead, exactly like templateGroupId: null.
        final currentRow = await _client.select(
          'task_templates',
          query: 'id=eq.${current.id}',
        );
        final currentOrgId = currentRow.isEmpty
            ? null
            : currentRow.first['organisation_id'] as int?;
        if (currentOrgId == myOrgId) {
          previousVersionId = current.id;
          nextVersionNumber = current.versionNumber + 1;
        } else {
          effectiveGroupId = null; // fork
        }
      }
    }

    final roleTiersValue = applicableRoleTiers.map((t) => t.name).join(',');

    final row = await _client.insertOne('task_templates', {
      'template_group_id': effectiveGroupId ?? 0,
      'version_number': nextVersionNumber,
      'previous_version_id': previousVersionId,
      'title': title,
      'segment': segment,
      'applicable_role_tiers': roleTiersValue,
      'method': method,
      'requires_photo': requiresPhoto,
      'requires_notes': requiresNotes,
      'custom_fields_json': customFieldsJson,
      'min_limit': minLimit,
      'max_limit': maxLimit,
      'unit': unit,
      'legal_limit_category': legalLimitCategory,
      'is_critical': priority == TaskPriority.critical,
      'priority': priority.name,
      'requires_corrective_action_on_fail': requiresCorrectiveActionOnFail,
      'fix_instructions': fixInstructions,
      'equipment_type_id': equipmentTypeId,
      'created_by_user_id': createdByUserId,
      // A fork or a brand-new template always becomes this tenant's own —
      // RLS's WITH CHECK would reject anything else anyway, this just
      // avoids relying on the server to reject before setting it right.
      'organisation_id': myOrgId,
    });

    var insertedId = row['id'] as int;
    if (effectiveGroupId == null) {
      await _client.update(
        'task_templates',
        filter: 'id=eq.$insertedId',
        body: {'template_group_id': insertedId},
      );
    }

    final savedRows = await _client.select(
      'task_templates',
      query: 'id=eq.$insertedId',
    );

    // Legal-limit advisory check isn't available on the backend path —
    // LegalLimitReferences isn't backend-hosted (out of B4's scope, purely
    // an informational UX nicety, not security-relevant).
    return TaskTemplateSaveResult(
      template: _toModel(savedRows.first),
      legalLimitWarning: null,
    );
  }

  @override
  Future<List<int>> getVenueTypeIds(int templateGroupId) {
    throw UnimplementedError(
      'Task-template venue-type tagging is not yet wired to the backend '
      'path — still Drift-only, matching the same "capability built, app '
      'wiring incremental" state it already has locally (unpopulated, no '
      'filtering UI yet).',
    );
  }

  @override
  Future<void> setVenueTypeIds(int templateGroupId, List<int> venueTypeIds) {
    throw UnimplementedError(
      'Task-template venue-type tagging is not yet wired to the backend '
      'path — see getVenueTypeIds.',
    );
  }

  List<int> _currentVersionIds(List<Map<String, dynamic>> rows) {
    final referencedAsPrevious = rows
        .map((r) => r['previous_version_id'] as int?)
        .whereType<int>()
        .toSet();
    return rows
        .where((r) => !referencedAsPrevious.contains(r['id'] as int))
        .map((r) => r['id'] as int)
        .toList();
  }

  TaskTemplate _toModel(Map<String, dynamic> row) => TaskTemplate(
    id: row['id'] as int,
    templateGroupId: row['template_group_id'] as int,
    versionNumber: row['version_number'] as int,
    previousVersionId: row['previous_version_id'] as int?,
    title: row['title'] as String,
    segment: row['segment'] as String,
    applicableRoleTiers: (row['applicable_role_tiers'] as String)
        .split(',')
        .where((s) => s.isNotEmpty)
        .map(RoleTier.values.byName)
        .toList(),
    method: row['method'] as String,
    requiresPhoto: row['requires_photo'] as bool,
    requiresNotes: row['requires_notes'] as bool,
    customFieldsJson: row['custom_fields_json'] as String?,
    minLimit: (row['min_limit'] as num?)?.toDouble(),
    maxLimit: (row['max_limit'] as num?)?.toDouble(),
    unit: row['unit'] as String?,
    legalLimitCategory: row['legal_limit_category'] as String?,
    isCritical: row['is_critical'] as bool,
    requiresCorrectiveActionOnFail:
        row['requires_corrective_action_on_fail'] as bool,
    fixInstructions: row['fix_instructions'] as String?,
    equipmentTypeId: row['equipment_type_id'] as int?,
    createdAt: DateTime.parse(row['created_at'] as String),
    createdByUserId: row['created_by_user_id'] as int?,
    priority: row['priority'] == null
        ? null
        : TaskPriority.values.byName(row['priority'] as String),
    jobRole: row['job_role'] == null
        ? null
        : JobRole.values.byName(row['job_role'] as String),
    guidanceText: row['guidance_text'] as String?,
    requiresSupplierSelection: row['requires_supplier_selection'] as bool,
  );
}
