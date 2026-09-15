import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/region.dart';
import '../../shared/models/site.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../onboarding/invite_code_screen.dart';

/// Phase C3 (2026-09-14, redesigned same day after live feedback) — the
/// "interactive org-builder/organogram." First pass showed structure
/// (regions/venues) but not people, which is exactly what made the OLD
/// separate Regions/Branches screens feel fragmented — a manager had to
/// leave the tree and open another screen to see who was actually in
/// each role. This version is a genuine organogram: Head Office (with
/// its people) at the top, each Region below it (with its regional
/// manager listed directly under the region's name), each Region's
/// Venues below THAT (with their venue manager listed directly under
/// the venue's name) — expanding downward (confirmed with the user over
/// a rightward canvas-style chart: this stays usable on a narrow/tablet
/// screen without horizontal scrolling, and matches every other
/// expandable list already in this app).
///
/// Reuses every existing piece, no duplicate logic: `regionRepository`/
/// `siteRepository`/`userRepository`'s `getForOrganisation()` calls,
/// `createInvite`/`InviteCodeScreen` (Sprint 034's token+QR flow), and
/// `resetSeniorPassword` (already built for RegionManagementScreen) for
/// resetting a regional manager's password directly from the tree.
class OrganisationTreeScreen extends ConsumerStatefulWidget {
  const OrganisationTreeScreen({super.key});

  @override
  ConsumerState<OrganisationTreeScreen> createState() =>
      _OrganisationTreeScreenState();
}

