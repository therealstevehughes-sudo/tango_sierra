import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';
import 'contrast.dart';

/// The app's Material theme — visual/UX pass, Sub-sprint 1; made brandable
/// in Sprint 031 (finalized beta build order item 7). Encodes
/// DESIGN_SYSTEM_LOCK.md's rules as real component themes (strong primary
/// button, consistent card structure, generous spacing, large touch
/// targets) rather than leaving every screen to reproduce them ad hoc, per
/// ARCHITECTURE_LOCK.md's Design Rule and Component Consistency Rule.
/// Light-only for now — no dark mode exists anywhere in this app yet.
///
/// NON-NEGOTIABLE (confirmed before building): [brandAccent] only ever
/// feeds the theme's primary/accent palette below. AppColors.pass/caution/
/// critical (and their Bg tints) are never referenced anywhere in this
/// file — StatusBadge/AppBanner/MetricChip read those three constants
/// directly, completely bypassing ThemeData, so there is no code path
/// through which a brand colour could reach a safety colour. A venue
/// picking a red brand colour changes button backgrounds; it cannot make a
/// "critical" alert less visible, since that alert's colour was never a
/// function of this parameter to begin with.
class AppTheme {
  AppTheme._();

  static ThemeData light({Color? brandAccent}) {
    final textTheme = AppTextTheme.textTheme;
    final accent = brandAccent ?? AppColors.teal;
    final onAccent = readableForegroundOn(accent);
    final accentTint = Color.alphaBlend(
      accent.withValues(alpha: 0.12),
      AppColors.paper,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.paper,
      colorScheme: ColorScheme.light(
        primary: accent,
        onPrimary: onAccent,
        secondary: accent,
        onSecondary: onAccent,
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
      // Guided Cards: 16px radius (was 10px), no Material elevation — the
      // soft warm-tinted shadow (rgba(90,80,60,.06) in the source mockup)
      // is applied by AppCard itself via a real BoxShadow, since Material
      // elevation shadows can't reproduce a specific tinted, tightly
      // blurred CSS box-shadow. `elevation: 0` here is deliberate, not a
      // leftover — AppCard supplies its own shadow instead.
      cardTheme: CardThemeData(
        color: AppColors.card,
        elevation: 0,
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
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
          backgroundColor: accent,
          foregroundColor: onAccent,
          disabledBackgroundColor: AppColors.lineStrong,
          disabledForegroundColor: AppColors.muted,
          textStyle: textTheme.labelLarge,
          minimumSize: const Size(64, 56),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          // Guided Cards: 16px (was 8px), matching the mockup's primary
          // action button radius.
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
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
        backgroundColor: accentTint,
        labelStyle: textTheme.bodySmall?.copyWith(
          color: accent,
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
          borderSide: BorderSide(color: accent, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
    );
  }
}
