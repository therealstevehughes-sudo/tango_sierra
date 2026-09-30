import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

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
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.accountCreatedTitle),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.giveNameAndPinText),
                const SizedBox(height: 16),
                SelectableText(l10n.nameColonLabel(result.name)),
                SelectableText(l10n.pinColonLabel(result.pin)),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.doneButton),
              ),
            ],
          );
        },
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.addTeamMemberTitle),
        actions: const [AssistantIconButton()],
      ),
      drawer: ManagementDrawer(title: l10n.addTeamMemberTitle),
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
                  AppBanner(
                    kind: BannerKind.info,
                    child: Text(l10n.createsTapNamePinAccountText),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(labelText: l10n.nameAxisLabel),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? l10n.requiredFieldError : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _jobTitle,
                    decoration: InputDecoration(labelText: l10n.jobTitleLabel),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v ?? '').trim().isEmpty ? l10n.requiredFieldError : null,
                  ),
                  const SizedBox(height: 12),
                  // Pressure-test audit fix (2026-09-22) — hand-typed
                  // labels replaced with the canonical roleTierDisplayName()
                  // helper, same fix as the wizard's own staff-invite
                  // dropdown (same hardcoded-list pattern as the venue-type
                  // dropdown bug that triggered this audit).
                  DropdownButtonFormField<String>(
                    initialValue: _roleTier,
                    decoration: InputDecoration(labelText: l10n.tierFieldLabel),
                    items: [RoleTier.base, RoleTier.supervisor]
                        .map(
                          (tier) => DropdownMenuItem(
                            value: tier.name,
                            child: Text(roleTierDisplayName(tier, l10n)),
                          ),
                        )
                        .toList(),
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
                        : Text(l10n.createAccountButton),
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
