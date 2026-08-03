import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/organisation.dart';
import '../../shared/models/site.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';

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

    final loadedOrg = await orgRepo.getDefault();
    final loadedSites = await siteRepo.getAll();

    if (!mounted) return;
    setState(() {
      organisation = loadedOrg;
      sites = loadedSites;
      loading = false;
    });
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
                return Card(
                  child: ListTile(
                    title: Text(site.name),
                    subtitle: Text(site.address ?? ''),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isActive)
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8),
                            child: Chip(label: Text('Active')),
                          )
                        else
                          TextButton(
                            onPressed: () => _setActive(site),
                            child: const Text('Set as Active'),
                          ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: 'Rename',
                          onPressed: () => _renameSite(site),
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (currentUser?.roleTier == RoleTier.top) ...[
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
