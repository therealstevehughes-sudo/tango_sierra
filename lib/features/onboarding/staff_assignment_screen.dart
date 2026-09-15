import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/equipment.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/task_preset.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_preset_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';

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
  bool customRequiresCorrectiveActionOnFail = false;
  int? customEquipmentTypeId;

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
    super.dispose();
  }

  Future<void> _loadData() async {
    final userRepo = ref.read(userRepositoryProvider);
    final templateRepo = ref.read(taskTemplateRepositoryProvider);
    final equipmentRepo = ref.read(equipmentRepositoryProvider);
    final presetRepo = ref.read(taskPresetRepositoryProvider);
    final site =
        ref.read(activeSiteProvider) ??
        await ref.read(currentSiteProvider.future);
    if (site == null) return;

    final loadedStaff = await userRepo.getForSite(site.id);
    final loadedTemplates = await templateRepo.getAllCurrentVersions();
    final loadedTypes = await equipmentRepo.getEquipmentTypes();
    final loadedInstances = await equipmentRepo.getForSite(site.id);
    final loadedPresets = await presetRepo.getAll();

    if (!mounted) return;
    setState(() {
      staffList = loadedStaff;
      templates = loadedTemplates;
      equipmentTypes = loadedTypes;
      equipmentInstances = loadedInstances;
      // Only active presets are offered for application.
      presets = loadedPresets.where((p) => p.active).toList();
      loading = false;
    });
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
    if (title.isEmpty || manager == null || staff == null) return;

    final templateRepo = ref.read(taskTemplateRepositoryProvider);
    final result = await templateRepo.saveNewVersion(
      title: title,
      segment: 'custom',
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
      customPriority = TaskPriority.standard;
      customRequiresCorrectiveActionOnFail = false;
      customRequiresPhoto = false;
      customRequiresNotes = false;
      customEquipmentTypeId = null;
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
    final parts = <String>[
      for (final t in equipmentTypes)
        if (t.id == preset.equipmentTypeId) t.name,
      if (preset.segment != null && preset.segment!.isNotEmpty)
        'Section: ${preset.segment}',
    ];
    final context = parts.join(' · ');
    final count =
        '${preset.items.length} task'
        '${preset.items.length == 1 ? '' : 's'}';
    return context.isEmpty ? count : '$context · $count';
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
        const SnackBar(content: Text('No equipment of this type set up yet.')),
      );
      return;
    }

    final chosen = await showDialog<Equipment>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text('Apply "${preset.name}" to which one?'),
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          count == 0
              ? 'All ${preset.name} tasks were already assigned'
              : 'Added $count task${count == 1 ? '' : 's'} from ${preset.name}',
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
          const SnackBar(content: Text('No equipment of this type set up yet.')),
        );
        return;
      }
      final chosen = await showDialog<Equipment>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text('Apply "${preset.name}" to which one?'),
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
        builder: (context, setDialogState) => AlertDialog(
          title: Text('Apply "${preset.name}" to'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              shrinkWrap: true,
              children: staffList
                  .map(
                    (u) => CheckboxListTile(
                      value: selected.contains(u.id),
                      title: Text(u.name),
                      subtitle: Text(u.jobTitle),
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
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: selected.isEmpty
                  ? null
                  : () => Navigator.pop(context, true),
              child: const Text('Apply'),
            ),
          ],
        ),
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
          'Added $totalAdded task${totalAdded == 1 ? '' : 's'} across '
          '${selected.length} staff member${selected.length == 1 ? '' : 's'}',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          mode == _AssignMode.byTask
              ? 'Assign Tasks'
              : selectedStaff == null
              ? 'Assign Tasks'
              : 'Assign Tasks — ${selectedStaff!.name}',
        ),
        leading: mode == _AssignMode.byPerson && selectedStaff != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedStaff = null),
              )
            : null,
      ),
      // Navigation-consistency pass (Sprint 031): while a staff member is
      // selected, this AppBar's `leading` is the "back to staff list"
      // arrow above, not the drawer hamburger — the drawer stays reachable
      // via edge-swipe in that state (pre-existing Scaffold behavior, not
      // new here), same as any screen with a custom leading widget.
      drawer: const ManagementDrawer(title: 'Assign Tasks'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SegmentedButton<_AssignMode>(
                  segments: const [
                    ButtonSegment(
                      value: _AssignMode.byPerson,
                      label: Text('By Person'),
                      icon: Icon(Icons.person_outline),
                    ),
                    ButtonSegment(
                      value: _AssignMode.byTask,
                      label: Text('By Task'),
                      icon: Icon(Icons.checklist_outlined),
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
    final groups = <String, List<_TaskRow>>{};
    for (final template in templates) {
      if (template.equipmentTypeId == null) {
        groups
            .putIfAbsent('Segment: ${template.segment}', () => [])
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
                    for (final row in groups[groupName]!)
                      _buildByTaskRow(row),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        PrimaryActionButton(
          label: selectedTaskKeys.isEmpty
              ? 'Select tasks to assign'
              : 'Assign ${selectedTaskKeys.length} task${selectedTaskKeys.length == 1 ? '' : 's'} to staff…',
          onPressed: selectedTaskKeys.isEmpty ? null : _pickStaffAndAssign,
        ),
      ],
    );
  }

  Widget _buildByTaskRow(_TaskRow row) {
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
                    tooltip: 'Show instructions',
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
      final existingForStaff = await scheduleRepo.getForStaffMember(
        staff.id,
      );
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$created assignment${created == 1 ? '' : 's'} created'
          '${skipped > 0 ? ' ($skipped skipped — already assigned or role mismatch)' : ''}.',
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
            title: Text('${user.name} (${user.jobTitle})'),
            subtitle: Text(roleTierDisplayName(user.roleTier)),
            onTap: () => _selectStaff(user),
          ),
        );
      },
    );
  }

  Widget _buildAssignmentList() {
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

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (presets.isNotEmpty) ...[
            const SectionHeader(title: 'Task Presets'),
            for (final preset in presets)
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
                            tooltip: 'Show tasks in this group',
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
                            child: const Text('Apply'),
                          ),
                          TextButton(
                            onPressed: () => _onApplyPresetToMultiple(preset),
                            child: const Text('Apply to Multiple'),
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
                'Show all roles (default: ${jobRoleDisplayName(staff.jobRole!)} only)',
              ),
              onChanged: (value) =>
                  setState(() => showAllJobRoles = value ?? false),
            ),
          for (final segment in grouped.keys) ...[
            SectionHeader(title: segment),
            for (final template in grouped[segment]!)
              _buildTemplateRow(template),
            const SizedBox(height: 16),
          ],
          const Divider(),
          if (!showCustomTaskForm)
            PrimaryActionButton(
              label: 'Add Custom Task',
              onPressed: () => setState(() => showCustomTaskForm = true),
            )
          else
            _buildCustomTaskForm(),
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
        onChanged: (assign, frequency, windowStart, windowEnd) =>
            _toggleAssignment(
              templateGroupId: template.templateGroupId,
              frequency: frequency,
              assign: assign,
              windowStartMinutes: windowStart,
              windowEndMinutesExclusive: windowEnd,
            ),
      );
    }

    final matchingInstances = equipmentInstances
        .where((e) => e.equipmentTypeId == template.equipmentTypeId && e.active)
        .toList();

    if (matchingInstances.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text('${template.title} — no equipment set up for this yet'),
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
      onChanged: (assign, frequency, windowStart, windowEnd) =>
          _toggleAssignment(
            templateGroupId: template.templateGroupId,
            equipmentId: instance.id,
            frequency: frequency,
            assign: assign,
            windowStartMinutes: windowStart,
            windowEndMinutesExclusive: windowEnd,
          ),
    );
  }

  Widget _buildCustomTaskForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const SectionHeader(title: 'Custom Task'),
        TextField(
          controller: customTitleController,
          decoration: const InputDecoration(labelText: 'Title'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: customMethod,
          decoration: const InputDecoration(labelText: 'Method'),
          items: const [
            DropdownMenuItem(value: 'tick', child: Text('Tick')),
            DropdownMenuItem(value: 'data', child: Text('Data')),
            DropdownMenuItem(value: 'data_tick', child: Text('Data + Tick')),
            DropdownMenuItem(value: 'tick_photo', child: Text('Tick + Photo')),
            DropdownMenuItem(value: 'data_photo', child: Text('Data + Photo')),
            DropdownMenuItem(value: 'note', child: Text('Note')),
            DropdownMenuItem(value: 'data_note', child: Text('Data + Note')),
            DropdownMenuItem(value: 'note_photo', child: Text('Note + Photo')),
            DropdownMenuItem(value: 'tick_note', child: Text('Tick + Note')),
            DropdownMenuItem(value: 'multi', child: Text('Multi')),
          ],
          onChanged: (value) {
            if (value != null) setState(() => customMethod = value);
          },
        ),
        CheckboxListTile(
          title: const Text('Requires photo'),
          value: customRequiresPhoto,
          onChanged: (v) => setState(() => customRequiresPhoto = v ?? false),
        ),
        CheckboxListTile(
          title: const Text('Requires notes'),
          value: customRequiresNotes,
          onChanged: (v) => setState(() => customRequiresNotes = v ?? false),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: customMinLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Min limit'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: customMaxLimitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Max limit'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        TextField(
          controller: customUnitController,
          decoration: const InputDecoration(labelText: 'Unit (e.g. celsius)'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int?>(
          initialValue: customEquipmentTypeId,
          decoration: const InputDecoration(
            labelText: 'Equipment type (optional)',
          ),
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('None')),
            ...equipmentTypes.map(
              (t) => DropdownMenuItem<int?>(value: t.id, child: Text(t.name)),
            ),
          ],
          onChanged: (value) => setState(() => customEquipmentTypeId = value),
        ),
        DropdownButtonFormField<TaskPriority>(
          initialValue: customPriority,
          decoration: const InputDecoration(labelText: 'Priority'),
          items: const [
            DropdownMenuItem(
              value: TaskPriority.critical,
              child: Text('Critical'),
            ),
            DropdownMenuItem(value: TaskPriority.high, child: Text('High')),
            DropdownMenuItem(
              value: TaskPriority.standard,
              child: Text('Standard'),
            ),
          ],
          onChanged: (value) {
            if (value != null) setState(() => customPriority = value);
          },
        ),
        CheckboxListTile(
          title: const Text('Requires corrective action on fail'),
          value: customRequiresCorrectiveActionOnFail,
          onChanged: (v) =>
              setState(() => customRequiresCorrectiveActionOnFail = v ?? false),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: customFixInstructionsController,
          decoration: const InputDecoration(labelText: 'Fix instructions'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: customFieldsJsonController,
          decoration: const InputDecoration(
            labelText: 'Custom fields (JSON, optional)',
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => showCustomTaskForm = false),
              child: const Text('Cancel'),
            ),
            PrimaryActionButton(
              label: 'Save Custom Task',
              onPressed: _saveCustomTask,
            ),
          ],
        ),
      ],
    );
  }
}

