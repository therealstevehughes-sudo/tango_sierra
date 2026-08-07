import 'package:flutter/material.dart';

/// Visual/UX pass, Sub-sprint 1 — the signed-off visual-direction proposal,
/// encoded as real tokens instead of per-screen literals. "Clinical but
/// warm": a hygiene-teal accent used only where something is actionable,
/// warm neutrals instead of clinical blue-white/cold grey, and three state
/// colours kept strictly separate from the accent so colour never competes
/// with itself.
class AppColors {
  AppColors._();

  // Brand / accent — used sparingly: primary actions, active states.
  static const Color teal = Color(0xFF0E6E77);
  static const Color tealInk = Color(0xFF0A555C);
  static const Color tealTint = Color(0xFFE4EFEF);
  static const Color onTeal = Color(0xFFFFFFFF);

  // Neutrals — warm-biased, not cold/clinical grey.
  static const Color ink = Color(0xFF211E1A);
  static const Color paper = Color(0xFFFAF8F5);
  static const Color card = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFE7E2DB);
  static const Color lineStrong = Color(0xFFD6CFC3);
  static const Color muted = Color(0xFF6B6459);

  // State colours — deliberately separate from the teal accent above.
  // Never used alone: always paired with an icon and a short word (see
  // StatusBadge).
  static const Color pass = Color(0xFF1E7A4C);
  static const Color passBg = Color(0xFFE4F1E8);
  static const Color caution = Color(0xFFB5720A);
  static const Color cautionBg = Color(0xFFFBEDD8);
  static const Color critical = Color(0xFFB23A2E);
  static const Color criticalBg = Color(0xFFF8E1DE);
}
