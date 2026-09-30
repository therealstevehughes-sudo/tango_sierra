import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/organisation.dart';
import '../../shared/models/site.dart';
import '../../shared/models/user.dart';
import '../../shared/models/venue_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/venue_type_providers.dart';
import 'billing_screen.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../l10n/app_localizations.dart';

class VenueDetailsScreen extends ConsumerStatefulWidget {
  const VenueDetailsScreen({super.key});

  @override
  ConsumerState<VenueDetailsScreen> createState() => _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends ConsumerState<VenueDetailsScreen> {
  bool loading = true;
  String? loadError;
  Organisation? organisation;
  List<Site> sites = [];
  List<VenueType> venueTypes = [];
  Map<int, Set<int>> siteVenueTypeIds = {};

  final TextEditingController newSiteNameController = TextEditingController();
  final TextEditingController newSiteAddressController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    newSiteNameController.dispose();
    newSiteAddressController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      loading = true;
      loadError = null;
    });
    try {
      final orgRepo = ref.read(organisationRepositoryProvider);
      final siteRepo = ref.read(siteRepositoryProvider);
      final venueTypeRepo = ref.read(venueTypeRepositoryProvider);

      final loadedOrg = await orgRepo.getDefault();
      final loadedSites = await siteRepo.getAll();
      final loadedVenueTypes = await venueTypeRepo.getAll();

      final loadedSiteVenueTypeIds = <int, Set<int>>{};
      for (final site in loadedSites) {
        final ids = await siteRepo.getVenueTypeIds(site.id);
        loadedSiteVenueTypeIds[site.id] = ids.toSet();
      }

      if (!mounted) return;
      setState(() {
        organisation = loadedOrg;
        sites = loadedSites;
        venueTypes = loadedVenueTypes;
        siteVenueTypeIds = loadedSiteVenueTypeIds;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        loadError = e.toString();
        loading = false;
      });
    }
  }

  Future<void> _toggleVenueType(Site site, int venueTypeId) async {
    final current = Set<int>.from(siteVenueTypeIds[site.id] ?? const {});
    if (current.contains(venueTypeId)) {
      current.remove(venueTypeId);
    } else {
      current.add(venueTypeId);
    }

    final siteRepo = ref.read(siteRepositoryProvider);
    await siteRepo.setVenueTypeIds(site.id, current.toList());

    if (!mounted) return;
    setState(() {
      siteVenueTypeIds[site.id] = current;
    });
  }

  Future<void> _addCustomVenueType(Site site) async {
    final name = await _promptForName(
      AppLocalizations.of(context)!.newVenueTypeTitle,
      '',
    );
    if (name == null || name.isEmpty) return;

    final venueTypeRepo = ref.read(venueTypeRepositoryProvider);
    final created = await venueTypeRepo.create(name);

    if (!mounted) return;
    setState(() {
      venueTypes = [...venueTypes, created];
    });
    await _toggleVenueType(site, created.id);
  }

  // Mirrors SiteRepository.getDefault()'s ordering (first by id) — the
  // site that's implicitly "active" whenever activeSiteProvider hasn't
  // been explicitly set yet.
  int? get _defaultSiteId {
    if (sites.isEmpty) return null;
    return sites.map((s) => s.id).reduce((a, b) => a < b ? a : b);
  }

  Future<String?> _promptForName(String title, String currentName) {
    final controller = TextEditingController(text: currentName);
    return showDialog<String>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.nameAxisLabel),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: Text(l10n.saveButton),
            ),
          ],
        );
      },
    );
  }

  Future<void> _renameOrganisation() async {
    final org = organisation;
    if (org == null) return;
    final newName = await _promptForName(
      AppLocalizations.of(context)!.renameOrganisationTitle,
      org.name,
    );
    if (newName == null || newName.isEmpty || newName == org.name) return;

    final repo = ref.read(organisationRepositoryProvider);
    await repo.rename(org.id, newName);
    await _loadData();
  }

  Future<void> _renameSite(Site site) async {
    final newName = await _promptForName(
      AppLocalizations.of(context)!.renameVenueTitle,
      site.name,
    );
    if (newName == null || newName.isEmpty || newName == site.name) return;

    final repo = ref.read(siteRepositoryProvider);
    await repo.rename(site.id, newName);
    await _loadData();
  }

  void _setActive(Site site) {
    ref.read(activeSiteProvider.notifier).state = site;
    setState(() {});
  }

  // Device pairing (2026-09-20) — regenerating disconnects every tablet
  // currently using this venue's old code (it's a shared-per-venue secret,
  // not per-device), so this is a real, warned-about action rather than a
  // casual "Reset" button.
  Future<void> _regenerateDeviceCode(Site site) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.resetSetupCodeTitle),
          content: Text(l10n.resetSetupCodeConfirmText),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.resetCodeButton),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    final repo = ref.read(siteRepositoryProvider);
    final updated = await repo.regenerateDeviceCredential(site.id);
    if (!mounted) return;
    setState(() {
      sites = [
        for (final s in sites) if (s.id == updated.id) updated else s,
      ];
    });
  }

  Future<void> _createVenue() async {
    final org = organisation;
    if (org == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.createNewVenueTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.multiSiteSupportPartialText,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newSiteNameController,
                decoration: InputDecoration(labelText: l10n.venueNameLabel),
                autofocus: true,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newSiteAddressController,
                decoration: InputDecoration(
                  labelText: l10n.addressOptionalLabel,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.createButton),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;
    final name = newSiteNameController.text.trim();
    if (name.isEmpty) return;

    final repo = ref.read(siteRepositoryProvider);
    await repo.create(
      name: name,
      address: newSiteAddressController.text.trim().isEmpty
          ? null
          : newSiteAddressController.text.trim(),
      organisationId: org.id,
    );

    newSiteNameController.clear();
    newSiteAddressController.clear();
    if (!mounted) return;
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final backendDataEnabled = ref.watch(backendDataEnabledProvider);
    final activeSite = ref.watch(activeSiteProvider);
    final effectiveActiveId = activeSite?.id ?? _defaultSiteId;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.venueDetailsTitle),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.venueDetailsTitle),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : loadError != null
          ? LoadErrorView(error: loadError!, onRetry: _loadData)
          : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: Text(l10n.organisationTitle),
                    subtitle: Text(organisation?.name ?? ''),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit),
                      tooltip: l10n.renameTooltip,
                      onPressed: _renameOrganisation,
                    ),
                  ),
                ),
                // GoCardless billing (2026-09-21) -- executive-only, backend
                // mode only (a local-only install has no subscription
                // concept at all, see Subscription's own doc comment).
                if (backendDataEnabled &&
                    currentUser?.roleTier == RoleTier.executive)
                  Card(
                    child: ListTile(
                      title: Text(l10n.billingLabel),
                      subtitle: Text(l10n.billingSubtitleText),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const BillingScreen()),
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
                SectionHeader(title: l10n.venuesSectionTitle),
                ...sites.map((site) {
                  final isActive = site.id == effectiveActiveId;
                  final taggedIds = siteVenueTypeIds[site.id] ?? const {};
                  return Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text(site.name),
                          // Visual/UX audit: the Active indicator and "Set as
                          // Active" action used to share `trailing` with the
                          // rename icon in a Row — the same "trailing eats the
                          // title's width" pattern that broke Staff
                          // Management's name wrap. Moved into `subtitle` so a
                          // long venue name isn't squeezed at narrow widths.
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(site.address ?? ''),
                              const SizedBox(height: 4),
                              if (isActive)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Chip(label: Text(l10n.activeLabel)),
                                )
                              else
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                    onPressed: () => _setActive(site),
                                    child: Text(l10n.setAsActiveButton),
                                  ),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: l10n.renameTooltip,
                            onPressed: () => _renameSite(site),
                          ),
                        ),
                        if (backendDataEnabled &&
                            currentUser != null &&
                            roleTierRank(currentUser.roleTier) >=
                                roleTierRank(RoleTier.venueManager))
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SectionHeader(title: l10n.tabletSetupCodeTitle),
                                const SizedBox(height: 4),
                                Text(
                                  l10n.tabletSetupCodeExplanation,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Text(
                                      site.deviceCredential ?? '-',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w700,
                                            letterSpacing: 2,
                                          ),
                                    ),
                                    const SizedBox(width: 12),
                                    TextButton(
                                      onPressed: () =>
                                          _regenerateDeviceCode(site),
                                      child: Text(
                                        site.deviceCredential == null
                                            ? l10n.generateCodeButton
                                            : l10n.resetCodeButton,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(title: l10n.venueTypeSectionTitle),
                              Wrap(
                                spacing: 8,
                                runSpacing: 4,
                                children: [
                                  ...venueTypes.map(
                                    (type) => FilterChip(
                                      label: Text(type.name),
                                      selected: taggedIds.contains(type.id),
                                      onSelected: (_) =>
                                          _toggleVenueType(site, type.id),
                                    ),
                                  ),
                                  ActionChip(
                                    avatar: const Icon(Icons.add, size: 18),
                                    label: Text(l10n.somethingElseOption),
                                    onPressed: () => _addCustomVenueType(site),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                if (currentUser?.roleTier == RoleTier.executive) ...[
                  const SizedBox(height: 12),
                  PrimaryActionButton(
                    label: l10n.createNewVenueTitle,
                    onPressed: _createVenue,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
