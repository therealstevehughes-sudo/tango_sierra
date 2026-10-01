import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/department.dart';
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
  const RotaWeekScreen({super.key});

  @override
  ConsumerState<RotaWeekScreen> createState() => _RotaWeekScreenState();
}

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
      if (_periodFilter != null) {
        final period = shiftPeriodFor(_periods, s.startsAt);
        if (period?.id != _periodFilter!.id) return false;
      }
      return true;
    }).toList();
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Table(
                            defaultColumnWidth: const FixedColumnWidth(140),
                            columnWidths: const {0: FixedColumnWidth(160)},
                            children: [
                              TableRow(
                                children: [
                                  _headerCell(l10n.rotaUnassignedRowLabel),
                                  for (final day in days)
                                    _headerCell(_formatDate(day)),
                                ],
                              ),
                              TableRow(
                                children: [
                                  _staffCell(l10n.rotaUnassignedRowLabel, isUnassigned: true),
                                  for (final day in days)
                                    _dayCell(_shiftsFor(null, day), null),
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
                          ),
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
                      border: Border.all(color: _blockColor(shift)),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '${_formatTime(shift.startsAt)}-${_formatTime(shift.endsAt)}',
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
