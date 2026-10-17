import '../../core/network/backend_rest_client.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/repositories/task_schedule_repository.dart';
import '../../shared/repositories/task_template_repository.dart';

// Equipment library (2026-10-17): a model-specific "pack" of checks for a
// piece of equipment (e.g. a Merrychef eikon e4s's daily air-filter clean),
// from VenuRite's library or drafted by AI and approved by a manager.

class PackCheck {
  const PackCheck({
    required this.title,
    required this.frequency,
    required this.method,
    required this.steps,
    this.min,
    this.max,
    this.unit,
    this.critical = false,
    this.photo = false,
    this.why,
    this.ifFails,
  });

  final String title;
  final String frequency;
  final String method; // 'tick' | 'data'
  final List<String> steps;
  final double? min;
  final double? max;
  final String? unit;
  final bool critical;
  final bool photo;
  final String? why;
  final String? ifFails;

  factory PackCheck.fromJson(Map<String, dynamic> j) => PackCheck(
    title: '${j['title'] ?? ''}',
    frequency: '${j['frequency'] ?? 'weekly'}',
    method: j['method'] == 'data' ? 'data' : 'tick',
    steps: [for (final s in (j['steps'] as List? ?? [])) '$s'],
    min: (j['min'] as num?)?.toDouble(),
    max: (j['max'] as num?)?.toDouble(),
    unit: j['unit'] as String?,
    critical: j['critical'] == true,
    photo: j['photo'] == true,
    why: j['why'] as String?,
    ifFails: j['if_fails'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'frequency': frequency,
    'method': method,
    'steps': steps,
    'min': min,
    'max': max,
    'unit': unit,
    'critical': critical,
    'photo': photo,
    'why': why,
    'if_fails': ifFails,
  };
}

class EquipmentModelChoice {
  const EquipmentModelChoice({
    required this.id,
    required this.manufacturer,
    required this.model,
    required this.equipmentTypeId,
    required this.checks,
    this.isVenueDraft = false,
  });

  final int id;
  final String manufacturer;
  final String model;
  final int? equipmentTypeId;
  final List<PackCheck> checks;
  final bool isVenueDraft;

  String get displayName => '$manufacturer $model';
}

/// Adds a pack's checks for one piece of equipment: each check becomes a
/// task for this business (reused if it already exists), with its steps as
/// the "How to do this correctly" guide, given to [assigneeId].
class EquipmentPackApplier {
  EquipmentPackApplier({
    required this.client,
    required this.templates,
    required this.schedules,
  });

  final BackendRestClient client;
  final TaskTemplateRepository templates;
  final TaskScheduleRepository schedules;

  Future<int> apply({
    required EquipmentModelChoice model,
    required List<PackCheck> checks,
    required int equipmentInstanceId,
    required int equipmentTypeId,
    required int siteId,
    required int assigneeId,
    required User manager,
  }) async {
    final existing = await templates.getAllCurrentVersions();
    var added = 0;
    for (final c in checks) {
      final title = '${model.model}: ${c.title}';
      var template = existing.where((t) => t.title == title).firstOrNull;
      if (template == null) {
        final saved = await templates.saveNewVersion(
          title: title,
          segment: c.critical ? 'food_safety' : 'preventive_maintenance',
          applicableRoleTiers: const [RoleTier.base, RoleTier.supervisor],
          method: c.method == 'data'
              ? (c.photo ? 'data_photo' : 'data')
              : (c.photo ? 'tick_photo' : 'tick'),
          requiresPhoto: c.photo,
          requiresNotes: false,
          minLimit: c.min,
          maxLimit: c.max,
          unit: c.unit,
          priority: c.critical ? TaskPriority.critical : TaskPriority.standard,
          requiresCorrectiveActionOnFail: c.critical,
          fixInstructions: c.ifFails,
          equipmentTypeId: equipmentTypeId,
          createdByUserId: manager.id,
        );
        template = saved.template;
        // The steps become this task's training guide (standardGuideFor
        // builds the guide from guidance text for venue-specific tasks).
        await client.update(
          'task_templates',
          filter: 'id=eq.${template.id}',
          body: {
            'guidance_text': [
              for (final step in c.steps)
                RegExp(r'[.!?]$').hasMatch(step.trim()) ? step.trim() : '${step.trim()}.',
            ].join(' '),
          },
        );
      }
      final already = (await schedules.getForStaffMember(assigneeId)).any(
        (s) =>
            s.active &&
            s.taskTemplateGroupId == template!.templateGroupId &&
            s.equipmentInstanceId == equipmentInstanceId,
      );
      if (already) continue;
      await schedules.assign(
        taskTemplateGroupId: template.templateGroupId,
        assignedUserId: assigneeId,
        equipmentInstanceId: equipmentInstanceId,
        frequency:
            ScheduleFrequency.values.asNameMap()[c.frequency] ??
            ScheduleFrequency.weekly,
        assignedByUserId: manager.id,
        siteId: siteId,
      );
      added++;
    }
    return added;
  }
}
