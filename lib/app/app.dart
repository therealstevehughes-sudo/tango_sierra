import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as gotrue;

import '../core/services/push_token_service.dart';
import '../features/auth/login_screen.dart';
import '../features/home/tier_home_screen.dart';
import '../features/onboarding/splash_screen.dart';
import '../features/tasks/worker_hub_screen.dart';
import '../shared/models/user.dart';
import '../shared/providers/auth_providers.dart';
import '../shared/providers/branding_providers.dart';
import 'navigator_key.dart';
import 'theme/app_theme.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  // Sprint 042 (First-Open Experience) — lives on this State object, which
  // is created exactly once per real app process launch (MyApp itself
  // sits at the MaterialApp root and is never recreated by a login/logout
  // rebuild, only rebuilt via ref.watch inside build()). A later logout
  // back to LoginScreen within the same running session must NOT
  // re-trigger the splash — this flag, not currentUser, is what decides
  // that.
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), () {
      if (mounted) setState(() => _showSplash = false);
    });
    _restoreBackendSession();
  }

  // Pressure-test audit fix (2026-09-22) — found a real severe gap:
  // backendAuthEnabledProvider/backendDataEnabledProvider were only ever
  // flipped on in-memory by the sign-up wizard's own _activateBackendSession
  // (Sprint 046). Nothing restored them on a later app relaunch, even
  // though supabase_flutter itself persists the GoTrue session to disk —
  // so a real paying customer who closed and reopened the app silently
  // lost 2FA, Billing, and real email+password Leadership sign-in (it fell
  // back to demo PIN mode instead), despite still holding a valid session
  // server-side. Mirrors the wizard's own activation logic exactly, just
  // triggered by a persisted session instead of a fresh sign-up. PIN-based
  // walk-up sessions are completely unaffected — they never touch GoTrue's
  // session storage at all (currentSessionTokenProvider, deliberately not
  // persisted, is a different mechanism entirely).
  Future<void> _restoreBackendSession() async {
    try {
      final session = gotrue.Supabase.instance.client.auth.currentSession;
      if (session == null) return;

      ref.read(backendDataEnabledProvider.notifier).state = true;
      final localUser = await ref
          .read(userRepositoryProvider)
          .findBySupabaseUserId(session.user.id);
      if (localUser == null) {
        if (mounted) {
          ref.read(backendDataEnabledProvider.notifier).state = false;
        }
        return;
      }
      if (!mounted) return;
      ref.read(backendAuthEnabledProvider.notifier).state = true;
      ref.read(currentUserProvider.notifier).state = localUser;
    } catch (_) {
      // No persisted session, or the backend is unreachable at launch --
      // same "don't block startup" principle as main()'s own initSupabase
      // try/catch. Local/demo experience continues exactly as before.
      if (mounted) {
        ref.read(backendDataEnabledProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    // Realtime push (2026-09-16) — one choke point for every login path
    // (PIN, senior email+password, senior demo-PIN) rather than wiring
    // registration into each of them separately. Fires once per sign-in
    // (previous==null, next!=null) — a currentUser change while already
    // signed in (e.g. a settings update) never re-registers.
    ref.listen(currentUserProvider, (previous, next) {
      if (previous == null && next != null) {
        ref
            .read(pushTokenServiceProvider)
            .registerForCurrentUser(ref.read(userRepositoryProvider), next.id);
      }
    });
    // Branding (Sprint 031, finalized beta build order item 7) — watching
    // this StreamProvider directly means saving a new brand colour
    // anywhere re-themes the whole app immediately, no restart. `null`
    // (no BrandingConfig row yet, or still loading) falls back to
    // AppTheme.light's own default teal accent.
    final brandAccentArgb = ref
        .watch(brandingConfigProvider)
        .maybeWhen(
          data: (config) => config?.primaryColorArgb,
          orElse: () => null,
        );
    final brandAccent = brandAccentArgb == null ? null : Color(brandAccentArgb);

    // Tier home screen (Sprint 031, Build Order item 5, Sub-sprint A):
    // every non-base tier now lands on TierHomeScreen (My Tasks /
    // Oversight), not straight on ManagerScreen/TopScreen — closes the
    // gap where a task tiered above base could be assigned but never
    // reached. base tier now lands on WorkerHubScreen (branch-hub build,
    // 2026-09-15) instead of straight on the carousel — a single fork
    // ("My scheduled tasks" vs. "Log something that just happened")
    // before TaskScreen, not a new nav surface; "My scheduled tasks"
    // leads to the exact same, unchanged TaskScreen base tier always had.
    Widget home;
    if (_showSplash) {
      home = const SplashScreen();
    } else if (currentUser == null) {
      home = const LoginScreen();
    } else if (currentUser.roleTier == RoleTier.base) {
      home = const WorkerHubScreen();
    } else {
      home = const TierHomeScreen();
    }

    return MaterialApp(
      navigatorKey: rootNavigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'VenuRite',
      theme: AppTheme.light(brandAccent: brandAccent),
      home: home,
    );
  }
}
