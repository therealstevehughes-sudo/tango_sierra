import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/common_job_title.dart';
import '../../shared/models/equipment.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/task_preset.dart';
import '../../shared/models/task_extra_field.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_segment.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_preset_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../l10n/app_localizations.dart';

class StaffAssignmentScreen extends ConsumerStatefulWidget {
  const StaffAssignmentScreen({super.key});

  @override
  ConsumerState<StaffAssignmentScreen> createState() =>
      _StaffAssignmentScreenState();
}

// Built 2026-09-14 -- "Dual-mode assignment (by-staff AND by-task)" was
// already a named v1.1 roadmap item (see the strategy-session roadmap
// logged in DECISIONS_LOG.md); brought forward on explicit request. The
// existing by-person flow (pick one staff member, tick their tasks) is
// entirely unchanged -- this only adds a second, independent mode.
enum _AssignMode { byPerson, byTask }

class _StaffAssignmentScreenState extends ConsumerState<StaffAssignmentScreen> {
  bool loading = true;
  String? loadError;
  _AssignMode mode = _AssignMode.byPerson;

  // "Assign by Task" mode's own state -- separate from the by-person
  // fields below, which stay exactly as they were.
  final Set<String> selectedTaskKeys = {};
  final Set<String> expandedTaskKeys = {};
  // Built 2026-09-14 -- Task Presets (the "By Person" mode's bundled
  // task-set shortcuts) only ever showed a count ("7 tasks"), not which
  // tasks -- a manager had to Apply blind to find out. Expandable, same
  // affordance as "By Task" mode's per-task guidance expand.
  final Set<int> expandedPresetIds = {};
  // Visual pass follow-up (2026-09-24, direct user feedback: "the sections/
  // departments can have a drop down to save space") — every segment
  // starts collapsed except the first, so a long "every task in the
  // library" list doesn't dump 100+ rows on screen at once.
  final Set<String> expandedSegments = {};

  // Venue-type filtering for presets (2026-09-15) — same "tagged =
  // filtered, untagged = universal, never a hard lockout" convention as
  // the equipment-type offering in the venue setup wizard, and the
  // existing jobRole narrowing just below (showAllJobRoles).
  List<int> siteVenueTypeIds = [];
  Map<int, List<int>> venueTypeIdsByPresetId = {};
  bool showAllPresetVenueTypes = false;

  String _taskKey(int templateGroupId, int? equipmentId) =>
      '$templateGroupId:${equipmentId ?? 'none'}';

  List<User> staffList = [];
  List<TaskTemplate> templates = [];
  List<EquipmentType> equipmentTypes = [];
  List<Equipment> equipmentInstances = [];
  List<TaskPreset> presets = [];

  User? selectedStaff;
  List<TaskSchedule> schedulesForSelectedStaff = [];
  // Sprint 031 (HORECA_TASK_ENRICHMENT.md load): jobRole is a default, not
  // a lockout (unlike the tier filter below, which stays untouched) — this
  // just starts the list narrowed to the selected staff member's own job,
  // resettable per-staff so it doesn't leak the last person's choice.
  bool showAllJobRoles = false;

