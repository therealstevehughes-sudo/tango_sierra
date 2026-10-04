import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/navigator_key.dart';
import '../../features/help/help_screen.dart';
import '../../shared/providers/auth_providers.dart';

/// Tracks dialogs/modal bottom sheets open on the root navigator, so
/// [AssistantFab] — painted as a sibling above the *entire* Navigator via
/// MaterialApp.builder, not as a per-Scaffold floatingActionButton — knows
/// to hide itself instead of floating on top of a modal's scrim. A normal
/// per-Scaffold FAB doesn't need this (the Overlay a dialog/sheet uses
/// already paints above it); a single app-root FAB does, since it sits
/// above that same Overlay in paint order.
class ModalVisibilityObserver extends NavigatorObserver {
  static final ValueNotifier<int> openModalCount = ValueNotifier(0);

  void _trackPush(Route<dynamic> route) {
    if (route is PopupRoute) openModalCount.value++;
  }

  void _trackPop(Route<dynamic> route) {
    if (route is PopupRoute && openModalCount.value > 0) {
      openModalCount.value--;
    }
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _trackPush(route);

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _trackPop(route);

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) =>
      _trackPop(route);
}

/// The one floating AI-assistant entry point (2026-10-03 redesign,
/// replacing the old per-screen [AssistantIconButton]) — a single button
/// painted once at the app root (MaterialApp.builder), bottom-right of
/// every screen, rather than an icon repeated in ~60 screens' own AppBar
/// actions. Hidden pre-login (HelpScreen assumes a signed-in user) and
/// while any dialog/bottom sheet is open.
class AssistantFab extends ConsumerWidget {
  const AssistantFab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    if (currentUser == null) return const SizedBox.shrink();

    return ValueListenableBuilder<int>(
      valueListenable: ModalVisibilityObserver.openModalCount,
      builder: (context, openModals, _) {
        if (openModals > 0) return const SizedBox.shrink();
        return Positioned(
          right: 16,
          bottom: 16 + MediaQuery.of(context).padding.bottom,
          child: FloatingActionButton(
            heroTag: 'assistantFab',
            // rootNavigatorKey, not Navigator.of(context) — this widget is
            // painted as a SIBLING of the Navigator (MaterialApp.builder's
            // `child` is the already-built Navigator subtree; this FAB
            // sits next to it in the returned Stack, not inside it), so
            // there is no Navigator ancestor reachable from this context
            // at all. Found via a real bug report: the button rendered
            // and was tappable, but tapping it did nothing — the push
            // silently failed because Navigator.of() had no Navigator to
            // find. Same fix ManagementDrawer already uses for the exact
            // same reason (see navigator_key.dart's own doc comment).
            onPressed: () => rootNavigatorKey.currentState!.push(
              MaterialPageRoute(builder: (_) => const HelpScreen()),
            ),
            child: const Icon(Icons.auto_awesome),
          ),
        );
      },
    );
  }
}
