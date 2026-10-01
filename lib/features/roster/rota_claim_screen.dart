import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/certification_requirement.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/shift_period.dart';
import '../../shared/models/training_item.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/shift_period_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import '../../shared/providers/site_role_certification_requirement_providers.dart';
import '../../shared/providers/training_record_providers.dart';

// Rota calendar, Sprint 6 (2026-10-01) — the staff-facing counterpart to
// RotaWeekScreen: each day shown as its configured period slots
// (Morning/Afternoon/Night etc. from Sprint 1), tap to claim a regular
// slot or join standby. A top toggle switches the same week view into
// day-off-marking mode (reuses the existing off_day_requests flow, just
// presented in one place instead of a separate screen) - the founder's
// own framing: "if they tick the book days off option, then they can
// mark the days off that they want."
class RotaClaimScreen extends ConsumerStatefulWidget {
  const RotaClaimScreen({super.key});

  @override
  ConsumerState<RotaClaimScreen> createState() => _RotaClaimScreenState();
}

class _RotaClaimScreenState extends ConsumerState<RotaClaimScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  int? _siteId;
  late DateTime _weekStart;
  List<Shift> _shifts = [];
  List<ShiftPeriod> _periods = [];
  List<OffDayRequest> _myOffDayRequests = [];
  bool _bookingDaysOff = false;
  final Set<DateTime> _selectedOffDays = {};
  bool _busy = false;

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
    final periods = await ref
        .read(shiftPeriodRepositoryProvider)
        .getForSite(siteId);
    final offDayRequests = currentUser == null
        ? <OffDayRequest>[]
        : await ref
            .read(offDayRequestRepositoryProvider)
            .getForUser(currentUser.id);
    if (!mounted) return;
    setState(() {
      _siteId = siteId;
      _shifts = shifts;
      _periods = periods;
      _myOffDayRequests = offDayRequests;
      _addonEnabled = true;
      _loading = false;
    });
  }

  void _changeWeek(int deltaWeeks) {
    setState(() => _weekStart = _weekStart.add(Duration(days: 7 * deltaWeeks)));
  }

  String _formatDate(DateTime d) => '${d.day}/${d.month}';

  List<Shift> _slotShifts(DateTime day, ShiftPeriod period) {
    return _shifts.where((s) {
      if (s.startsAt.year != day.year ||
          s.startsAt.month != day.month ||
          s.startsAt.day != day.day) {
        return false;
      }
      return shiftPeriodFor(_periods, s.startsAt)?.id == period.id;
    }).toList();
  }

  Future<void> _claim(Shift shift) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final l10n = AppLocalizations.of(context)!;

    // Same certification-expiry check as ClaimBoardScreen's own _claim.
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
      (r) =>
          r.requestedDate.year == day.year &&
          r.requestedDate.month == day.month &&
          r.requestedDate.day == day.day &&
          r.status != OffDayRequestStatus.denied,
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final days = List.generate(7, (i) => _weekStart.add(Duration(days: i)));
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.rotaClaimCalendarTitle),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? Center(child: Text(l10n.rosterAddonNotEnabledText))
          : SafeArea(
              child: ResponsiveContent(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _changeWeek(-1),
                          ),
                          Expanded(
                            child: Text(
                              '${_formatDate(days.first)} - ${_formatDate(days.last)}',
                              style: Theme.of(context).textTheme.titleMedium,
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
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (final day in days)
                            _bookingDaysOff
                                ? _buildOffDayTile(l10n, day)
                                : _buildDayCard(l10n, day, currentUser?.id),
                        ],
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

  Widget _buildOffDayTile(AppLocalizations l10n, DateTime day) {
    final alreadyRequested = _alreadyRequestedOff(day);
    final selected = _selectedOffDays.any(
      (d) => d.year == day.year && d.month == day.month && d.day == day.day,
    );
    return Card(
      child: CheckboxListTile(
        title: Text(_formatDate(day)),
        subtitle: alreadyRequested ? Text(l10n.alreadyRequestedOffText) : null,
        value: alreadyRequested || selected,
        onChanged: alreadyRequested
            ? null
            : (value) => setState(() {
                if (value ?? false) {
                  _selectedOffDays.add(day);
                } else {
                  _selectedOffDays.removeWhere(
                    (d) => d.year == day.year && d.month == day.month && d.day == day.day,
                  );
                }
              }),
      ),
    );
  }

  Widget _buildDayCard(AppLocalizations l10n, DateTime day, int? userId) {
    if (_periods.isEmpty) {
      return AppCard(
        child: ListTile(title: Text(_formatDate(day))),
      );
    }
    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDate(day),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            for (final period in _periods)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _buildPeriodRow(l10n, day, period, userId),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodRow(
    AppLocalizations l10n,
    DateTime day,
    ShiftPeriod period,
    int? userId,
  ) {
    final slotShifts = _slotShifts(day, period);
    if (slotShifts.isEmpty) {
      return Row(
        children: [
          Expanded(child: Text(period.name)),
          Text(l10n.noShiftsThisPeriodText, style: const TextStyle(color: Colors.grey)),
        ],
      );
    }
    final mine = slotShifts.where((s) => s.claimedByUserId == userId);
    if (mine.isNotEmpty) {
      final shift = mine.first;
      return Row(
        children: [
          Expanded(child: Text(period.name)),
          Text(
            shift.isStandby ? l10n.youAreStandbyText : l10n.youAreAssignedText,
            style: const TextStyle(color: AppColors.pass, fontWeight: FontWeight.w600),
          ),
        ],
      );
    }
    final openRegular = slotShifts
        .where((s) => !s.isStandby && s.claimedByUserId == null)
        .firstOrNull;
    final openStandby = slotShifts
        .where((s) => s.isStandby && s.claimedByUserId == null)
        .firstOrNull;
    if (openRegular != null) {
      return Row(
        children: [
          Expanded(child: Text(period.name)),
          ElevatedButton(
            onPressed: _busy ? null : () => _claim(openRegular),
            child: Text(l10n.claimLabel),
          ),
        ],
      );
    }
    if (openStandby != null) {
      return Row(
        children: [
          Expanded(child: Text(period.name)),
          OutlinedButton(
            onPressed: _busy ? null : () => _claim(openStandby),
            child: Text(l10n.joinStandbyButton),
          ),
        ],
      );
    }
    return Row(
      children: [
        Expanded(child: Text(period.name)),
        Text(l10n.shiftFullText, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
