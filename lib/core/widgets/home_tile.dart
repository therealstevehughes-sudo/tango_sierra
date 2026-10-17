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
    // Lighter design (2026-10-17 founder feedback: "quite bulky") — compact
    // padding, the icon in a small soft chip, medium-weight labels and a
    // soft shadow in place of a heavy outline.
    final fg = primary ? AppColors.onTeal : AppColors.ink;
    final radius = BorderRadius.circular(16);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: primary ? AppColors.teal : AppColors.card,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: Container(
            constraints: BoxConstraints(minHeight: tall ? 104 : 88),
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: primary
                            ? const Color(0x26FFFFFF)
                            : AppColors.tealTint,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        icon,
                        size: 19,
                        color: primary ? fg : AppColors.teal,
                      ),
                    ),
                    const Spacer(),
                    if (badge != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
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
                            fontWeight: FontWeight.w600,
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
                const SizedBox(height: 10),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: tall ? 17 : 15,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.25,
                      color: primary ? AppColors.tealTint : AppColors.muted,
                    ),
                  ),
                ],
              ],
            ),
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
      for (final w in wide) ...[w, const SizedBox(height: 10)],
    ];
    for (var i = 0; i < children.length; i += 2) {
      rows.add(
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: children[i]),
              const SizedBox(width: 10),
              Expanded(
                child: i + 1 < children.length
                    ? children[i + 1]
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
      rows.add(const SizedBox(height: 10));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: rows,
    );
  }
}
