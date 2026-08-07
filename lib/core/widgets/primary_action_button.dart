import 'package:flutter/material.dart';

/// The app's one consistent "strong primary button" (DESIGN_SYSTEM_LOCK's
/// Layout Rule) — large, high-contrast, always the same shape. Reads its
/// look entirely from the theme's `ElevatedButtonTheme`; this widget exists
/// so every screen calls one thing instead of re-deriving the style,
/// per the Component Consistency Rule.
class PrimaryActionButton extends StatelessWidget {
  const PrimaryActionButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon != null) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
      );
    }
    return ElevatedButton(onPressed: onPressed, child: Text(label));
  }
}
