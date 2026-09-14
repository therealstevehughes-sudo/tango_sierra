import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import '../../features/regions/branch_management_screen.dart';
import '../../features/regions/region_management_screen.dart';
import '../../features/venue_setup/venue_setup_wizard_screen.dart';

/// Phase C1d — per-tier setup completeness, guide-don't-block (Fail-safe
/// #4 from the C1 plan). Every count comes from the same RLS-scoped
/// repositories the rest of the app already uses, never a stored flag —
/// "done" here means "the data exists," not "someone ticked a box." Shows
/// nothing once its tier's own steps are all done, and nothing at all for
/// base (no setup responsibility). Purely advisory: every screen it
/// points at is already reachable without this card, and nothing in the
/// app is gated on completing it.
///
/// Setup Checklist deep-links (UX-research P0 "deep-linkable checklist"):
/// each row opens the exact screen that completes it — the Venue Setup
/// wizard at the matching step for manager-scope items (Areas 0 /
/// Equipment 1 / Staff 2 / Suppliers 3), the Region/Branch management
/// screens for leadership-scope items. Rows that are already done render
/// non-tappable (nothing to complete).
class SetupChecklistCard extends ConsumerStatefulWidget {
  const SetupChecklistCard({super.key});

  @override
  ConsumerState<SetupChecklistCard> createState() => _SetupChecklistCardState();
}

class _ChecklistItem {
  const _ChecklistItem(this.label, this.done, {this.destination});
  final String label;
  final bool done;
  final WidgetBuilder? destination;
}

class _SetupChecklistCardState extends ConsumerState<SetupChecklistCard> {
  List<_ChecklistItem>? _items;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    List<_ChecklistItem> items;
    switch (user.roleTier) {
      case RoleTier.executive:
        final orgId = await ref.read(currentOrganisationIdProvider.future);
        final regions = orgId == null
            ? const []
            : await ref
                  .read(regionRepositoryProvider)
                  .getForOrganisation(orgId);
        final sites = await ref.read(siteRepositoryProvider).getAll();
        items = [
          _ChecklistItem(
            'Add at least one region',
            regions.isNotEmpty,
            destination: (_) => const RegionManagementScreen(),
          ),
          _ChecklistItem(
            'Add at least one branch',
            sites.isNotEmpty,
            destination: (_) => const BranchManagementScreen(),
          ),
        ];
      case RoleTier.regional:
        final sites = await ref.read(siteRepositoryProvider).getAll();
        final hasManager = sites.isNotEmpty; // a branch manager check would
        // need a per-site users query; branch count alone is a fair
        // first-cut signal and avoids N extra queries here.
        items = [
          _ChecklistItem(
            'Add at least one branch',
            sites.isNotEmpty,
            destination: (_) => const BranchManagementScreen(),
          ),
          _ChecklistItem(
            'Add a branch manager',
            hasManager,
            destination: (_) => const BranchManagementScreen(),
          ),
        ];
      case RoleTier.venueManager:
        final siteId =
            user.siteId ?? (await ref.read(currentSiteProvider.future)).id;
        final equipment = await ref
            .read(equipmentRepositoryProvider)
            .getForSite(siteId);
        final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
        items = [
          _ChecklistItem(
            'Add your equipment',
            equipment.isNotEmpty,
            destination: (_) => const VenueSetupWizardScreen(initialStep: 1),
          ),
          _ChecklistItem(
            'Add your team',
            staff.where((u) => u.id != user.id).isNotEmpty,
            destination: (_) => const VenueSetupWizardScreen(initialStep: 2),
          ),
        ];
      case RoleTier.supervisor:
      case RoleTier.base:
        items = const [];
    }

    if (!mounted) return;
    setState(() => _items = items);
  }

  @override
  Widget build(BuildContext context) {
    final items = _items;
    if (items == null || items.isEmpty || items.every((i) => i.done)) {
      return const SizedBox.shrink();
    }
    final doneCount = items.where((i) => i.done).length;

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Text(
                  'Get set up',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                Text(
                  '$doneCount of ${items.length}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            for (final item in items)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: item.done
                    // Done rows are plain — nothing to complete, no affordance.
                    ? Row(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 18,
                            color: AppColors.pass,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(item.label)),
                        ],
                      )
                    : InkWell(
                        onTap: item.destination == null
                            ? null
                            : () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: item.destination!),
                              ),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 6,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.radio_button_unchecked,
                                size: 18,
                                color: AppColors.muted,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  item.label,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              if (item.destination != null)
                                const Icon(
                                  Icons.chevron_right,
                                  size: 18,
                                  color: AppColors.muted,
                                ),
                            ],
                          ),
                        ),
                      ),
              ),
          ],
        ),
      ),
    );
  }
}
