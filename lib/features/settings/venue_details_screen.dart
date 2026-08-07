import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/organisation.dart';
import '../../shared/models/site.dart';
import '../../shared/models/user.dart';
import '../../shared/models/venue_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/venue_type_providers.dart';

class VenueDetailsScreen extends ConsumerStatefulWidget {
  const VenueDetailsScreen({super.key});

  @override
  ConsumerState<VenueDetailsScreen> createState() =>
      _VenueDetailsScreenState();
}

class _VenueDetailsScreenState extends ConsumerState<VenueDetailsScreen> {
  bool loading = true;
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
    final name = await _promptForName('New Venue Type', '');
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
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _renameOrganisation() async {
    final org = organisation;
    if (org == null) return;
    final newName = await _promptForName('Rename Organisation', org.name);
    if (newName == null || newName.isEmpty || newName == org.name) return;

    final repo = ref.read(organisationRepositoryProvider);
    await repo.rename(org.id, newName);
    await _loadData();
  }

  Future<void> _renameSite(Site site) async {
    final newName = await _promptForName('Rename Venue', site.name);
    if (newName == null || newName.isEmpty || newName == site.name) return;

    final repo = ref.read(siteRepositoryProvider);
    await repo.rename(site.id, newName);
    await _loadData();
  }

  void _setActive(Site site) {
    ref.read(activeSiteProvider.notifier).state = site;
    setState(() {});
  }

  Future<void> _createVenue() async {
    final org = organisation;
    if (org == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create New Venue'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Multi-site support is partial: equipment, staff, and task '
              'lists are not yet filtered by venue, so day-to-day use of a '
              'second venue is not fully supported yet. Creating one is '
              'safe, but you\'ll see this venue\'s and the original '
              'venue\'s data mixed together in shared lists until that\'s '
              'built.',
              style: TextStyle(fontSize: 13),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newSiteNameController,
              decoration: const InputDecoration(labelText: 'Venue name'),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newSiteAddressController,
              decoration: const InputDecoration(
                labelText: 'Address (optional)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Create'),
          ),
        ],
      ),
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
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUser = ref.watch(currentUserProvider);
    final activeSite = ref.watch(activeSiteProvider);
    final effectiveActiveId = activeSite?.id ?? _defaultSiteId;

    return Scaffold(
      appBar: AppBar(title: const Text('Venue Details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              Card(
                child: ListTile(
                  title: const Text('Organisation'),
                  subtitle: Text(organisation?.name ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Rename',
                    onPressed: _renameOrganisation,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Venues',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
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
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Chip(label: Text('Active')),
                              )
                            else
                              Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton(
                                  onPressed: () => _setActive(site),
                                  child: const Text('Set as Active'),
                                ),
                              ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Rename',
                          onPressed: () => _renameSite(site),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Venue type',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
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
                                  label: const Text('Something else...'),
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
                ElevatedButton(
                  onPressed: _createVenue,
                  child: const Text('Create New Venue'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
