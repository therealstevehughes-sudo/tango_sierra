import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
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
        _error = e.toString();
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
        actions: const [AssistantIconButton()],
      ),
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
    if (regular.isEmpty) return const SizedBox.shrink();
    final filled = regular.where((s) => s.claimedByUserId != null).length;
    final full = filled == regular.length;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RotaStatusDot(color: full ? AppColors.pass : AppColors.critical, size: 8),
        Text(
          '$filled/${regular.length}',
          style: const TextStyle(fontSize: 10),
        ),
      ],
    );
  }
}
