import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/errors/friendly_error.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/task_segment.dart';
import '../../shared/models/user.dart';
import '../../shared/models/venue_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_providers.dart'
    show backendRestClientProvider;
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/providers/venue_type_providers.dart';
import 'setup_applier.dart';
import 'setup_draft.dart';

/// Task library sections every venue needs, ticked by default.
const _coreSegments = {
  'food_safety',
  'allergen',
  'personal_hygiene_ppe',
  'cleaning_sanitation',
  'cleaning_chemicals',
  'refrigeration_cold_storage',
  'deliveries_goods_in',
  'dry_ambient_storage',
  'waste_pest_control',
  'opening_procedures',
  'closing_procedures',
  'utilities_safety',
  'management_compliance_oversight',
};

/// Extra sections ticked by kind of venue (by venue type name).
Set<String> _segmentsForVenueTypes(Iterable<String> names) {
  final out = <String>{};
  for (final n in names.map((n) => n.toLowerCase())) {
    if (n.contains('pub') || n.contains('bar')) out.addAll({'bar_beverage'});
    if (n.contains('hotel')) {
      out.addAll({'hotel_specific', 'housekeeping', 'reception', 'security'});
    }
    if (!n.contains('ghost') && !n.contains('bakery')) {
      out.addAll({'front_of_house', 'service_readiness'});
    }
    if (n.contains('dining') ||
        n.contains('pub') ||
        n.contains('service') ||
        n.contains('casual') ||
        n.contains('gastro') ||
        n.contains('hotel') ||
        n.contains('catering') ||
        n.contains('ghost')) {
      out.addAll({'cooking_line_equipment', 'washup_dishwash'});
    }
  }
  return out;
}

const _suggestedDepartments = [
  'Kitchen',
  'Bar',
  'Front of House',
  'Cellar',
  'Housekeeping',
  'Reception',
];

/// Equipment shown first (by name); everything else under "show all".
const _commonEquipment = [
  'fridge',
  'freezer',
  'walk-in',
  'fryer',
  'oven',
  'combi',
  'grill',
  'hob',
  'dishwasher',
  'glasswasher',
  'ice',
  'blast',
  'bain',
  'hot cupboard',
  'coffee',
  'cellar',
];

enum _Step {
  start,
  you,
  leaders,
  shape,
  regions,
  branches,
  details,
  equipment,
  staff,
  tasks,
  preview,
}

/// Business Setup Wizard (2026-10-17, founder-approved redesign): top-down
/// — you, head office, regions, branches, then each branch's details,
/// equipment, staff and checks — with VenuRite's AI filling the forms from
/// a description, branch search from public listings (ticked by the
/// person, never added on its own), single-site businesses skipping
/// regions, and progress saved to the server after every step.
class BusinessSetupWizardScreen extends ConsumerStatefulWidget {
  const BusinessSetupWizardScreen({super.key});

  @override
  ConsumerState<BusinessSetupWizardScreen> createState() =>
      _BusinessSetupWizardScreenState();
}

