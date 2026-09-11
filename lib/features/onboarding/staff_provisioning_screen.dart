import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';

/// Phase C1d — venueManager (branch manager) adds supervisor/base staff
/// at their OWN site via `provision-staff-pin`. This is the backend-first
/// counterpart to the existing local-only staff creation in
/// VenueSetupWizardScreen — that path stays for the demo/dev flavour;
/// once `backendDataEnabledProvider` is on, staff at a real tenant are
/// created here so they get a real, tenant-isolated PIN account from the
/// start (same "generated credential, shown once" pattern as C1c's
/// senior invite).
class StaffProvisioningScreen extends ConsumerStatefulWidget {
  const StaffProvisioningScreen({super.key});

  @override
  ConsumerState<StaffProvisioningScreen> createState() =>
      _StaffProvisioningScreenState();
}

class _StaffProvisioningScreenState
    extends ConsumerState<StaffProvisioningScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _jobTitle = TextEditingController();
  String _roleTier = 'base';
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _jobTitle.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final currentUser = ref.read(currentUserProvider);
    final token = ref.read(currentBackendAccessTokenProvider);
    final siteId = currentUser?.siteId;
    if (token == null || siteId == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      final result = await ref.read(tenantProvisioningRepositoryProvider).provisionStaffPin(
            callerAccessToken: token,
            name: _name.text.trim(),
            jobTitle: _jobTitle.text.trim(),
            roleTier: _roleTier,
            siteId: siteId,
          );
      if (!mounted) return;
      setState(() => _submitting = false);
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
      if (!mounted) return;
      _name.clear();
      _jobTitle.clear();
    } on StaffPinProvisionException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Team Member')),
      drawer: const ManagementDrawer(title: 'Add Team Member'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 440,
            alignment: Alignment.center,
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppBanner(
                    kind: BannerKind.info,
                    child: Text(
                      'Creates a tap-name + PIN account for your own '
                      'venue.',
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(labelText: 'Name'),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _jobTitle,
                    decoration: const InputDecoration(labelText: 'Job title'),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _roleTier,
                    decoration: const InputDecoration(labelText: 'Tier'),
                    items: const [
                      DropdownMenuItem(value: 'base', child: Text('Team Member')),
                      DropdownMenuItem(
                        value: 'supervisor',
                        child: Text('Supervisor'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _roleTier = value);
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    AppBanner(kind: BannerKind.critical, child: Text(_error!)),
                  ],
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _submitting ? null : _submit,
                    child: _submitting
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Create account'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
