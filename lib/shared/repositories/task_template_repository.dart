import 'package:drift/drift.dart';

import '../../core/storage/app_database.dart';
import '../models/task_template.dart';
import '../models/user.dart';

class TaskTemplateSaveResult {
  final TaskTemplate template;
  final String? legalLimitWarning;

  const TaskTemplateSaveResult({
    required this.template,
    this.legalLimitWarning,
  });
}

abstract class TaskTemplateRepository {
  Future<List<TaskTemplate>> getAllCurrentVersions();
  Future<List<TaskTemplate>> getVersionHistory(int templateGroupId);
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
  });

  /// The venue type ids a task template is tagged relevant to (Sprint 029),
  /// keyed on templateGroupId (a soft reference, not a real FK — see
  /// TaskTemplateVenueTypes in app_database.dart) so it survives template
  /// versioning. Schema-ready only this sprint — deliberately unpopulated,
  /// prepared for Build Order item 4 (loading the real task library) to
  /// populate later.
  Future<List<int>> getVenueTypeIds(int templateGroupId);

  /// Replaces the full set of venue types tagged on a template group with
  /// exactly [venueTypeIds].
  Future<void> setVenueTypeIds(int templateGroupId, List<int> venueTypeIds);
}

class DriftTaskTemplateRepository implements TaskTemplateRepository {
  DriftTaskTemplateRepository(this._db);

  final AppDatabase _db;

  @override
  Future<List<TaskTemplate>> getAllCurrentVersions() async {
    final rows = await _db.select(_db.taskTemplates).get();
    final currentVersionIds = _currentVersionIds(rows);
    return rows
        .where((row) => currentVersionIds.contains(row.id))
        .map(_toModel)
        .toList();
  }

  @override
  Future<List<TaskTemplate>> getVersionHistory(int templateGroupId) async {
    final query = _db.select(_db.taskTemplates)
      ..where((t) => t.templateGroupId.equals(templateGroupId))
      ..orderBy([(t) => OrderingTerm.asc(t.versionNumber)]);
    final rows = await query.get();
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
    int? previousVersionId;
    var nextVersionNumber = 1;

    if (templateGroupId != null) {
      final history = await getVersionHistory(templateGroupId);
      if (history.isNotEmpty) {
        final current = history.last;
        previousVersionId = current.id;
        nextVersionNumber = current.versionNumber + 1;
      }
    }

    final roleTiersValue = applicableRoleTiers.map((t) => t.name).join(',');

    final insertedId = await _db
        .into(_db.taskTemplates)
        .insert(
          TaskTemplatesCompanion.insert(
            templateGroupId: templateGroupId ?? 0,
            versionNumber: nextVersionNumber,
            previousVersionId: Value(previousVersionId),
            title: title,
            segment: segment,
            applicableRoleTiers: roleTiersValue,
            method: method,
            requiresPhoto: Value(requiresPhoto),
            requiresNotes: Value(requiresNotes),
            customFieldsJson: Value(customFieldsJson),
            minLimit: Value(minLimit),
            maxLimit: Value(maxLimit),
            unit: Value(unit),
            legalLimitCategory: Value(legalLimitCategory),
            isCritical: Value(priority == TaskPriority.critical),
            priority: Value(priority.name),
            requiresCorrectiveActionOnFail: Value(
              requiresCorrectiveActionOnFail,
            ),
            fixInstructions: Value(fixInstructions),
            equipmentTypeId: Value(equipmentTypeId),
            createdAt: DateTime.now(),
            createdByUserId: Value(createdByUserId),
          ),
        );

    if (templateGroupId == null) {
      await (_db.update(
        _db.taskTemplates,
      )..where((t) => t.id.equals(insertedId))).write(
        TaskTemplatesCompanion(templateGroupId: Value(insertedId)),
      );
    }

    final savedRow = await (_db.select(
      _db.taskTemplates,
    )..where((t) => t.id.equals(insertedId))).getSingle();

    final warning = await _checkLegalLimit(
      legalLimitCategory: legalLimitCategory,
      minLimit: minLimit,
      maxLimit: maxLimit,
      unit: unit,
    );

    return TaskTemplateSaveResult(
      template: _toModel(savedRow),
      legalLimitWarning: warning,
    );
  }

