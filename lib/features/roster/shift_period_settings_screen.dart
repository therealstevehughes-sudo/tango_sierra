import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/friendly_error.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/shift_period.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_period_providers.dart';

// Rota calendar, Sprint 1 (2026-10-01) — leadership picks 2 or 3 shift
// periods for the site and names/times each one. Everything downstream
// (the week/month calendar filters, auto-assign) reads this config live,
// so editing it here reclassifies every shift automatically — see
// shift_period.dart's own doc comment.
class ShiftPeriodSettingsScreen extends ConsumerStatefulWidget {
  const ShiftPeriodSettingsScreen({super.key});

  @override
  ConsumerState<ShiftPeriodSettingsScreen> createState() =>
      _ShiftPeriodSettingsScreenState();
}

class _PeriodDraft {
  _PeriodDraft({required this.name, required this.startMinutes, required this.endMinutes});
  String name;
  int startMinutes;
  int endMinutes;
}

class _ShiftPeriodSettingsScreenState
    extends ConsumerState<ShiftPeriodSettingsScreen> {
  bool _loading = true;
  int? _siteId;
  List<_PeriodDraft> _drafts = [];
  bool _saving = false;

  // Starting suggestions only — every field is immediately editable, so
  // these default names are a sensible first draft, not fixed UI copy;
  // only the labels/buttons around them are localized.
  List<(String, int, int)> _defaultTwoPeriods(AppLocalizations l10n) => [
    (l10n.shiftPeriodDefaultDay, 6 * 60, 18 * 60),
    (l10n.shiftPeriodDefaultNight, 18 * 60, 6 * 60),
  ];
  List<(String, int, int)> _defaultThreePeriods(AppLocalizations l10n) => [
    (l10n.shiftPeriodDefaultMorning, 6 * 60, 14 * 60),
    (l10n.shiftPeriodDefaultAfternoon, 14 * 60, 22 * 60),
    (l10n.shiftPeriodDefaultNight, 22 * 60, 6 * 60),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final currentUser = ref.read(currentUserProvider);
    final siteId = currentUser?.siteId;
    if (siteId == null) {
      setState(() => _loading = false);
      return;
    }
    final existing = await ref
        .read(shiftPeriodRepositoryProvider)
        .getForSite(siteId);
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _siteId = siteId;
      _drafts = existing.isEmpty
          ? _defaultThreePeriods(l10n)
              .map(
                (p) => _PeriodDraft(
                  name: p.$1,
                  startMinutes: p.$2,
                  endMinutes: p.$3,
                ),
              )
              .toList()
          : existing
              .map(
                (p) => _PeriodDraft(
                  name: p.name,
                  startMinutes: p.startMinutes,
                  endMinutes: p.endMinutes,
                ),
              )
              .toList();
      _loading = false;
    });
  }

  void _setPeriodCount(int count) {
    final l10n = AppLocalizations.of(context)!;
    final template = count == 2
        ? _defaultTwoPeriods(l10n)
        : _defaultThreePeriods(l10n);
    setState(() {
      _drafts = template
          .map(
            (p) =>
                _PeriodDraft(name: p.$1, startMinutes: p.$2, endMinutes: p.$3),
          )
          .toList();
    });
  }

  Future<void> _pickTime(_PeriodDraft draft, {required bool isStart}) async {
    final current = isStart ? draft.startMinutes : draft.endMinutes;
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current ~/ 60, minute: current % 60),
    );
    if (picked == null) return;
    setState(() {
      final minutes = picked.hour * 60 + picked.minute;
      if (isStart) {
        draft.startMinutes = minutes;
      } else {
        draft.endMinutes = minutes;
      }
    });
  }

  Future<void> _save() async {
    final siteId = _siteId;
    if (siteId == null) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() => _saving = true);
    try {
      await ref.read(shiftPeriodRepositoryProvider).replaceAll(
        siteId,
        _drafts
            .map(
              (d) => ShiftPeriod(
                id: null,
                siteId: siteId,
                name: d.name,
                startMinutes: d.startMinutes,
                endMinutes: d.endMinutes,
                sortOrder: 0,
              ),
            )
            .toList(),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.shiftPeriodsSavedMessage)));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(friendlyErrorMessage(l10n, e))),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  String _formatMinutes(int minutes) {
    final h = (minutes ~/ 60).toString().padLeft(2, '0');
    final m = (minutes % 60).toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.shiftPeriodsTitle),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _siteId == null
          ? LoadErrorView(error: l10n.noSignedInUserError, onRetry: _load)
          : SafeArea(
              child: ResponsiveContent(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      l10n.shiftPeriodsDescription,
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    SegmentedButton<int>(
                      segments: [
                        ButtonSegment(
                          value: 2,
                          label: Text(l10n.shiftPeriodCountOption(2)),
                        ),
                        ButtonSegment(
                          value: 3,
                          label: Text(l10n.shiftPeriodCountOption(3)),
                        ),
                      ],
                      selected: {_drafts.length == 2 ? 2 : 3},
                      onSelectionChanged: (selection) =>
                          _setPeriodCount(selection.first),
                    ),
                    const SizedBox(height: 16),
                    for (final draft in _drafts)
                      AppCard(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: draft.name,
                                decoration: InputDecoration(
                                  labelText: l10n.shiftPeriodNameLabel,
                                ),
                                onChanged: (v) => draft.name = v,
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(l10n.shiftPeriodStartsLabel),
                                      subtitle: Text(
                                        _formatMinutes(draft.startMinutes),
                                      ),
                                      onTap: () =>
                                          _pickTime(draft, isStart: true),
                                    ),
                                  ),
                                  Expanded(
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(l10n.shiftPeriodEndsLabel),
                                      subtitle: Text(
                                        _formatMinutes(draft.endMinutes),
                                      ),
                                      onTap: () =>
                                          _pickTime(draft, isStart: false),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saving ? null : _save,
                      child: _saving
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(l10n.saveButton),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
