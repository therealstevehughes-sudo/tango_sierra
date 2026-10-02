import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/certification_requirement.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/shift_period.dart';
import '../../shared/models/training_item.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/shift_period_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import '../../shared/providers/site_role_certification_requirement_providers.dart';
import '../../shared/providers/training_record_providers.dart';
import 'widgets/rota_month_grid.dart';

// Rota calendar (2026-10-02 month-view rebuild) — the staff-facing
// counterpart to RotaMonthScreen's leadership view: a real month grid
// (one cell per day, dots per shift period) instead of the original
// Sprint 6 vertical week list. Per the founder's own spec: "1 calendar,
// 2 functions" — the day-off toggle still lives here, reusing the same
// grid rather than a separate screen. Tapping a day opens a detail sheet
// with who else is on each shift, who's unavailable, who's standby and
// who's free — the original week-list version could only show the
// viewer's own status inline, with no way to see teammates without
// leaving the screen.
class RotaClaimScreen extends ConsumerStatefulWidget {
  const RotaClaimScreen({super.key});

  @override
  ConsumerState<RotaClaimScreen> createState() => _RotaClaimScreenState();
}

class _RotaClaimScreenState extends ConsumerState<RotaClaimScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  String? _error;
  int? _siteId;
  late DateTime _monthStart;
  List<Shift> _shifts = [];
  List<ShiftPeriod> _periods = [];
  List<OffDayRequest> _myOffDayRequests = [];
  List<User> _staff = [];
  bool _bookingDaysOff = false;
  final Set<DateTime> _selectedOffDays = {};
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
      final offDayRequests = await ref
          .read(offDayRequestRepositoryProvider)
          .getForSite(siteId);
      final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
      if (!mounted) return;
      setState(() {
        _siteId = siteId;
        _shifts = shifts;
        _periods = periods;
        _myOffDayRequests = currentUser == null
            ? []
            : offDayRequests.where((r) => r.userId == currentUser.id).toList();
        _staff = staff.where((u) => u.active).toList();
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

  List<Shift> _shiftsOn(DateTime day) {
    return _shifts
        .where(
          (s) =>
              s.startsAt.year == day.year &&
              s.startsAt.month == day.month &&
              s.startsAt.day == day.day,
        )
        .toList();
  }

  List<Shift> _slotShifts(DateTime day, ShiftPeriod period) {
    return _shiftsOn(
      day,
    ).where((s) => shiftPeriodFor(_periods, s.startsAt)?.id == period.id).toList();
  }

  OffDayRequest? _offDayFor(int userId, DateTime day) {
    return _myOffDayRequestsForUser(
      userId,
    ).where((r) => _isSameDay(r.requestedDate, day)).firstOrNull;
  }

  List<OffDayRequest> _myOffDayRequestsForUser(int userId) =>
      _myOffDayRequests.where((r) => r.userId == userId).toList();

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  String _staffName(int? userId) =>
      userId == null ? '' : _staff.where((u) => u.id == userId).firstOrNull?.name ?? '?';

  Future<void> _claim(Shift shift) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final l10n = AppLocalizations.of(context)!;

    final records = await ref
        .read(trainingRecordRepositoryProvider)
        .getForUser(user.id);
    final siteAdditions = await ref.read(
      siteRoleCertificationRequirementsForSiteProvider(shift.siteId).future,
    );
    final missing = missingCertificationsForRole(
      role: user.jobRole,
      records: records,
      siteAdditions: siteAdditions,
    );
    if (!mounted) return;
    if (missing.isNotEmpty) {
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.cannotClaimShiftTitle),
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
    final result = await ref
        .read(shiftRepositoryProvider)
        .claimShift(shiftId: shift.id, userId: user.id);
    if (!mounted) return;
    setState(() => _busy = false);
    Navigator.of(context).popUntil((route) => route.isFirst || !route.isCurrent);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result == null ? l10n.someoneElseClaimedShift : l10n.shiftClaimedMessage,
        ),
      ),
    );
    await _load();
  }

  bool _alreadyRequestedOff(DateTime day) {
    return _myOffDayRequests.any(
      (r) => _isSameDay(r.requestedDate, day) && r.status != OffDayRequestStatus.denied,
    );
  }

  Future<void> _submitDaysOff() async {
    final user = ref.read(currentUserProvider);
    final siteId = _siteId;
    if (user == null || siteId == null || _selectedOffDays.isEmpty) return;
    setState(() => _busy = true);
    for (final day in _selectedOffDays) {
      await ref.read(offDayRequestRepositoryProvider).request(
        siteId: siteId,
        userId: user.id,
        requestedDate: day,
      );
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context)!;
    setState(() {
      _busy = false;
      _selectedOffDays.clear();
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(l10n.daysOffRequestedMessage)));
    await _load();
  }

  void _onDayTap(DateTime day) {
    if (_bookingDaysOff) {
      final alreadyRequested = _alreadyRequestedOff(day);
      if (alreadyRequested) return;
      setState(() {
        final existing = _selectedOffDays.firstWhereOrNull(
          (d) => _isSameDay(d, day),
        );
        if (existing != null) {
          _selectedOffDays.remove(existing);
        } else {
          _selectedOffDays.add(day);
        }
      });
      return;
    }
    _showDayDetail(day);
  }

  Future<void> _showDayDetail(DateTime day) async {
    final l10n = AppLocalizations.of(context)!;
    final userId = ref.read(currentUserProvider)?.id;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.75,
              maxChildSize: 0.95,
              expand: false,
              builder: (context, scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _formatFullDate(day),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),
                      if (_periods.isEmpty)
                        Text(l10n.noShiftsThisPeriodText)
                      else
                        for (final period in _periods)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildPeriodDetail(
                              l10n,
                              day,
                              period,
                              userId,
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
    ShiftPeriod period,
    int? userId,
    Future<void> Function() onChanged,
  ) {
    final slotShifts = _slotShifts(day, period);
    final regular = slotShifts.where((s) => !s.isStandby).toList();
    final standby = slotShifts.where((s) => s.isStandby).toList();
    final workingIds = regular
        .where((s) => s.claimedByUserId != null)
        .map((s) => s.claimedByUserId!)
        .toSet();
    final standbyIds = standby
        .where((s) => s.claimedByUserId != null)
        .map((s) => s.claimedByUserId!)
        .toSet();
    final unavailableIds = _staff
        .where((u) => _offDayFor(u.id, day)?.status == OffDayRequestStatus.approved)
        .map((u) => u.id)
        .toSet();
    final availableIds = _staff
        .map((u) => u.id)
        .where(
          (id) =>
              !workingIds.contains(id) &&
              !standbyIds.contains(id) &&
              !unavailableIds.contains(id),
        )
        .toSet();

    final mine = slotShifts.where((s) => s.claimedByUserId == userId).firstOrNull;
    final openRegular = regular
        .where((s) => s.claimedByUserId == null)
        .firstOrNull;
    final openStandby = standby
        .where((s) => s.claimedByUserId == null)
        .firstOrNull;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    period.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                if (mine != null)
                  Text(
                    mine.isStandby
                        ? l10n.youAreStandbyText
                        : mine.status == ShiftStatus.assigned
                        ? l10n.youAreAssignedText
                        : l10n.rotaBookedPendingApprovalText,
                    style: TextStyle(
                      color: mine.isStandby
                          ? AppColors.standby
                          : mine.status == ShiftStatus.assigned
                          ? AppColors.pass
                          : AppColors.info,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                else if (openRegular != null)
                  ElevatedButton(
                    onPressed: _busy
                        ? null
                        : () async {
                            await _claim(openRegular);
                            await onChanged();
                          },
                    child: Text(l10n.claimLabel),
                  )
                else if (openStandby != null)
                  OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () async {
                            await _claim(openStandby);
                            await onChanged();
                          },
                    child: Text(l10n.joinStandbyButton),
                  )
                else
                  Text(
                    l10n.shiftFullText,
                    style: const TextStyle(color: AppColors.mutedLight),
                  ),
              ],
            ),
            if (slotShifts.isEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  l10n.noShiftsThisPeriodText,
                  style: const TextStyle(color: AppColors.mutedLight),
                ),
              )
            else ...[
              const SizedBox(height: 8),
              _namesRow(l10n.rotaAssignedLabel, workingIds),
              if (standby.isNotEmpty) _namesRow(l10n.rotaStandbyLabel, standbyIds),
              _namesRow(l10n.rotaUnavailableLabel, unavailableIds),
              _namesRow(l10n.rotaAvailableLabel, availableIds),
            ],
          ],
        ),
      ),
    );
  }

  Widget _namesRow(String label, Set<int> userIds) {
    final names = userIds.map(_staffName).toList()..sort();
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style.copyWith(fontSize: 13),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(text: names.isEmpty ? '—' : names.join(', ')),
          ],
        ),
      ),
    );
  }

  String _formatFullDate(DateTime d) => '${d.day}/${d.month}/${d.year}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.rotaClaimCalendarTitle),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(l10n.bookDaysOffToggleLabel),
                        value: _bookingDaysOff,
                        onChanged: (value) => setState(() {
                          _bookingDaysOff = value;
                          _selectedOffDays.clear();
                        }),
                      ),
                    ),
                    Expanded(
                      child: RotaMonthGrid(
                        monthStart: _monthStart,
                        onChangeMonth: _changeMonth,
                        onDayTap: _onDayTap,
                        isSelected: (day) =>
                            _selectedOffDays.any((d) => _isSameDay(d, day)),
                        dayCellBuilder: (context, day) =>
                            _dayCell(day, currentUser?.id),
                      ),
                    ),
                    if (_bookingDaysOff)
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: ElevatedButton(
                          onPressed: _busy || _selectedOffDays.isEmpty
                              ? null
                              : _submitDaysOff,
                          child: Text(l10n.submitDaysOffButton),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _dayCell(DateTime day, int? userId) {
    if (userId == null) return const SizedBox.shrink();

    final offDay = _offDayFor(userId, day);
    if (offDay != null && offDay.status == OffDayRequestStatus.approved) {
      return const DecoratedBox(
        decoration: BoxDecoration(color: AppColors.lineStrong),
      );
    }

    final dots = <Widget>[];
    for (final period in _periods) {
      final mine = _slotShifts(
        day,
        period,
      ).where((s) => s.claimedByUserId == userId).firstOrNull;
      if (mine == null) continue;
      final color = mine.isStandby
          ? AppColors.standby
          : mine.status == ShiftStatus.assigned
          ? AppColors.pass
          : AppColors.info;
      dots.add(RotaStatusDot(color: color));
    }
    if (offDay != null && offDay.status == OffDayRequestStatus.pending) {
      dots.add(const RotaStatusDot(color: AppColors.caution));
    }

    if (dots.isEmpty) return const SizedBox.shrink();
    return Wrap(alignment: WrapAlignment.center, children: dots);
  }
}

extension _FirstWhereOrNullExt<T> on Iterable<T> {
  T? firstWhereOrNull(bool Function(T) test) {
    for (final e in this) {
      if (test(e)) return e;
    }
    return null;
  }
}
