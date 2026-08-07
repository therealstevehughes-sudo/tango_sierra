import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

/// The app's Material theme — visual/UX pass, Sub-sprint 1. Encodes
/// DESIGN_SYSTEM_LOCK.md's rules as real component themes (strong primary
/// button, consistent card structure, generous spacing, large touch
/// targets) rather than leaving every screen to reproduce them ad hoc, per
/// ARCHITECTURE_LOCK.md's Design Rule and Component Consistency Rule.
/// Light-only for now — no dark mode exists anywhere in this app yet.
class AppTheme {
  AppTheme._();

  static ThemeData get light {
    final textTheme = AppTextTheme.textTheme;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: const ColorScheme.light(
        primary: AppColors.teal,
        onPrimary: AppColors.onTeal,
        secondary: AppColors.tealInk,
        onSecondary: AppColors.onTeal,
        surface: AppColors.card,
        onSurface: AppColors.ink,
        error: AppColors.critical,
        onError: Colors.white,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.card,
        foregroundColor: AppColors.ink,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.line),
        ),
      ),
      // Strong primary button (Layout Rule) with a real touch-target floor
      // for wet hands / time pressure — 56dp, not Material's smaller
      // default. `Size(64, 56)`, not `Size.fromHeight(56)` — the latter
      // sets minimum WIDTH to infinity, which crashes with "BoxConstraints
      // forces an infinite width" the moment an ElevatedButton is placed
      // inside a Row (unconstrained main-axis width), found during the
      // full-app visual/UX audit on the task screen's PASS/FAIL buttons.
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.onTeal,
          disabledBackgroundColor: AppColors.lineStrong,
          disabledForegroundColor: AppColors.muted,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tealInk,
          minimumSize: const Size(48, 48),
          textStyle: textTheme.labelLarge?.copyWith(fontSize: 14),
        ),
      ),
      iconTheme: const IconThemeData(color: AppColors.ink),
      // No tiny icon-only critical actions (Prohibited Drift) — 48dp floor.
      iconButtonTheme: const IconButtonThemeData(
        style: ButtonStyle(
          minimumSize: WidgetStatePropertyAll(Size(48, 48)),
          foregroundColor: WidgetStatePropertyAll(AppColors.ink),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.tealTint,
        labelStyle: textTheme.bodySmall?.copyWith(
          color: AppColors.tealInk,
          fontWeight: FontWeight.w600,
        ),
        side: BorderSide.none,
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.line,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.paper,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.teal, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
