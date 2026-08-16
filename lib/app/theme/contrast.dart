import 'package:flutter/material.dart';

// Branding (Sprint 031, finalized beta build order item 7) — contrast-safety
// for an arbitrary brand accent colour used as a button/chip background.
// Uses Flutter's own Color.computeLuminance() (relative luminance per
// WCAG 2.0) — no new dependency. Picks whichever of black/white gives the
// HIGHER contrast ratio against the given background, rather than a single
// luminance threshold guess, so it's always the better of the two options
// for any colour, not just colours on one side of an arbitrary cutoff.
double contrastRatio(Color a, Color b) {
  final l1 = a.computeLuminance() + 0.05;
  final l2 = b.computeLuminance() + 0.05;
  return l1 > l2 ? l1 / l2 : l2 / l1;
}

/// The higher-contrast of black/white against [background].
///
/// This choice is provably safe for ANY background colour, not just the
/// curated presets: picking the better of two extremes (pure black, pure
/// white) mathematically guarantees a contrast ratio of at least √21 ≈
/// 4.58:1 against whichever background is given — the worst case occurs
/// where both candidates tie, at background luminance (√21 − 1)/20, and
/// even there the guaranteed ratio already clears WCAG AA for both large
/// UI text (3:1) and normal body text (4.5:1). There is no background
/// colour for which this function produces unreadable text, so no
/// separate "low contrast" warning is needed on top of it.
Color readableForegroundOn(Color background) {
  final contrastWithBlack = contrastRatio(background, Colors.black);
  final contrastWithWhite = contrastRatio(background, Colors.white);
  return contrastWithBlack >= contrastWithWhite ? Colors.black : Colors.white;
}
