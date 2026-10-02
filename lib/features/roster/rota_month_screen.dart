import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/shift.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import 'rota_week_screen.dart';

// Rota calendar, Sprint 7 (2026-10-01) — the zoomed-out month view: each
// day shows a compact shift-count/unfilled-count summary, tap to drill
// into that day's week in RotaWeekScreen. No separate filtering here
// (period/department/role/person) - this view is for "how busy does this
// month look," the week/slot views are where a manager actually drills
// into who's on what.
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
      if (!mounted) return;
      setState(() {
        _shifts = shifts;
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

  void _openWeekFor(DateTime day) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => RotaWeekScreen(initialDate: day)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final firstOfMonth = _monthStart;
    final daysInMonth = DateTime(
      firstOfMonth.year,
      firstOfMonth.month + 1,
      0,
    ).day;
    // Leading blanks so the 1st lands under its correct weekday column
    // (Monday-first grid, matching every other week/weekday view in this
    // feature).
    final leadingBlanks = firstOfMonth.weekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final trailingBlanks = (7 - (totalCells % 7)) % 7;

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
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () => _changeMonth(-1),
                          ),
                          Expanded(
                            child: Text(
                              '${_monthStart.month}/${_monthStart.year}',
                              style: Theme.of(context).textTheme.titleMedium,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => _changeMonth(1),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: GridView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: leadingBlanks + daysInMonth + trailingBlanks,
                        itemBuilder: (context, index) {
                          if (index < leadingBlanks ||
                              index >= leadingBlanks + daysInMonth) {
                            return const SizedBox.shrink();
                          }
                          final dayNum = index - leadingBlanks + 1;
                          final day = DateTime(
                            firstOfMonth.year,
                            firstOfMonth.month,
                            dayNum,
                          );
                          final shifts = _shiftsOn(day);
                          final unfilled = shifts
                              .where((s) => s.claimedByUserId == null)
                              .length;
                          return InkWell(
                            onTap: () => _openWeekFor(day),
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                border: Border.all(color: AppColors.line),
                                borderRadius: BorderRadius.circular(6),
                                color: unfilled > 0
                                    ? AppColors.cautionBg
                                    : null,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '$dayNum',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  if (shifts.isNotEmpty) ...[
                                    const Spacer(),
                                    Text(
                                      l10n.rotaMonthShiftCountText(shifts.length),
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                    if (unfilled > 0)
                                      Text(
                                        l10n.rotaUnfilledCountText(unfilled),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: AppColors.caution,
                                        ),
                                      ),
                                  ],
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
