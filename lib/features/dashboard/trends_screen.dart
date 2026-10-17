import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../manager/manager_screen.dart';
import 'dashboard_screen.dart';
import 'leadership_dashboard_screen.dart';
import 'top_screen.dart';

/// Trends (2026-10-17, menu stage 2): the three overview screens in one
/// place, as tabs — today across the team, tasks and incidents over time,
/// and reliability & team — instead of three separate menu destinations.
class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final tier = ref.watch(currentUserProvider)?.roleTier ?? RoleTier.venueManager;
    final senior = tier == RoleTier.regional || tier == RoleTier.executive;
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppScreenHeader(
          title: Text(l10n.menuTrends),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.menuTodayAcrossTeam),
              Tab(text: l10n.menuTasksIncidentsOverTime),
              Tab(text: l10n.menuReliabilityTeam),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            senior
                ? const TopScreen(embedded: true)
                : const ManagerScreen(embedded: true),
            const LeadershipDashboardScreen(embedded: true),
            const DashboardScreen(embedded: true),
          ],
        ),
      ),
    );
  }
}
