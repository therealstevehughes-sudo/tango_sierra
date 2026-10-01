import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/department.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/shift_period.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/shift_period_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;

// Rota calendar, Sprint 2 (2026-10-01) — the week-grid primary rota view:
// rows = staff, columns = the 7 days of the displayed week, shifts shown
// as coloured blocks. Standard rota-tool layout (Deputy/When I Work).
// Filterable by shift period (Sprint 1's config), department and person.
// Deliberately additive alongside RosterBoardScreen/ClaimBoardScreen for
// now, not a replacement — Sprint 4 covers consolidating entry points.
class RotaWeekScreen extends ConsumerStatefulWidget {
  const RotaWeekScreen({super.key, this.initialDate});

  /// Opens showing the week containing this date instead of the current
  /// week — set when navigated here from RotaMonthScreen (Sprint 7)
  /// drilling into a specific day/week.
  final DateTime? initialDate;

  @override
  ConsumerState<RotaWeekScreen> createState() => _RotaWeekScreenState();
}

enum _ViewMode { staff, slots }

class _RotaWeekScreenState extends ConsumerState<RotaWeekScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  late DateTime _weekStart;
  List<Shift> _shifts = [];
  List<User> _staff = [];
  List<Department> _departments = [];
  List<ShiftPeriod> _periods = [];

  ShiftPeriod? _periodFilter;
  Department? _departmentFilter;
  User? _personFilter;
  JobRole? _roleFilter;
  _ViewMode _viewMode = _ViewMode.staff;

  @override
  void initState() {
    super.initState();
    _weekStart = _mondayOf(widget.initialDate ?? DateTime.now());
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
    final departments = await ref
        .read(departmentRepositoryProvider)
        .getForSite(siteId);
    final periods = await ref
        .read(shiftPeriodRepositoryProvider)
        .getForSite(siteId);
    if (!mounted) return;
    setState(() {
      _shifts = shifts;
      _staff = staff.where((u) => u.active).toList();
      _departments = departments;
      _periods = periods;
      _addonEnabled = true;
      _loading = false;
    });
  }

  void _changeWeek(int deltaWeeks) {
    setState(() => _weekStart = _weekStart.add(Duration(days: 7 * deltaWeeks)));
  }

  List<Shift> _shiftsFor(User? person, DateTime day) {
    return _shifts.where((s) {
      if (s.startsAt.year != day.year ||
          s.startsAt.month != day.month ||
          s.startsAt.day != day.day) {
        return false;
      }
      if (person == null) {
        // Unassigned row — only truly open shifts.
        if (s.claimedByUserId != null) return false;
      } else {
        if (s.claimedByUserId != person.id) return false;
      }
      if (_departmentFilter != null && s.departmentId != _departmentFilter!.id) {
        return false;
      }
      if (_roleFilter != null && s.roleRequired != _roleFilter!.name) {
        return false;
      }
      if (_periodFilter != null) {
        final period = shiftPeriodFor(_periods, s.startsAt);
        if (period?.id != _periodFilter!.id) return false;
      }
      return true;
    }).toList();
  }

  /// Every shift on [day] matching the active department/role/period
  /// filters, regardless of who (if anyone) has claimed it — the raw
  /// material for the slot view's aggregated counts.
  List<Shift> _allShiftsFor(DateTime day) {
    return _shifts.where((s) {
      if (s.startsAt.year != day.year ||
          s.startsAt.month != day.month ||
          s.startsAt.day != day.day) {
        return false;
      }
      if (_departmentFilter != null && s.departmentId != _departmentFilter!.id) {
        return false;
      }
      if (_roleFilter != null && s.roleRequired != _roleFilter!.name) {
        return false;
      }
      if (_periodFilter != null) {
        final period = shiftPeriodFor(_periods, s.startsAt);
        if (period?.id != _periodFilter!.id) return false;
      }
      return true;
    }).toList();
  }

  String _staffName(int? userId) =>
      userId == null ? '' : _staff.where((u) => u.id == userId).firstOrNull?.name ?? '?';

  Future<void> _showSlotDetail(
    List<Shift> regular,
    List<Shift> standby,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final assignedNames = regular
        .where((s) => s.claimedByUserId != null)
        .map((s) => _staffName(s.claimedByUserId))
        .toList();
    final standbyNames = standby
        .where((s) => s.claimedByUserId != null)
        .map((s) => _staffName(s.claimedByUserId))
        .toList();
    final unfilledRegular = regular.length - assignedNames.length;
    final unfilledStandby = standby.length - standbyNames.length;

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.rotaSlotDetailTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.rotaAssignedLabel,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (assignedNames.isEmpty)
              Text(l10n.rotaNoneAssignedText)
            else
              for (final name in assignedNames) Text(name),
            if (unfilledRegular > 0)
              Text(
                l10n.rotaUnfilledCountText(unfilledRegular),
                style: const TextStyle(color: AppColors.caution),
              ),
            if (standby.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.rotaStandbyLabel,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              if (standbyNames.isEmpty)
                Text(l10n.rotaNoneAssignedText)
              else
                for (final name in standbyNames) Text(name),
              if (unfilledStandby > 0)
                Text(
                  l10n.rotaUnfilledCountText(unfilledStandby),
                  style: const TextStyle(color: AppColors.caution),
                ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.okLabel),
          ),
        ],
      ),
    );
  }

  Future<void> _showShiftDetail(Shift shift, User? person) async {
    final l10n = AppLocalizations.of(context)!;
    final manager = ref.read(currentUserProvider);
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(person?.name ?? l10n.availableShiftsTitle),
        content: Text(
          '${_formatTime(shift.startsAt)} - ${_formatTime(shift.endsAt)}'
          '${shift.notes != null ? '\n${shift.notes}' : ''}',
        ),
        actions: [
          if (person != null && manager != null)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await ref.read(shiftRepositoryProvider).managerRemove(
                  shiftId: shift.id,
                  removedUserId: person.id,
                  removedByUserId: manager.id,
                );
                await _load();
              },
              child: Text(l10n.cancelShiftButton),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.okLabel),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  Color _blockColor(Shift shift) {
    if (shift.claimedByUserId == null) return AppColors.caution;
    return AppColors.pass;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));
    final visibleStaff = _personFilter != null
        ? [_personFilter!]
        : _departmentFilter != null
            ? _staff.where((u) => u.departmentId == _departmentFilter!.id).toList()
            : _staff;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.rotaWeekTitle),
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
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _changeWeek(-1),
                          ),
                          Text(
                            '${_formatDate(days.first)} - ${_formatDate(days.last)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _changeWeek(1),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () =>
                                setState(() => _weekStart = _mondayOf(DateTime.now())),
                            child: Text(l10n.rotaTodayButton),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          DropdownButton<ShiftPeriod?>(
                            value: _periodFilter,
                            hint: Text(l10n.rotaFilterPeriodLabel),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(l10n.rotaFilterAllLabel),
                              ),
                              for (final period in _periods)
                                DropdownMenuItem(
                                  value: period,
                                  child: Text(period.name),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _periodFilter = value),
                          ),
                          DropdownButton<Department?>(
                            value: _departmentFilter,
                            hint: Text(l10n.rotaFilterDepartmentLabel),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(l10n.rotaFilterAllLabel),
                              ),
                              for (final dept in _departments)
                                DropdownMenuItem(
                                  value: dept,
                                  child: Text(dept.name),
                                ),
                            ],
                            onChanged: (value) => setState(() {
                              _departmentFilter = value;
                              _personFilter = null;
                            }),
                          ),
                          DropdownButton<User?>(
                            value: _personFilter,
                            hint: Text(l10n.rotaFilterPersonLabel),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(l10n.rotaFilterAllLabel),
                              ),
                              for (final person in _staff)
                                DropdownMenuItem(
                                  value: person,
                                  child: Text(person.name),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _personFilter = value),
                          ),
                          DropdownButton<JobRole?>(
                            value: _roleFilter,
                            hint: Text(l10n.rotaFilterRoleLabel),
                            items: [
                              DropdownMenuItem(
                                value: null,
                                child: Text(l10n.rotaFilterAllLabel),
                              ),
                              for (final role in JobRole.values)
                                DropdownMenuItem(
                                  value: role,
                                  child: Text(jobRoleDisplayName(role, l10n)),
                                ),
                            ],
                            onChanged: (value) =>
                                setState(() => _roleFilter = value),
                          ),
                          SegmentedButton<_ViewMode>(
                            segments: [
                              ButtonSegment(
                                value: _ViewMode.staff,
                                label: Text(l10n.rotaStaffViewLabel),
                              ),
                              ButtonSegment(
                                value: _ViewMode.slots,
                                label: Text(l10n.rotaSlotsViewLabel),
                              ),
                            ],
                            selected: {_viewMode},
                            onSelectionChanged: (selection) =>
                                setState(() => _viewMode = selection.first),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _viewMode == _ViewMode.staff
                              ? _buildStaffTable(l10n, days, visibleStaff)
                              : _buildSlotsTable(l10n, days),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}';

  Widget _buildStaffTable(
    AppLocalizations l10n,
    List<DateTime> days,
    List<User> visibleStaff,
  ) {
    return Table(
      defaultColumnWidth: const FixedColumnWidth(140),
      columnWidths: const {0: FixedColumnWidth(160)},
      children: [
        TableRow(
          children: [
            _headerCell(l10n.rotaUnassignedRowLabel),
            for (final day in days) _headerCell(_formatDate(day)),
          ],
        ),
        TableRow(
          children: [
            _staffCell(l10n.rotaUnassignedRowLabel, isUnassigned: true),
            for (final day in days) _dayCell(_shiftsFor(null, day), null),
          ],
        ),
        for (final person in visibleStaff)
          TableRow(
            children: [
              _staffCell(person.name),
              for (final day in days)
                _dayCell(_shiftsFor(person, day), person),
            ],
          ),
      ],
    );
  }

  Widget _buildSlotsTable(AppLocalizations l10n, List<DateTime> days) {
    // Rows = departments present among the (filtered) shifts this week,
    // plus a catch-all for shifts with no department. Each cell
    // aggregates that department's shifts on that day into one badge per
    // period present — "2/3" regular + a separate standby count — rather
    // than one block per shift, since the ask here is "how many people
    // are on this shift," not "who specifically" (that's the tap-through).
    final deptIds = _shifts.map((s) => s.departmentId).toSet();
    final rows = <Department?>[
      for (final dept in _departments)
        if (deptIds.contains(dept.id)) dept,
      if (deptIds.contains(null)) null,
    ];

    return Table(
      defaultColumnWidth: const FixedColumnWidth(160),
      columnWidths: const {0: FixedColumnWidth(160)},
      children: [
        TableRow(
          children: [
            _headerCell(l10n.rotaFilterDepartmentLabel),
            for (final day in days) _headerCell(_formatDate(day)),
          ],
        ),
        for (final dept in rows)
          TableRow(
            children: [
              _staffCell(dept?.name ?? l10n.anyDepartmentLabel),
              for (final day in days) _buildSlotCell(dept, day),
            ],
          ),
      ],
    );
  }

  Widget _buildSlotCell(Department? dept, DateTime day) {
    final dayShifts = _allShiftsFor(
      day,
    ).where((s) => s.departmentId == dept?.id).toList();
    if (dayShifts.isEmpty) return const SizedBox.shrink();

    // Group by period so a day with both a lunch and evening slot for the
    // same department shows two badges, not one misleading combined count.
    final byPeriod = <int?, List<Shift>>{};
    for (final shift in dayShifts) {
      final period = shiftPeriodFor(_periods, shift.startsAt);
      byPeriod.putIfAbsent(period?.id, () => []).add(shift);
    }

    return Padding(
      padding: const EdgeInsets.all(2),
      child: Column(
        children: [
          for (final entry in byPeriod.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Builder(
                builder: (context) {
                  final regular = entry.value
                      .where((s) => !s.isStandby)
                      .toList();
                  final standby = entry.value
                      .where((s) => s.isStandby)
                      .toList();
                  final filled = regular
                      .where((s) => s.claimedByUserId != null)
                      .length;
                  final standbyFilled = standby
                      .where((s) => s.claimedByUserId != null)
                      .length;
                  final full = regular.isNotEmpty && filled == regular.length;
                  final period = _periods
                      .where((p) => p.id == entry.key)
                      .firstOrNull;
                  return InkWell(
                    onTap: () => _showSlotDetail(regular, standby),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 6,
                      ),
                      decoration: BoxDecoration(
                        color: (full ? AppColors.pass : AppColors.caution)
                            .withValues(alpha: 0.18),
                        border: Border.all(
                          color: full ? AppColors.pass : AppColors.caution,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${period?.name ?? ''} $filled/${regular.length}'
                        '${standby.isNotEmpty ? ' (+$standbyFilled/${standby.length})' : ''}',
                        style: const TextStyle(fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _headerCell(String text) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          text,
          style: const TextStyle(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      );

  Widget _staffCell(String name, {bool isUnassigned = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        child: Text(
          name,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: isUnassigned ? AppColors.caution : null,
          ),
        ),
      );

  Widget _dayCell(List<Shift> shifts, User? person) => Padding(
        padding: const EdgeInsets.all(2),
        child: Column(
          children: [
            for (final shift in shifts)
              Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: InkWell(
                  onTap: () => _showShiftDetail(shift, person),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 4,
                      horizontal: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _blockColor(shift).withValues(alpha: 0.18),
                      border: Border.all(
                        color: _blockColor(shift),
                        width: shift.isStandby ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      shift.isStandby
                          ? '${AppLocalizations.of(context)!.rotaStandbyLabel}: '
                              '${_formatTime(shift.startsAt)}-${_formatTime(shift.endsAt)}'
                          : '${_formatTime(shift.startsAt)}-${_formatTime(shift.endsAt)}',
                      style: const TextStyle(fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