  bool showCustomTaskForm = false;
  final TextEditingController customTitleController = TextEditingController();
  String customMethod = 'tick';
  bool customRequiresPhoto = false;
  bool customRequiresNotes = false;
  final TextEditingController customMinLimitController =
      TextEditingController();
  final TextEditingController customMaxLimitController =
      TextEditingController();
  final TextEditingController customUnitController = TextEditingController();
  final TextEditingController customFixInstructionsController =
      TextEditingController();
  final TextEditingController customFieldsJsonController =
      TextEditingController();
  TaskPriority customPriority = TaskPriority.standard;
  // Department/section picker (2026-09-24, direct user feedback) — was
  // hardcoded to segment: 'custom', a hidden bucket separate from every
  // real department, instead of filing under wherever the venue actually
  // wants an equipment-specific task to live. Null forces an explicit
  // choice rather than silently defaulting to the first segment.
  String? customSegment;
  bool customRequiresCorrectiveActionOnFail = false;
  int? customEquipmentTypeId;
  // Generic extra fields (2026-09-24, direct user request) — reference
  // fields like "PO number"/"batch number"/"quantity received" a manager
  // can attach to this custom task, beyond its normal PASS/FAIL/limits.
  final List<TaskExtraFieldDef> customExtraFields = [];
  final TextEditingController customExtraFieldLabelController =
      TextEditingController();
  TaskExtraFieldType customExtraFieldType = TaskExtraFieldType.text;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    customTitleController.dispose();
    customMinLimitController.dispose();
    customMaxLimitController.dispose();
    customUnitController.dispose();
    customFixInstructionsController.dispose();
    customFieldsJsonController.dispose();
    customExtraFieldLabelController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
      loadError = null;
    });
    // One silent retry before showing an error — see
    // venue_setup_wizard_screen.dart's own _loadData() for the full
    // explanation: reading `currentSiteProvider.future` this early can hit
    // a rare Riverpod internal race ("_listenedElement was called on
    // null"), caught live during a demo. A persistent failure still
    // surfaces via loadError on the second attempt.
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final userRepo = ref.read(userRepositoryProvider);
        final templateRepo = ref.read(taskTemplateRepositoryProvider);
        final equipmentRepo = ref.read(equipmentRepositoryProvider);
        final presetRepo = ref.read(taskPresetRepositoryProvider);
        final siteRepo = ref.read(siteRepositoryProvider);
        final site =
            ref.read(activeSiteProvider) ??
            await ref.read(currentSiteProvider.future);
        if (site == null) {
          if (!mounted) return;
          setState(() {
            loadError = AppLocalizations.of(context)!.noActiveSiteFoundError;
            loading = false;
          });
          return;
        }

        final loadedStaff = await userRepo.getForSite(site.id);
        final loadedTemplates = await templateRepo.getAllCurrentVersions();
        final loadedTypes = await equipmentRepo.getEquipmentTypes();
        final loadedInstances = await equipmentRepo.getForSite(site.id);
        final loadedPresets = await presetRepo.getAll();
        final activePresets = loadedPresets.where((p) => p.active).toList();
        final loadedSiteVenueTypeIds = await siteRepo.getVenueTypeIds(
          site.id,
        );
        final venueTypeTags = <int, List<int>>{};
        for (final preset in activePresets) {
          venueTypeTags[preset.id] = await presetRepo.getVenueTypeIds(
            preset.id,
          );
        }

        if (!mounted) return;
        setState(() {
          staffList = loadedStaff;
          templates = loadedTemplates;
          equipmentTypes = loadedTypes;
          equipmentInstances = loadedInstances;
          // Only active presets are offered for application.
          presets = activePresets;
          siteVenueTypeIds = loadedSiteVenueTypeIds;
          venueTypeIdsByPresetId = venueTypeTags;
          loading = false;
        });
        return;
      } catch (e) {
        if (!mounted) return;
        if (attempt == 0) continue;
        setState(() {
          loadError = e.toString();
          loading = false;
        });
      }
    }
  }

  // A preset with no venue-type tags is universal (offered everywhere);
  // a tagged one only shows when it matches one of the site's own tags.
  List<TaskPreset> get _visiblePresets {
    if (showAllPresetVenueTypes || siteVenueTypeIds.isEmpty) return presets;
    return presets.where((p) {
      final tags = venueTypeIdsByPresetId[p.id] ?? const [];
      return tags.isEmpty || tags.any(siteVenueTypeIds.contains);
    }).toList();
  }

  Future<void> _selectStaff(User user) async {
    final scheduleRepo = ref.read(taskScheduleRepositoryProvider);
    final schedules = await scheduleRepo.getForStaffMember(user.id);

    if (!mounted) return;
    setState(() {
      selectedStaff = user;
      schedulesForSelectedStaff = schedules;
      showAllJobRoles = false;
    });
  }

  TaskSchedule? _existingSchedule(int templateGroupId, int? equipmentId) {
    for (final schedule in schedulesForSelectedStaff) {
      if (schedule.taskTemplateGroupId == templateGroupId &&
          schedule.equipmentInstanceId == equipmentId) {
        return schedule;
      }
    }
    return null;
  }

  Future<void> _toggleAssignment({
    required int templateGroupId,
    int? equipmentId,
    required ScheduleFrequency frequency,
    required bool assign,
    int? windowStartMinutes,
    int? windowEndMinutesExclusive,
    bool windowStartsAtShiftStart = false,
  }) async {
    final staff = selectedStaff;
    final manager = ref.read(currentUserProvider);
    if (staff == null || manager == null) return;

    final scheduleRepo = ref.read(taskScheduleRepositoryProvider);

    if (assign) {
      await scheduleRepo.assign(
        taskTemplateGroupId: templateGroupId,
        assignedUserId: staff.id,
        equipmentInstanceId: equipmentId,
        frequency: frequency,
        assignedByUserId: manager.id,
        siteId: staff.siteId!,
        windowStartMinutes: windowStartMinutes,
        windowEndMinutesExclusive: windowEndMinutesExclusive,
        windowStartsAtShiftStart: windowStartsAtShiftStart,
      );
    } else {
      final existing = _existingSchedule(templateGroupId, equipmentId);
      if (existing != null) {
        await scheduleRepo.deactivate(existing.id);
      }
    }

    if (!mounted) return;
    final refreshed = await scheduleRepo.getForStaffMember(staff.id);
    if (!mounted) return;
    setState(() => schedulesForSelectedStaff = refreshed);
  }

  Future<void> _saveCustomTask() async {
    final title = customTitleController.text.trim();
    final manager = ref.read(currentUserProvider);
    final staff = selectedStaff;
    final segment = customSegment;
    if (title.isEmpty || manager == null || staff == null || segment == null) {
      return;
    }

    final templateRepo = ref.read(taskTemplateRepositoryProvider);
    final result = await templateRepo.saveNewVersion(
      title: title,
      segment: segment,
      applicableRoleTiers: [staff.roleTier],
      method: customMethod,
      requiresPhoto: customRequiresPhoto,
      requiresNotes: customRequiresNotes,
      customFieldsJson: customFieldsJsonController.text.trim().isEmpty
          ? null
          : customFieldsJsonController.text.trim(),
      minLimit: double.tryParse(customMinLimitController.text.trim()),
      maxLimit: double.tryParse(customMaxLimitController.text.trim()),
      unit: customUnitController.text.trim().isEmpty
          ? null
          : customUnitController.text.trim(),
      priority: customPriority,
      requiresCorrectiveActionOnFail: customRequiresCorrectiveActionOnFail,
      fixInstructions: customFixInstructionsController.text.trim().isEmpty
          ? null
          : customFixInstructionsController.text.trim(),
      equipmentTypeId: customEquipmentTypeId,
      createdByUserId: manager.id,
      extraFieldsJson: customExtraFields.isEmpty
          ? null
          : encodeExtraFieldDefs(customExtraFields),
    );

    if (!mounted) return;
    setState(() {
      templates = [...templates, result.template];
      showCustomTaskForm = false;
      customTitleController.clear();
      customMinLimitController.clear();
      customMaxLimitController.clear();
      customUnitController.clear();
      customFixInstructionsController.clear();
      customFieldsJsonController.clear();
      customExtraFields.clear();
      customExtraFieldLabelController.clear();
      customExtraFieldType = TaskExtraFieldType.text;
      customPriority = TaskPriority.standard;
      customRequiresCorrectiveActionOnFail = false;
      customRequiresPhoto = false;
      customRequiresNotes = false;
      customEquipmentTypeId = null;
      customSegment = null;
    });
  }

  // Resolves each item's taskTemplateGroupId to that template's current
  // title, via the already-loaded `templates` list -- no extra query.
  // Silently drops an item with no matching template (a stale reference)
  // rather than guessing at a title for it.
  List<String> _presetTaskTitles(TaskPreset preset) {
    final titles = <String>[];
    for (final item in preset.items) {
      for (final template in templates) {
        if (template.templateGroupId == item.taskTemplateGroupId) {
          titles.add(template.title);
          break;
        }
      }
    }
    return titles;
  }

  String _presetSubtitle(TaskPreset preset) {
    final l10n = AppLocalizations.of(context)!;
    final parts = <String>[
      for (final t in equipmentTypes)
        if (t.id == preset.equipmentTypeId) t.name,
      if (preset.segment != null && preset.segment!.isNotEmpty)
        l10n.presetSectionPrefix(preset.segment!),
    ];
    final joined = parts.join(' · ');
    final count = l10n.taskCountLabel(preset.items.length);
    return joined.isEmpty ? count : '$joined · $count';
  }

  Future<void> _onApplyPreset(TaskPreset preset) async {
    // A segment-only preset applies directly to the staff member (no
    // equipment instance). An equipment-type preset needs a target
    // instance, so prompt for which one.
    if (preset.equipmentTypeId == null) {
      await _applyPreset(preset);
      return;
    }

    final matching = equipmentInstances
        .where((e) => e.equipmentTypeId == preset.equipmentTypeId && e.active)
        .toList();
    if (matching.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.noEquipmentOfTypeSetUp)),
      );
      return;
    }

    final chosen = await showDialog<Equipment>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(
          AppLocalizations.of(context)!.applyPresetToWhichOneTitle(preset.name),
        ),
        children: matching
            .map(
              (e) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, e),
                child: Text(e.name),
              ),
            )
            .toList(),
      ),
    );
    if (chosen == null) return;
    await _applyPreset(preset, equipmentInstanceId: chosen.id);
  }

  Future<void> _applyPreset(
    TaskPreset preset, {
    int? equipmentInstanceId,
  }) async {
    final staff = selectedStaff;
    final manager = ref.read(currentUserProvider);
    if (staff == null || manager == null) return;

    final presetRepo = ref.read(taskPresetRepositoryProvider);
    final count = await presetRepo.applyPresetToStaff(
      presetId: preset.id,
      staffUserId: staff.id,
      equipmentInstanceId: equipmentInstanceId,
      assignedByUserId: manager.id,
      siteId: staff.siteId!,
    );

    if (!mounted) return;
    final scheduleRepo = ref.read(taskScheduleRepositoryProvider);
    final refreshed = await scheduleRepo.getForStaffMember(staff.id);
    if (!mounted) return;
    setState(() => schedulesForSelectedStaff = refreshed);

    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          count == 0
              ? l10n.allPresetTasksAlreadyAssigned(preset.name)
              : l10n.addedTasksFromPreset(count, preset.name),
        ),
      ),
    );
  }

  // Apply a preset to multiple staff at once (2026-09-15) — the per-staff
  // mechanism above (Sprint 026) already does the real work; this is
  // that same call looped once per person picked in the multi-select
  // dialog below, per the roadmap's own framing ("a natural loop, not a
  // rework"). An equipment-type preset still needs exactly one target
  // instance, prompted for once up front and applied to everyone chosen
  // — the realistic case is several people all needing, say, the
  // fridge-check preset for the same fridge.
  Future<void> _onApplyPresetToMultiple(TaskPreset preset) async {
    int? equipmentInstanceId;
    if (preset.equipmentTypeId != null) {
      final matching = equipmentInstances
          .where((e) => e.equipmentTypeId == preset.equipmentTypeId && e.active)
          .toList();
      if (matching.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.noEquipmentOfTypeSetUp),
          ),
        );
        return;
      }
      final chosen = await showDialog<Equipment>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(
            AppLocalizations.of(context)!.applyPresetToWhichOneTitle(preset.name),
          ),
          children: matching
              .map(
                (e) => SimpleDialogOption(
                  onPressed: () => Navigator.pop(context, e),
                  child: Text(e.name),
                ),
              )
              .toList(),
        ),
      );
      if (chosen == null) return;
      equipmentInstanceId = chosen.id;
    }
    if (!mounted) return;

    final selected = <int>{};
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.applyPresetToTitle(preset.name)),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView(
                shrinkWrap: true,
                children: staffList
                    .map(
                      (u) => CheckboxListTile(
                        value: selected.contains(u.id),
                        title: Text(u.name),
                        subtitle: Text(localizedJobTitle(u.jobTitle, l10n)),
                        onChanged: (checked) => setDialogState(() {
                          if (checked ?? false) {
                            selected.add(u.id);
                          } else {
                            selected.remove(u.id);
                          }
                        }),
                      ),
                    )
                    .toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: selected.isEmpty
                    ? null
                    : () => Navigator.pop(context, true),
                child: Text(l10n.applyButton),
              ),
            ],
          );
        },
      ),
    );
    if (confirmed != true || selected.isEmpty) return;

    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    final presetRepo = ref.read(taskPresetRepositoryProvider);

    var totalAdded = 0;
    for (final staffId in selected) {
      final staff = staffList.where((u) => u.id == staffId).firstOrNull;
      if (staff?.siteId == null) continue;
      totalAdded += await presetRepo.applyPresetToStaff(
        presetId: preset.id,
        staffUserId: staffId,
        equipmentInstanceId: equipmentInstanceId,
        assignedByUserId: manager.id,
        siteId: staff!.siteId!,
      );
    }

    if (!mounted) return;
    // Refresh the currently-selected staff member's own schedule list too,
    // in case they were one of the people just bulk-applied to.
    final currentlySelected = selectedStaff;
    if (currentlySelected != null && selected.contains(currentlySelected.id)) {
      final scheduleRepo = ref.read(taskScheduleRepositoryProvider);
      final refreshed = await scheduleRepo.getForStaffMember(
        currentlySelected.id,
      );
      if (!mounted) return;
      setState(() => schedulesForSelectedStaff = refreshed);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          AppLocalizations.of(
            context,
          )!.addedTasksAcrossStaffLabel(totalAdded, selected.length),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(
          mode == _AssignMode.byTask
              ? l10n.assignTasksTitle
              : selectedStaff == null
              ? l10n.assignTasksTitle
              : l10n.assignTasksForStaffTitle(selectedStaff!.name),
        ),
        leading: mode == _AssignMode.byPerson && selectedStaff != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedStaff = null),
              )
            : null,
        actions: const [AssistantIconButton()],
      ),
      // Navigation-consistency pass (Sprint 031): while a staff member is
      // selected, this AppBar's `leading` is the "back to staff list"
      // arrow above, not the drawer hamburger — the drawer stays reachable
      // via edge-swipe in that state (pre-existing Scaffold behavior, not
      // new here), same as any screen with a custom leading widget.
      drawer: ManagementDrawer(title: l10n.assignTasksTitle),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
          ? LoadErrorView(error: loadError!, onRetry: _loadData)
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<_AssignMode>(
                  segments: [
                    ButtonSegment(
                      value: _AssignMode.byPerson,
                      label: Text(l10n.byPersonLabel),
                      icon: const Icon(Icons.person_outline),
                    ),
                    ButtonSegment(
                      value: _AssignMode.byTask,
                      label: Text(l10n.byTaskLabel),
                      icon: const Icon(Icons.checklist_outlined),
                    ),
                  ],
                  selected: {mode},
                  onSelectionChanged: (selection) => setState(() {
                    mode = selection.first;
                    selectedStaff = null;
                    selectedTaskKeys.clear();
                  }),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: mode == _AssignMode.byTask
                      ? _buildByTaskMode()
                      : selectedStaff == null
                      ? _buildStaffList()
                      : _buildAssignmentList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // "Assign by Task" mode — tick a set of (task, equipment instance)
  // rows, then assign all of them to a chosen set of staff in one go.
  // Grouped by equipment instance (e.g. "Walk-in Fridge") for
  // equipment-linked tasks, falling back to the task's segment (e.g.
  // "Dry Store") for tasks with no equipment — collapsible, since a real
  // venue's full task library is long. Each row can expand to show its
  // guidance text (the same instructions a worker sees on the task
  // screen), so a manager can see exactly what they're assigning without
  // leaving this screen.
  Widget _buildByTaskMode() {
    final l10n = AppLocalizations.of(context)!;
    final groups = <String, List<_TaskRow>>{};
    for (final template in templates) {
      if (template.equipmentTypeId == null) {
        // Visual pass follow-up (2026-09-24) — was the raw segment slug
        // prefixed with "Segment: " (e.g. "Segment: reception"); now the
        // same friendly name used by the By Person tab's own grouping.
        groups
            .putIfAbsent(segmentDisplayName(template.segment, l10n), () => [])
            .add(_TaskRow(template: template, instance: null));
        continue;
      }
      final matchingInstances = equipmentInstances
          .where(
            (e) => e.equipmentTypeId == template.equipmentTypeId && e.active,
          )
          .toList();
      for (final instance in matchingInstances) {
        groups
            .putIfAbsent(instance.name, () => [])
            .add(_TaskRow(template: template, instance: instance));
      }
    }
    final sortedGroupNames = groups.keys.toList()..sort();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              for (final groupName in sortedGroupNames)
                ExpansionTile(
                  title: Text(groupName),
                  initiallyExpanded: false,
                  children: [
                    for (final row in groups[groupName]!) _buildByTaskRow(row),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PrimaryActionButton(
          label: selectedTaskKeys.isEmpty
              ? l10n.selectTasksToAssignLabel
              : l10n.assignTasksCountLabel(selectedTaskKeys.length),
          onPressed: selectedTaskKeys.isEmpty ? null : _pickStaffAndAssign,
        ),
      ],
    );
  }

  Widget _buildByTaskRow(_TaskRow row) {
    final l10n = AppLocalizations.of(context)!;
    final key = _taskKey(row.template.templateGroupId, row.instance?.id);
    final hasGuidance = (row.template.guidanceText ?? '').trim().isNotEmpty;
    final expanded = expandedTaskKeys.contains(key);
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CheckboxListTile(
            value: selectedTaskKeys.contains(key),
            onChanged: (checked) => setState(() {
              if (checked ?? false) {
                selectedTaskKeys.add(key);
              } else {
                selectedTaskKeys.remove(key);
              }
            }),
            title: Text(row.template.title),
            secondary: hasGuidance
                ? IconButton(
                    icon: Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                    ),
                    tooltip: l10n.showInstructionsTooltip,
                    onPressed: () => setState(() {
                      if (expanded) {
                        expandedTaskKeys.remove(key);
                      } else {
                        expandedTaskKeys.add(key);
                      }
                    }),
                  )
                : null,
          ),
          if (expanded && hasGuidance)
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
              child: Text(
                row.template.guidanceText!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _pickStaffAndAssign() async {
    // The union of tiers the selected tasks actually apply to — staff
    // outside that union couldn't be validly assigned any of them, so
    // they're not offered as a confusing dead-end option.
    final selectedTemplates = <TaskTemplate>{};
    for (final template in templates) {
      for (final instance in [
        null,
        ...equipmentInstances.where(
          (e) => e.equipmentTypeId == template.equipmentTypeId,
        ),
      ]) {
        if (selectedTaskKeys.contains(
          _taskKey(template.templateGroupId, instance?.id),
        )) {
          selectedTemplates.add(template);
        }
      }
    }
    final eligibleTiers = selectedTemplates
        .expand((t) => t.applicableRoleTiers)
        .toSet();
    final eligibleStaff = staffList
        .where((u) => u.active && eligibleTiers.contains(u.roleTier))
        .toList();

    final chosen = await showDialog<List<User>>(
      context: context,
      builder: (_) => _StaffMultiSelectDialog(staff: eligibleStaff),
    );
    if (chosen == null || chosen.isEmpty || !mounted) return;

    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    final scheduleRepo = ref.read(taskScheduleRepositoryProvider);

    var created = 0;
    var skipped = 0;
    for (final staff in chosen) {
      final existingForStaff = await scheduleRepo.getForStaffMember(staff.id);
      final existingKeys = existingForStaff
          .map((s) => _taskKey(s.taskTemplateGroupId, s.equipmentInstanceId))
          .toSet();

      for (final row in <_TaskRow>[
        for (final template in templates)
          if (template.equipmentTypeId == null)
            _TaskRow(template: template, instance: null)
          else
            for (final instance in equipmentInstances.where(
              (e) => e.equipmentTypeId == template.equipmentTypeId,
            ))
              _TaskRow(template: template, instance: instance),
      ]) {
        final key = _taskKey(row.template.templateGroupId, row.instance?.id);
        if (!selectedTaskKeys.contains(key)) continue;
        if (!row.template.applicableRoleTiers.contains(staff.roleTier)) {
          skipped++;
          continue;
        }
        if (existingKeys.contains(key)) {
          skipped++;
          continue;
        }
        await scheduleRepo.assign(
          taskTemplateGroupId: row.template.templateGroupId,
          assignedUserId: staff.id,
          equipmentInstanceId: row.instance?.id,
          frequency: ScheduleFrequency.daily,
          assignedByUserId: manager.id,
          siteId: staff.siteId!,
        );
        created++;
      }
    }

    if (!mounted) return;
    setState(() => selectedTaskKeys.clear());
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.createdAssignmentsLabel(
            created,
            skipped > 0 ? l10n.skippedNoteLabel(skipped) : '',
          ),
        ),
      ),
    );
  }

  Widget _buildStaffList() {
    // Deactivated staff can't log in to perform tasks, so they're excluded
    // from being selected for new assignments (Sprint 024). Regional/
    // executive are company-wide oversight roles, not day-to-day
    // task-assignment targets — excluded here too (Sprint 031), same shape
    // as the login screen's regional/executive exclusion.
    final activeStaff = staffList
        .where(
          (u) =>
              u.active &&
              u.roleTier != RoleTier.regional &&
              u.roleTier != RoleTier.executive,
        )
        .toList();
    return ListView.builder(
      itemCount: activeStaff.length,
      itemBuilder: (context, index) {
        final user = activeStaff[index];
        return Card(
          child: ListTile(
            title: Text(
              '${user.name} (${localizedJobTitle(user.jobTitle, AppLocalizations.of(context))})',
            ),
            subtitle: Text(
              roleTierDisplayName(user.roleTier, AppLocalizations.of(context)),
            ),
            onTap: () => _selectStaff(user),
          ),
        );
      },
    );
  }

  Widget _buildAssignmentList() {
    final l10n = AppLocalizations.of(context)!;
    final staff = selectedStaff!;
    // Tier is a real lockout — unchanged, still the only access-control
    // filter. jobRole below is a default on top of it, not a second
    // lockout: a manager can always reveal the rest of this same
    // tier-filtered set via the toggle.
    final applicable = templates
        .where((t) => t.applicableRoleTiers.contains(staff.roleTier))
        .toList();

    final canNarrowByJobRole = staff.jobRole != null;
    final visible = (canNarrowByJobRole && !showAllJobRoles)
        ? applicable
              .where(
                (t) =>
                    t.jobRole == null ||
                    t.jobRole == JobRole.everyone ||
                    t.jobRole == staff.jobRole,
              )
              .toList()
        : applicable;

    final Map<String, List<TaskTemplate>> grouped = {};
    for (final template in visible) {
      grouped.putIfAbsent(template.segment, () => []).add(template);
    }
    // First segment open by default so the screen isn't a wall of
    // collapsed rows on first open; every subsequent one starts closed.
    if (expandedSegments.isEmpty && grouped.isNotEmpty) {
      expandedSegments.add(grouped.keys.first);
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (presets.isNotEmpty) ...[
            SectionHeader(title: l10n.taskPresetsSectionTitle),
            if (!showAllPresetVenueTypes &&
                siteVenueTypeIds.isNotEmpty &&
                _visiblePresets.length < presets.length)
              TextButton(
                onPressed: () => setState(() => showAllPresetVenueTypes = true),
                child: Text(l10n.showAllPresetsButton),
              ),
            for (final preset in _visiblePresets)
              Card(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(preset.name),
                      subtitle: Text(_presetSubtitle(preset)),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              expandedPresetIds.contains(preset.id)
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                            tooltip: l10n.showTasksInGroupTooltip,
                            onPressed: () => setState(() {
                              if (expandedPresetIds.contains(preset.id)) {
                                expandedPresetIds.remove(preset.id);
                              } else {
                                expandedPresetIds.add(preset.id);
                              }
                            }),
                          ),
                          TextButton(
                            onPressed: () => _onApplyPreset(preset),
                            child: Text(l10n.applyButton),
                          ),
                          TextButton(
                            onPressed: () => _onApplyPresetToMultiple(preset),
                            child: Text(l10n.applyToMultipleButton),
                          ),
                        ],
                      ),
                    ),
                    if (expandedPresetIds.contains(preset.id))
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            for (final title in _presetTaskTitles(preset))
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.check_box_outline_blank,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(child: Text(title)),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
          ],
          if (canNarrowByJobRole)
            CheckboxListTile(
              value: showAllJobRoles,
              title: Text(
                l10n.showAllRolesLabel(jobRoleDisplayName(staff.jobRole!, l10n)),
              ),
              onChanged: (value) =>
                  setState(() => showAllJobRoles = value ?? false),
            ),
          for (final segment in grouped.keys) ...[
            _buildSegmentGroup(segment, grouped[segment]!),
            const SizedBox(height: 8),
          ],
          const Divider(),
          if (!showCustomTaskForm)
            PrimaryActionButton(
              label: l10n.addCustomTaskButton,
              onPressed: () => setState(() => showCustomTaskForm = true),
            )
          else
            _buildCustomTaskForm(),
        ],
      ),
    );
  }

  // Visual pass follow-up (2026-09-24) — was a flat, always-expanded
  // SectionHeader + every task beneath it; a venue with the full library
  // loaded could dump 100+ rows on screen with no way to collapse any of
  // it. Now a real collapsible group per segment (friendly name via
  // segmentDisplayName, not the raw slug), first one open by default so
  // the screen isn't empty-looking on first open.
  Widget _buildSegmentGroup(String segment, List<TaskTemplate> templates) {
    final l10n = AppLocalizations.of(context)!;
    final isExpanded = expandedSegments.contains(segment);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            title: Text(
              segmentDisplayName(segment, l10n),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(l10n.taskCountLabel(templates.length)),
            trailing: Icon(isExpanded ? Icons.expand_less : Icons.expand_more),
            onTap: () => setState(() {
              if (isExpanded) {
                expandedSegments.remove(segment);
              } else {
                expandedSegments.add(segment);
              }
            }),
          ),
          if (isExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Column(
                children: [
                  for (final template in templates) _buildTemplateRow(template),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemplateRow(TaskTemplate template) {
    if (template.equipmentTypeId == null) {
      final existing = _existingSchedule(template.templateGroupId, null);
      return _AssignmentTile(
        label: template.title,
        frequency: existing?.frequency ?? ScheduleFrequency.daily,
        assigned: existing != null,
        windowStartMinutes: existing?.windowStartMinutes,
        windowEndMinutesExclusive: existing?.windowEndMinutesExclusive,
        windowStartsAtShiftStart: existing?.windowStartsAtShiftStart ?? false,
        onChanged: (assign, frequency, windowStart, windowEnd, startsAtShift) =>
            _toggleAssignment(
              templateGroupId: template.templateGroupId,
              frequency: frequency,
              assign: assign,
              windowStartMinutes: windowStart,
              windowEndMinutesExclusive: windowEnd,
              windowStartsAtShiftStart: startsAtShift,
            ),
      );
    }

    final matchingInstances = equipmentInstances
        .where((e) => e.equipmentTypeId == template.equipmentTypeId && e.active)
        .toList();

    if (matchingInstances.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(
          AppLocalizations.of(context)!.noEquipmentSetUpForTemplate(template.title),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            template.title,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          for (final instance in matchingInstances)
            _buildEquipmentAssignmentTile(template, instance),
        ],
      ),
    );
  }

  Widget _buildEquipmentAssignmentTile(
    TaskTemplate template,
    Equipment instance,
  ) {
    final existing = _existingSchedule(template.templateGroupId, instance.id);
    return _AssignmentTile(
      label: instance.name,
      indent: true,
      frequency: existing?.frequency ?? ScheduleFrequency.daily,
      assigned: existing != null,
      windowStartMinutes: existing?.windowStartMinutes,
      windowEndMinutesExclusive: existing?.windowEndMinutesExclusive,
      windowStartsAtShiftStart: existing?.windowStartsAtShiftStart ?? false,
      onChanged: (assign, frequency, windowStart, windowEnd, startsAtShift) =>
          _toggleAssignment(
            templateGroupId: template.templateGroupId,
            equipmentId: instance.id,
            frequency: frequency,
            assign: assign,
            windowStartMinutes: windowStart,
            windowEndMinutesExclusive: windowEnd,
            windowStartsAtShiftStart: startsAtShift,
          ),
    );
  }

  String _extraFieldTypeLabel(AppLocalizations l10n, TaskExtraFieldType type) {
    switch (type) {
      case TaskExtraFieldType.text:
        return l10n.extraFieldTypeText;
      case TaskExtraFieldType.number:
        return l10n.extraFieldTypeNumber;
      case TaskExtraFieldType.date:
        return l10n.extraFieldTypeDate;
    }
  }

  Widget _buildCustomTaskForm() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        SectionHeader(title: l10n.customTaskSectionTitle),
        TextField(
          controller: customTitleController,
          decoration: InputDecoration(labelText: l10n.titleFieldLabel),
        ),
        const SizedBox(height: 12),
        // Department/section (2026-09-24, direct user feedback) — files
        // this custom task under a real department alongside the built-in
        // library, rather than a hidden separate bucket. A long, fixed
        // reference list (25 segments) stays a dropdown per the app's own
        // "short lists -> tick/radio, long lists -> dropdown" rule.
        DropdownButtonFormField<String>(
          initialValue: customSegment,
          decoration: InputDecoration(labelText: l10n.departmentSectionLabel),
          items: allTaskSegments
              .map(
                (s) => DropdownMenuItem(
                  value: s,
                  child: Text(segmentDisplayName(s, l10n)),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => customSegment = value),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: customMethod,
          decoration: InputDecoration(labelText: l10n.methodLabel),
          items: [
            DropdownMenuItem(value: 'tick', child: Text(l10n.methodTick)),
            DropdownMenuItem(value: 'data', child: Text(l10n.methodData)),
            DropdownMenuItem(value: 'data_tick', child: Text(l10n.methodDataTick)),
            DropdownMenuItem(value: 'tick_photo', child: Text(l10n.methodTickPhoto)),
            DropdownMenuItem(value: 'data_photo', child: Text(l10n.methodDataPhoto)),
            DropdownMenuItem(value: 'note', child: Text(l10n.methodNote)),
            DropdownMenuItem(value: 'data_note', child: Text(l10n.methodDataNote)),
            DropdownMenuItem(value: 'note_photo', child: Text(l10n.methodNotePhoto)),
            DropdownMenuItem(value: 'tick_note', child: Text(l10n.methodTickNote)),
            DropdownMenuItem(value: 'multi', child: Text(l10n.methodMulti)),
          ],
          onChanged: (value) {
            if (value != null) setState(() => customMethod = value);
          },
        ),
        CheckboxListTile(
          title: Text(l10n.requiresPhotoLabel),
          value: customRequiresPhoto,
          onChanged: (v) => setState(() => customRequiresPhoto = v ?? false),
        ),
        CheckboxListTile(
          title: Text(l10n.requiresNotesLabel),
          value: customRequiresNotes,
          onChanged: (v) => setState(() => customRequiresNotes = v ?? false),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: customMinLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.minLimitLabel),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: customMaxLimitController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: l10n.maxLimitLabel),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: customUnitController,
          decoration: InputDecoration(labelText: l10n.unitHintLabel),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int?>(
          initialValue: customEquipmentTypeId,
          decoration: InputDecoration(
            labelText: l10n.equipmentTypeOptionalLabel,
          ),
          items: [
            DropdownMenuItem<int?>(value: null, child: Text(l10n.noneLabel)),
            ...equipmentTypes.map(
              (t) => DropdownMenuItem<int?>(value: t.id, child: Text(t.name)),
            ),
          ],
          onChanged: (value) => setState(() => customEquipmentTypeId = value),
        ),
        DropdownButtonFormField<TaskPriority>(
          initialValue: customPriority,
          decoration: InputDecoration(labelText: l10n.priorityLabel),
          items: [
            DropdownMenuItem(
              value: TaskPriority.critical,
              child: Text(l10n.priorityCritical),
            ),
            DropdownMenuItem(value: TaskPriority.high, child: Text(l10n.priorityHigh)),
            DropdownMenuItem(
              value: TaskPriority.standard,
              child: Text(l10n.priorityStandard),
            ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => customPriority = value);
          },
        ),
        CheckboxListTile(
          title: Text(l10n.requiresCorrectiveActionLabel),
          value: customRequiresCorrectiveActionOnFail,
          onChanged: (v) =>
              setState(() => customRequiresCorrectiveActionOnFail = v ?? false),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: customFixInstructionsController,
          decoration: InputDecoration(labelText: l10n.fixInstructionsLabel),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: customFieldsJsonController,
          decoration: InputDecoration(
            labelText: l10n.customFieldsJsonLabel,
          ),
        ),
        const SizedBox(height: 16),
        // Generic extra fields (2026-09-24, direct user request) —
        // reference fields (PO number, batch/lot number, quantity
        // received, etc.) a worker fills in alongside this task's normal
        // PASS/FAIL/limits. A short, manager-built list rather than
        // hardcoded per task type - see task_extra_field.dart.
        SectionHeader(title: l10n.extraFieldsSectionTitle),
        for (final field in customExtraFields)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.extraFieldSummary(
                      field.label,
                      _extraFieldTypeLabel(l10n, field.type),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  tooltip: l10n.removeTooltip,
                  onPressed: () =>
                      setState(() => customExtraFields.remove(field)),
                ),
              ],
            ),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: customExtraFieldLabelController,
                decoration: InputDecoration(
                  labelText: l10n.fieldLabelHint,
                ),
              ),
            ),
            const SizedBox(width: 8),
            DropdownButton<TaskExtraFieldType>(
              value: customExtraFieldType,
              items: [
                DropdownMenuItem(
                  value: TaskExtraFieldType.text,
                  child: Text(l10n.extraFieldTypeText),
                ),
                DropdownMenuItem(
                  value: TaskExtraFieldType.number,
                  child: Text(l10n.extraFieldTypeNumber),
                ),
                DropdownMenuItem(
                  value: TaskExtraFieldType.date,
                  child: Text(l10n.extraFieldTypeDate),
                ),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() => customExtraFieldType = value);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.addFieldTooltip,
              onPressed: () {
                final label = customExtraFieldLabelController.text.trim();
                if (label.isEmpty) return;
                setState(() {
                  customExtraFields.add(
                    TaskExtraFieldDef(
                      key: 'field_${DateTime.now().microsecondsSinceEpoch}',
                      label: label,
                      type: customExtraFieldType,
                    ),
                  );
                  customExtraFieldLabelController.clear();
                  customExtraFieldType = TaskExtraFieldType.text;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => showCustomTaskForm = false),
              child: Text(l10n.cancel),
            ),
            PrimaryActionButton(
              label: l10n.saveCustomTaskButton,
              onPressed: customSegment == null ? null : _saveCustomTask,
            ),
          ],
        ),
      ],
    );
  }
}

