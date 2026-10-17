import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/errors/friendly_error.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/equipment_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_providers.dart'
    show backendRestClientProvider;
import 'equipment_pack.dart';

/// "Find exact model" (2026-10-17, equipment library): search VenuRite's
/// library of model packs; if it's not there, VenuRite's AI drafts one for
/// the manager to review and approve. Pops an [EquipmentModelChoice].
class EquipmentModelPickerScreen extends ConsumerStatefulWidget {
  const EquipmentModelPickerScreen({
    super.key,
    required this.equipmentTypes,
    this.initialQuery = '',
    this.equipmentTypeId,
  });

  final List<EquipmentType> equipmentTypes;
  final String initialQuery;
  final int? equipmentTypeId;

  @override
  ConsumerState<EquipmentModelPickerScreen> createState() =>
      _EquipmentModelPickerScreenState();
}

class _EquipmentModelPickerScreenState
    extends ConsumerState<EquipmentModelPickerScreen> {
  late final _query = TextEditingController(text: widget.initialQuery);
  final _make = TextEditingController();
  final _model = TextEditingController();
  bool _busy = false;
  List<Map<String, dynamic>>? _results;
  Map<String, dynamic>? _detail;
  List<PackCheck>? _draft;
  String? _draftNote;
  final Set<int> _keep = {};
  int? _typeId;

  @override
  void initState() {
    super.initState();
    _typeId = widget.equipmentTypeId;
    if (widget.initialQuery.trim().length >= 2) _search();
  }

  void _snack(Object e) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(friendlyErrorMessage(AppLocalizations.of(context)!, e)),
    ),
  );

  Future<void> _search() async {
    if (_query.text.trim().length < 2) return;
    setState(() {
      _busy = true;
      _detail = null;
    });
    try {
      final rows = await ref.read(backendRestClientProvider).rpc(
        'search_equipment_models',
        {'p_query': _query.text.trim()},
      );
      setState(
        () => _results = [
          for (final r in rows) Map<String, dynamic>.from(r as Map),
        ],
      );
    } catch (e) {
      _snack(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(int id) async {
    setState(() => _busy = true);
    try {
      final rows = await ref.read(backendRestClientProvider).rpc(
        'get_equipment_model',
        {'p_id': id},
      );
      if (rows.isNotEmpty) {
        setState(() => _detail = Map<String, dynamic>.from(rows.first as Map));
      }
    } catch (e) {
      _snack(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _aiDraft() async {
    if (_make.text.trim().isEmpty || _model.text.trim().isEmpty) return;
    setState(() => _busy = true);
    try {
      final typeName = widget.equipmentTypes
          .where((t) => t.id == _typeId)
          .firstOrNull
          ?.name;
      final r = await ref.read(backendRestClientProvider).invokeFunction(
        'equipment-pack-draft',
        {
          'manufacturer': _make.text.trim(),
          'model': _model.text.trim(),
          'type_name': ?typeName,
        },
      );
      if (r['outcome'] != 'drafted') {
        throw Exception(r['error'] ?? 'no draft');
      }
      final checks = [
        for (final c in (r['checks'] as List))
          PackCheck.fromJson(Map<String, dynamic>.from(c as Map)),
      ];
      setState(() {
        _draft = checks;
        _draftNote = r['note'] as String?;
        _keep
          ..clear()
          ..addAll(List.generate(checks.length, (i) => i));
      });
    } catch (e) {
      _snack(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveDraft() async {
    final draft = _draft;
    if (draft == null || _keep.isEmpty) return;
    final kept = [for (final i in _keep.toList()..sort()) draft[i]];
    setState(() => _busy = true);
    try {
      final rows = await ref.read(backendRestClientProvider).rpc(
        'save_venue_equipment_model',
        {
          'p_manufacturer': _make.text.trim(),
          'p_model': _model.text.trim(),
          'p_equipment_type_id': _typeId,
          'p_checks': [for (final c in kept) c.toJson()],
          'p_user_id': ref.read(currentUserProvider)?.id,
        },
      );
      if (!mounted) return;
      Navigator.of(context).pop(
        EquipmentModelChoice(
          id: (rows.first as Map)['model_id'] as int,
          manufacturer: _make.text.trim(),
          model: _model.text.trim(),
          equipmentTypeId: _typeId,
          checks: kept,
          isVenueDraft: true,
        ),
      );
    } catch (e) {
      _snack(e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  String _freq(AppLocalizations l10n, String f) => switch (f) {
    'daily' => l10n.packFrequencyDaily,
    'weekly' => l10n.packFrequencyWeekly,
    'monthly' => l10n.packFrequencyMonthly,
    'quarterly' => l10n.packFrequencyQuarterly,
    'perService' => l10n.packFrequencyPerService,
    'sixMonthly' => l10n.freqSixMonthly,
    'annually' => l10n.freqAnnually,
    _ => f,
  };

  Widget _checkTile(AppLocalizations l10n, PackCheck c, {Widget? leading}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ?leading,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    c.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    _freq(l10n, c.frequency),
                    style: const TextStyle(color: AppColors.muted, fontSize: 13),
                  ),
                  for (var i = 0; i < c.steps.length; i++)
                    Text('${i + 1}. ${c.steps[i]}'),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.packFindModelTitle)),
      body: ResponsiveContent(
        maxWidth: 640,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (_busy) const LinearProgressIndicator(),
            if (_detail != null) ..._detailView(l10n) else ..._searchView(l10n),
          ],
        ),
      ),
    );
  }

  List<Widget> _searchView(AppLocalizations l10n) => [
    TextField(
      controller: _query,
      decoration: InputDecoration(
        labelText: l10n.packSearchLabel,
        suffixIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: _busy ? null : _search,
        ),
      ),
      onSubmitted: (_) => _search(),
    ),
    const SizedBox(height: 8),
    if (_results != null && _results!.isEmpty)
      Text(l10n.packNoneFound, style: const TextStyle(color: AppColors.muted)),
    for (final r in _results ?? const <Map<String, dynamic>>[])
      Card(
        child: ListTile(
          title: Text('${r['manufacturer']} ${r['model']}'),
          subtitle: Text(
            [
              if (r['equipment_type_name'] != null) '${r['equipment_type_name']}',
              l10n.packCheckCount(r['check_count'] as int? ?? 0),
              if (r['status'] == 'venue') l10n.packYourDraft,
            ].join(' · '),
          ),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _open(r['id'] as int),
        ),
      ),
    const SizedBox(height: 16),
    AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.packNotListedTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l10n.packNotListedHelp, style: const TextStyle(color: AppColors.muted)),
          TextField(
            controller: _make,
            decoration: InputDecoration(labelText: l10n.packMakeLabel),
          ),
          TextField(
            controller: _model,
            decoration: InputDecoration(labelText: l10n.packModelLabel),
          ),
          DropdownButtonFormField<int?>(
            initialValue: _typeId,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.packTypeLabel),
            items: [
              for (final t in widget.equipmentTypes)
                DropdownMenuItem(value: t.id, child: Text(t.name)),
            ],
            onChanged: (v) => setState(() => _typeId = v),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            icon: const Icon(Icons.auto_awesome),
            label: Text(l10n.packDraftButton),
            onPressed: _busy ? null : _aiDraft,
          ),
          if (_draft != null) ...[
            const SizedBox(height: 12),
            AppBanner(
              kind: BannerKind.caution,
              child: Text(
                [l10n.packDraftWarning, if (_draftNote?.isNotEmpty ?? false) _draftNote!]
                    .join(' '),
              ),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < _draft!.length; i++)
              _checkTile(
                l10n,
                _draft![i],
                leading: Checkbox(
                  value: _keep.contains(i),
                  onChanged: (v) => setState(
                    () => v == true ? _keep.add(i) : _keep.remove(i),
                  ),
                ),
              ),
            FilledButton(
              onPressed: _busy || _keep.isEmpty ? null : _saveDraft,
              child: Text(l10n.packApproveButton),
            ),
          ],
        ],
      ),
    ),
  ];

  List<Widget> _detailView(AppLocalizations l10n) {
    final d = _detail!;
    final checks = [
      for (final c in (d['checks'] as List? ?? []))
        PackCheck.fromJson(Map<String, dynamic>.from(c as Map)),
    ];
    final sources = [for (final s in (d['source_urls'] as List? ?? [])) '$s'];
    return [
      Text(
        '${d['manufacturer']} ${d['model']}',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      if (d['checked_on'] != null)
        Text(
          l10n.packCheckedOn('${d['checked_on']}'),
          style: const TextStyle(color: AppColors.muted),
        ),
      const SizedBox(height: 12),
      for (final c in checks) _checkTile(l10n, c),
      if (sources.isNotEmpty) ...[
        const SizedBox(height: 4),
        Text(l10n.packSources, style: const TextStyle(fontWeight: FontWeight.w600)),
        for (final s in sources)
          SelectableText(s, style: const TextStyle(fontSize: 12, color: AppColors.muted)),
      ],
      const SizedBox(height: 16),
      FilledButton(
        onPressed: () => Navigator.of(context).pop(
          EquipmentModelChoice(
            id: d['id'] as int,
            manufacturer: '${d['manufacturer']}',
            model: '${d['model']}',
            equipmentTypeId: d['equipment_type_id'] as int?,
            checks: checks,
            isVenueDraft: d['status'] == 'venue',
          ),
        ),
        child: Text(l10n.packUseModelButton),
      ),
      TextButton(
        onPressed: () => setState(() => _detail = null),
        child: Text(l10n.back),
      ),
    ];
  }
}
