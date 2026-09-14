import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/region.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';

/// Phase C1c — executive-only. Builds the Organisation's Regions and
/// invites a regional manager for each (email/temp-password, since SMTP
/// isn't configured — the inviting Director passes these on). Per the
/// cascade rule ("nobody sets up more than one level below them"), an
/// executive stops here — a region's branches are the regional manager's
/// own job (BranchManagementScreen), enforced by RLS, not just this UI.
class RegionManagementScreen extends ConsumerStatefulWidget {
  const RegionManagementScreen({super.key});

  @override
  ConsumerState<RegionManagementScreen> createState() =>
      _RegionManagementScreenState();
}

class _RegionManagementScreenState
    extends ConsumerState<RegionManagementScreen> {
  List<Region>? _regions;
  List<User>? _leadershipAccounts;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final orgId = ref.read(currentBackendOrganisationIdProvider);
    if (orgId == null) {
      setState(() {
        _loading = false;
        _error = 'No organisation on this session.';
      });
      return;
    }
    final regions = await ref
        .read(regionRepositoryProvider)
        .getForOrganisation(orgId);
    final leadershipAccounts = await ref
        .read(userRepositoryProvider)
        .getForOrganisation(orgId);
    if (!mounted) return;
    setState(() {
      _regions = regions;
      _leadershipAccounts = leadershipAccounts;
      _loading = false;
    });
  }

  Future<void> _resetPassword(User account) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Reset password?'),
        content: Text(
          "This immediately invalidates ${account.name}'s current "
          "password. You'll get a new temporary password to pass along "
          'to them.',
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
    if (confirmed != true) return;
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
              const Text(
                'Give this person their new temporary password — they '
                'sign in via Leadership Access with their existing email.',
              ),
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

  Future<void> _addRegion() async {
    final orgId = ref.read(currentBackendOrganisationIdProvider);
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

  Future<void> _inviteRegionalManager(Region region) async {
    final orgId = ref.read(currentBackendOrganisationIdProvider);
    if (orgId == null) return;
    final result = await showDialog<(String name, String email)>(
      context: context,
      builder: (_) => const _InviteDialog(roleLabel: 'Regional Manager'),
    );
    if (result == null) return;
    try {
      final invite = await ref
          .read(tenantProvisioningRepositoryProvider)
          .inviteSenior(
            email: result.$2,
            name: result.$1,
            roleTier: 'regional',
            organisationId: orgId,
            regionId: region.id,
          );
      if (!mounted) return;
      await _showCredentials(invite);
    } on SeniorInviteException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    }
  }

  Future<void> _showCredentials(SeniorInviteResult invite) {
    return showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Account created'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Give this person these details — they sign in via '
              'Leadership Access and can change the password after.',
            ),
            const SizedBox(height: 16),
            SelectableText('Email: ${invite.email}'),
            SelectableText(
              'Temporary password: ${invite.temporaryPassword}',
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Regions')),
      drawer: const ManagementDrawer(title: 'Regions'),
      floatingActionButton: FloatingActionButton(
        onPressed: _addRegion,
        child: const Icon(Icons.add),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? AppBanner(kind: BannerKind.critical, child: Text(_error!))
                    : ListView(
                        children: [
                          if ((_regions ?? []).isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                'No regions yet. Add one to invite a '
                                'regional manager.',
                              ),
                            )
                          else
                            ...List.generate(_regions!.length, (index) {
                              final region = _regions![index];
                              return ListTile(
                                title: Text(region.name),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'rename') {
                                      _renameRegion(region);
                                    } else if (value == 'invite') {
                                      _inviteRegionalManager(region);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'invite',
                                      child: Text('Invite regional manager'),
                                    ),
                                    PopupMenuItem(
                                      value: 'rename',
                                      child: Text('Rename'),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          if ((_leadershipAccounts ?? []).isNotEmpty) ...[
                            const Padding(
                              padding: EdgeInsets.only(top: 24, bottom: 8),
                              child: Text(
                                'Leadership accounts',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            const Divider(height: 1),
                            ...List.generate(_leadershipAccounts!.length, (
                              index,
                            ) {
                              final account = _leadershipAccounts![index];
                              return ListTile(
                                title: Text(account.name),
                                subtitle: Text(
                                  account.roleTier == RoleTier.executive
                                      ? 'Director'
                                      : 'Regional Manager',
                                ),
                                trailing: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'reset') {
                                      _resetPassword(account);
                                    }
                                  },
                                  itemBuilder: (_) => const [
                                    PopupMenuItem(
                                      value: 'reset',
                                      child: Text('Reset password'),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ],
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

class _InviteDialog extends StatefulWidget {
  const _InviteDialog({required this.roleLabel});
  final String roleLabel;

  @override
  State<_InviteDialog> createState() => _InviteDialogState();
}

class _InviteDialogState extends State<_InviteDialog> {
  final _name = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite ${widget.roleLabel}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            autofocus: true,
          ),
          TextField(
            controller: _email,
            decoration: const InputDecoration(labelText: 'Email'),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            if (_name.text.trim().isEmpty || _email.text.trim().isEmpty) {
              return;
            }
            Navigator.pop(context, (_name.text.trim(), _email.text.trim()));
          },
          child: const Text('Invite'),
        ),
      ],
    );
  }
}
