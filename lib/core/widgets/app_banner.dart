import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

enum BannerKind { caution, critical }

/// A consistent icon + tinted-background alert banner — replaces three
/// near-duplicate ad hoc implementations (manager screen's session
/// summaries/trigger notifications, task presets' verification notice)
/// that each hand-rolled their own `Container` with raw Material colours.
/// Content is fully caller-defined (a single line or a titled list) — this
/// widget only owns the icon/colour/tint chrome, per `StatusBadge`'s same
/// switch-expression pattern.
class AppBanner extends StatelessWidget {
  const AppBanner({super.key, required this.kind, required this.child});

  final BannerKind kind;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // Same icon language as StatusBadge for the same semantic colours —
    // caution/critical should look like the same "kind" of thing wherever
    // they appear, not just share a hue.
    final (Color fg, Color bg, IconData icon) = switch (kind) {
      BannerKind.caution => (
        AppColors.caution,
        AppColors.cautionBg,
        Icons.error_outline,
      ),
      BannerKind.critical => (
        AppColors.critical,
        AppColors.criticalBg,
        Icons.cancel_outlined,
      ),
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg, size: 20),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}
