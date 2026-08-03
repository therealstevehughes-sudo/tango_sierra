import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/organisation.dart';
import '../../shared/models/site.dart';
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
  Site? site;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final orgRepo = ref.read(organisationRepositoryProvider);
    final siteRepo = ref.read(siteRepositoryProvider);

    final loadedOrg = await orgRepo.getDefault();
    final loadedSite = await siteRepo.getDefault();

    if (!mounted) return;
    setState(() {
      organisation = loadedOrg;
      site = loadedSite;
      loading = false;
    });
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

  Future<void> _renameSite() async {
    final currentSite = site;
    if (currentSite == null) return;
    final newName = await _promptForName('Rename Site', currentSite.name);
    if (newName == null || newName.isEmpty || newName == currentSite.name) {
      return;
    }

    final repo = ref.read(siteRepositoryProvider);
    await repo.rename(currentSite.id, newName);
    await _loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Venue Details')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
              Card(
                child: ListTile(
                  title: const Text('Site'),
                  subtitle: Text(site?.name ?? ''),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    tooltip: 'Rename',
                    onPressed: _renameSite,
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
