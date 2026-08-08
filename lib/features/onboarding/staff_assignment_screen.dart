import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/equipment.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/task_preset.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
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

class _StaffAssignmentScreenState
    extends ConsumerState<StaffAssignmentScreen> {
  bool loading = true;

  List<User> staffList = [];
  List<TaskTemplate> templates = [];
  List<EquipmentType> equipmentTypes = [];
  List<Equipment> equipmentInstances = [];
  List<TaskPreset> presets = [];

  User? selectedStaff;
  List<TaskSchedule> schedulesForSelectedStaff = [];

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

    final loadedStaff = await userRepo.getAll();
    final loadedTemplates = await templateRepo.getAllCurrentVersions();
    final loadedTypes = await equipmentRepo.getEquipmentTypes();
    final loadedInstances = await equipmentRepo.getAll();
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
        siteId: staff.siteId,
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

  String _presetSubtitle(TaskPreset preset) {
    final parts = <String>[
      for (final t in equipmentTypes)
        if (t.id == preset.equipmentTypeId) t.name,
      if (preset.segment != null && preset.segment!.isNotEmpty)
        'Section: ${preset.segment}',
    ];
    final context = parts.join(' · ');
    final count = '${preset.items.length} task'
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
      siteId: staff.siteId,
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

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          selectedStaff == null
              ? 'Assign Tasks'
              : 'Assign Tasks — ${selectedStaff!.name}',
        ),
        leading: selectedStaff == null
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => selectedStaff = null),
              ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: selectedStaff == null
              ? _buildStaffList()
              : _buildAssignmentList(),
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
    final applicable = templates
        .where((t) => t.applicableRoleTiers.contains(staff.roleTier))
        .toList();

    final Map<String, List<TaskTemplate>> grouped = {};
    for (final template in applicable) {
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
                child: ListTile(
                  title: Text(preset.name),
                  subtitle: Text(_presetSubtitle(preset)),
                  trailing: TextButton(
                    onPressed: () => _onApplyPreset(preset),
                    child: const Text('Apply'),
                  ),
                ),
              ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
          ],
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
      return _AssignmentTile(
        label: template.title,
        frequency: _existingSchedule(
          template.templateGroupId,
          null,
        )?.frequency ?? ScheduleFrequency.daily,
        assigned: _existingSchedule(template.templateGroupId, null) != null,
        onChanged: (assign, frequency) => _toggleAssignment(
          templateGroupId: template.templateGroupId,
          frequency: frequency,
          assign: assign,
        ),
      );
    }

    final matchingInstances = equipmentInstances
        .where(
          (e) => e.equipmentTypeId == template.equipmentTypeId && e.active,
        )
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
          Text(template.title, style: const TextStyle(fontWeight: FontWeight.w600)),
          for (final instance in matchingInstances)
            _AssignmentTile(
              label: instance.name,
              indent: true,
              frequency: _existingSchedule(
                template.templateGroupId,
                instance.id,
              )?.frequency ?? ScheduleFrequency.daily,
              assigned:
                  _existingSchedule(template.templateGroupId, instance.id) !=
                  null,
              onChanged: (assign, frequency) => _toggleAssignment(
                templateGroupId: template.templateGroupId,
                equipmentId: instance.id,
                frequency: frequency,
                assign: assign,
              ),
            ),
        ],
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
          decoration: const InputDecoration(labelText: 'Equipment type (optional)'),
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
          decoration: const InputDecoration(labelText: 'Custom fields (JSON, optional)'),
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
  });

  final String label;
  final bool assigned;
  final ScheduleFrequency frequency;
  final bool indent;
  final void Function(bool assign, ScheduleFrequency frequency) onChanged;

  @override
  State<_AssignmentTile> createState() => _AssignmentTileState();
}

class _AssignmentTileState extends State<_AssignmentTile> {
  late ScheduleFrequency frequency = widget.frequency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: widget.indent ? 16 : 0),
      child: Row(
        children: [
          Checkbox(
            value: widget.assigned,
            onChanged: (checked) =>
                widget.onChanged(checked ?? false, frequency),
          ),
          Expanded(child: Text(widget.label)),
          DropdownButton<ScheduleFrequency>(
            value: frequency,
            items: ScheduleFrequency.values
                .map(
                  (f) =>
                      DropdownMenuItem(value: f, child: Text(frequencyLabel(f))),
                )
                .toList(),
            onChanged: (value) {
              if (value == null) return;
              // Only takes effect the next time the checkbox is (re-)ticked —
              // changing frequency on an already-active assignment would
              // otherwise silently create a duplicate schedule row.
              setState(() => frequency = value);
            },
          ),
        ],
      ),
    );
  }
}
