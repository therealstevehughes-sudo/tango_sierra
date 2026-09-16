import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/services/push_token_service.dart';
import '../features/auth/login_screen.dart';
import '../features/home/tier_home_screen.dart';
import '../features/tasks/worker_hub_screen.dart';
import '../shared/models/user.dart';
import '../shared/providers/auth_providers.dart';
import '../shared/providers/branding_providers.dart';
import 'theme/app_theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
    if (currentUser == null) {
      home = const LoginScreen();
    } else if (currentUser.roleTier == RoleTier.base) {
      home = const WorkerHubScreen();
    } else {
      home = const TierHomeScreen();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VenuRite',
      theme: AppTheme.light(brandAccent: brandAccent),
      home: home,
    );
  }
}
