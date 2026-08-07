import 'package:flutter/material.dart';

import 'app_colors.dart';

/// The signed-off type scale (task title 28/600, section header 20/600,
/// body 16/400, button 16/600, caption 14/400 floor) — deliberately built
/// on Flutter's own default per-platform system font (Roboto/Segoe UI/San
/// Francisco/etc.), not a bundled custom typeface. Per explicit instruction
/// during Sub-sprint 1's build: a device-agnostic font that can never fail
/// to load or need a network fetch matters more here than the specific
/// typeface the visual-direction proposal originally showed — this
/// supersedes that one detail of the proposal, not the palette or scale.
class AppTextTheme {
  AppTextTheme._();

  /// Numeric readouts (temperatures, PINs, timestamps) get tabular figures
  /// so digits line up in columns, without needing a dedicated mono font —
  /// tabular figures are a standard OpenType feature most system UI fonts
  /// already support.
  static const List<FontFeature> _tabularFigures = [
    FontFeature.tabularFigures(),
  ];

  static TextStyle numeric({
    double fontSize = 22,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
  }) {
    return TextStyle(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color ?? AppColors.ink,
      fontFeatures: _tabularFigures,
    );
  }

  static TextTheme get textTheme => const TextTheme(
    // Task title — the one-thing-at-a-time staff screen's headline.
    headlineMedium: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      color: AppColors.ink,
    ),
    // Section header.
    titleLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.ink,
    ),
    // Body — the 16px floor for real reading content.
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    ),
    // Button label.
    labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    // Caption / metadata — 14px floor, nothing smaller for real content.
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: AppColors.muted,
    ),
  );
}
