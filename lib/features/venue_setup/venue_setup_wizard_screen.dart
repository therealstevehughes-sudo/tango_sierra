import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../shared/models/area.dart';
import '../../shared/models/equipment.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/site.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';

class VenueSetupWizardScreen extends ConsumerStatefulWidget {
  const VenueSetupWizardScreen({super.key});

  @override
  ConsumerState<VenueSetupWizardScreen> createState() =>
      _VenueSetupWizardScreenState();
}

class _VenueSetupWizardScreenState
    extends ConsumerState<VenueSetupWizardScreen> {
  int currentStep = 0;
  bool loading = true;

  List<Area> areas = [];
  List<EquipmentType> equipmentTypes = [];
  List<Equipment> equipmentInstances = [];
  List<User> staff = [];

  final TextEditingController areaNameController = TextEditingController();
  final TextEditingController equipmentNameController =
      TextEditingController();
  int? selectedEquipmentTypeId;
  int? selectedAreaId;
  bool addingNewEquipmentType = false;
  final TextEditingController newEquipmentTypeController =
      TextEditingController();

  final TextEditingController staffNameController = TextEditingController();
  final TextEditingController staffJobTitleController =
      TextEditingController();
  final TextEditingController staffPinController = TextEditingController();
  RoleTier selectedRoleTier = RoleTier.base;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    areaNameController.dispose();
    equipmentNameController.dispose();
    newEquipmentTypeController.dispose();
    staffNameController.dispose();
    staffJobTitleController.dispose();
    staffPinController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final areaRepo = ref.read(areaRepositoryProvider);
    final equipmentRepo = ref.read(equipmentRepositoryProvider);
    final userRepo = ref.read(userRepositoryProvider);

    final loadedAreas = await areaRepo.getAll();
    final loadedTypes = await equipmentRepo.getEquipmentTypes();
    final loadedEquipment = await equipmentRepo.getAll();
    final loadedStaff = await userRepo.getAll();

    if (!mounted) return;
    setState(() {
      areas = loadedAreas;
      equipmentTypes = loadedTypes;
      equipmentInstances = loadedEquipment;
      staff = loadedStaff;
      loading = false;
    });
  }

  // Falls back to the default site when no active site has been explicitly
  // selected (Venue Details' "Set as Active") — preserves existing
  // single-site behavior unchanged (Sprint 025).
  Future<Site> _resolveActiveSite() async {
    return ref.read(activeSiteProvider) ??
        await ref.read(currentSiteProvider.future);
  }

  Future<void> _addArea(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;

    final site = await _resolveActiveSite();
    final repo = ref.read(areaRepositoryProvider);
    final created = await repo.create(trimmed, site.id);

    if (!mounted) return;
    setState(() {
      areas = [...areas, created];
      areaNameController.clear();
    });
  }

  Future<void> _addEquipment() async {
    final name = equipmentNameController.text.trim();
    if (name.isEmpty || selectedEquipmentTypeId == null) return;

    final site = await _resolveActiveSite();
    final repo = ref.read(equipmentRepositoryProvider);
    final created = await repo.create(
      name: name,
      equipmentTypeId: selectedEquipmentTypeId!,
      areaId: selectedAreaId,
      siteId: site.id,
    );

    if (!mounted) return;
    setState(() {
      equipmentInstances = [...equipmentInstances, created];
      equipmentNameController.clear();
    });
  }

  Future<void> _addNewEquipmentType() async {
    final name = newEquipmentTypeController.text.trim();
    if (name.isEmpty) return;

    final repo = ref.read(equipmentRepositoryProvider);
    final created = await repo.createEquipmentType(name);

    if (!mounted) return;
    setState(() {
      equipmentTypes = [...equipmentTypes, created];
      selectedEquipmentTypeId = created.id;
      addingNewEquipmentType = false;
      newEquipmentTypeController.clear();
      equipmentNameController.text = _suggestedEquipmentName(created.id);
    });
  }

  Future<void> _addStaff() async {
    final name = staffNameController.text.trim();
    final jobTitle = staffJobTitleController.text.trim();
    final pin = staffPinController.text.trim();
    if (name.isEmpty || jobTitle.isEmpty || pin.isEmpty) return;

    final site = await _resolveActiveSite();
    final repo = ref.read(userRepositoryProvider);
    final created = await repo.createStaffMember(
      name: name,
      jobTitle: jobTitle,
      roleTier: selectedRoleTier,
      pin: pin,
      siteId: site.id,
    );

    if (!mounted) return;
    setState(() {
      staff = [...staff, created];
      staffNameController.clear();
      staffJobTitleController.clear();
      staffPinController.clear();
    });
  }

  Future<String?> _promptForName(String title, String currentName) {
    final controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
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
  }

  Future<void> _renameArea(Area area) async {
    final newName = await _promptForName('Rename Area', area.name);
    if (newName == null || newName.isEmpty || newName == area.name) return;

    final repo = ref.read(areaRepositoryProvider);
    await repo.rename(area.id, newName);

    if (!mounted) return;
    setState(() {
      areas = areas
          .map((a) => a.id == area.id ? Area(id: a.id, name: newName, siteId: a.siteId) : a)
          .toList();
    });
  }

  Future<void> _renameEquipment(Equipment equipment) async {
    final newName = await _promptForName('Rename Equipment', equipment.name);
    if (newName == null || newName.isEmpty || newName == equipment.name) {
      return;
    }

    final repo = ref.read(equipmentRepositoryProvider);
    await repo.rename(equipment.id, newName);

    if (!mounted) return;
    setState(() {
      equipmentInstances = equipmentInstances
          .map(
            (e) => e.id == equipment.id
                ? Equipment(
                    id: e.id,
                    name: newName,
                    equipmentTypeId: e.equipmentTypeId,
                    areaId: e.areaId,
                    siteId: e.siteId,
                    active: e.active,
                  )
                : e,
          )
          .toList();
    });
  }

  Future<void> _toggleEquipmentActive(Equipment equipment) async {
    final activating = !equipment.active;

    if (!activating) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Retire Equipment'),
          content: const Text(
            'Retiring this equipment will also unassign any tasks '
            'currently assigned to it. Past submission history is kept. '
            'Continue?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Retire'),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
    }

    final repo = ref.read(equipmentRepositoryProvider);
    await repo.setActive(equipment.id, activating);

    if (!mounted) return;
    setState(() {
      equipmentInstances = equipmentInstances
          .map(
            (e) => e.id == equipment.id
                ? Equipment(
                    id: e.id,
                    name: e.name,
                    equipmentTypeId: e.equipmentTypeId,
                    areaId: e.areaId,
                    siteId: e.siteId,
                    active: activating,
                  )
                : e,
          )
          .toList();
    });
  }

  String _suggestedEquipmentName(int? typeId) {
    if (typeId == null) return '';
    final type = equipmentTypes.firstWhere(
      (t) => t.id == typeId,
      orElse: () => const EquipmentType(id: -1, name: ''),
    );
    if (type.name.isEmpty) return '';

    final countOfType = equipmentInstances
        .where((e) => e.equipmentTypeId == typeId)
        .length;
    return '${type.name} ${countOfType + 1}';
  }

  String _equipmentSubtitle(Equipment equipment) {
    final type = equipmentTypes.firstWhere(
      (t) => t.id == equipment.equipmentTypeId,
      orElse: () => const EquipmentType(id: -1, name: 'Unknown type'),
    );
    if (equipment.areaId == null) return type.name;

    final area = areas.firstWhere(
      (a) => a.id == equipment.areaId,
      orElse: () => const Area(id: -1, name: 'Unknown area', siteId: -1),
    );
    return '${type.name} — ${area.name}';
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Venue Setup — Step ${currentStep + 1} of 3'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: SingleChildScrollView(child: _buildStep())),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (currentStep > 0)
                    TextButton(
                      onPressed: () => setState(() => currentStep -= 1),
                      child: const Text('Back'),
                    )
                  else
                    const SizedBox.shrink(),
                  PrimaryActionButton(
                    label: currentStep < 2 ? 'Next' : 'Finish Setup',
                    onPressed: () {
                      if (currentStep < 2) {
                        setState(() => currentStep += 1);
                      } else {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep() {
    switch (currentStep) {
      case 0:
        return _buildAreasStep();
      case 1:
        return _buildEquipmentStep();
      default:
        return _buildStaffStep();
    }
  }

  Widget _buildAreasStep() {
    const suggestions = ['Kitchen', 'Storage', 'Receiving', 'Front of House'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Areas', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('Add the operational zones of this venue.'),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          children: suggestions
              .map((s) => ActionChip(label: Text(s), onPressed: () => _addArea(s)))
              .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: areaNameController,
                decoration: const InputDecoration(labelText: 'Area name'),
              ),
            ),
            IconButton(
              onPressed: () => _addArea(areaNameController.text),
              icon: const Icon(Icons.add),
              tooltip: 'Add area',
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...areas.map(
          (a) => Card(
            child: ListTile(
              title: Text(a.name),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                tooltip: 'Rename',
                onPressed: () => _renameArea(a),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Equipment', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('Add named equipment instances, e.g. "Fridge 1", "Fridge 2".'),
        const SizedBox(height: 16),
        DropdownButtonFormField<int>(
          initialValue: selectedEquipmentTypeId,
          decoration: const InputDecoration(labelText: 'Equipment type'),
          items: [
            ...equipmentTypes.map(
              (t) => DropdownMenuItem(value: t.id, child: Text(t.name)),
            ),
            const DropdownMenuItem(
              value: -1,
              child: Text('Something else...'),
            ),
          ],
          onChanged: (value) {
            if (value == -1) {
              setState(() {
                addingNewEquipmentType = true;
                selectedEquipmentTypeId = null;
              });
              return;
            }
            setState(() {
              addingNewEquipmentType = false;
              selectedEquipmentTypeId = value;
              equipmentNameController.text = _suggestedEquipmentName(value);
            });
          },
        ),
        if (addingNewEquipmentType)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: newEquipmentTypeController,
                    decoration: const InputDecoration(
                      labelText: 'New equipment type name',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addNewEquipmentType,
                  icon: const Icon(Icons.check),
                  tooltip: 'Confirm new equipment type',
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        if (areas.isEmpty)
          const Text('No areas added yet — go back to add one.')
        else
          DropdownButtonFormField<int>(
            initialValue: selectedAreaId,
            decoration: const InputDecoration(labelText: 'Area'),
            items: areas
                .map(
                  (a) => DropdownMenuItem(value: a.id, child: Text(a.name)),
                )
                .toList(),
            onChanged: (value) => setState(() => selectedAreaId = value),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: equipmentNameController,
                decoration: const InputDecoration(labelText: 'Equipment name'),
              ),
            ),
            IconButton(
              onPressed: _addEquipment,
              icon: const Icon(Icons.add),
              tooltip: 'Add equipment',
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...equipmentInstances.map(
          (e) => Card(
            child: ListTile(
              title: Text(
                e.active ? e.name : '${e.name} (retired)',
                style: e.active
                    ? null
                    : const TextStyle(color: AppColors.muted),
              ),
              subtitle: Text(_equipmentSubtitle(e)),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Rename',
                    onPressed: () => _renameEquipment(e),
                  ),
                  IconButton(
                    icon: Icon(
                      e.active ? Icons.remove_circle_outline : Icons.restore,
                    ),
                    tooltip: e.active ? 'Retire' : 'Reactivate',
                    onPressed: () => _toggleEquipmentActive(e),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStaffStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Staff', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        const Text('Add staff members and assign their role tier.'),
        const SizedBox(height: 16),
        TextField(
          controller: staffNameController,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: staffJobTitleController,
          decoration: const InputDecoration(labelText: 'Job title'),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<RoleTier>(
          initialValue: selectedRoleTier,
          decoration: const InputDecoration(labelText: 'Role tier'),
          items: RoleTier.values
              .map(
                (tier) => DropdownMenuItem(
                  value: tier,
                  child: Text(roleTierDisplayName(tier)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => selectedRoleTier = value);
          },
        ),
        const SizedBox(height: 12),
        TextField(
          controller: staffPinController,
          keyboardType: TextInputType.number,
          obscureText: true,
          decoration: const InputDecoration(labelText: 'PIN'),
        ),
        const SizedBox(height: 12),
        PrimaryActionButton(label: 'Add Staff Member', onPressed: _addStaff),
        const SizedBox(height: 16),
        ...staff.map(
          (s) => Card(
            child: ListTile(
              title: Text('${s.name} (${s.jobTitle})'),
              subtitle: Text(roleTierDisplayName(s.roleTier)),
            ),
          ),
        ),
      ],
    );
  }
}