class _AssignmentTile extends StatefulWidget {
  const _AssignmentTile({
    required this.label,
    required this.assigned,
    required this.frequency,
    required this.onChanged,
    this.indent = false,
    this.windowStartMinutes,
    this.windowEndMinutesExclusive,
  });

  final String label;
  final bool assigned;
  final ScheduleFrequency frequency;
  final bool indent;
  final int? windowStartMinutes;
  final int? windowEndMinutesExclusive;
  final void Function(
    bool assign,
    ScheduleFrequency frequency,
    int? windowStartMinutes,
    int? windowEndMinutesExclusive,
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

  static TimeOfDay? _toTimeOfDay(int? minutes) => minutes == null
      ? null
      : TimeOfDay(hour: minutes ~/ 60, minute: minutes % 60);

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
        windowStart != null &&
        windowEnd != null;
    widget.onChanged(
      assign,
      frequency,
      hasWindow ? windowStart!.hour * 60 + windowStart!.minute : null,
      hasWindow ? windowEnd!.hour * 60 + windowEnd!.minute + 1 : null,
    );
  }

  @override
  Widget build(BuildContext context) {
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
              DropdownButton<ScheduleFrequency>(
                value: frequency,
                items: ScheduleFrequency.values
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(frequencyLabel(f)),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  // Only takes effect the next time the checkbox is
                  // (re-)ticked — changing frequency on an already-active
                  // assignment would otherwise silently create a
                  // duplicate schedule row.
                  setState(() => frequency = value);
                },
              ),
            ],
          ),
          if (_windowSupported)
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: CheckboxListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                value: windowEnabled,
                title: const Text('Restrict to a time window'),
                onChanged: (checked) =>
                    setState(() => windowEnabled = checked ?? false),
              ),
            ),
          if (_windowSupported && windowEnabled)
            Padding(
              padding: const EdgeInsets.only(left: 40, bottom: 8),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                        context: context,
                        initialTime:
                            windowStart ?? const TimeOfDay(hour: 21, minute: 0),
                      );
                      if (picked == null) return;
                      setState(() => windowStart = picked);
                    },
                    child: Text(
                      windowStart == null
                          ? 'Available from…'
                          : 'From ${windowStart!.format(context)}',
                    ),
                  ),
                  const Text('–'),
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
                          ? 'until…'
                          : 'until ${windowEnd!.format(context)}',
                    ),
                  ),
                ],
              ),
            ),
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
    return AlertDialog(
      title: const Text('Assign to'),
      content: SizedBox(
        width: double.maxFinite,
        child: widget.staff.isEmpty
            ? const Text(
                'No staff match the tier(s) these tasks apply to.',
              )
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
                        '${user.jobTitle} · ${roleTierDisplayName(user.roleTier)}',
                      ),
                    ),
                ],
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
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
          child: const Text('Assign'),
        ),
      ],
    );
  }
}
