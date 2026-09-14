import 'package:flutter/material.dart';

/// Guided Cards (2026-09-14) — replaces the Sprint 031 "Clinical but warm"
/// neutral palette with the warmer, rounder direction extracted verbatim
/// from the approved `VenuRite_Design_Mockups.html` (Style B). See
/// DECISIONS_LOG.md's "Guided Cards visual design spec" entry for the full
/// source values. The accent teal and all three state colours
/// (pass/caution/critical) are UNCHANGED — confirmed pixel-identical to
/// the mockup's own hex values — only the neutrals below moved.
class AppColors {
  AppColors._();

  // Brand / accent — used sparingly: primary actions, active states.
  static const Color teal = Color(0xFF0E6E77);
  static const Color tealInk = Color(0xFF0A555C);
  static const Color tealTint = Color(0xFFEEF4F5);
  static const Color onTeal = Color(0xFFFFFFFF);

  // Neutrals — Guided Cards' warmer, softer set (was #211E1A/#FAF8F5/
  // #E7E2DB/#D6CFC3/#6B6459 under the old "Clinical but warm" palette).
  static const Color ink = Color(0xFF2D2A26);
  static const Color paper = Color(0xFFF7F5F2);
  static const Color card = Color(0xFFFFFFFF);
  static const Color line = Color(0xFFF0ECE6);
  static const Color lineStrong = Color(0xFFECE8E2);
  static const Color muted = Color(0xFF6A635A);
  // New with Guided Cards — secondary/tertiary text tones the old palette
  // didn't distinguish (subtitles vs. list-row timestamps vs. primary
  // muted text all used the same `muted` before).
  static const Color mutedLight = Color(0xFF8A8178);
  static const Color mutedFaint = Color(0xFFA59C92);
  // List-row divider — lighter than a card's own border (`line`), for
  // rows *inside* a card rather than the card's outer edge.
  static const Color divider = Color(0xFFF6F3EF);

  // State colours — deliberately separate from the teal accent above.
  // Never used alone: always paired with an icon and a short word (see
  // StatusBadge).
  static const Color pass = Color(0xFF1E7A4C);
  static const Color passBg = Color(0xFFE4F1E8);
  // Darkened from the original #B5720A (2026-09-03): the original failed
  // WCAG AA for normal text (3.4-3.9:1 depending on background — the icon
  // and large-text cases were fine, but StatusBadge's 14px label wasn't).
  // This shade clears 4.5:1 against cautionBg/paper/card while staying
  // unmistakably amber, not drifting toward brown or red.
  static const Color caution = Color(0xFF976008);
  static const Color cautionBg = Color(0xFFFBEDD8);
  static const Color critical = Color(0xFFB23A2E);
  static const Color criticalBg = Color(0xFFF8E1DE);
}
