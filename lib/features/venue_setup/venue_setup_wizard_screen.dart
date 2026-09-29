import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/area.dart';
import '../../shared/models/duplicate_equipment_name_exception.dart';
import '../../shared/models/equipment.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/site.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/supplier_category.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/supplier_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import '../settings/widgets/add_staff_dialog.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../l10n/app_localizations.dart';

class VenueSetupWizardScreen extends ConsumerStatefulWidget {
  const VenueSetupWizardScreen({super.key, this.initialStep = 0});

  /// The wizard step to open on (0 = Areas, 1 = Equipment, 2 = Staff,
  /// 3 = Suppliers). Used by the Setup Checklist's deep-links so a
  /// manager tapping "Add your equipment" lands on the Equipment step
  /// instead of always starting from Areas. Clamped to 0..3.
  final int initialStep;

  @override
  ConsumerState<VenueSetupWizardScreen> createState() =>
      _VenueSetupWizardScreenState();
}

class _VenueSetupWizardScreenState
    extends ConsumerState<VenueSetupWizardScreen> {
  late int currentStep;
  bool loading = true;
  // Surfaced load failure (2026-09-28, direct founder report of this
  // screen hanging on a spinner forever with no way to tell why) —
  // _loadData() previously had no error handling at all, so any thrown
  // exception left `loading` stuck true permanently with nothing visible
  // anywhere. Now the real error (and a retry) shows in the body instead.
  String? loadError;

  List<Area> areas = [];
  List<EquipmentType> equipmentTypes = [];
  List<Equipment> equipmentInstances = [];
  List<User> staff = [];
  List<Supplier> suppliers = [];

  // Venue-type filtering (2026-09-15) — Sprint 029 built the tagging
  // schema/repository layer only; this wires it into the one place the
  // backlog specifically named: the equipment-type offering below. An
  // equipment type with NO tags at all is universal/generic and always
  // offered (e.g. "Thermometer" isn't specific to any venue type); a
  // tagged one only shows when it matches one of the site's own tags.
  // Never a hard lockout, matching this app's "defaults not lockouts"
  // convention — "Show all equipment types" always escapes the filter.
  List<int> siteVenueTypeIds = [];
  Map<int, List<int>> venueTypeIdsByEquipmentTypeId = {};
  bool showAllEquipmentTypes = false;

  final TextEditingController supplierNameController = TextEditingController();
  final TextEditingController supplierContactController =
      TextEditingController();
  SupplierCategory selectedSupplierCategory = SupplierCategory.freshProduce;
  SupplierApprovalStatus selectedSupplierApproval =
      SupplierApprovalStatus.approved;

  final TextEditingController areaNameController = TextEditingController();
  final TextEditingController equipmentNameController = TextEditingController();
  // Model/serial number (2026-09-28, direct founder request) — optional,
  // helps ordering the right replacement part when something breaks.
  final TextEditingController equipmentModelController =
      TextEditingController();
  final TextEditingController equipmentSerialController =
      TextEditingController();
  int? selectedEquipmentTypeId;
  int? selectedAreaId;
  bool addingNewEquipmentType = false;
  final TextEditingController newEquipmentTypeController =
      TextEditingController();

  final TextEditingController staffNameController = TextEditingController();
  final TextEditingController staffJobTitleController = TextEditingController();
  final TextEditingController staffPinController = TextEditingController();
  RoleTier selectedRoleTier = RoleTier.base;
  // JobRole.everyone is deliberately excluded from selection here — it's a
  // task-applicability value (a handful of hygiene-basics tasks that apply
  // regardless of job), never a real person's own day job.
  JobRole selectedJobRole = JobRole.chefCook;

  // Department heads can add their own equipment (2026-09-28, direct
  // founder request — Ryan Osei/Marco Rossi etc. previously had no way to
  // reach this screen at all, only a GM/venueManager could). Kept narrow
  // rather than opening the whole 4-step wizard to supervisors: a
  // supervisor only ever sees the Equipment step, no Areas/Staff/Supplier
  // setup. A GM (or above) still gets the full wizard, unchanged.
  bool get _equipmentOnly {
    final tier = ref.read(currentUserProvider)?.roleTier;
    return tier == RoleTier.supervisor;
  }

  // Properly scoped to the supervisor's own department (2026-09-28,
  // direct founder follow-up: "a department head can add equipment for
  // the whole site, not just their own department"). null for a GM (or a
  // departmentless supervisor) — every filter below is a no-op in that
  // case, matching "defaults not lockouts": nobody loses visibility of
  // equipment/areas that were never tagged with a department at all.
  int? get _myDepartmentId {
    if (!_equipmentOnly) return null;
    return ref.read(currentUserProvider)?.departmentId;
  }

  // A department head sees their own department's equipment/areas plus
  // anything nobody has tagged with a department yet — never a hard
  // lockout of pre-existing untagged content.
  List<Equipment> get _visibleEquipment {
    final deptId = _myDepartmentId;
    if (deptId == null) return equipmentInstances;
    return equipmentInstances
        .where((e) => e.departmentId == null || e.departmentId == deptId)
        .toList();
  }

  List<Area> get _visibleAreas {
    final deptId = _myDepartmentId;
    if (deptId == null) return areas;
    return areas
        .where((a) => a.departmentId == null || a.departmentId == deptId)
        .toList();
  }

  @override
  void initState() {
    super.initState();
    currentStep = _equipmentOnly ? 1 : widget.initialStep.clamp(0, 3);
    _loadData();
  }

  @override
  void dispose() {
    areaNameController.dispose();
    equipmentNameController.dispose();
    equipmentModelController.dispose();
    equipmentSerialController.dispose();
    newEquipmentTypeController.dispose();
    staffNameController.dispose();
    staffJobTitleController.dispose();
    staffPinController.dispose();
    supplierNameController.dispose();
    supplierContactController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
      loadError = null;
    });
    // One silent retry before ever showing an error (2026-09-28, real
    // crash caught live: "NoSuchMethodError: _listenedElement was called
    // on null"). Root cause: `_resolveActiveSite()` awaits
    // `currentSiteProvider.future` as the very first step of this method,
    // called straight from initState() — a known Riverpod internal race
    // (its one-shot temporary subscription for a `.future` read can
    // resolve against an already-torn-down provider element if something
    // elsewhere invalidates/disposes a dependency mid-await, e.g. a fast
    // in/out of this screen or a concurrent provider rebuild). It isn't
    // this screen's own bug to fully prevent — it's an inherent hazard of
    // reading `.future` this early — so rather than a deeper Riverpod
    // restructure for a rare timing race, one transparent retry absorbs
    // it: a genuine, persistent failure still surfaces via loadError
    // (with the user's own Retry button) on the second attempt.
    for (var attempt = 0; attempt < 2; attempt++) {
      try {
        final areaRepo = ref.read(areaRepositoryProvider);
        final equipmentRepo = ref.read(equipmentRepositoryProvider);
        final userRepo = ref.read(userRepositoryProvider);
        final supplierRepo = ref.read(supplierRepositoryProvider);
        final siteRepo = ref.read(siteRepositoryProvider);
        final site = await _resolveActiveSite();

        final loadedAreas = await areaRepo.getForSite(site.id);
        final loadedTypes = await equipmentRepo.getEquipmentTypes();
        final loadedEquipment = await equipmentRepo.getForSite(site.id);
        final loadedStaff = await userRepo.getForSite(site.id);
        final loadedSuppliers = await supplierRepo.getForSite(site.id);
        final loadedSiteVenueTypeIds = await siteRepo.getVenueTypeIds(
          site.id,
        );
        final venueTypeTags = <int, List<int>>{};
        for (final type in loadedTypes) {
          venueTypeTags[type.id] = await equipmentRepo.getVenueTypeIds(
            type.id,
          );
        }

        if (!mounted) return;
        setState(() {
          areas = loadedAreas;
          equipmentTypes = loadedTypes;
          equipmentInstances = loadedEquipment;
          staff = loadedStaff;
          suppliers = loadedSuppliers;
          siteVenueTypeIds = loadedSiteVenueTypeIds;
          venueTypeIdsByEquipmentTypeId = venueTypeTags;
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

  // An equipment type with no tags is universal; a tagged one needs to
  // match one of the site's own venue-type tags. If the site itself has
  // no venue types set, or the manager has explicitly asked to see
  // everything, no filtering rule can apply — the full list shows.
  List<EquipmentType> get _offeredEquipmentTypes {
    if (showAllEquipmentTypes || siteVenueTypeIds.isEmpty) {
      return equipmentTypes;
    }
    return equipmentTypes.where((t) {
      final tags = venueTypeIdsByEquipmentTypeId[t.id] ?? const [];
      return tags.isEmpty || tags.any(siteVenueTypeIds.contains);
    }).toList();
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
    // Same-venue uniqueness (2026-09-06): a rejected duplicate is a real,
    // expected outcome here, not an unhandled crash — the error message
    // itself repeats the naming-guidance examples as a second nudge.
    try {
      final model = equipmentModelController.text.trim();
      final serial = equipmentSerialController.text.trim();
      final created = await repo.create(
        name: name,
        equipmentTypeId: selectedEquipmentTypeId!,
        areaId: selectedAreaId,
        siteId: site.id,
        model: model.isEmpty ? null : model,
        serialNumber: serial.isEmpty ? null : serial,
        // A department head's own equipment is implicitly theirs — no
        // picker shown, since in this mode there's only one department
        // it could possibly be. A GM adding equipment (not in this mode)
        // leaves it untagged, same as before this feature existed.
        departmentId: _myDepartmentId,
      );

      if (!mounted) return;
      setState(() {
        equipmentInstances = [...equipmentInstances, created];
        equipmentNameController.clear();
        equipmentModelController.clear();
        equipmentSerialController.clear();
      });
    } on DuplicateEquipmentNameException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
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
      jobRole: selectedJobRole,
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

  // Suppliers step (UX-research P0: "venue → staff → tasks → suppliers").
  // Mirrors the supplier screen's add flow fields, but compact — name +
  // optional contact + category + approval, the essentials a setup wizard
  // needs; the full Supplier Management screen remains for editing
  // after setup.
  Future<void> _addSupplier() async {
    final name = supplierNameController.text.trim();
    if (name.isEmpty) return;

    final site = await _resolveActiveSite();
    final repo = ref.read(supplierRepositoryProvider);
    final created = await repo.create(
      name: name,
      contact: supplierContactController.text.trim().isEmpty
          ? null
          : supplierContactController.text.trim(),
      category: selectedSupplierCategory,
      approvalStatus: selectedSupplierApproval,
      siteId: site.id,
    );

    if (!mounted) return;
    setState(() {
      suppliers = [...suppliers, created];
      supplierNameController.clear();
      supplierContactController.clear();
      selectedSupplierCategory = SupplierCategory.freshProduce;
      selectedSupplierApproval = SupplierApprovalStatus.approved;
    });
  }

  Future<String?> _promptForName(String title, String currentName) {
    final controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.nameAxisLabel),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameArea(Area area) async {
    final newName = await _promptForName(
      AppLocalizations.of(context)!.renameAreaTitle,
      area.name,
    );
    if (newName == null || newName.isEmpty || newName == area.name) return;

    final repo = ref.read(areaRepositoryProvider);
    await repo.rename(area.id, newName);

    if (!mounted) return;
    setState(() {
      areas = areas
          .map(
            (a) => a.id == area.id
                ? Area(id: a.id, name: newName, siteId: a.siteId)
                : a,
          )
          .toList();
    });
  }

  Future<void> _renameEquipment(Equipment equipment) async {
    final newName = await _promptForName(
      AppLocalizations.of(context)!.renameEquipmentTitle,
      equipment.name,
    );
    if (newName == null || newName.isEmpty || newName == equipment.name) {
      return;
    }

    final repo = ref.read(equipmentRepositoryProvider);
    try {
      await repo.rename(equipment.id, newName);
    } on DuplicateEquipmentNameException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
      return;
    }

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
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.retireEquipmentTitle),
            content: Text(l10n.retireEquipmentConfirmText),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.retireButton),
              ),
            ],
          );
        },
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
    final l10n = AppLocalizations.of(context)!;
    final type = equipmentTypes.firstWhere(
      (t) => t.id == equipment.equipmentTypeId,
      orElse: () => EquipmentType(id: -1, name: l10n.unknownTypeLabel),
    );
    final parts = <String>[type.name];
    if (equipment.areaId != null) {
      final area = areas.firstWhere(
        (a) => a.id == equipment.areaId,
        orElse: () => Area(id: -1, name: l10n.unknownAreaLabel, siteId: -1),
      );
      parts.add(area.name);
    }
    // Model/serial number (2026-09-28) — shown only when set, so existing
    // equipment with neither doesn't grow an empty-looking subtitle tail.
    if (equipment.model != null && equipment.model!.isNotEmpty) {
      parts.add(l10n.modelPrefixLabel(equipment.model!));
    }
    if (equipment.serialNumber != null && equipment.serialNumber!.isNotEmpty) {
      parts.add(l10n.serialPrefixLabel(equipment.serialNumber!));
    }
    return parts.join(' - ');
  }

  @override
  Widget build(BuildContext context) {
    // The header/drawer render unconditionally, loading or not — a stuck
    // or failed load must never strand the user on a header-less blank
    // screen with no way back (2026-09-28, direct founder bug report).
    final l10n = AppLocalizations.of(context)!;
    final equipmentOnly = _equipmentOnly;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(
          equipmentOnly
              ? l10n.addEquipmentTitle
              : l10n.venueSetupStepTitle(currentStep + 1),
        ),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.venueSetupTitle),
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
                Expanded(child: SingleChildScrollView(child: _buildStep())),
                if (!equipmentOnly) ...[
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (currentStep > 0)
                        TextButton(
                          onPressed: () => setState(() => currentStep -= 1),
                          child: Text(l10n.back),
                        )
                      else
                        const SizedBox.shrink(),
                      PrimaryActionButton(
                        label: currentStep < 3 ? l10n.nextButton : l10n.finishSetupButton,
                        onPressed: () {
                          if (currentStep < 3) {
                            setState(() => currentStep += 1);
                          } else {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ],
            ),
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
      case 2:
        return _buildStaffStep();
      default:
        return _buildSuppliersStep();
    }
  }

  Widget _buildAreasStep() {
    final l10n = AppLocalizations.of(context)!;
    final suggestions = [
      l10n.areaSuggestionKitchen,
      l10n.areaSuggestionStorage,
      l10n.areaSuggestionReceiving,
      l10n.areaSuggestionFrontOfHouse,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.areasStepTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.areasStepIntro),
        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: suggestions
              .map(
                (s) => ActionChip(label: Text(s), onPressed: () => _addArea(s)),
              )
              .toList(),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: areaNameController,
                decoration: InputDecoration(labelText: l10n.areaNameLabel),
              ),
            ),
            IconButton(
              onPressed: () => _addArea(areaNameController.text),
              icon: const Icon(Icons.add),
              tooltip: l10n.addAreaTooltip,
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
                tooltip: l10n.renameTooltip,
                onPressed: () => _renameArea(a),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.equipmentStepTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.equipmentStepIntro),
        const SizedBox(height: 16),
        if (!showAllEquipmentTypes &&
            siteVenueTypeIds.isNotEmpty &&
            _offeredEquipmentTypes.length < equipmentTypes.length)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: TextButton(
              onPressed: () => setState(() => showAllEquipmentTypes = true),
              child: Text(l10n.showAllEquipmentTypesButton),
            ),
          ),
        DropdownButtonFormField<int>(
          initialValue: selectedEquipmentTypeId,
          decoration: InputDecoration(labelText: l10n.equipmentTypeLabel),
          items: [
            ..._offeredEquipmentTypes.map(
              (t) => DropdownMenuItem(value: t.id, child: Text(t.name)),
            ),
            DropdownMenuItem(value: -1, child: Text(l10n.somethingElseOption)),
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
                    decoration: InputDecoration(
                      labelText: l10n.newEquipmentTypeNameLabel,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _addNewEquipmentType,
                  icon: const Icon(Icons.check),
                  tooltip: l10n.confirmNewEquipmentTypeTooltip,
                ),
              ],
            ),
          ),
        const SizedBox(height: 12),
        if (_visibleAreas.isEmpty)
          Text(
            _equipmentOnly ? l10n.noAreasForDeptText : l10n.noAreasAddOneText,
          )
        else
          DropdownButtonFormField<int>(
            initialValue: selectedAreaId,
            decoration: InputDecoration(labelText: l10n.areaLabel),
            items: _visibleAreas
                .map((a) => DropdownMenuItem(value: a.id, child: Text(a.name)))
                .toList(),
            onChanged: (value) => setState(() => selectedAreaId = value),
          ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: equipmentNameController,
                // Naming guidance (2026-09-06): nudges toward a name that
                // distinguishes this instance from any others of the same
                // type ("Fridge 1/2" tells nobody which physical unit to
                // check) — compliance-critical once a venue has 2+ of the
                // same equipment.
                decoration: InputDecoration(
                  labelText: l10n.equipmentNameLabel,
                  hintText: l10n.equipmentNameHint,
                ),
              ),
            ),
            IconButton(
              onPressed: _addEquipment,
              icon: const Icon(Icons.add),
              tooltip: l10n.addEquipmentTooltip,
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Model/serial number (2026-09-28, direct founder request) — both
        // optional, helps ordering the right replacement part later if
        // something breaks. Kept visually secondary (smaller row, no
        // asterisk) since most equipment gets added without these.
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: equipmentModelController,
                decoration: InputDecoration(
                  labelText: l10n.modelOptionalLabel,
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextField(
                controller: equipmentSerialController,
                decoration: InputDecoration(
                  labelText: l10n.serialNumberOptionalLabel,
                  isDense: true,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._visibleEquipment.map(
          (e) => Card(
            child: ListTile(
              title: Text(
                e.active ? e.name : l10n.retiredSuffixLabel(e.name),
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
                    tooltip: l10n.renameTooltip,
                    onPressed: () => _renameEquipment(e),
                  ),
                  IconButton(
                    icon: Icon(
                      e.active ? Icons.remove_circle_outline : Icons.restore,
                    ),
                    tooltip: e.active ? l10n.retireTooltip : l10n.reactivateTooltip,
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
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.staffStepTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.staffStepIntro),
        const SizedBox(height: 16),
        AddStaffFormFields(
          nameController: staffNameController,
          jobTitleController: staffJobTitleController,
          pinController: staffPinController,
          selectedTier: selectedRoleTier,
          onTierChanged: (t) => setState(() => selectedRoleTier = t),
          selectedJobRole: selectedJobRole,
          onJobRoleChanged: (r) => setState(() => selectedJobRole = r),
          // A freshly signed-up owner setting up their first venue can hand
          // out any tier — there's nobody else's outrank to check yet.
          allowedTiers: RoleTier.values.toList(),
        ),
        const SizedBox(height: 12),
        PrimaryActionButton(label: l10n.addStaffMemberButton, onPressed: _addStaff),
        const SizedBox(height: 16),
        ...staff.map(
          (s) => Card(
            child: ListTile(
              title: Text('${s.name} (${s.jobTitle})'),
              subtitle: Text(
                s.jobRole == null
                    ? roleTierDisplayName(s.roleTier, l10n)
                    : '${roleTierDisplayName(s.roleTier, l10n)} · ${jobRoleDisplayName(s.jobRole!, l10n)}',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuppliersStep() {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.suppliersStepTitle, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text(l10n.suppliersStepIntro),
        const SizedBox(height: 16),
        TextField(
          controller: supplierNameController,
          decoration: InputDecoration(labelText: l10n.supplierNameLabel),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: supplierContactController,
          decoration: InputDecoration(
            labelText: l10n.contactOptionalLabel,
            hintText: l10n.phoneOrEmailHint,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<SupplierCategory>(
          initialValue: selectedSupplierCategory,
          decoration: InputDecoration(labelText: l10n.categoryLabel),
          items: SupplierCategory.values
              .map(
                (category) => DropdownMenuItem(
                  value: category,
                  child: Text(supplierCategoryLabel(category, l10n)),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value != null) setState(() => selectedSupplierCategory = value);
          },
        ),
        const SizedBox(height: 12),
        Text(l10n.approvalStatusLabel),
        const SizedBox(height: 4),
        Wrap(
          spacing: 8,
          children: [
            for (final status in SupplierApprovalStatus.values)
              ChoiceChip(
                label: Text(supplierApprovalStatusLabel(status, l10n)),
                selected: selectedSupplierApproval == status,
                onSelected: (_) =>
                    setState(() => selectedSupplierApproval = status),
              ),
          ],
        ),
        const SizedBox(height: 12),
        PrimaryActionButton(label: l10n.addSupplierButton, onPressed: _addSupplier),
        const SizedBox(height: 16),
        ...suppliers.map(
          (supplier) => Card(
            child: ListTile(
              title: Text(supplier.name),
              subtitle: Text(
                '${supplier.displayCategory}'
                '${supplier.contact == null ? '' : ' · ${supplier.contact}'}',
              ),
              trailing: Text(
                supplierApprovalStatusLabel(supplier.approvalStatus, l10n),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
