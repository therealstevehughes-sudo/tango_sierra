import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/metric_chip.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import 'shift_fairness_service.dart';

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
  SiteShiftFairnessSummary? _summary;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
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
  }

  @override
  Widget build(BuildContext context) {
    final summary = _summary;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Fairness Review'),
        actions: const [AssistantIconButton()],
      ),
      drawer: const ManagementDrawer(title: 'Shift Fairness Review'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'The Roster add-on isn\'t switched on for this venue.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : summary == null || summary.staff.isEmpty
          ? const Center(child: Text('No active staff at this venue yet.'))
          : SafeArea(
              child: ResponsiveContent(
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Text(
                      'Last 90 days, by shift category. Alphabetical - not '
                      'a ranking.',
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
                                    label: '${person.total} shifts',
                                  ),
                                ],
                              ),
                              if (person.total == 0)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Text(
                                    'No shifts in this period.',
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
                                            label:
                                                '$category: '
                                                '${person.countsByCategory[category]}',
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
