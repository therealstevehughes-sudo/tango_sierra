import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/equipment_type.dart';
import '../../shared/models/task_preset.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/models/task_template.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/task_preset_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';

class PresetManagementScreen extends ConsumerStatefulWidget {
  const PresetManagementScreen({super.key});

  @override
  ConsumerState<PresetManagementScreen> createState() =>
      _PresetManagementScreenState();
}

class _PresetManagementScreenState
    extends ConsumerState<PresetManagementScreen> {
  bool loading = true;
  List<TaskPreset> presets = [];
  List<EquipmentType> equipmentTypes = [];
  List<TaskTemplate> templates = [];

  bool showCreateForm = false;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController segmentController = TextEditingController();
  int? createEquipmentTypeId;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    nameController.dispose();
    segmentController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final presetRepo = ref.read(taskPresetRepositoryProvider);
    final equipmentRepo = ref.read(equipmentRepositoryProvider);
    final templateRepo = ref.read(taskTemplateRepositoryProvider);

    final loadedPresets = await presetRepo.getAll();
    final loadedTypes = await equipmentRepo.getEquipmentTypes();
    final loadedTemplates = await templateRepo.getAllCurrentVersions();

    if (!mounted) return;
    setState(() {
      presets = loadedPresets;
      equipmentTypes = loadedTypes;
      templates = loadedTemplates;
      loading = false;
    });
  }

  String _equipmentTypeName(int id) {
    for (final t in equipmentTypes) {
      if (t.id == id) return t.name;
    }
    return 'Equipment type #$id';
  }

  String _templateTitle(int templateGroupId) {
    for (final t in templates) {
      if (t.templateGroupId == templateGroupId) return t.title;
    }
    return 'Task #$templateGroupId';
  }

  String _contextLabel(TaskPreset preset) {
    final parts = <String>[
      if (preset.equipmentTypeId != null)
        _equipmentTypeName(preset.equipmentTypeId!),
      if (preset.segment != null && preset.segment!.isNotEmpty)
        'Section: ${preset.segment}',
    ];
    return parts.join(' · ');
  }

  Future<void> _createPreset() async {
    final name = nameController.text.trim();
    final segment = segmentController.text.trim();
    final manager = ref.read(currentUserProvider);
    if (name.isEmpty || manager == null) return;
    if (createEquipmentTypeId == null && segment.isEmpty) return;

    final repo = ref.read(taskPresetRepositoryProvider);
    await repo.create(
      name: name,
      equipmentTypeId: createEquipmentTypeId,
      segment: segment.isEmpty ? null : segment,
      createdByUserId: manager.id,
    );

    if (!mounted) return;
    setState(() {
      showCreateForm = false;
      nameController.clear();
      segmentController.clear();
      createEquipmentTypeId = null;
    });
    await _loadData();
  }

  Future<void> _rename(TaskPreset preset) async {
    final controller = TextEditingController(text: preset.name);
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Preset'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (newName == null || newName.isEmpty || newName == preset.name) return;

    final repo = ref.read(taskPresetRepositoryProvider);
    await repo.rename(preset.id, newName);
    await _loadData();
  }

  Future<void> _setActive(TaskPreset preset, bool active) async {
    final repo = ref.read(taskPresetRepositoryProvider);
    await repo.setActive(preset.id, active);
    await _loadData();
  }

  Future<void> _removeItem(TaskPresetItem item) async {
    final repo = ref.read(taskPresetRepositoryProvider);
    await repo.removeItem(item.id);
    await _loadData();
  }

  Future<void> _addItem(TaskPreset preset) async {
    if (templates.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No task templates exist yet.')),
      );
      return;
    }

    int? selectedTemplateGroupId = templates.first.templateGroupId;
    ScheduleFrequency selectedFrequency = ScheduleFrequency.daily;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Add Task to Preset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<int>(
                initialValue: selectedTemplateGroupId,
                decoration: const InputDecoration(labelText: 'Task'),
                isExpanded: true,
                items: templates
                    .map(
                      (t) => DropdownMenuItem(
                        value: t.templateGroupId,
                        child: Text(t.title, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (value) =>
                    setDialogState(() => selectedTemplateGroupId = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ScheduleFrequency>(
                initialValue: selectedFrequency,
                decoration: const InputDecoration(labelText: 'Default frequency'),
                isExpanded: true,
                items: ScheduleFrequency.values
                    .map(
                      (f) => DropdownMenuItem(
                        value: f,
                        child: Text(frequencyLabel(f)),
                      ),
                    )
                    .toList(),
                onChanged: (value) => setDialogState(
                  () => selectedFrequency = value ?? selectedFrequency,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );

    if (confirmed != true || selectedTemplateGroupId == null) return;

    final repo = ref.read(taskPresetRepositoryProvider);
    await repo.addItem(
      presetId: preset.id,
      taskTemplateGroupId: selectedTemplateGroupId!,
      defaultFrequency: selectedFrequency,
    );
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Task Presets')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              if (presets.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('No presets yet.'),
                )
              else
                ...presets.map(_buildPresetCard),
              const Divider(),
              if (!showCreateForm)
                ElevatedButton(
                  onPressed: () => setState(() => showCreateForm = true),
                  child: const Text('Create Preset'),
                )
              else
                _buildCreateForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPresetCard(TaskPreset preset) {
    return Card(
      child: ExpansionTile(
        title: Text(
          preset.active ? preset.name : '${preset.name} (inactive)',
          style: TextStyle(color: preset.active ? null : Colors.grey),
        ),
        subtitle: Text(
          '${_contextLabel(preset)} · ${preset.items.length} task'
          '${preset.items.length == 1 ? '' : 's'}',
        ),
        children: [
          for (final item in preset.items)
            ListTile(
              dense: true,
              title: Text(_templateTitle(item.taskTemplateGroupId)),
              subtitle: Text(frequencyLabel(item.defaultFrequency)),
              trailing: IconButton(
                icon: const Icon(Icons.close),
                tooltip: 'Remove',
                onPressed: () => _removeItem(item),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () => _addItem(preset),
                  icon: const Icon(Icons.add),
                  label: const Text('Add task'),
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () => _rename(preset),
                      child: const Text('Rename'),
                    ),
                    TextButton(
                      onPressed: () => _setActive(preset, !preset.active),
                      child: Text(preset.active ? 'Deactivate' : 'Reactivate'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCreateForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        const Text(
          'New Preset',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: nameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<int?>(
          initialValue: createEquipmentTypeId,
          decoration: const InputDecoration(
            labelText: 'Equipment type (optional)',
          ),
          isExpanded: true,
          items: [
            const DropdownMenuItem<int?>(value: null, child: Text('None')),
            ...equipmentTypes.map(
              (t) => DropdownMenuItem<int?>(value: t.id, child: Text(t.name)),
            ),
          ],
          onChanged: (value) => setState(() => createEquipmentTypeId = value),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: segmentController,
          decoration: const InputDecoration(
            labelText: 'Section / segment (optional)',
          ),
        ),
        const SizedBox(height: 8),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            'Set an equipment type or a section (at least one).',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => setState(() => showCreateForm = false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _createPreset,
              child: const Text('Create Preset'),
            ),
          ],
        ),
      ],
    );
  }
}
