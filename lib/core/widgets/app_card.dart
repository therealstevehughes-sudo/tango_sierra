import 'package:flutter/material.dart';

/// Consistent card structure (DESIGN_SYSTEM_LOCK's Layout Rule) — reads its
/// look from the theme's `CardTheme`; this widget just standardises the
/// internal padding every screen otherwise re-decides for itself.
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(padding: padding ?? const EdgeInsets.all(16), child: child),
    );
  }
}
