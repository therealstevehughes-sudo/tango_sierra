import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

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
    this.onLogout,
    this.extraMenuItems,
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

  /// When set, a single "⋮" overflow menu is appended to [actions] with a
  /// "Log out" entry that calls this. Consolidates what used to be a
  /// `TextButton.icon(icon: logout, label: 'Log out')` repeated directly
  /// in a screen's own actions list (2026-10-03, direct founder feedback:
  /// the header was "far too crowded" with that plus the AI icon, the
  /// language icon, and End shift all sitting in a row).
  final VoidCallback? onLogout;

  /// Extra entries (e.g. "End shift", "Change language") folded into the
  /// same overflow menu as [onLogout], so a screen with several secondary
  /// actions still shows only one icon in the header. Each item's `value`
  /// is the callback to run when tapped.
  final List<PopupMenuItem<VoidCallback>>? extraMenuItems;

  @override
  Widget build(BuildContext context) {
    final canPop = ModalRoute.of(context)?.canPop ?? false;
    final effectiveLeading =
        leading ??
        (automaticallyImplyLeading && canPop ? const _StyledBackButton() : null);
    final hasOverflowMenu =
        onLogout != null || (extraMenuItems?.isNotEmpty ?? false);

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
      actions: [
        ...?actions,
        if (hasOverflowMenu)
          PopupMenuButton<VoidCallback>(
            icon: const Icon(Icons.more_vert),
            onSelected: (action) => action(),
            itemBuilder: (context) => [
              ...?extraMenuItems,
              if (onLogout != null)
                PopupMenuItem<VoidCallback>(
                  value: onLogout,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.logout, size: 18),
                      const SizedBox(width: 12),
                      Text(AppLocalizations.of(context)!.logOut),
                    ],
                  ),
                ),
            ],
          ),
      ],
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
