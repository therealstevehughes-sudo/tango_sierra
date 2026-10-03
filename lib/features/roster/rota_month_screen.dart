import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/errors/friendly_error.dart';
import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/certification_requirement.dart';
import '../../shared/models/department.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/shift_period.dart';
import '../../shared/models/training_item.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/shift_period_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import '../../shared/providers/site_role_certification_requirement_providers.dart';
import '../../shared/providers/training_record_providers.dart';
import 'rota_week_screen.dart';
import 'widgets/rota_month_grid.dart';

// Rota calendar, leadership view (2026-10-02 month-view rebuild, was
// Sprint 7's bare "shift count per day" summary) — department tabs above
// a real month grid, each day showing a green (fully staffed) or red
// (short-staffed) dot with a filled/total count for the selected
// department. Tapping a day drills into that day's shifts with names,
// an Approve action for self-claimed-but-unapproved shifts, and an
// Assign action for anything still open — all inline, no separate
// screen, per the founder's "click the shift and see who is available"
// spec. RotaWeekScreen (the per-person grid) stays reachable from here
// for the deeper "who specifically, across the whole week" view that
// this month-level screen deliberately doesn't try to replace.
class RotaMonthScreen extends ConsumerStatefulWidget {
  const RotaMonthScreen({super.key});

  @override
  ConsumerState<RotaMonthScreen> createState() => _RotaMonthScreenState();
}

