import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../auth/senior_login_screen.dart';

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

  static String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join existing company')),
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
                        const AppBanner(
                          kind: BannerKind.info,
                          child: Text(
                            'Enter the invite code your manager gave you.',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _token,
                          decoration: const InputDecoration(
                            labelText: 'Invite code',
                          ),
                          autocorrect: false,
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _name,
                          decoration: const InputDecoration(
                            labelText: 'Your name',
                          ),
                          textCapitalization: TextCapitalization.words,
                          validator: _required,
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _email,
                          decoration: const InputDecoration(
                            labelText: 'Your email',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          autocorrect: false,
                          validator: (v) {
                            final t = v?.trim() ?? '';
                            if (t.isEmpty) return 'Required';
                            if (!t.contains('@') || !t.contains('.')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 12),
                        TextFormField(
                          controller: _password,
                          obscureText: _obscure,
                          decoration: InputDecoration(
                            labelText: 'Choose a password',
                            helperText: 'At least 8 characters',
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
                              ? 'At least 8 characters'
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
                              : const Text('Join'),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppBanner(
          kind: BannerKind.info,
          child: Text(
            "You're in. Sign in with your email and the password you "
            'just chose.',
          ),
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const SeniorLoginScreen()),
            );
          },
          child: const Text('Go to sign in'),
        ),
      ],
    );
  }
}
