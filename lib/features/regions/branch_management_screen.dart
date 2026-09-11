import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/site.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';

/// Phase C1c — regional-tier. Builds branches (Sites) within the
/// manager's OWN region — RLS scopes `siteRepositoryProvider.getAll()` to
/// exactly that region already (proven B2), so this screen never needs to
/// filter by region itself. Inviting a branch (venueManager) is a PIN
/// account, provisioned in C1d via provision-staff-pin — not built here
/// yet; per the cascade rule, this screen stops at "create the branch."
class BranchManagementScreen extends ConsumerStatefulWidget {
  const BranchManagementScreen({super.key});

  @override
  ConsumerState<BranchManagementScreen> createState() =>
      _BranchManagementScreenState();
}

class _BranchManagementScreenState
    extends ConsumerState<BranchManagementScreen> {
  List<Site>? _sites;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final sites = await ref.read(siteRepositoryProvider).getAll();
    if (!mounted) return;
    setState(() {
      _sites = sites;
      _loading = false;
    });
  }

  Future<void> _addBranch() async {
    final currentUser = ref.read(currentUserProvider);
    final orgId = ref.read(currentBackendOrganisationIdProvider);
    final regionId = currentUser?.regionId;
    if (orgId == null || regionId == null) return;
    final name = await _promptText(context, title: 'New branch name');
    if (name == null || name.trim().isEmpty) return;
    await ref.read(siteRepositoryProvider).create(
          name: name.trim(),
          organisationId: orgId,
          regionId: regionId,
        );
    await _load();
  }

  Future<void> _renameBranch(Site site) async {
    final name = await _promptText(
      context,
      title: 'Rename branch',
      initial: site.name,
    );
    if (name == null || name.trim().isEmpty || name.trim() == site.name) {
      return;
    }
    await ref.read(siteRepositoryProvider).rename(site.id, name.trim());
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final hasRegion = currentUser?.regionId != null;

    return Scaffold(
      appBar: AppBar(title: const Text('Branches')),
      drawer: const ManagementDrawer(title: 'Branches'),
      floatingActionButton: hasRegion
          ? FloatingActionButton(
              onPressed: _addBranch,
              child: const Icon(Icons.add),
            )
          : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: !hasRegion
                ? const AppBanner(
                    kind: BannerKind.info,
                    child: Text(
                      'Your account has no region set — contact your '
                      'Director.',
                    ),
                  )
                : _loading
                    ? const Center(child: CircularProgressIndicator())
                    : (_sites ?? []).isEmpty
                        ? const Center(
                            child: Text('No branches in your region yet.'),
                          )
                        : ListView.separated(
                            itemCount: _sites!.length,
                            separatorBuilder: (_, _) => const Divider(),
                            itemBuilder: (context, index) {
                              final site = _sites![index];
                              return ListTile(
                                title: Text(site.name),
                                subtitle: site.address == null
                                    ? null
                                    : Text(site.address!),
                                trailing: IconButton(
                                  icon: const Icon(Icons.edit_outlined),
                                  onPressed: () => _renameBranch(site),
                                ),
                              );
                            },
                          ),
          ),
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
