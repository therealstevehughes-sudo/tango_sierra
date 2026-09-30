import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../auth/senior_login_screen.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

/// Sprint 034 — "Join existing company", the redeem side. For staff,
/// managers, or anyone else whose company already has a VenuRite
/// account: paste the invite code (or scan its QR with a phone camera
/// app — this screen only needs the resulting text, no in-app scanner
/// built yet) they were given, choose a password, and they're in. No
/// session exists yet when this runs, same as `CompanyOnboardingWizardScreen`.
class JoinCompanyScreen extends ConsumerStatefulWidget {
  const JoinCompanyScreen({super.key});

  @override
  ConsumerState<JoinCompanyScreen> createState() => _JoinCompanyScreenState();
}

class _JoinCompanyScreenState extends ConsumerState<JoinCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _token = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;
  String? _done;

  @override
  void dispose() {
    _token.dispose();
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _error = null;
      _submitting = true;
    });
    try {
      await ref
          .read(tenantProvisioningRepositoryProvider)
          .redeemInvite(
            token: _token.text.trim(),
            name: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
          );
      if (!mounted) return;
      // Pressure-test audit fix (2026-09-22) — this call creates a real
      // GoTrue account, but nothing used to sign it in: backendAuthEnabled
      // Provider/backendDataEnabledProvider stayed false for this session,
      // so SeniorLoginScreen (reachable via the fallback button below)
      // would only ever show its demo PIN mode, not the real email+
      // password form -- the person who just joined could never actually
      // sign in with the credentials they were just given. Same activation
      // pattern as CompanyOnboardingWizardScreen's own
      // _activateBackendSession, applied to this second real sign-up path.
      final activated = await _activateBackendSession();
      if (!mounted) return;
      if (activated) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        return;
      }
      setState(() {
        _submitting = false;
        _done = _email.text.trim();
      });
    } on InviteRedeemException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.message;
        _submitting = false;
      });
    }
  }

  Future<bool> _activateBackendSession() async {
    try {
      final response = await gotrue.Supabase.instance.client.auth
          .signInWithPassword(
            email: _email.text.trim(),
            password: _password.text,
          );
      final user = response.user;
      if (response.session == null || user == null) return false;

      ref.read(backendAuthEnabledProvider.notifier).state = true;
      ref.read(backendDataEnabledProvider.notifier).state = true;

      final localUser = await ref
          .read(userRepositoryProvider)
          .findBySupabaseUserId(user.id);
      if (localUser == null) return false;
      ref.read(currentUserProvider.notifier).state = localUser;
      return true;
    } catch (_) {
      // Best-effort -- the account is already real regardless. Falls back
      // to the "Go to sign in" success view if this doesn't work.
      return false;
    }
  }

  String? _required(String? v, AppLocalizations l10n) =>
      (v == null || v.trim().isEmpty) ? l10n.requiredFieldError : null;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.joinExistingCompanyTitle),
        actions: const [AssistantIconButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 440,
            alignment: Alignment.center,
            child: _done != null
                ? _SuccessView(email: _done!)
                : Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppBanner(
                          kind: BannerKind.info,
                          child: Text(l10n.enterInviteCodeText),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _token,
                          decoration: InputDecoration(
                            labelText: l10n.inviteCodeLabel,
                          ),
                          autocorrect: false,
                          validator: (v) => _required(v, l10n),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _name,
                          decoration: InputDecoration(
                            labelText: l10n.yourNameLabel,
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: (v) => _required(v, l10n),
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _email,
                          decoration: InputDecoration(
                            labelText: l10n.yourEmailLabel,
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return l10n.requiredFieldError;
                            if (!t.contains('@') || !t.contains('.')) {
                              return l10n.enterValidEmailError;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: l10n.choosePasswordLabel,
                            helperText: l10n.passwordMinCharsHelper,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscure
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                            ),
                          ),
                          validator: (v) => (v ?? '').length < 8
                              ? l10n.passwordMinCharsHelper
                              : null,
                        ),
                        if (_error != null) ...[
                          const SizedBox(height: 16),
                          AppBanner(
                            kind: BannerKind.critical,
                            child: Text(_error!),
                          ),
                        ],
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: _submitting ? null : _submit,
                          child: _submitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(l10n.joinButton),
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

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppBanner(
          kind: BannerKind.info,
          child: Text(l10n.youreInSignInText),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
            );
          },
          child: Text(l10n.goToSignInButton),
        ),
      ],
    );
  }
}