class _RotaMonthScreenState extends ConsumerState<RotaMonthScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  String? _error;
  late DateTime _monthStart;
  List<Shift> _shifts = [];
  List<ShiftPeriod> _periods = [];
  List<Department> _departments = [];
  List<User> _staff = [];
  List<OffDayRequest> _offDayRequests = [];
  Department? _departmentFilter;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _monthStart = DateTime(now.year, now.month, 1);
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
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

      final shifts = await ref.read(shiftRepositoryProvider).getForSite(siteId);
      final periods = await ref
          .read(shiftPeriodRepositoryProvider)
          .getForSite(siteId);
      final departments = await ref
          .read(departmentRepositoryProvider)
          .getForSite(siteId);
      final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
      final offDayRequests = await ref
          .read(offDayRequestRepositoryProvider)
          .getForSite(siteId);
      if (!mounted) return;
      setState(() {
        _shifts = shifts;
        _periods = periods;
        _departments = departments;
        _staff = staff.where((u) => u.active).toList();
        _offDayRequests = offDayRequests;
        _addonEnabled = true;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(AppLocalizations.of(context)!, e);
        _loading = false;
      });
    }
  }

  void _changeMonth(int delta) {
    setState(
      () => _monthStart = DateTime(_monthStart.year, _monthStart.month + delta, 1),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  List<Shift> _shiftsOn(DateTime day, {Department? department}) {
    return _shifts.where((s) {
      if (!_isSameDay(s.startsAt, day)) return false;
      if (department != null && s.departmentId != department.id) return false;
      return true;
    }).toList();
  }

  String _staffName(int? userId) =>
      userId == null ? '' : _staff.where((u) => u.id == userId).firstOrNull?.name ?? '?';

  Future<void> _approve(Shift shift) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null || shift.claimedByUserId == null) return;
    setState(() => _busy = true);
    await ref.read(shiftRepositoryProvider).managerAssign(
      shiftId: shift.id,
      userId: shift.claimedByUserId!,
      assignedByUserId: manager.id,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  // Day-off decide, folded in here (2026-10-03, UX audit) — previously the
  // ONLY place a manager could approve/deny a day-off request was
  // RosterBoardScreen's second tab, which isn't reachable from this
  // calendar at all; a manager living in the month/week views had no way
  // to act on a pending request without knowing to go back to the older
  // screen. Same `decide` RPC call RosterBoardScreen used.
  Future<void> _decideOffDay(int requestId, OffDayRequestStatus status) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    setState(() => _busy = true);
    await ref
        .read(offDayRequestRepositoryProvider)
        .decide(requestId: requestId, status: status, decidedByUserId: manager.id);
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  // Post a one-off shift (2026-10-03, UX audit) — ported from
  // RosterBoardScreen, which this screen replaces as the drawer's single
  // "Rota" entry point. Recurring staffing needs still go through Master
  // Rota Settings' "generate shifts"; this is for the one-off, unplanned
  // addition that template wasn't meant to cover.
  Future<void> _postShift() async {
    final siteId =
        ref.read(activeSiteProvider)?.id ?? ref.read(currentUserProvider)?.siteId;
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
                    decoration: InputDecoration(labelText: l10n.categoryHint),
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      startsAt == null ? l10n.pickStartTime : formatDateTime(startsAt!),
                    ),
                    trailing: const Icon(Icons.calendar_today, size: 18),
                    onTap: () async {
                      final picked = await _pickDateTime(context);
                      if (picked != null) setDialogState(() => startsAt = picked);
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
                      if (picked != null) setDialogState(() => endsAt = picked);
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
    await _load();
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

  Future<void> _assign(Shift shift, List<User> candidates) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    final l10n = AppLocalizations.of(context)!;
    final selected = await showDialog<User>(
      context: context,
      builder: (context) => SimpleDialog(
        title: Text(l10n.assignShiftToTitle),
        children: [
          for (final u in candidates)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, u),
              child: Text(u.name),
            ),
        ],
      ),
    );
    if (selected == null) return;

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

    setState(() => _busy = true);
    await ref.read(shiftRepositoryProvider).managerAssign(
      shiftId: shift.id,
      userId: selected.id,
      assignedByUserId: manager.id,
    );
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  Future<void> _showDayDetail(DateTime day) async {
    final l10n = AppLocalizations.of(context)!;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.8,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                final dayShifts = _shiftsOn(
                  day,
                  department: _departmentFilter,
                );
                final byPeriod = <int?, List<Shift>>{};
                for (final shift in dayShifts) {
                  final period = shiftPeriodFor(_periods, shift.startsAt);
                  byPeriod.putIfAbsent(period?.id, () => []).add(shift);
                }
                final dayOffRequests = _offDayRequests
                    .where((r) => _isSameDay(r.requestedDate, day))
                    .toList();
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: AppColors.line,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        '${day.day}/${day.month}/${day.year}'
                        '${_departmentFilter != null ? ' · ${_departmentFilter!.name}' : ''}',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      if (dayShifts.isEmpty)
                        Text(l10n.noShiftsThisPeriodText, textAlign: TextAlign.center)
                      else
                        for (final entry in byPeriod.entries)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPeriodDetail(
                              l10n,
                              day,
                              entry.value,
                              () async {
                                await _load();
                                setSheetState(() {});
                              },
                            ),
                          ),
                      // Day-off decide, folded in here (2026-10-03, UX
                      // audit) — see _decideOffDay's own doc comment.
                      if (dayOffRequests.isNotEmpty)
                        _buildDayOffRequests(l10n, dayOffRequests, () async {
                          await _load();
                          setSheetState(() {});
                        }),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDayOffRequests(
    AppLocalizations l10n,
    List<OffDayRequest> requests,
    Future<void> Function() onChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.offDayRequestsTabLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final request in requests)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(child: Text(_staffName(request.userId))),
                    if (request.status == OffDayRequestStatus.pending) ...[
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                await _decideOffDay(
                                  request.id,
                                  OffDayRequestStatus.approved,
                                );
                                await onChanged();
                              },
                        child: Text(l10n.approveLabel),
                      ),
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                await _decideOffDay(
                                  request.id,
                                  OffDayRequestStatus.denied,
                                );
                                await onChanged();
                              },
                        child: Text(l10n.denyLabel),
                      ),
                    ] else
                      Text(
                        request.status == OffDayRequestStatus.approved
                            ? l10n.approvedLabel
                            : l10n.deniedLabel,
                        style: TextStyle(
                          color: request.status == OffDayRequestStatus.approved
                              ? AppColors.pass
                              : AppColors.critical,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodDetail(
    AppLocalizations l10n,
    DateTime day,
    List<Shift> periodShifts,
    Future<void> Function() onChanged,
  ) {
    final period = shiftPeriodFor(_periods, periodShifts.first.startsAt);
    final regular = periodShifts.where((s) => !s.isStandby).toList();
    final standby = periodShifts.where((s) => s.isStandby).toList();

    final workingIds = regular
        .where((s) => s.claimedByUserId != null)
        .map((s) => s.claimedByUserId!)
        .toSet();
    final standbyIds = standby
        .where((s) => s.claimedByUserId != null)
        .map((s) => s.claimedByUserId!)
        .toSet();
    final unavailableIds = _staff
        .where(
          (u) => _offDayRequests.any(
            (r) =>
                r.userId == u.id &&
                _isSameDay(r.requestedDate, day) &&
                r.status == OffDayRequestStatus.approved,
          ),
        )
        .map((u) => u.id)
        .toSet();
    final candidatePool = _departmentFilter == null
        ? _staff
        : _staff.where((u) => u.departmentId == _departmentFilter!.id).toList();
    final available = candidatePool
        .where(
          (u) =>
              !workingIds.contains(u.id) &&
              !standbyIds.contains(u.id) &&
              !unavailableIds.contains(u.id),
        )
        .toList();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              period?.name ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final shift in regular)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        shift.claimedByUserId != null
                            ? _staffName(shift.claimedByUserId)
                            : l10n.openStatusLabel,
                        style: TextStyle(
                          color: shift.claimedByUserId == null
                              ? AppColors.critical
                              : null,
                        ),
                      ),
                    ),
                    if (shift.claimedByUserId == null)
                      TextButton(
                        onPressed: _busy || available.isEmpty
                            ? null
                            : () async {
                                await _assign(shift, available);
                                await onChanged();
                              },
                        child: Text(l10n.rotaAssignButton),
                      )
                    else if (shift.status == ShiftStatus.claimed)
                      TextButton(
                        onPressed: _busy
                            ? null
                            : () async {
                                await _approve(shift);
                                await onChanged();
                              },
                        child: Text(l10n.rotaApproveButton),
                      )
                    else
                      Text(
                        l10n.youAreAssignedText,
                        style: const TextStyle(
                          color: AppColors.pass,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
              ),
            if (standby.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                l10n.rotaStandbyLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              for (final shift in standby)
                Text(
                  shift.claimedByUserId != null
                      ? _staffName(shift.claimedByUserId)
                      : l10n.openStatusLabel,
                ),
            ],
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
                children: [
                  TextSpan(
                    text: '${l10n.rotaUnavailableLabel}: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: unavailableIds.isEmpty
                        ? '—'
                        : (unavailableIds.map(_staffName).toList()..sort()).join(', '),
                  ),
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
                children: [
                  TextSpan(
                    text: '${l10n.rotaAvailableLabel}: ',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: available.isEmpty
                        ? '—'
                        : (available.map((u) => u.name).toList()..sort()).join(', '),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.rotaMonthTitle),
        actions: [
          // Drill-down into the per-person week grid (2026-10-03, UX
          // audit) — previously only reachable as its own separate
          // top-level drawer item, with no actual link between it and
          // this screen despite both doc comments claiming one. "Week
          // view" is now folded into this screen's own header instead of
          // sitting as a second, easily-confused-for-unrelated drawer
          // entry.
          IconButton(
            icon: const Icon(Icons.calendar_view_week_outlined),
            tooltip: l10n.rotaWeekTitle,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => RotaWeekScreen(initialDate: _monthStart),
              ),
            ),
          ),
          if (_addonEnabled)
            IconButton(
              icon: const Icon(Icons.add),
              tooltip: l10n.postAShiftTitle,
              onPressed: _postShift,
            ),
        ],
      ),
      drawer: ManagementDrawer(title: l10n.rotaMonthTitle),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? LoadErrorView(error: _error!, onRetry: _load)
          : !_addonEnabled
          ? Center(child: Text(l10n.rosterAddonNotEnabledText))
          : SafeArea(
              child: ResponsiveContent(
                child: Column(
                  children: [
                    if (_departments.isNotEmpty)
                      SizedBox(
                        height: 44,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                label: Text(l10n.rotaFilterAllLabel),
                                selected: _departmentFilter == null,
                                onSelected: (_) =>
                                    setState(() => _departmentFilter = null),
                              ),
                            ),
                            for (final dept in _departments)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: ChoiceChip(
                                  label: Text(dept.name),
                                  selected: _departmentFilter?.id == dept.id,
                                  onSelected: (_) =>
                                      setState(() => _departmentFilter = dept),
                                ),
                              ),
                          ],
                        ),
                      ),
                    Expanded(
                      child: RotaMonthGrid(
                        monthStart: _monthStart,
                        onChangeMonth: _changeMonth,
                        onDayTap: _showDayDetail,
                        dayCellBuilder: (context, day) => _dayCell(day),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _dayCell(DateTime day) {
    final dayShifts = _shiftsOn(day, department: _departmentFilter);
    final regular = dayShifts.where((s) => !s.isStandby).toList();
    // Pending-day-off indicator (2026-10-03, UX audit) — so a manager can
    // spot which days have a request waiting without opening every day;
    // shown regardless of whether the selected department has any shifts
    // that day, since a day-off request isn't department-scoped.
    final hasPendingOffDay = _offDayRequests.any(
      (r) => _isSameDay(r.requestedDate, day) && r.status == OffDayRequestStatus.pending,
    );
    if (regular.isEmpty) {
      return hasPendingOffDay
          ? const Align(
              alignment: Alignment.topRight,
              child: RotaStatusDot(color: AppColors.caution, size: 8),
            )
          : const SizedBox.shrink();
    }
    final filled = regular.where((s) => s.claimedByUserId != null).length;
    final full = filled == regular.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            RotaStatusDot(color: full ? AppColors.pass : AppColors.critical, size: 8),
            if (hasPendingOffDay)
              const Positioned(
                right: -10,
                top: -2,
                child: RotaStatusDot(color: AppColors.caution, size: 6),
              ),
          ],
        ),
        Text(
          '$filled/${regular.length}',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
