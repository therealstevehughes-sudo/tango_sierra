import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/site.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';

/// Phase C1c/C1d — regional-tier. Builds branches (Sites) within the
/// manager's OWN region — RLS scopes `siteRepositoryProvider.getAll()` to
/// exactly that region already (proven B2), so this screen never needs to
/// filter by region itself. Each branch can have a branch manager (PIN
/// account) provisioned via `provision-staff-pin` — the credential is a
/// generated PIN shown once for the regional to pass on, same "copyable
/// thing, not a real email" pattern as the senior invite.
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

  Future<void> _inviteBranchManager(Site site) async {
    final token = ref.read(currentBackendAccessTokenProvider);
    if (token == null) return;
    final name = await _promptText(
      context,
      title: 'Branch manager\'s name',
    );
    if (name == null || name.trim().isEmpty) return;
    try {
      final result = await ref.read(tenantProvisioningRepositoryProvider).provisionStaffPin(
            callerAccessToken: token,
            name: name.trim(),
            jobTitle: 'Branch Manager',
            roleTier: 'venueManager',
            siteId: site.id,
          );
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Account created'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Give this person their name (to tap on the login screen) '
                'and this PIN.',
              ),
              const SizedBox(height: 16),
              SelectableText('Name: ${result.name}'),
              SelectableText('PIN: ${result.pin}'),
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
    } on StaffPinProvisionException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
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
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'invite') {
                                      _inviteBranchManager(site);
                                    } else if (value == 'rename') {
                                      _renameBranch(site);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'invite',
                                      child: Text('Add branch manager'),
                                    ),
                                    PopupMenuItem(
                                      value: 'rename',
                                      child: Text('Rename'),
                                    ),
                                  ],
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
