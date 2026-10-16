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

/// Space kept clear above the bottom edge for the AI button (56px button +
/// 16px margin).
const double assistantFabReserve = 72;

/// Wraps every screen (via MaterialApp.builder) to fix two layout problems
/// at once (2026-10-16, founder report from a Samsung phone):
///
///  1. Android 15+ draws apps edge-to-edge, behind the system navigation
///     bar. Many screens have no bottom SafeArea, so their bottom buttons
///     sat under Samsung's nav bar. The real system inset is applied here
///     as physical padding, once, for every screen.
///  2. The AI button floats bottom-right above every screen, on top of
///     screens' own bottom-right "Add" buttons (Menu & Allergens,
///     Suppliers, ...). While it's showing, [assistantFabReserve] is added
///     to MediaQuery's bottom padding, which Scaffold uses to lift its own
///     floating buttons and which SafeArea/ListView use to keep their last
///     content clear of it.
class AppChrome extends ConsumerWidget {
  const AppChrome({super.key, required this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loggedIn = ref.watch(currentUserProvider) != null;
    final mq = MediaQuery.of(context);
    // padding (not viewPadding): drops to 0 while the keyboard is open, so
    // forms don't get a dead strip between the keyboard and content.
    final systemBottom = mq.padding.bottom;
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Stack(
        children: [
          ValueListenableBuilder<int>(
            valueListenable: ModalVisibilityObserver.openModalCount,
            builder: (context, openModals, _) {
              final reserve = loggedIn && openModals == 0
                  ? assistantFabReserve
                  : 0.0;
              return Padding(
                padding: EdgeInsets.only(bottom: systemBottom),
                child: MediaQuery(
                  data: mq.copyWith(
                    padding: mq.padding.copyWith(bottom: reserve),
                    viewPadding: mq.viewPadding.copyWith(bottom: reserve),
                    viewInsets: mq.viewInsets.copyWith(
                      bottom: (mq.viewInsets.bottom - systemBottom)
                          .clamp(0, double.infinity),
                    ),
                  ),
                  child: child ?? const SizedBox.shrink(),
                ),
              );
            },
          ),
          const AssistantFab(),
        ],
      ),
    );
  }
}