enum _SchedulingMode { adHoc, timeAllocated }

class _AssignmentTile extends StatefulWidget {
  const _AssignmentTile({
    required this.label,
    required this.assigned,
    required this.frequency,
    required this.onChanged,
    this.indent = false,
    this.windowStartMinutes,
    this.windowEndMinutesExclusive,
    this.windowStartsAtShiftStart = false,
  });

  final String label;
  final bool assigned;
  final ScheduleFrequency frequency;
  final bool indent;
  final int? windowStartMinutes;
  final int? windowEndMinutesExclusive;
  final bool windowStartsAtShiftStart;
  final void Function(
    bool assign,
    ScheduleFrequency frequency,
    int? windowStartMinutes,
    int? windowEndMinutesExclusive,
    bool windowStartsAtShiftStart,
  )
  onChanged;

  @override
  State<_AssignmentTile> createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<_AssignmentTile> {
  late ScheduleFrequency frequency = widget.frequency;
  late bool windowEnabled = widget.windowStartMinutes != null;
  late TimeOfDay? windowStart = _toTimeOfDay(widget.windowStartMinutes);
  // Stored exclusive-of-that-minute, but the picker shows the last minute
  // the task is actually available — so displayed as (stored - 1).
  late TimeOfDay? windowEnd = _toTimeOfDay(
    widget.windowEndMinutesExclusive == null
        ? null
        : widget.windowEndMinutesExclusive! - 1,
  );
  // Shift-relative window start (2026-09-24) — when true, windowStart's
  // own TimeOfDay is ignored entirely and the picker for it is hidden;
  // the effective start is resolved at read time from that day's
  // ShiftLog (see TaskController._todaysClockInMinutes).
  late bool startsAtShiftStart = widget.windowStartsAtShiftStart;

  static TimeOfDay? _toTimeOfDay(int? minutes) => minutes == null
      ? null
      : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

  // Ad hoc / Time allocated (2026-09-24, direct user request) — a plain
  // binary framing over the same underlying frequency + time-window
  // fields that already existed: "Ad hoc" simply means frequency ==
  // asNeeded with no time window (do it whenever it's needed); "Time
  // allocated" means a real cadence, and picking it now opens the time-
  // of-day picker directly instead of requiring a separate "Restrict to
  // a time window" checkbox tick on top. No new data — just a clearer
  // choice up front.
  late _SchedulingMode mode =
      (frequency == ScheduleFrequency.asNeeded && !windowEnabled)
      ? _SchedulingMode.adHoc
      : _SchedulingMode.timeAllocated;

  // Time-windowed tasks (Sprint 031, Sub-sprint C) — a single window can't
  // sensibly represent 2/3 separate required check-ins in a day (which
  // "check" would it gate?), so the option isn't offered for those
  // frequencies rather than shipping a combination that technically works
  // but doesn't mean what a manager would expect.
  bool get _windowSupported =>
      frequency != ScheduleFrequency.twoXDaily &&
      frequency != ScheduleFrequency.threeXDaily;

  void _notifyChanged(bool assign) {
    final hasWindow =
        windowEnabled &&
        _windowSupported &&
        (startsAtShiftStart || windowStart != null) &&
        windowEnd != null;
    final effectiveStartsAtShift = hasWindow && startsAtShiftStart;
    widget.onChanged(
      assign,
      frequency,
      // The literal minute value is never read when
      // effectiveStartsAtShift is true (TaskController resolves the real
      // start from that day's ShiftLog instead) -- 0 is just a
      // placeholder satisfying "both window fields set or neither."
      hasWindow
          ? (effectiveStartsAtShift
                ? 0
                : windowStart!.hour * 60 + windowStart!.minute)
          : null,
      hasWindow ? windowEnd!.hour * 60 + windowEnd!.minute + 1 : null,
      effectiveStartsAtShift,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: EdgeInsets.only(left: widget.indent ? 16 : 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: widget.assigned,
                onChanged: (checked) => _notifyChanged(checked ?? false),
              ),
              Expanded(child: Text(widget.label)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40, bottom: 8),
            child: Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: Text(l10n.adHocLabel),
                  selected: mode == _SchedulingMode.adHoc,
                  onSelected: (_) => setState(() {
                    mode = _SchedulingMode.adHoc;
                    frequency = ScheduleFrequency.asNeeded;
                    windowEnabled = false;
                  }),
                ),
                ChoiceChip(
                  label: Text(l10n.timeAllocatedLabel),
                  selected: mode == _SchedulingMode.timeAllocated,
                  onSelected: (_) => setState(() {
                    mode = _SchedulingMode.timeAllocated;
                    if (frequency == ScheduleFrequency.asNeeded) {
                      frequency = ScheduleFrequency.daily;
                    }
                    if (_windowSupported) windowEnabled = true;
                  }),
                ),
              ],
            ),
          ),
          if (mode == _SchedulingMode.timeAllocated)
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: Row(
                children: [
                  Text(l10n.frequencyPrefixLabel),
                  DropdownButton<ScheduleFrequency>(
                    value: frequency,
                    items: ScheduleFrequency.values
                        .where((f) => f != ScheduleFrequency.asNeeded)
                        .map(
                          (f) => DropdownMenuItem(
                            value: f,
                            child: Text(frequencyLabel(f, l10n)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value == null) return;
                      // Only takes effect the next time the checkbox is
                      // (re-)ticked — changing frequency on an already-
                      // active assignment would otherwise silently create
                      // a duplicate schedule row.
                      setState(() => frequency = value);
                    },
                  ),
                ],
              ),
            ),
          if (mode == _SchedulingMode.timeAllocated && _windowSupported) ...[
            // Shift-relative window start (2026-09-24, direct user
            // request) — a real alternative to picking a fixed clock
            // time: "From start of shift" resolves at read time against
            // that day's actual clock-in, per person, per day, instead
            // of a fixed hour that doesn't fit everyone's real start
            // time.
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 4),
              child: Wrap(
                spacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(l10n.atATimeLabel),
                    selected: !startsAtShiftStart,
                    onSelected: (_) =>
                        setState(() => startsAtShiftStart = false),
                  ),
                  ChoiceChip(
                    label: Text(l10n.fromStartOfShiftLabel),
                    selected: startsAtShiftStart,
                    onSelected: (_) =>
                        setState(() => startsAtShiftStart = true),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: Row(
                children: [
                  if (!startsAtShiftStart)
                    TextButton(
                      onPressed: () async {
                        final picked = await showTimePicker(
                          context: context,
                          initialTime:
                              windowStart ??
                              const TimeOfDay(hour: 21, minute: 0),
                        );
                        if (picked == null) return;
                        setState(() => windowStart = picked);
                      },
                      child: Text(
                        windowStart == null
                            ? l10n.availableFromEllipsis
                            : l10n.fromTimeLabel(windowStart!.format(context)),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(l10n.fromClockInLabel),
                    ),
                  const Text('-'),
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime:
                            windowEnd ?? const TimeOfDay(hour: 23, minute: 59),
                      );
                      if (picked == null) return;
                      setState(() => windowEnd = picked);
                    },
                    child: Text(
                      windowEnd == null
                          ? l10n.untilEllipsis
                          : l10n.untilTimeLabel(windowEnd!.format(context)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// One row in "Assign by Task" mode — a task template, optionally paired
/// with a specific equipment instance (null for non-equipment tasks).
class _TaskRow {
  const _TaskRow({required this.template, required this.instance});
  final TaskTemplate template;
  final Equipment? instance;
}

/// Multi-select staff picker for "Assign by Task" mode's second step.
class _StaffMultiSelectDialog extends StatefulWidget {
  const _StaffMultiSelectDialog({required this.staff});
  final List<User> staff;

  @override
  State<_StaffMultiSelectDialog> createState() =>
      _StaffMultiSelectDialogState();
}

class _StaffMultiSelectDialogState extends State<_StaffMultiSelectDialog> {
  final Set<int> selectedIds = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.assignToTitle),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.staff.isEmpty
            ? Text(l10n.noStaffMatchTiers)
            : ListView(
                shrinkWrap: true,
                children: [
                  for (final user in widget.staff)
                    CheckboxListTile(
                      value: selectedIds.contains(user.id),
                      onChanged: (checked) => setState(() {
                        if (checked ?? false) {
                          selectedIds.add(user.id);
                        } else {
                          selectedIds.remove(user.id);
                        }
                      }),
                      title: Text(user.name),
                      subtitle: Text(
                        '${localizedJobTitle(user.jobTitle, l10n)} · ${roleTierDisplayName(user.roleTier, l10n)}',
                      ),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: selectedIds.isEmpty
              ? null
              : () => Navigator.pop(
                  context,
                  widget.staff
                      .where((u) => selectedIds.contains(u.id))
                      .toList(),
                ),
          child: Text(l10n.assignButton),
        ),
      ],
    );
  }
}
