import 'package:flutter/material.dart';

// Responsive foundation (mobile build, step 1) — the breakpoint and content
// wrapper every screen in this app should use going forward, so the next
// ~17 screens copy one established pattern rather than each inventing its
// own width handling.
//
// The 600dp boundary is Material's own compact/medium breakpoint, not a
// number invented for this app — phone portrait falls below it, tablet
// landscape and desktop sit above it.
class Breakpoints {
  Breakpoints._();
  static const double compact = 600;
}

bool isCompactWidth(BuildContext context) =>
    MediaQuery.sizeOf(context).width < Breakpoints.compact;

/// Wraps a screen's main content so it never stretches uncomfortably wide
/// on a tablet-landscape or desktop window. Below the compact breakpoint,
/// [child] fills the available width unchanged (a phone doesn't need
/// centering — it already is the comfortable width). At or above it,
/// [child] is constrained to [maxWidth] and centered, the same way a
/// single-column form or list reads better centered on a wide screen than
/// stretched edge to edge.
///
/// This does not change [child]'s own internal layout (scrolling,
/// wrapping, flex behaviour) — it only constrains the width [child] is
/// given. A screen that already overflows narrow widths needs its own
/// fix; this widget only addresses "too wide," not "too narrow."
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    super.key,
    required this.child,
    this.maxWidth = 480,
    this.alignment = Alignment.topCenter,
  });

  final Widget child;
  final double maxWidth;
  // topCenter suits a scrollable list/form (the content's own natural
  // height varies, so pinning it to the top reads correctly at any window
  // height). A short, fixed-height form that isn't scrollable — a login
  // screen, say — wants full `Alignment.center` instead, so it isn't stuck
  // awkwardly at the top of a tall tablet/desktop window.
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    if (isCompactWidth(context)) return child;
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
