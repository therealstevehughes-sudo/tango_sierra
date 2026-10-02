import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/certification_requirement.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/training_item.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_role_certification_requirement_providers.dart';
import '../../shared/providers/training_record_providers.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;

// Roster add-on, Phase R2 (2026-09-27) — the manager-facing side: post
// shifts, see who's claimed what, remove a claim, or assign someone
// directly. Menu-based actions, same convention as the branch organogram
// (this app has no drag-and-drop precedent) — a shift's own PopupMenuButton
// carries "Assign directly" and "Remove claim/cancel."
//
// Second tab added (R5, 2026-09-27): pending off-day requests, approve/deny
// via the same PopupMenuButton pattern the Shifts tab already uses.
class RosterBoardScreen extends ConsumerStatefulWidget {
  const RosterBoardScreen({super.key});

  @override
  ConsumerState<RosterBoardScreen> createState() => _RosterBoardScreenState();
}

class _RosterBoardScreenState extends ConsumerState<RosterBoardScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  String? _error;
  int? _siteId;
  List<User> _staff = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Resolves addon-enabled/siteId/staff once — the shift LIST itself is no
  // longer loaded here (R7, 2026-09-27): build() watches
  // shiftsStreamForSiteProvider instead, which polls on its own, so
  // mutations below no longer need to call this again just to refresh the
  // list.
  Future<void> _load() async {
    setState(() => _error = null);
    try {
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

      final staff = await ref.read(userRepositoryProvider).getForSite(siteId);

      if (!mounted) return;
      setState(() {
        _addonEnabled = true;
        _siteId = siteId;
        _staff = staff.where((u) => u.active).toList();
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _postShift() async {
    final siteId = _siteId;
    final manager = ref.read(currentUserProvider);
    if (siteId == null || manager == null) return;

    DateTime? startsAt;
    DateTime? endsAt;
    final categoryController = TextEditingController();
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.postAShiftTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: l10n.categoryHint,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      startsAt == null
                          ? l10n.pickStartTime
                          : formatDateTime(startsAt!),
                    ),
                    trailing: const Icon(Icons.calendar_today, size: 18),
                    onTap: () async {
                      final picked = await _pickDateTime(context);
                      if (picked != null) {
                        setDialogState(() => startsAt = picked);
                      }
                    },
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      endsAt == null ? l10n.pickEndTime : formatDateTime(endsAt!),
                    ),
                    trailing: const Icon(Icons.calendar_today, size: 18),
                    onTap: () async {
                      final picked = await _pickDateTime(context);
                      if (picked != null) {
                        setDialogState(() => endsAt = picked);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(labelText: l10n.notesOptionalLabel),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: startsAt != null && endsAt != null
                    ? () => Navigator.pop(context, true)
                    : null,
                child: Text(l10n.postLabel),
              ),
            ],
          );
        },
      ),
    );

    final category = categoryController.text.trim();
    final notes = notesController.text.trim();
    categoryController.dispose();
    notesController.dispose();

    if (confirmed != true || startsAt == null || endsAt == null) return;

    await ref.read(shiftRepositoryProvider).postShift(
      siteId: siteId,
      category: category.isEmpty ? null : category,
      startsAt: startsAt!,
      endsAt: endsAt!,
      notes: notes.isEmpty ? null : notes,
      createdByUserId: manager.id,
    );
    // No manual reload — shiftsStreamForSiteProvider picks this up on its
    // next poll (within 20s, see R7's doc comment on that provider).
  }

  Future<DateTime?> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _assign(Shift shift) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    final selected = await showDialog<User>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(AppLocalizations.of(context)!.assignShiftToTitle),
        children: [
          for (final u in _staff)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, u),
              child: Text(u.name),
            ),
        ],
      ),
    );
    if (selected == null) return;

    // Same certification-expiry check as ClaimBoardScreen's own _claim —
    // a manager assigning someone directly shouldn't bypass it.
    final records = await ref
        .read(trainingRecordRepositoryProvider)
        .getForUser(selected.id);
    final siteAdditions = await ref.read(
      siteRoleCertificationRequirementsForSiteProvider(shift.siteId).future,
    );
    final missing = missingCertificationsForRole(
      role: selected.jobRole,
      records: records,
      siteAdditions: siteAdditions,
    );
    if (!mounted) return;
    if (missing.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.cannotAssignShiftTitle(selected.name)),
          content: Text(
            l10n.missingCertificationsMessage(
              missing.map((t) => trainingItemTypeLabel(t, l10n)).join(', '),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.okLabel),
            ),
          ],
        ),
      );
      return;
    }

    final result = await ref.read(shiftRepositoryProvider).managerAssign(
      shiftId: shift.id,
      userId: selected.id,
      assignedByUserId: manager.id,
    );
    // The client-side check above is the specific "you need X" UX; this
    // covers the server rejecting it anyway (e.g. a role check failure,
    // or the eligibility changed between the check and this call — same
    // race-safety reasoning as claim_shift's own atomic check).
    if (result == null && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.assignmentRejectedMessage)));
    }
    // No manual reload — see _postShift's comment.
  }

  Future<void> _remove(Shift shift) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null || shift.claimedByUserId == null) return;
    await ref.read(shiftRepositoryProvider).managerRemove(
      shiftId: shift.id,
      removedUserId: shift.claimedByUserId!,
      removedByUserId: manager.id,
    );
    // No manual reload — see _postShift's comment.
  }

  String _staffName(int? userId) {
    if (userId == null) return '';
    return _staff.where((u) => u.id == userId).firstOrNull?.name ??
        AppLocalizations.of(context)!.unknownLabel;
  }

  Future<void> _decideOffDay(int requestId, OffDayRequestStatus status) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    await ref
        .read(offDayRequestRepositoryProvider)
        .decide(
          requestId: requestId,
          status: status,
          decidedByUserId: manager.id,
        );
    // Off-day requests still use the one-shot provider (no polling stream
    // for these — a lower-frequency, less time-sensitive list than the
    // shift board), so an explicit invalidate is needed here.
    if (_siteId != null) {
      ref.invalidate(offDayRequestsForSiteProvider(_siteId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final shiftsAsync = _siteId == null
        ? const AsyncValue<List<Shift>>.loading()
        : ref.watch(shiftsStreamForSiteProvider(_siteId!));
    final offDayRequestsAsync = _siteId == null
        ? const AsyncValue<List<OffDayRequest>>.loading()
        : ref.watch(offDayRequestsForSiteProvider(_siteId!));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppScreenHeader(
          title: Text(l10n.rosterBoard),
          actions: [
            if (_addonEnabled)
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: l10n.postAShiftTitle,
                onPressed: _postShift,
              ),
            const AssistantIconButton(),
          ],
          bottom: _addonEnabled
              ? TabBar(
                  tabs: [
                    Tab(text: l10n.shiftsTabLabel),
                    Tab(text: l10n.offDayRequestsTabLabel),
                  ],
                )
              : null,
        ),
        drawer: ManagementDrawer(title: l10n.rosterBoard),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? LoadErrorView(error: _error!, onRetry: _load)
            : !_addonEnabled
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    l10n.rosterAddonNotEnabledManager,
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : TabBarView(
                children: [
                  _buildShiftsTab(context, shiftsAsync),
                  _buildOffDayRequestsTab(context, offDayRequestsAsync),
                ],
              ),
      ),
    );
  }

  Widget _buildShiftsTab(
    BuildContext context,
    AsyncValue<List<Shift>> shiftsAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return shiftsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text(l10n.couldNotLoadShifts('$error'))),
              data: (shifts) => shifts.isEmpty
                  ? Center(
                      child: Text(l10n.noShiftsTapPlus),
                    )
                  : ResponsiveContent(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (final shift in shifts)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AppCard(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${formatDateTime(shift.startsAt)} - '
                                            '${shift.endsAt.hour.toString().padLeft(2, '0')}:'
                                            '${shift.endsAt.minute.toString().padLeft(2, '0')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            [
                                              if (shift.category != null)
                                                shift.category!,
                                              shift.status == ShiftStatus.open
                                                  ? l10n.openStatusLabel
                                                  : '${shift.status == ShiftStatus.assigned ? l10n.assignedStatusPrefix : l10n.claimedStatusPrefix} - ${_staffName(shift.claimedByUserId)}',
                                            ].join(' · '),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (action) {
                                        if (action == 'assign') {
                                          _assign(shift);
                                        }
                                        if (action == 'remove') {
                                          _remove(shift);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          value: 'assign',
                                          child: Text(l10n.assignDirectlyLabel),
                                        ),
                                        if (shift.status != ShiftStatus.open)
                                          PopupMenuItem(
                                            value: 'remove',
                                            child: Text(l10n.removeClaimLabel),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            );
  }

  Widget _buildOffDayRequestsTab(
    BuildContext context,
    AsyncValue<List<OffDayRequest>> requestsAsync,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text(l10n.couldNotLoadOffDayRequests('$error'))),
      data: (requests) => requests.isEmpty
          ? Center(child: Text(l10n.noOffDayRequests))
          : ResponsiveContent(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final request in requests)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_staffName(request.userId)} - '
                                    '${formatDate(request.requestedDate)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  if (request.reason != null)
                                    Text(
                                      request.reason!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            if (request.status == OffDayRequestStatus.pending)
                              PopupMenuButton<String>(
                                onSelected: (action) {
                                  if (action == 'approve') {
                                    _decideOffDay(
                                      request.id,
                                      OffDayRequestStatus.approved,
                                    );
                                  }
                                  if (action == 'deny') {
                                    _decideOffDay(
                                      request.id,
                                      OffDayRequestStatus.denied,
                                    );
                                  }
                                },
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'approve',
                                    child: Text(l10n.approveLabel),
                                  ),
                                  PopupMenuItem(
                                    value: 'deny',
                                    child: Text(l10n.denyLabel),
                                  ),
                                ],
                              )
                            else
                              _OffDayStatusChip(status: request.status),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _OffDayStatusChip extends StatelessWidget {
  const _OffDayStatusChip({required this.status});

  final OffDayRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (StatusKind kind, String label) = switch (status) {
      OffDayRequestStatus.approved => (StatusKind.pass, l10n.approvedLabel),
      OffDayRequestStatus.denied => (StatusKind.critical, l10n.deniedLabel),
      OffDayRequestStatus.pending => (StatusKind.caution, l10n.pendingLabel),
    };
    return StatusBadge(kind: kind, label: label);
  }
}
