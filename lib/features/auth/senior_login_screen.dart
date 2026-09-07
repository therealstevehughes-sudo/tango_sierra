import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/auth_providers.dart';

/// Leadership Access — the private entry point for regional/executive
/// accounts, reached via the discreet lock icon on the main login screen
/// (they're deliberately hidden from that shared, walk-up staff list).
///
/// Phase 2: this used to reuse the same PIN-hash check every other account
/// goes through, with a banner warning that it was interim. It's now real
/// email + password sign-in via Supabase's own auth, replacing the PIN
/// entirely for this tier. Two-factor (an authenticator app code) is a
/// planned fast-follow, not built in this pass — see Phase 2 notes.
class SeniorLoginScreen extends ConsumerStatefulWidget {
  const SeniorLoginScreen({super.key});

  @override
  ConsumerState<SeniorLoginScreen> createState() => _SeniorLoginScreenState();
}

class _SeniorLoginScreenState extends ConsumerState<SeniorLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String? error;
  bool submitting = false;
  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> submit() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    setState(() {
      error = null;
      submitting = true;
    });

    try {
      final response = await gotrue.Supabase.instance.client.auth
          .signInWithPassword(email: email, password: password);
      final authUserId = response.user?.id;
      final session = response.session;

      if (authUserId == null || session == null) {
        setState(() {
          error = 'Sign-in failed';
          submitting = false;
        });
        return;
      }

      final repository = ref.read(userRepositoryProvider);
      final localUser = await repository.findBySupabaseUserId(authUserId);

      if (!mounted) return;

      if (localUser == null) {
        setState(() {
          error =
              "This account isn't linked to a staff profile yet — contact an admin.";
          submitting = false;
        });
        return;
      }

      ref.read(currentUserProvider.notifier).state = localUser;
      ref.read(currentSessionTokenProvider.notifier).state =
          session.accessToken;

      // This screen was reached via Navigator.push, so it sits on top of
      // the nav stack — setting currentUserProvider only changes what
      // MaterialApp.home *should* be, it doesn't retroactively unwind an
      // already-pushed route. Without popping back to root, the app would
      // silently stay on this now-inert screen instead of showing the
      // rebuilt home.
      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on gotrue.AuthException catch (e) {
      if (!mounted) return;
      setState(() {
        error = e.message;
        submitting = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        error = 'Could not reach the server';
        submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Leadership Access')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 400,
            alignment: Alignment.center,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const AppBanner(
                    kind: BannerKind.info,
                    child: Text('Regional & Director sign-in.'),
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email],
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                    ),
                    onSubmitted: (_) => submit(),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    autofillHints: const [AutofillHints.password],
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                        onPressed: () => setState(
                          () => obscurePassword = !obscurePassword,
                        ),
                      ),
                    ),
                    onSubmitted: (_) => submit(),
                  ),
                  if (error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      error!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ],
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: submitting ? null : submit,
                    child: submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('SIGN IN'),
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }
}
