import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Consistent card structure (DESIGN_SYSTEM_LOCK's Layout Rule) — reads its
/// radius/border colour from the theme's `CardTheme` so both stay in one
/// place, but supplies its own soft, warm-tinted shadow directly (Guided
/// Cards, 2026-09-14) rather than using Material `Card` elevation: a
/// Material elevation shadow is always a neutral grey at a fixed opacity
/// curve, and can't reproduce the mockup's specific tinted, tightly
/// blurred shadow (`0 2px 8px rgba(90,80,60,.06)`) — this widget renders
/// that exact shadow as a real `BoxShadow` instead.
///
/// [elevated] selects the mockup's "primary/elevated card" treatment
/// (18px radius, a stronger shadow) instead of the standard 16px + subtle
/// shadow — e.g. the staff task card, the one card on a screen that
/// should read as the main event.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.elevated = false,
    this.accentColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool elevated;
  // Urgency stripe fix (2026-09-18) — when set, a coloured band runs down
  // the card's left edge, drawn INSIDE this Container and clipped to the
  // same borderRadius as the card itself, so it's part of the card's own
  // rounded frame rather than a separate rectangle painted behind it. The
  // previous approach (a plain rectangular border on a wrapper OUTSIDE
  // this Container) sat behind this Container's own opaque rounded
  // background, which is why it only ever showed as a short, broken
  // sliver in the rounded-corner gap instead of a continuous edge.
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final radius = elevated ? 18.0 : 16.0;
    final content = Padding(
      padding: padding ?? const EdgeInsets.all(16),
      child: child,
    );
    return Container(
      decoration: BoxDecoration(
        color: cardTheme.color ?? AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        // Thicker + darker (2026-09-22, direct user follow-up: "thicker
        // border on the buttons and maybe darker") — 1px was still too
        // faint even after darkening the colour itself; bumped to 1.5px
        // using lineStrong instead of line for a clearer edge on tappable
        // cards/tiles (the staff picker cards, action tiles, etc.).
        border: Border.all(color: AppColors.lineStrong, width: 1.5),
        boxShadow: [
          BoxShadow(
            // 90,80,60 in the source mockup's rgba() shadow == #5A503C.
            color: const Color(0xFF5A503C).withValues(
              alpha: elevated ? 0.08 : 0.06,
            ),
            blurRadius: elevated ? 14 : 8,
            offset: Offset(0, elevated ? 4 : 2),
          ),
        ],
      ),
      margin: cardTheme.margin ?? const EdgeInsets.symmetric(vertical: 6),
      child: accentColor == null
          ? content
          : ClipRRect(
              borderRadius: BorderRadius.circular(radius),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(width: 4, color: accentColor),
                  Expanded(child: content),
                ],
              ),
            ),
    );
  }
}