  Future<String?> _checkLegalLimit({
    required String? legalLimitCategory,
    required double? minLimit,
    required double? maxLimit,
    required String? unit,
  }) async {
    if (legalLimitCategory == null) return null;

    final references = await _db.select(_db.legalLimitReferences).get();
    LegalLimitReferenceEntity? reference;
    for (final r in references) {
      if (r.category == legalLimitCategory) {
        reference = r;
        break;
      }
    }
    if (reference == null || unit != reference.unit) return null;

    final warnings = <String>[];
    if (minLimit != null &&
        reference.legalMin != null &&
        minLimit < reference.legalMin!) {
      warnings.add(
        'Minimum $minLimit$unit is below the legal minimum of '
        '${reference.legalMin}$unit',
      );
    }
    if (maxLimit != null &&
        reference.legalMax != null &&
        maxLimit > reference.legalMax!) {
      warnings.add(
        'Maximum $maxLimit$unit exceeds the legal maximum of '
        '${reference.legalMax}$unit',
      );
    }

    return warnings.isEmpty ? null : warnings.join('; ');
  }

  @override
  Future<List<int>> getVenueTypeIds(int templateGroupId) async {
    final rows = await (_db.select(_db.taskTemplateVenueTypes)
          ..where((j) => j.taskTemplateGroupId.equals(templateGroupId)))
        .get();
    return rows.map((row) => row.venueTypeId).toList();
  }

  @override
  Future<void> setVenueTypeIds(
    int templateGroupId,
    List<int> venueTypeIds,
  ) async {
    await _db.transaction(() async {
      await (_db.delete(_db.taskTemplateVenueTypes)
            ..where((j) => j.taskTemplateGroupId.equals(templateGroupId)))
          .go();
      for (final venueTypeId in venueTypeIds) {
        await _db
            .into(_db.taskTemplateVenueTypes)
            .insert(
              TaskTemplateVenueTypesCompanion.insert(
                taskTemplateGroupId: templateGroupId,
                venueTypeId: venueTypeId,
              ),
            );
      }
    });
  }

  List<int> _currentVersionIds(List<TaskTemplateEntity> rows) {
    final referencedAsPrevious = rows
        .map((r) => r.previousVersionId)
        .whereType<int>()
        .toSet();
    return rows
        .where((r) => !referencedAsPrevious.contains(r.id))
        .map((r) => r.id)
        .toList();
  }

  TaskTemplate _toModel(TaskTemplateEntity row) {
    final tiers = row.applicableRoleTiers
        .split(',')
        .where((s) => s.isNotEmpty)
        .map(RoleTier.values.byName)
        .toList();

    return TaskTemplate(
      id: row.id,
      templateGroupId: row.templateGroupId,
      versionNumber: row.versionNumber,
      previousVersionId: row.previousVersionId,
      title: row.title,
      segment: row.segment,
      applicableRoleTiers: tiers,
      method: row.method,
      requiresPhoto: row.requiresPhoto,
      requiresNotes: row.requiresNotes,
      customFieldsJson: row.customFieldsJson,
      minLimit: row.minLimit,
      maxLimit: row.maxLimit,
      unit: row.unit,
      legalLimitCategory: row.legalLimitCategory,
      isCritical: row.isCritical,
      requiresCorrectiveActionOnFail: row.requiresCorrectiveActionOnFail,
      fixInstructions: row.fixInstructions,
      equipmentTypeId: row.equipmentTypeId,
      createdAt: row.createdAt,
      createdByUserId: row.createdByUserId,
      priority: row.priority == null
          ? null
          : TaskPriority.values.byName(row.priority!),
    );
  }
}
