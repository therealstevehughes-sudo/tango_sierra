import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/pin_auth_outcome.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import 'pin_entry.dart';

/// Leadership Access — the private entry point for regional/executive
/// accounts, reached via the discreet lock icon on the main login screen
/// (they're deliberately hidden from that shared, walk-up staff list).
///
/// Phase 2: real email + password sign-in via Supabase's own auth, once a
/// real backend tenant is configured (`backendAuthEnabledProvider` true).
/// Two-factor (an authenticator app code) is a planned fast-follow.
///
/// Found 2026-09-14 while checking a "no logo shows" report: this screen's
/// GoTrue-only flow made Leadership Access completely unreachable in a
/// local/demo build (`backendAuthEnabledProvider` false — the default) —
/// there's no real GoTrue account for the seeded demo Director/Regional
/// accounts, and they're deliberately hidden from the PIN-based staff
/// list, so no executive-only screen (like Company branding) could ever
/// be reached at all. Restored the ORIGINAL local PIN-check path (this
/// screen's own doc comment already noted it "used to" work this way)
/// as the demo-mode fallback: PIN-based sign-in, reusing the exact same
/// `PinEntry` widget and `UserRepository.authenticate()` call the main
/// staff login screen uses, so a real backend tenant is the only thing
/// that switches this over to real email+password.
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

  // Demo-mode (backendAuthEnabled false) PIN path.
  User? selectedUser;
  final pinController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    pinController.dispose();
    super.dispose();
  }

  void selectUser(User user) {
    setState(() {
      selectedUser = user;
      pinController.clear();
      error = null;
    });
  }

  void backToList() {
    setState(() {
      selectedUser = null;
      pinController.clear();
      error = null;
    });
  }

  Future<void> submitPin() async {
    final user = selectedUser;
    if (user == null) return;

    setState(() {
      error = null;
      submitting = true;
    });

    final repository = ref.read(userRepositoryProvider);
    final outcome = await repository.authenticate(
      userId: user.id,
      pin: pinController.text.trim(),
    );

    if (!mounted) return;

    switch (outcome) {
      case PinAuthSuccess(:final user, :final accessToken):
        ref.read(currentUserProvider.notifier).state = user;
        ref.read(currentSessionTokenProvider.notifier).state = accessToken;
        Navigator.of(context).popUntil((route) => route.isFirst);
      case PinAuthIncorrect():
        setState(() {
          error = 'Incorrect PIN';
          submitting = false;
        });
      case PinAuthLocked(:final lockedUntil):
        final minutesLeft =
            lockedUntil.difference(DateTime.now()).inMinutes + 1;
        setState(() {
          error = 'Too many wrong attempts. Try again in $minutesLeft min.';
          submitting = false;
        });
      case PinAuthNotFound():
        setState(() {
          error = 'Account not found';
          submitting = false;
        });
      case PinAuthError(:final message):
        setState(() {
          error = message;
          submitting = false;
        });
    }
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
    if (!ref.watch(backendAuthEnabledProvider)) {
      return _buildDemoPinMode(context);
    }
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
                      onPressed: () =>
                          setState(() => obscurePassword = !obscurePassword),
                    ),
                  ),
                  onSubmitted: (_) => submit(),
                ),
                if (error != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    error!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
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

  Widget _buildDemoPinMode(BuildContext context) {
    final staffAsync = ref.watch(staffDirectoryProvider);
    final seniorStaff = staffAsync.maybeWhen(
      data: (staff) => staff
          .where(
            (u) =>
                u.roleTier == RoleTier.regional ||
                u.roleTier == RoleTier.executive,
          )
          .toList(),
      orElse: () => const <User>[],
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Leadership Access')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 400,
            alignment: Alignment.center,
            child: selectedUser != null
                ? PinEntry(
                    user: selectedUser!,
                    controller: pinController,
                    error: error,
                    submitting: submitting,
                    onSubmit: submitPin,
                    onBack: backToList,
                  )
                : staffAsync.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const AppBanner(
                        kind: BannerKind.info,
                        child: Text(
                          'No backend is configured for this install — '
                          'sign in with a PIN, same as everyone else.',
                        ),
                      ),
                      const SizedBox(height: 24),
                      if (seniorStaff.isEmpty)
                        const Text(
                          'No Director/Regional accounts on this device.',
                        )
                      else
                        for (final user in seniorStaff)
                          Card(
                            child: ListTile(
                              title: Text(user.name),
                              subtitle: Text(
                                user.roleTier == RoleTier.executive
                                    ? 'Director'
                                    : 'Regional Manager',
                              ),
                              onTap: () => selectUser(user),
                            ),
                          ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
