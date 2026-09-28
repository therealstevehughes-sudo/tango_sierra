import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// Drop-in replacement for `AppBar` as a Scaffold's `appBar:` (2026-09-28,
/// direct founder request). Two problems this fixes:
///
/// 1. The back button was a bare arrow icon — didn't read as tappable.
///    Here it's a filled circular button instead, still using
///    `Navigator.maybePop` so behavior is unchanged.
/// 2. Every screen title now gets a consistent, bolder style via
///    `titleTextStyle` (a plain `Text('...')` title picks this up
///    automatically, same as it would from `AppBarTheme`).
///
/// Same named parameters as `AppBar` for the ones this codebase actually
/// uses, so most call sites are a straight `AppBar(` → `AppScreenHeader(`
/// rename. Pair this with the loading-guard rule: a screen's `build()`
/// must return its real `Scaffold` (with this header) even while data is
/// still loading — swap only the *body* for a spinner — so a stuck load
/// never strands the user on a header-less blank screen with no way back.
class AppScreenHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppScreenHeader({
    super.key,
    required this.title,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.foregroundColor,
    this.elevation,
    this.bottom,
    this.centerTitle,
  });

  final Widget title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool automaticallyImplyLeading;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? elevation;
  final PreferredSizeWidget? bottom;
  final bool? centerTitle;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final effectiveLeading =
        leading ??
        (automaticallyImplyLeading && canPop ? const _StyledBackButton() : null);

    return AppBar(
      leading: effectiveLeading,
      automaticallyImplyLeading: leading == null && effectiveLeading == null
          ? automaticallyImplyLeading
          : false,
      title: title,
      titleTextStyle: const TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 20,
        color: AppColors.ink,
      ),
      actions: actions,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      elevation: elevation,
      bottom: bottom,
      centerTitle: centerTitle,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

class _StyledBackButton extends StatelessWidget {
  const _StyledBackButton();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Center(
        child: Material(
          color: AppColors.tealTint,
          shape: const CircleBorder(),
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: () => Navigator.of(context).maybePop(),
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.tealInk,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
