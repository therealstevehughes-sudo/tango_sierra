import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/tenant_provisioning_providers.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../auth/senior_login_screen.dart';

/// Phase C1b — "Set up a new company". Creates an isolated tenant: an
/// Organisation and its first Director (a real email+password account).
/// On success the Director signs in through Leadership Access as normal.
class TenantSignupScreen extends ConsumerStatefulWidget {
  const TenantSignupScreen({super.key});

  @override
  ConsumerState<TenantSignupScreen> createState() => _TenantSignupScreenState();
}

class _TenantSignupScreenState extends ConsumerState<TenantSignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _company = TextEditingController();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;
  String? _error;
  String? _done;

  @override
  void dispose() {
    _company.dispose();
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
      await ref.read(tenantProvisioningRepositoryProvider).signUpCompany(
            companyName: _company.text.trim(),
            directorName: _name.text.trim(),
            email: _email.text.trim(),
            password: _password.text,
          );
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _done = _email.text.trim();
      });
    } on TenantSignupException catch (e) {
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
      appBar: AppBar(title: const Text('Set up a new company')),
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
                            'This creates your company and your own '
                            'Director account. You can invite your team '
                            'once you sign in.',
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _company,
                          decoration: const InputDecoration(
                            labelText: 'Company name',
                          ),
                          textCapitalization: TextCapitalization.words,
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
                              : const Text('Create company'),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  static String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;
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
            'Your company is set up. Sign in with your email and the '
            'password you just chose.',
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
