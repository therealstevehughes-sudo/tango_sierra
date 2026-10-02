import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/training_record.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_role_certification_requirement_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import '../../shared/providers/training_record_providers.dart';
import 'fair_auto_assign_service.dart';

// Rota calendar, Sprint 8 (2026-10-02) — the last outstanding piece of the
// founder's original request: tick staff + shifts, hit one button, the
// app assigns fairly instead of a manager doing it one shift at a time.
// See fair_auto_assign_service.dart for the actual algorithm and its hard
// constraints/fairness rule. This screen only selects the inputs and
// shows the mandatory preview — it never calls managerAssign directly
// from here, only from FairAutoAssignPreviewScreen after review.
class FairAutoAssignScreen extends ConsumerStatefulWidget {
  const FairAutoAssignScreen({super.key});

  @override
  ConsumerState<FairAutoAssignScreen> createState() =>
      _FairAutoAssignScreenState();
}

class _FairAutoAssignScreenState extends ConsumerState<FairAutoAssignScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  int? _siteId;
  late DateTime _weekStart;
  List<Shift> _allShifts = [];
  List<User> _staff = [];
  final Set<int> _selectedShiftIds = {};
  final Set<int> _selectedUserIds = {};

  @override
  void initState() {
    super.initState();
    _weekStart = _mondayOf(DateTime.now());
    _load();
  }

  DateTime _mondayOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final org = await ref.read(organisationRepositoryProvider).getDefault();
    if (!mounted) return;
    if (!org.rosterAddonEnabled) {
      setState(() {
        _addonEnabled = false;
        _loading = false;
      });
      return;
    }

    final activeSite = ref.read(activeSiteProvider);
    final currentUser = ref.read(currentUserProvider);
    final siteId =
        activeSite?.id ??
        currentUser?.siteId ??
        (await ref.read(currentSiteProvider.future)).id;

    final shifts = await ref.read(shiftRepositoryProvider).getForSite(siteId);
    final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
    if (!mounted) return;
    final openThisWeek = _openShiftsInWeek(shifts);
    setState(() {
      _siteId = siteId;
      _allShifts = shifts;
      _staff = staff.where((u) => u.active).toList();
      _selectedShiftIds
        ..clear()
        ..addAll(openThisWeek.map((s) => s.id));
      _selectedUserIds
        ..clear()
        ..addAll(_staff.map((u) => u.id));
      _addonEnabled = true;
      _loading = false;
    });
  }

  List<Shift> _openShiftsInWeek(List<Shift> shifts) {
    final weekEnd = _weekStart.add(const Duration(days: 7));
    return shifts
        .where(
          (s) =>
              s.claimedByUserId == null &&
              s.status == ShiftStatus.open &&
              !s.startsAt.isBefore(_weekStart) &&
              s.startsAt.isBefore(weekEnd),
        )
        .toList();
  }

  void _changeWeek(int deltaWeeks) {
    setState(() {
      _weekStart = _weekStart.add(Duration(days: 7 * deltaWeeks));
      final openThisWeek = _openShiftsInWeek(_allShifts);
      _selectedShiftIds
        ..clear()
        ..addAll(openThisWeek.map((s) => s.id));
    });
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}';

  String _formatShift(Shift s) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${_formatDate(s.startsAt)} ${two(s.startsAt.hour)}:${two(s.startsAt.minute)}'
        '-${two(s.endsAt.hour)}:${two(s.endsAt.minute)}'
        '${s.isStandby ? ' (standby)' : ''}'
        '${s.roleRequired != null ? ' - ${s.roleRequired}' : ''}';
  }

  Future<void> _preview() async {
    final l10n = AppLocalizations.of(context)!;
    final siteId = _siteId;
    if (siteId == null ||
        _selectedShiftIds.isEmpty ||
        _selectedUserIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.noShiftsOrStaffSelectedText)),
      );
      return;
    }

    final candidateShifts = _allShifts
        .where((s) => _selectedShiftIds.contains(s.id))
        .toList();
    final candidateStaff = _staff
        .where((u) => _selectedUserIds.contains(u.id))
        .toList();

    final offDayRequests = await ref
        .read(offDayRequestRepositoryProvider)
        .getForSite(siteId);
    final trainingRecords = await ref
        .read(trainingRecordRepositoryProvider)
        .getForSite(siteId);
    final siteAdditions = await ref.read(
      siteRoleCertificationRequirementsForSiteProvider(siteId).future,
    );
    final recordsByUserId = <int, List<TrainingRecord>>{};
    for (final r in trainingRecords) {
      (recordsByUserId[r.userId] ??= []).add(r);
    }

    final proposals = computeFairAutoAssignProposals(
      candidateShifts: candidateShifts,
      candidateStaff: candidateStaff,
      allExistingShiftsForSite: _allShifts,
      offDayRequestsForSite: offDayRequests,
      trainingRecordsByUserId: recordsByUserId,
      siteCertAdditions: siteAdditions,
    );

    if (!mounted) return;
    final assignedCount = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => FairAutoAssignPreviewScreen(proposals: proposals),
      ),
    );
    if (assignedCount != null && assignedCount > 0) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final openThisWeek = _openShiftsInWeek(_allShifts);

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.fairAutoAssignTitle),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? Center(child: Text(l10n.rosterAddonNotEnabledText))
          : SafeArea(
              child: ResponsiveContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.fairAutoAssignDescription,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _changeWeek(-1),
                          ),
                          Expanded(
                            child: Text(
                              '${_formatDate(_weekStart)} - ${_formatDate(_weekStart.add(const Duration(days: 6)))}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _changeWeek(1),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        children: [
                          AppCard(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l10n.selectShiftsLabel,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: openThisWeek.isEmpty
                                            ? null
                                            : () => setState(() {
                                                if (_selectedShiftIds.length ==
                                                    openThisWeek.length) {
                                                  _selectedShiftIds.clear();
                                                } else {
                                                  _selectedShiftIds
                                                    ..clear()
                                                    ..addAll(
                                                      openThisWeek.map(
                                                        (s) => s.id,
                                                      ),
                                                    );
                                                }
                                              }),
                                        child: Text(l10n.selectAllLabel),
                                      ),
                                    ],
                                  ),
                                  if (openThisWeek.isEmpty)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 8,
                                      ),
                                      child: Text(
                                        l10n.noOpenShiftsThisWeekText,
                                      ),
                                    )
                                  else
                                    for (final s in openThisWeek)
                                      CheckboxListTile(
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(_formatShift(s)),
                                        value: _selectedShiftIds.contains(
                                          s.id,
                                        ),
                                        onChanged: (v) => setState(() {
                                          if (v ?? false) {
                                            _selectedShiftIds.add(s.id);
                                          } else {
                                            _selectedShiftIds.remove(s.id);
                                          }
                                        }),
                                      ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          AppCard(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          l10n.selectStaffLabel,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _staff.isEmpty
                                            ? null
                                            : () => setState(() {
                                                if (_selectedUserIds.length ==
                                                    _staff.length) {
                                                  _selectedUserIds.clear();
                                                } else {
                                                  _selectedUserIds
                                                    ..clear()
                                                    ..addAll(
                                                      _staff.map((u) => u.id),
                                                    );
                                                }
                                              }),
                                        child: Text(l10n.selectAllLabel),
                                      ),
                                    ],
                                  ),
                                  for (final u in _staff)
                                    CheckboxListTile(
                                      dense: true,
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(u.name),
                                      subtitle: Text(u.jobTitle),
                                      value: _selectedUserIds.contains(u.id),
                                      onChanged: (v) => setState(() {
                                        if (v ?? false) {
                                          _selectedUserIds.add(u.id);
                                        } else {
                                          _selectedUserIds.remove(u.id);
                                        }
                                      }),
                                    ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: ElevatedButton.icon(
                        onPressed: openThisWeek.isEmpty ? null : _preview,
                        icon: const Icon(Icons.auto_awesome_outlined),
                        label: Text(l10n.previewAutoAssignButton),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// The mandatory preview — nothing in fair_auto_assign_service.dart ever
// writes anything; this screen is the only place managerAssign actually
// gets called, and only for proposals still checked when "Confirm" is
// pressed. Matches the same "never auto-publish unreviewed" shape as the
// allergen matrix's draft/approve step and the AI-drafted SOP flow.
class FairAutoAssignPreviewScreen extends ConsumerStatefulWidget {
  const FairAutoAssignPreviewScreen({super.key, required this.proposals});

  final List<FairAssignProposal> proposals;

  @override
  ConsumerState<FairAutoAssignPreviewScreen> createState() =>
      _FairAutoAssignPreviewScreenState();
}

class _FairAutoAssignPreviewScreenState
    extends ConsumerState<FairAutoAssignPreviewScreen> {
  late Set<int> _acceptedShiftIds;
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    _acceptedShiftIds = widget.proposals
        .where((p) => p.isFilled)
        .map((p) => p.shift.id)
        .toSet();
  }

  String _formatShift(Shift s) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${s.startsAt.day}/${s.startsAt.month} '
        '${two(s.startsAt.hour)}:${two(s.startsAt.minute)}'
        '-${two(s.endsAt.hour)}:${two(s.endsAt.minute)}'
        '${s.isStandby ? ' (standby)' : ''}';
  }

  Future<void> _confirm() async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    setState(() => _confirming = true);
    var assignedCount = 0;
    for (final p in widget.proposals) {
      if (!p.isFilled || !_acceptedShiftIds.contains(p.shift.id)) continue;
      final result = await ref.read(shiftRepositoryProvider).managerAssign(
        shiftId: p.shift.id,
        userId: p.user!.id,
        assignedByUserId: manager.id,
      );
      if (result != null) assignedCount++;
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.assignmentsConfirmedMessage(assignedCount))),
    );
    Navigator.pop(context, assignedCount);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filledCount = widget.proposals.where((p) => p.isFilled).length;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.fairAutoAssignPreviewTitle),
        actions: const [AssistantIconButton()],
      ),
      body: SafeArea(
        child: ResponsiveContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  l10n.fairAutoAssignSummaryText(
                    filledCount,
                    widget.proposals.length,
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    for (final p in widget.proposals)
                      Card(
                        child: p.isFilled
                            ? CheckboxListTile(
                                title: Text(
                                  '${_formatShift(p.shift)} -> ${p.user!.name}',
                                ),
                                subtitle: Text(p.reason ?? ''),
                                value: _acceptedShiftIds.contains(p.shift.id),
                                onChanged: (v) => setState(() {
                                  if (v ?? false) {
                                    _acceptedShiftIds.add(p.shift.id);
                                  } else {
                                    _acceptedShiftIds.remove(p.shift.id);
                                  }
                                }),
                              )
                            : ListTile(
                                title: Text(
                                  '${_formatShift(p.shift)} - ${l10n.unfilledShiftLabel}',
                                ),
                                subtitle: Text(p.reason ?? ''),
                                leading: const Icon(
                                  Icons.warning_amber_outlined,
                                  color: Colors.orange,
                                ),
                              ),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: _confirming || _acceptedShiftIds.isEmpty
                      ? null
                      : _confirm,
                  child: Text(l10n.confirmAssignmentsButton),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
