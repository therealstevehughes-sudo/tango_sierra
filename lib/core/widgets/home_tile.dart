import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// A big home-screen tile (2026-10-17 menu redesign): staff and
/// supervisors get these instead of a side menu — one tap to the job.
class HomeTile extends StatelessWidget {
  const HomeTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.subtitle,
    this.badge,
    this.primary = false,
    this.tall = false,
    this.badgeAlert = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? badge;
  final bool primary;
  final bool tall;

  /// Badge in the caution colour (something needs doing) rather than neutral.
  final bool badgeAlert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final fg = primary ? AppColors.onTeal : AppColors.ink;
    return Material(
      color: primary ? AppColors.teal : AppColors.card,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(minHeight: tall ? 140 : 112),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: primary ? null : Border.all(color: AppColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 28, color: primary ? fg : AppColors.teal),
                  const Spacer(),
                  if (badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: primary
                            ? AppColors.card
                            : badgeAlert
                            ? AppColors.cautionBg
                            : AppColors.tealTint,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        badge!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: primary
                              ? AppColors.tealInk
                              : badgeAlert
                              ? AppColors.caution
                              : AppColors.tealInk,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: TextStyle(
                  fontSize: tall ? 22 : 18,
                  fontWeight: FontWeight.w700,
                  color: fg,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 13,
                    color: primary ? AppColors.tealTint : AppColors.muted,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Two-column tile grid that stays two columns on phones and caps width on
/// tablets/desktop.
class HomeTileGrid extends StatelessWidget {
  const HomeTileGrid({super.key, required this.children, this.wide = const []});

  final List<Widget> children;

  /// Tiles that span the full width, shown first.
  final List<Widget> wide;

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[
      for (final w in wide) ...[w, const SizedBox(height: 12)],
    ];
    for (var i = 0; i < children.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 12),
              Expanded(
                child: i + 1 < children.length
                    ? children[i + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: 12));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
