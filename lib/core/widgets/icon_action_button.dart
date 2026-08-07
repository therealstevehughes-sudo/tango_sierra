import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// An icon paired with a visible label underneath — built to fix the
/// logged "bare icon rows" bug (manager_screen.dart / top_screen.dart's
/// icon-only AppBar actions, tooltip only, no visible text — tooltips
/// don't surface on touch devices at all). Component only this sub-sprint;
/// not yet wired into any screen — that's Sub-sprint 2.
class IconActionButton extends StatelessWidget {
  const IconActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 22,
              backgroundColor: AppColors.tealTint,
              foregroundColor: AppColors.tealInk,
              child: Icon(icon, size: 22),
            ),
            const SizedBox(height: 6),
            SizedBox(
              width: 76,
              child: Text(
                label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