class _OrganisationTreeScreenState
    extends ConsumerState<OrganisationTreeScreen> {
  bool _loading = true;
  String? _error;
  String _orgName = '';
  int? _orgId;
  List<Region> _regions = [];
  List<Site> _sites = [];
  List<User> _leadershipAccounts = [];
  // venueManager name(s) per site — a separate load since venueManagers
  // are PIN-tier (getForOrganisation only returns senior/GoTrue tiers).
  final Map<int, List<User>> _venueManagersBySite = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final orgId = await ref.read(currentOrganisationIdProvider.future);
    if (orgId == null) {
      setState(() {
        _loading = false;
        _error = 'No organisation on this session.';
      });
      return;
    }
    final org = await ref.read(organisationRepositoryProvider).getDefault();
    final regions = await ref
        .read(regionRepositoryProvider)
        .getForOrganisation(orgId);
    final sites = await ref
        .read(siteRepositoryProvider)
        .getForOrganisation(orgId);
    final leadershipAccounts = await ref
        .read(userRepositoryProvider)
        .getForOrganisation(orgId);

    final userRepo = ref.read(userRepositoryProvider);
    final venueManagersBySite = <int, List<User>>{};
    for (final site in sites) {
      final staff = await userRepo.getForSite(site.id);
      venueManagersBySite[site.id] = staff
          .where((u) => u.active && u.roleTier == RoleTier.venueManager)
          .toList();
    }

    if (!mounted) return;
    setState(() {
      _orgId = orgId;
      _orgName = org.name;
      _regions = regions;
      _sites = sites;
      _leadershipAccounts = leadershipAccounts;
      _venueManagersBySite
        ..clear()
        ..addAll(venueManagersBySite);
      _loading = false;
    });
  }

  Future<void> _addRegion() async {
    final orgId = _orgId;
    if (orgId == null) return;
    final name = await _promptText(context, title: 'New region name');
    if (name == null || name.trim().isEmpty) return;
    await ref
        .read(regionRepositoryProvider)
        .create(name: name.trim(), organisationId: orgId);
    await _load();
  }

  Future<void> _renameRegion(Region region) async {
    final name = await _promptText(
      context,
      title: 'Rename region',
      initial: region.name,
    );
    if (name == null || name.trim().isEmpty || name.trim() == region.name) {
      return;
    }
    await ref.read(regionRepositoryProvider).rename(region.id, name.trim());
    await _load();
  }

  Future<void> _renameSite(Site site) async {
    final name = await _promptText(
      context,
      title: 'Rename venue',
      initial: site.name,
    );
    if (name == null || name.trim().isEmpty || name.trim() == site.name) {
      return;
    }
    await ref.read(siteRepositoryProvider).rename(site.id, name.trim());
    await _load();
  }

  // Closes the gap noted in the class doc: an executive-created venue
  // with regionId left null attaches directly to the Organisation, just
  // like a regional manager's own venue-create, only without a region.
  Future<void> _addVenue({int? regionId}) async {
    final orgId = _orgId;
    if (orgId == null) return;
    final name = await _promptText(context, title: 'New venue name');
    if (name == null || name.trim().isEmpty) return;
    await ref
        .read(siteRepositoryProvider)
        .create(name: name.trim(), organisationId: orgId, regionId: regionId);
    await _load();
  }

  Future<void> _inviteRegionalManager(Region region) async {
    try {
      final invite = await ref
          .read(tenantProvisioningRepositoryProvider)
          .createInvite(roleTier: 'regional', regionId: region.id);
      if (!mounted) return;
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => InviteCodeScreen(invite: invite)),
      );
    } on OrganisationInviteException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  Future<void> _resetPassword(User account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset password?'),
        content: Text(
          "This immediately invalidates ${account.name}'s current "
          "password. You'll get a new temporary password to pass along.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    try {
      final result = await ref
          .read(tenantProvisioningRepositoryProvider)
          .resetSeniorPassword(targetLocalUserId: account.id);
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Password reset'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Give this person their new temporary password.'),
              const SizedBox(height: 16),
              SelectableText('Email: ${result.email}'),
              SelectableText(
                'Temporary password: ${result.temporaryPassword}',
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } on SeniorPasswordResetException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Organisation')),
      drawer: const ManagementDrawer(title: 'Organisation'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 720,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(child: Text(_error!))
                : _buildTree(),
          ),
        ),
      ),
    );
  }

  Widget _buildTree() {
    final unregionedSites = _sites.where((s) => s.regionId == null).toList();
    final headOfficePeople = _leadershipAccounts
        .where((u) => u.roleTier == RoleTier.executive)
        .toList();

    return ListView(
      children: [
        // Level 1: Head Office — the Organisation itself, its people
        // listed directly underneath.
        AppCard(
          elevated: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.apartment, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _orgName,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        Text(
                          'Head Office',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: AppColors.muted),
                        ),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'region') _addRegion();
                      if (value == 'venue') _addVenue();
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: 'region',
                        child: Text('Add Region'),
                      ),
                      PopupMenuItem(
                        value: 'venue',
                        child: Text('Add Venue (no region)'),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              for (final person in headOfficePeople)
                _buildPersonRow(
                  person,
                  subtitle: 'Director',
                  onResetPassword: () => _resetPassword(person),
                ),
            ],
          ),
        ),
        // Level 2: Regions, each below Head Office, connected by a
        // simple indent + left rule rather than drawn lines — reads as
        // "belongs to the level above" without canvas/line-painting.
        for (final region in _regions) _buildRegionNode(region),
        // Venues attached directly to the Organisation (no region) —
        // the gap this screen closes: previously uncreatable via any UI.
        if (unregionedSites.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 12, bottom: 4),
            child: Text(
              'Venues (no region)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          for (final site in unregionedSites) _buildSiteNode(site, indent: 1),
        ],
      ],
    );
  }

  Widget _buildPersonRow(
    User person, {
    required String subtitle,
    VoidCallback? onResetPassword,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 40, top: 2, bottom: 2),
      child: Row(
        children: [
          const Icon(Icons.person_outline, size: 18, color: AppColors.muted),
          const SizedBox(width: 8),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: person.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  TextSpan(
                    text: '  ·  $subtitle',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
          if (onResetPassword != null)
            IconButton(
              icon: const Icon(Icons.lock_reset, size: 18),
              tooltip: 'Reset password',
              onPressed: onResetPassword,
            ),
        ],
      ),
    );
  }

  Widget _buildRegionNode(Region region) {
    final sitesInRegion = _sites
        .where((s) => s.regionId == region.id)
        .toList();
    final manager = _leadershipAccounts
        .where(
          (u) => u.roleTier == RoleTier.regional && u.regionId == region.id,
        )
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 12),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.lineStrong, width: 2),
          ),
        ),
        padding: const EdgeInsets.only(left: 16),
        child: AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.map_outlined, size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      region.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'venue') _addVenue(regionId: region.id);
                      if (value == 'rename') _renameRegion(region);
                      if (value == 'invite') _inviteRegionalManager(region);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(
                        value: 'venue',
                        child: Text('Add Venue'),
                      ),
                      const PopupMenuItem(
                        value: 'rename',
                        child: Text('Rename Region'),
                      ),
                      PopupMenuItem(
                        value: 'invite',
                        child: Text(
                          manager == null
                              ? 'Invite Regional Manager'
                              : 'Invite Replacement Manager',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (manager != null)
                _buildPersonRow(
                  manager,
                  subtitle: 'Regional Manager',
                  onResetPassword: () => _resetPassword(manager),
                )
              else
                const Padding(
                  padding: EdgeInsets.only(left: 40, top: 2, bottom: 2),
                  child: Text(
                    'No regional manager yet',
                    style: TextStyle(color: AppColors.muted),
                  ),
                ),
              const SizedBox(height: 8),
              if (sitesInRegion.isEmpty)
                const Padding(
                  padding: EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'No venues in this region yet.',
                    style: TextStyle(color: AppColors.muted),
                  ),
                )
              else
                for (final site in sitesInRegion)
                  _buildSiteNode(site, indent: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSiteNode(Site site, {required int indent}) {
    final managers = _venueManagersBySite[site.id] ?? const <User>[];
    return Padding(
      padding: EdgeInsets.only(left: indent * 16.0, top: 8),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            left: BorderSide(color: AppColors.line, width: 2),
          ),
        ),
        padding: const EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storefront_outlined, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    site.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined, size: 16),
                  tooltip: 'Rename venue',
                  onPressed: () => _renameSite(site),
                ),
              ],
            ),
            if (managers.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 26, bottom: 4),
                child: Text(
                  'No venue manager yet',
                  style: TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              )
            else
              for (final manager in managers)
                Padding(
                  padding: const EdgeInsets.only(left: 26, bottom: 4),
                  child: Text(
                    '${manager.name}  ·  Venue Manager',
                    style: const TextStyle(color: AppColors.muted),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

Future<String?> _promptText(
  BuildContext context, {
  required String title,
  String? initial,
}) {
  final controller = TextEditingController(text: initial);
  return showDialog<String>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(title),
      content: TextField(controller: controller, autofocus: true),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Save'),
        ),
      ],
    ),
  );
}