class _BusinessSetupWizardScreenState
    extends ConsumerState<BusinessSetupWizardScreen> {
  SetupDraft _draft = SetupDraft();
  bool _loading = true;
  bool _busy = false;
  String? _aiReply;
  List<VenueType> _venueTypes = const [];
  List<EquipmentType> _equipmentTypes = const [];
  List<String> _segments = const [];
  bool _showAllEquipment = false;
  final _aiController = TextEditingController();

  // Search state.
  final _searchName = TextEditingController();
  final _searchArea = TextEditingController();
  bool _searching = false;
  List<Map<String, dynamic>>? _results;
  final Set<int> _ticked = {};

  // Create state.
  bool _creating = false;
  int _done = 0;
  int _total = 0;
  String? _createError;
  List<SetupLogin>? _logins;

  _Step get _step =>
      _Step.values[_draft.step.clamp(0, _Step.values.length - 1)];

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _aiController.dispose();
    _searchName.dispose();
    _searchArea.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final client = ref.read(backendRestClientProvider);
    final me = ref.read(currentUserProvider);
    try {
      final (draftRows, venueTypes, equipmentTypes, templates) = await (
        client.rpc('get_setup_draft', {}),
        ref.read(venueTypeRepositoryProvider).getAll(),
        ref.read(equipmentRepositoryProvider).getEquipmentTypes(),
        ref.read(taskTemplateRepositoryProvider).getAllCurrentVersions(),
      ).wait;
      final segments = {for (final t in templates) t.segment}.toList()..sort();
      SetupDraft draft;
      if (draftRows.isNotEmpty && (draftRows.first as Map)['draft'] is Map) {
        draft = SetupDraft.fromJson(
          Map<String, dynamic>.from((draftRows.first as Map)['draft'] as Map),
        );
      } else {
        draft = SetupDraft(myJobTitle: me?.jobTitle ?? '');
      }
      if (!mounted) return;
      setState(() {
        _draft = draft;
        _venueTypes = {for (final v in venueTypes) v.name: v}.values.toList();
        _equipmentTypes = equipmentTypes;
        _segments = segments;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loading = false);
      _snack(friendlyErrorMessage(AppLocalizations.of(context)!, e));
    }
  }

  void _snack(String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  Future<void> _save({bool completed = false}) async {
    await ref.read(backendRestClientProvider).rpcVoid('save_setup_draft', {
      'p_draft': _draft.toJson(),
      'p_completed': completed,
    });
  }

  bool _skip(_Step s) => switch (s) {
    _Step.regions => _draft.multiSite != true || !_draft.useRegions,
    _ => false,
  };

  Future<void> _go(int delta) async {
    final l10n = AppLocalizations.of(context)!;
    if (delta > 0 && _step == _Step.branches) {
      _draft.branches.removeWhere((b) => b.name.trim().isEmpty);
      if (_draft.branches.isEmpty) {
        _snack(l10n.setupNoBranchesYet);
        return;
      }
    }
    if (delta > 0 && _step == _Step.shape && _draft.multiSite == false) {
      // Tweak 1: a single venue needs no regions.
      _draft.useRegions = false;
      if (_draft.branches.isEmpty) {
        _draft.branches.add(DraftBranch(key: _draft.newKey('b')));
      }
    }
    var next = _draft.step + delta;
    while (next > 0 &&
        next < _Step.values.length - 1 &&
        _skip(_Step.values[next])) {
      next += delta;
    }
    setState(() {
      _draft.step = next.clamp(0, _Step.values.length - 1);
      if (_step == _Step.tasks) _preTickSegments();
    });
    try {
      await _save();
    } catch (_) {
      // Next save will catch up; never block the wizard on it.
    }
  }

  void _preTickSegments() {
    for (final b in _draft.branches) {
      if (b.segmentsChosen) continue;
      final names = _venueTypes
          .where((v) => b.venueTypeIds.contains(v.id))
          .map((v) => v.name);
      b.segments = {
        ..._coreSegments,
        ..._segmentsForVenueTypes(names.isEmpty ? ['casual dining'] : names),
      }.where(_segments.contains).toSet();
      b.segmentsChosen = true;
    }
  }

  Future<void> _askAi() async {
    final l10n = AppLocalizations.of(context)!;
    final text = _aiController.text.trim();
    if (text.isEmpty) return;
    setState(() => _busy = true);
    try {
      final r = await ref.read(backendRestClientProvider).invokeFunction(
        'setup-assistant',
        {'message': text, 'current': _draft.toJson()..remove('applied')},
      );
      if (r['outcome'] != 'outline') {
        throw Exception(r['error'] ?? 'no outline');
      }
      final outline = Map<String, dynamic>.from(r['outline'] as Map);
      setState(() {
        _draft.mergeOutline(outline, {
          for (final v in _venueTypes) v.name.toLowerCase(): v.id,
        });
        _aiReply = outline['reply'] as String?;
        _aiController.clear();
      });
      await _save();
    } catch (e) {
      _snack(l10n.setupAiError(friendlyErrorMessage(l10n, e)));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _search() async {
    final l10n = AppLocalizations.of(context)!;
    if (_searchName.text.trim().length < 2) return;
    setState(() {
      _searching = true;
      _results = null;
      _ticked.clear();
    });
    try {
      final r = await ref.read(backendRestClientProvider).invokeFunction(
        'branch-search',
        {'query': _searchName.text.trim(), 'area': _searchArea.text.trim()},
      );
      if (r['outcome'] != 'found') {
        throw Exception(r['error'] ?? 'search failed');
      }
      setState(
        () => _results = [
          for (final x in (r['results'] as List))
            Map<String, dynamic>.from(x as Map),
        ],
      );
    } catch (e) {
      _snack(friendlyErrorMessage(l10n, e));
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _addTicked() {
    final results = _results ?? const [];
    setState(() {
      for (final i in _ticked) {
        final r = results[i];
        final name = '${r['name']}';
        if (_draft.branches.any(
          (b) => b.name == name && b.address == r['address'],
        )) {
          continue;
        }
        _draft.branches.add(
          DraftBranch(
            key: _draft.newKey('b'),
            name: name,
            address: '${r['address'] ?? ''}',
            regionKey: _draft.regions.isEmpty ? null : _draft.regions.first.key,
          ),
        );
      }
      _ticked.clear();
      _results = null;
    });
  }

  Future<void> _create() async {
    final me = ref.read(currentUserProvider);
    final org = await ref.read(currentOrganisationIdProvider.future);
    if (me == null || org == null) return;
    setState(() {
      _creating = true;
      _createError = null;
    });
    try {
      final applier = SetupApplier(
        client: ref.read(backendRestClientProvider),
        sites: ref.read(siteRepositoryProvider),
        regions: ref.read(regionRepositoryProvider),
        departments: ref.read(departmentRepositoryProvider),
        equipment: ref.read(equipmentRepositoryProvider),
        users: ref.read(userRepositoryProvider),
        provisioning: ref.read(tenantProvisioningRepositoryProvider),
        templates: ref.read(taskTemplateRepositoryProvider),
        schedules: ref.read(taskScheduleRepositoryProvider),
        saveDraft: (_) => _save(),
      );
      final logins = await applier.apply(
        draft: _draft,
        me: me,
        organisationId: org,
        onProgress: (done, total, _) {
          if (mounted) {
            setState(() {
              _done = done;
              _total = total;
            });
          }
        },
      );
      await _save(completed: true);
      ref.invalidate(siteRepositoryProvider);
      if (!mounted) return;
      setState(() => _logins = logins);
    } catch (e) {
      if (!mounted) return;
      setState(
        () => _createError = friendlyErrorMessage(
          AppLocalizations.of(context)!,
          e,
        ),
      );
    } finally {
      if (mounted) setState(() => _creating = false);
    }
  }

  // ---------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final visible = [
      for (final s in _Step.values)
        if (!_skip(s)) s,
    ];
    final position = visible.indexOf(_step) + 1;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.setupTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ResponsiveContent(
                maxWidth: 640,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.setupStepOf(position, visible.length),
                            style: const TextStyle(color: AppColors.muted),
                          ),
                          const SizedBox(height: 6),
                          LinearProgressIndicator(
                            value: position / visible.length,
                            backgroundColor: AppColors.line,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: _stepBody(l10n),
                      ),
                    ),
                    if (_logins == null)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            if (_draft.step > 0 && !_creating)
                              TextButton(
                                onPressed: () => _go(-1),
                                child: Text(l10n.back),
                              ),
                            const Spacer(),
                            if (_step != _Step.preview && _step != _Step.start)
                              FilledButton(
                                onPressed: _busy ? null : () => _go(1),
                                child: Text(l10n.nextButton),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  List<Widget> _stepBody(AppLocalizations l10n) => switch (_step) {
    _Step.start => _startStep(l10n),
    _Step.you => _youStep(l10n),
    _Step.leaders => _leadersStep(l10n),
    _Step.shape => _shapeStep(l10n),
    _Step.regions => _regionsStep(l10n),
    _Step.branches => _branchesStep(l10n),
    _Step.details => _detailsStep(l10n),
    _Step.equipment => _equipmentStep(l10n),
    _Step.staff => _staffStep(l10n),
    _Step.tasks => _tasksStep(l10n),
    _Step.preview => _previewStep(l10n),
  };

  Widget _title(String text, [String? help]) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text, style: Theme.of(context).textTheme.headlineSmall),
        if (help != null) ...[
          const SizedBox(height: 6),
          Text(help, style: const TextStyle(color: AppColors.muted)),
        ],
      ],
    ),
  );

  Widget _field({
    required String label,
    required String value,
    required ValueChanged<String> onChanged,
    TextInputType? keyboard,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: TextFormField(
      initialValue: value,
      keyboardType: keyboard,
      decoration: InputDecoration(labelText: label),
      onChanged: onChanged,
    ),
  );

  List<Widget> _startStep(AppLocalizations l10n) => [
    _title(l10n.setupStartTitle, l10n.setupStartHelp),
    if (_aiReply != null) ...[
      AppBanner(kind: BannerKind.info, child: Text(_aiReply!)),
      const SizedBox(height: 12),
    ],
    TextField(
      controller: _aiController,
      minLines: 3,
      maxLines: 6,
      decoration: InputDecoration(hintText: l10n.setupAskHint),
    ),
    const SizedBox(height: 12),
    FilledButton.icon(
      icon: _busy
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Icon(Icons.auto_awesome),
      label: Text(l10n.setupAskButton),
      onPressed: _busy ? null : _askAi,
    ),
    const SizedBox(height: 8),
    OutlinedButton(
      onPressed: _busy ? null : () => _go(1),
      child: Text(_aiReply == null ? l10n.setupSkipAi : l10n.nextButton),
    ),
  ];

  List<Widget> _youStep(AppLocalizations l10n) {
    final me = ref.read(currentUserProvider);
    return [
      _title(l10n.setupYouTitle),
      if (me != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(me.name, style: Theme.of(context).textTheme.titleMedium),
        ),
      _field(
        label: l10n.setupYourJobTitle,
        value: _draft.myJobTitle,
        onChanged: (v) => _draft.myJobTitle = v,
      ),
    ];
  }

  List<Widget> _personRows(List<DraftPerson> people, AppLocalizations l10n) => [
    for (final p in people)
      AppCard(
        child: Column(
          children: [
            _field(
              label: l10n.setupNameLabel,
              value: p.name,
              onChanged: (v) => p.name = v,
            ),
            _field(
              label: l10n.setupEmailLabel,
              value: p.email,
              keyboard: TextInputType.emailAddress,
              onChanged: (v) => p.email = v,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() => people.remove(p)),
                child: Text(l10n.setupRemove),
              ),
            ),
          ],
        ),
      ),
  ];

  List<Widget> _leadersStep(AppLocalizations l10n) => [
    _title(l10n.setupLeadersTitle, l10n.setupLeadersHelp),
    ..._personRows(_draft.leaders, l10n),
    OutlinedButton.icon(
      icon: const Icon(Icons.person_add_alt),
      label: Text(l10n.setupAddPerson),
      onPressed: () => setState(() => _draft.leaders.add(DraftPerson())),
    ),
  ];

  List<Widget> _shapeStep(AppLocalizations l10n) => [
    _title(l10n.setupShapeTitle),
    RadioGroup<bool>(
      groupValue: _draft.multiSite,
      onChanged: (v) => setState(() => _draft.multiSite = v),
      child: Column(
        children: [
          RadioListTile<bool>(value: false, title: Text(l10n.setupOneBranch)),
          RadioListTile<bool>(
            value: true,
            title: Text(l10n.setupSeveralBranches),
          ),
        ],
      ),
    ),
    if (_draft.multiSite == true)
      SwitchListTile(
        value: _draft.useRegions,
        title: Text(l10n.setupUseRegions),
        onChanged: (v) => setState(() => _draft.useRegions = v),
      ),
  ];

  List<Widget> _regionsStep(AppLocalizations l10n) => [
    _title(l10n.setupRegionsTitle, l10n.setupRegionsHelp),
    for (final r in _draft.regions)
      AppCard(
        child: Column(
          children: [
            _field(
              label: l10n.setupRegionNameLabel,
              value: r.name,
              onChanged: (v) => r.name = v,
            ),
            _field(
              label: l10n.setupManagerNameLabel,
              value: r.managerName,
              onChanged: (v) => r.managerName = v,
            ),
            _field(
              label: l10n.setupManagerEmailLabel,
              value: r.managerEmail,
              keyboard: TextInputType.emailAddress,
              onChanged: (v) => r.managerEmail = v,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => setState(() {
                  _draft.regions.remove(r);
                  for (final b in _draft.branches) {
                    if (b.regionKey == r.key) b.regionKey = null;
                  }
                }),
                child: Text(l10n.setupRemove),
              ),
            ),
          ],
        ),
      ),
    OutlinedButton.icon(
      icon: const Icon(Icons.add),
      label: Text(l10n.setupAddRegion),
      onPressed: () => setState(
        () => _draft.regions.add(DraftRegion(key: _draft.newKey('r'))),
      ),
    ),
  ];

  List<Widget> _branchesStep(AppLocalizations l10n) {
    final regionsOn =
        _draft.multiSite == true &&
        _draft.useRegions &&
        _draft.regions.isNotEmpty;
    return [
      _title(l10n.setupBranchesTitle),
      if (_draft.multiSite == true)
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.setupFindBranchesTitle,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.setupFindBranchesHelp,
                style: const TextStyle(color: AppColors.muted),
              ),
              TextField(
                controller: _searchName,
                decoration: InputDecoration(
                  labelText: l10n.setupSearchNameLabel,
                ),
              ),
              TextField(
                controller: _searchArea,
                decoration: InputDecoration(
                  labelText: l10n.setupSearchAreaLabel,
                ),
              ),
              const SizedBox(height: 8),
              FilledButton.tonalIcon(
                icon: const Icon(Icons.search),
                label: Text(l10n.setupSearchButton),
                onPressed: _searching ? null : _search,
              ),
              if (_searching) ...[
                const SizedBox(height: 8),
                const LinearProgressIndicator(),
                const SizedBox(height: 4),
                Text(l10n.setupSearching, textAlign: TextAlign.center),
              ],
              if (_results != null && _results!.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(l10n.setupNoResults),
                ),
              if (_results != null && _results!.isNotEmpty) ...[
                const SizedBox(height: 8),
                for (var i = 0; i < _results!.length; i++)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _ticked.contains(i),
                    onChanged: (v) => setState(
                      () => v == true ? _ticked.add(i) : _ticked.remove(i),
                    ),
                    title: Text('${_results![i]['name']}'),
                    subtitle: Text(
                      [
                        '${_results![i]['address'] ?? ''}',
                        '${_results![i]['category'] ?? ''}',
                      ].where((s) => s.isNotEmpty).join(' · '),
                    ),
                  ),
                FilledButton(
                  onPressed: _ticked.isEmpty ? null : _addTicked,
                  child: Text(l10n.setupAddTicked(_ticked.length)),
                ),
              ],
            ],
          ),
        ),
      const SizedBox(height: 12),
      for (final b in _draft.branches)
        AppCard(
          key: ValueKey(b.key),
          child: Column(
            children: [
              _field(
                label: l10n.setupBranchNameLabel,
                value: b.name,
                onChanged: (v) => b.name = v,
              ),
              _field(
                label: l10n.setupAddressLabel,
                value: b.address,
                onChanged: (v) => b.address = v,
              ),
              if (regionsOn)
                DropdownButtonFormField<String?>(
                  initialValue: b.regionKey,
                  decoration: InputDecoration(labelText: l10n.setupRegionLabel),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('-')),
                    for (final r in _draft.regions)
                      DropdownMenuItem(value: r.key, child: Text(r.name)),
                  ],
                  onChanged: (v) => setState(() => b.regionKey = v),
                ),
              if (_draft.multiSite == true)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => setState(() => _draft.branches.remove(b)),
                    child: Text(l10n.setupRemove),
                  ),
                ),
            ],
          ),
        ),
      if (_draft.multiSite == true || _draft.branches.isEmpty)
        OutlinedButton.icon(
          icon: const Icon(Icons.add_business_outlined),
          label: Text(l10n.setupAddBranch),
          onPressed: () => setState(
            () => _draft.branches.add(
              DraftBranch(
                key: _draft.newKey('b'),
                regionKey: regionsOn ? _draft.regions.first.key : null,
              ),
            ),
          ),
        ),
    ];
  }

  Widget _branchHeader(DraftBranch b) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      b.name.isEmpty ? '-' : b.name,
      style: Theme.of(context).textTheme.titleMedium,
    ),
  );

  List<Widget> _detailsStep(AppLocalizations l10n) => [
    _title(l10n.setupDetailsTitle),
    for (final b in _draft.branches)
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _branchHeader(b),
            Text(l10n.setupVenueTypesLabel),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final v in _venueTypes)
                  FilterChip(
                    label: Text(v.name),
                    selected: b.venueTypeIds.contains(v.id),
                    onSelected: (on) => setState(
                      () => on
                          ? b.venueTypeIds.add(v.id)
                          : b.venueTypeIds.remove(v.id),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(l10n.setupDepartmentsLabel),
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final d in {..._suggestedDepartments, ...b.departments})
                  FilterChip(
                    label: Text(d),
                    selected: b.departments.contains(d),
                    onSelected: (on) => setState(
                      () => on ? b.departments.add(d) : b.departments.remove(d),
                    ),
                  ),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: Text(l10n.setupAddDepartment),
                  onPressed: () async {
                    final c = TextEditingController();
                    final name = await showDialog<String>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        content: TextField(controller: c, autofocus: true),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(),
                            child: Text(l10n.cancel),
                          ),
                          FilledButton(
                            onPressed: () =>
                                Navigator.of(ctx).pop(c.text.trim()),
                            child: Text(l10n.saveButton),
                          ),
                        ],
                      ),
                    );
                    if (name != null && name.isNotEmpty) {
                      setState(() => b.departments.add(name));
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
  ];

  List<Widget> _equipmentStep(AppLocalizations l10n) {
    bool common(EquipmentType t) =>
        _commonEquipment.any((c) => t.name.toLowerCase().contains(c));
    final shown = _showAllEquipment
        ? _equipmentTypes
        : _equipmentTypes.where(common).toList();
    return [
      _title(l10n.setupEquipmentTitle, l10n.setupEquipmentHelp),
      for (final b in _draft.branches)
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _branchHeader(b),
              for (final t in {
                ...shown,
                ..._equipmentTypes.where((t) => (b.equipment[t.id] ?? 0) > 0),
              })
                Row(
                  children: [
                    Expanded(child: Text(t.name)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: (b.equipment[t.id] ?? 0) == 0
                          ? null
                          : () => setState(() {
                              final n = (b.equipment[t.id] ?? 0) - 1;
                              n == 0
                                  ? b.equipment.remove(t.id)
                                  : b.equipment[t.id] = n;
                            }),
                    ),
                    SizedBox(
                      width: 28,
                      child: Text(
                        '${b.equipment[t.id] ?? 0}',
                        textAlign: TextAlign.center,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: (b.equipment[t.id] ?? 0) >= 30
                          ? null
                          : () => setState(
                              () => b.equipment[t.id] =
                                  (b.equipment[t.id] ?? 0) + 1,
                            ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      if (!_showAllEquipment)
        TextButton(
          onPressed: () => setState(() => _showAllEquipment = true),
          child: Text(l10n.setupShowAllEquipment),
        ),
    ];
  }

  List<Widget> _staffStep(AppLocalizations l10n) => [
    _title(l10n.setupStaffTitle, l10n.setupStaffHelp),
    for (final b in _draft.branches)
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _branchHeader(b),
            for (final s in b.staff)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Column(
                  children: [
                    _field(
                      label: l10n.setupNameLabel,
                      value: s.name,
                      onChanged: (v) => s.name = v,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<JobRole>(
                            initialValue: s.jobRole,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.setupStaffRoleLabel,
                            ),
                            items: [
                              for (final r in JobRole.values)
                                DropdownMenuItem(
                                  value: r,
                                  child: Text(jobRoleDisplayName(r, l10n)),
                                ),
                            ],
                            onChanged: (v) =>
                                setState(() => s.jobRole = v ?? s.jobRole),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonFormField<RoleTier>(
                            initialValue: s.tier,
                            isExpanded: true,
                            decoration: InputDecoration(
                              labelText: l10n.setupStaffLevelLabel,
                            ),
                            items: [
                              for (final t in [
                                RoleTier.base,
                                RoleTier.supervisor,
                                RoleTier.venueManager,
                              ])
                                DropdownMenuItem(
                                  value: t,
                                  child: Text(roleTierDisplayName(t, l10n)),
                                ),
                            ],
                            onChanged: (v) =>
                                setState(() => s.tier = v ?? s.tier),
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.setupRemove,
                          icon: const Icon(Icons.close),
                          onPressed: () => setState(() => b.staff.remove(s)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            OutlinedButton.icon(
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.setupAddStaff),
              onPressed: () => setState(() => b.staff.add(DraftStaff())),
            ),
          ],
        ),
      ),
  ];

  List<Widget> _tasksStep(AppLocalizations l10n) => [
    _title(l10n.setupTasksTitle, l10n.setupTasksHelp),
    for (final b in _draft.branches)
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _branchHeader(b),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final s in _segments)
                  FilterChip(
                    label: Text(segmentDisplayName(s, l10n)),
                    selected: b.segments.contains(s),
                    onSelected: (on) => setState(
                      () => on ? b.segments.add(s) : b.segments.remove(s),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
  ];

  List<Widget> _previewStep(AppLocalizations l10n) {
    final logins = _logins;
    if (logins != null) {
      return [
        _title(l10n.setupDoneTitle, logins.isEmpty ? null : l10n.setupDoneHelp),
        for (final l in logins)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(
              l.pin != null ? Icons.pin_outlined : Icons.email_outlined,
            ),
            title: Text(
              l.pin != null
                  ? l10n.setupLoginPin(l.name, l.pin!)
                  : l10n.setupLoginEmail(
                      l.name,
                      l.email ?? '',
                      l.password ?? '',
                    ),
            ),
          ),
        if (logins.isNotEmpty)
          OutlinedButton.icon(
            icon: const Icon(Icons.copy),
            label: Text(l10n.setupCopyLogins),
            onPressed: () => Clipboard.setData(
              ClipboardData(
                text: [
                  for (final l in logins)
                    l.pin != null
                        ? l10n.setupLoginPin(l.name, l.pin!)
                        : l10n.setupLoginEmail(
                            l.name,
                            l.email ?? '',
                            l.password ?? '',
                          ),
                ].join('\n'),
              ),
            ),
          ),
        const SizedBox(height: 12),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.setupFinishButton),
        ),
      ];
    }
    final regionsOn = _draft.multiSite == true && _draft.useRegions;
    return [
      _title(l10n.setupPreviewTitle, l10n.setupPreviewHelp),
      AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.setupPreviewLeaders(
                _draft.leaders.where((p) => !p.isEmpty).length,
              ),
            ),
            if (regionsOn)
              Text(l10n.setupPreviewRegions(_draft.regions.length)),
            const Divider(),
            for (final b in _draft.branches)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  l10n.setupPreviewBranch(
                    b.name,
                    b.equipment.values.fold(0, (a, n) => a + n),
                    b.staff.where((s) => s.name.trim().isNotEmpty).length,
                    b.segments.length,
                  ),
                ),
              ),
          ],
        ),
      ),
      const SizedBox(height: 16),
      if (_createError != null) ...[
        AppBanner(
          kind: BannerKind.critical,
          child: Text(l10n.setupFailedPart(_createError!)),
        ),
        const SizedBox(height: 12),
      ],
      if (_creating) ...[
        LinearProgressIndicator(value: _total == 0 ? null : _done / _total),
        const SizedBox(height: 6),
        Text(l10n.setupCreating(_done, _total), textAlign: TextAlign.center),
      ] else
        FilledButton.icon(
          icon: const Icon(Icons.rocket_launch_outlined),
          label: Text(l10n.setupCreateButton),
          onPressed: _create,
        ),
    ];
  }
}

/// Directors' home (2026-10-17): until the business setup is finished, a
/// prompt to start or carry on with it. Hidden once it's done, or if the
/// server can't be asked.
final setupNeededProvider = FutureProvider.autoDispose<bool>((ref) async {
  try {
    final rows = await ref
        .watch(backendRestClientProvider)
        .rpc('get_setup_draft', {});
    return rows.isEmpty || (rows.first as Map)['completed_at'] == null;
  } catch (_) {
    return false;
  }
});

class SetupPromptCard extends ConsumerWidget {
  const SetupPromptCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(setupNeededProvider).value != true) {
      return const SizedBox.shrink();
    }
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: FilledButton.icon(
        icon: const Icon(Icons.rocket_launch_outlined),
        label: Text(l10n.setupTitle),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const BusinessSetupWizardScreen(),
            ),
          );
          ref.invalidate(setupNeededProvider);
        },
      ),
    );
  }
}
