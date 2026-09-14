import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

/// Phase C3 (2026-09-14) — the "interactive org-builder/organogram" named
/// in the original Phase C vision but never spec'd out. Confirmed with
/// the user before building: a visual, expandable hierarchy tree (not a
/// free-form drag-and-drop canvas) — Company → Regions → Venues, each
/// level expandable, with add/invite actions right on the tree rather
/// than needing separate flat screens.
///
/// Reuses every existing piece rather than duplicating: `regionRepository`
/// /`siteRepository`/`userRepository`'s `getForOrganisation()` calls
/// (already built), and `createInvite` + `InviteCodeScreen` (Sprint 034's
/// token/QR flow) for inviting a regional manager. `RegionManagementScreen`
/// and `BranchManagementScreen` are untouched — this is a new overview,
/// not a replacement.
///
/// Genuine gap closed here, found while building this: there was
/// previously NO way for an executive to add a venue directly under the
/// Organisation (no region) — `BranchManagementScreen` only lets a
/// REGIONAL manager add a venue within their own region.
/// `SiteRepository.create()` already supports a null `regionId` for
/// exactly this case; nothing in the UI ever called it that way before.
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
    if (!mounted) return;
    setState(() {
      _orgId = orgId;
      _orgName = org.name;
      _regions = regions;
      _sites = sites;
      _leadershipAccounts = leadershipAccounts;
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

  // Closes the gap noted in the class doc: an executive-created venue
  // with regionId left null attaches directly to the Organisation,
  // exactly like BranchManagementScreen's regional-scoped create, just
  // without a region.
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

    return ListView(
      children: [
        // Root: the Organisation itself.
        AppCard(
          elevated: true,
          child: Row(
            children: [
              const Icon(Icons.apartment, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _orgName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'region') _addRegion();
                  if (value == 'venue') _addVenue();
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'region', child: Text('Add Region')),
                  PopupMenuItem(
                    value: 'venue',
                    child: Text('Add Venue (no region)'),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Each Region, expandable to its own venues.
        for (final region in _regions) _buildRegionNode(region),
        // Venues attached directly to the Organisation (no region) —
        // the gap this screen closes: previously uncreatable via any UI.
        if (unregionedSites.isNotEmpty) ...[
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
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

  Widget _buildRegionNode(Region region) {
    final sitesInRegion = _sites.where((s) => s.regionId == region.id).toList();
    final manager = _leadershipAccounts
        .where((u) => u.roleTier == RoleTier.regional && u.regionId == region.id)
        .firstOrNull;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: AppCard(
        padding: EdgeInsets.zero,
        child: ExpansionTile(
          leading: const Icon(Icons.map_outlined),
          title: Text(region.name),
          subtitle: Text(
            manager != null
                ? 'Regional Manager: ${manager.name}'
                : 'No regional manager yet',
          ),
          trailing: PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'venue') _addVenue(regionId: region.id);
              if (value == 'invite') _inviteRegionalManager(region);
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'venue', child: Text('Add Venue')),
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
          children: [
            if (sitesInRegion.isEmpty)
              const Padding(
                padding: EdgeInsets.only(left: 32, bottom: 12),
                child: Text('No venues in this region yet.'),
              )
            else
              for (final site in sitesInRegion) _buildSiteNode(site, indent: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildSiteNode(Site site, {required int indent}) {
    final staffCount = _leadershipAccounts
        .where((u) => u.roleTier == RoleTier.venueManager && u.siteId == site.id)
        .length;
    return Padding(
      padding: EdgeInsets.only(left: indent * 16.0, bottom: 4),
      child: ListTile(
        leading: const Icon(Icons.storefront_outlined),
        title: Text(site.name),
        subtitle: staffCount > 0 ? const Text('Has a venue manager') : null,
      ),
    );
  }
}

Future<String?> _promptText(
  BuildContext context, {
  required String title,
}) {
  final controller = TextEditingController();
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
