import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/metric_chip.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import 'shift_fairness_service.dart';
import '../../core/widgets/app_screen_header.dart';

// Shift fairness pattern review (R6, 2026-09-27) — see
// shift_fairness_service.dart's doc comment for the non-negotiable
// governance rule this screen enforces: alphabetical only, never a ranked
// leaderboard, no numeric score. This exists so a manager can spot a
// distribution problem ("these three never get an opening shift"), not to
// compare individuals.
class ShiftFairnessScreen extends ConsumerStatefulWidget {
  const ShiftFairnessScreen({super.key});

  @override
  ConsumerState<ShiftFairnessScreen> createState() =>
      _ShiftFairnessScreenState();
}

class _ShiftFairnessScreenState extends ConsumerState<ShiftFairnessScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  String? _error;
  SiteShiftFairnessSummary? _summary;

  @override
  void initState() {
    super.initState();
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

      final summary = await ref
          .read(shiftFairnessServiceProvider)
          .computeForSite(siteId);
      if (!mounted) return;
      setState(() {
        _addonEnabled = true;
        _summary = summary;
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final summary = _summary;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.shiftFairnessReview),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.shiftFairnessReview),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? LoadErrorView(error: _error!, onRetry: _load)
          : !_addonEnabled
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.rosterAddonNotEnabledPlain,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : summary == null || summary.staff.isEmpty
          ? Center(child: Text(l10n.noActiveStaffVenue))
          : SafeArea(
              child: ResponsiveContent(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      l10n.last90DaysAlphabetical,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final person in summary.staff)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: AppCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      person.userName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                  MetricChip(
                                    icon: Icons.event_available_outlined,
                                    label: l10n.shiftsCountLabel(person.total),
                                  ),
                                ],
                              ),
                              if (person.total == 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    l10n.noShiftsInPeriod,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(color: AppColors.muted),
                                  ),
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: [
                                      for (final category
                                          in summary.categories)
                                        if ((person.countsByCategory[category] ??
                                                0) >
                                            0)
                                          MetricChip(
                                            icon: Icons.label_outline,
                                            label: l10n.categoryCountLabel(
                                              category,
                                              person.countsByCategory[category]!,
                                            ),
                                          ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
