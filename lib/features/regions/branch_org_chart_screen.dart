import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';

// Chain of command / branch organogram (2026-09-15) — requested alongside
// Issues & Incidents: "who does each employee report to" needed a real,
// visible answer (not just a mental model), and issue escalation needed
// somewhere to point at. Deliberately a SEPARATE screen from
// OrganisationTreeScreen (Phase C3), not an extra level added to it — that
// one is executive/regional-scoped (Head Office -> Region -> Venue
// managers); this one is branch-manager-scoped, going inside a single
// venue to show its own staff's reporting lines via User.reportsToUserId.
//
// Renders downward-expanding, same convention as OrganisationTreeScreen
// (confirmed with the user there over a rightward canvas chart — stays
// usable on a narrow/tablet screen). A person with no reportsToUserId set
// is a root of their own — most branches will show several roots until a
// manager goes through Staff Management and sets this for everyone, which
// is expected and shown honestly, not hidden.
// Resolves its own site the same way StaffManagementScreen does — an
// activeSite override if one's been picked, else the logged-in manager's
// own site — so this can be reached as a plain drawer WidgetBuilder
// without needing a siteId threaded through the drawer definition.
class BranchOrgChartScreen extends ConsumerStatefulWidget {
  const BranchOrgChartScreen({super.key});

  @override
  ConsumerState<BranchOrgChartScreen> createState() =>
      _BranchOrgChartScreenState();
}

class _BranchOrgChartScreenState extends ConsumerState<BranchOrgChartScreen> {
  bool _loading = true;
  List<User> _staff = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final activeSite = ref.read(activeSiteProvider);
    final currentUser = ref.read(currentUserProvider);
    final siteId =
        activeSite?.id ??
        currentUser?.siteId ??
        (await ref.read(currentSiteProvider.future)).id;
    final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
    if (!mounted) return;
    setState(() {
      _staff = staff.where((u) => u.active).toList();
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Roots: nobody-reports-to-anyone, OR reports to someone not on this
    // list (a stale/cross-site pointer, e.g. after a transfer) — treated
    // the same way as unassigned rather than silently dropped from the
    // tree.
    final staffIds = _staff.map((u) => u.id).toSet();
    final roots = _staff
        .where(
          (u) =>
              u.reportsToUserId == null ||
              !staffIds.contains(u.reportsToUserId),
        )
        .toList()
      ..sort(_byTierThenName);
    final childrenOf = <int, List<User>>{};
    for (final u in _staff) {
      if (u.reportsToUserId != null && staffIds.contains(u.reportsToUserId)) {
        childrenOf.putIfAbsent(u.reportsToUserId!, () => []).add(u);
      }
    }
    for (final list in childrenOf.values) {
      list.sort(_byTierThenName);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Branch Team Structure')),
      drawer: const ManagementDrawer(title: 'Branch Team Structure'),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _staff.isEmpty
          ? const Center(child: Text('No staff at this branch yet.'))
          : ResponsiveContent(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final root in roots)
                    _PersonNode(
                      user: root,
                      childrenOf: childrenOf,
                      depth: 0,
                    ),
                ],
              ),
            ),
    );
  }

  int _byTierThenName(User a, User b) {
    final tierCompare = roleTierRank(b.roleTier).compareTo(
      roleTierRank(a.roleTier),
    );
    return tierCompare != 0 ? tierCompare : a.name.compareTo(b.name);
  }
}

class _PersonNode extends StatelessWidget {
  const _PersonNode({
    required this.user,
    required this.childrenOf,
    required this.depth,
  });

  final User user;
  final Map<int, List<User>> childrenOf;
  final int depth;

  @override
  Widget build(BuildContext context) {
    final reports = childrenOf[user.id] ?? const <User>[];
    final card = Padding(
      padding: EdgeInsets.only(left: depth * 24.0, bottom: 8),
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '${user.jobTitle} · ${roleTierDisplayName(user.roleTier)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            if (reports.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.tealTint,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  '${reports.length} report${reports.length == 1 ? '' : 's'}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.tealInk,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );

    if (reports.isEmpty) return card;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        card,
        for (final report in reports)
          _PersonNode(user: report, childrenOf: childrenOf, depth: depth + 1),
      ],
    );
  }
}
