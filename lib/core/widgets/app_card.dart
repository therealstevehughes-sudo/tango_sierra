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
  const AppCard({super.key, required this.child, this.padding, this.elevated = false});

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final cardTheme = Theme.of(context).cardTheme;
    final radius = elevated ? 18.0 : 16.0;
    return Container(
      decoration: BoxDecoration(
        color: cardTheme.color ?? AppColors.card,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.line),
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
      child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
    );
  }
}
