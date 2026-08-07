import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';

/// A small uppercase section label — built to fix the logged "Task
/// Presets: no grouping between equipment-type and section presets" bug
/// (preset_management_screen.dart's flat, undifferentiated list).
/// Component only this sub-sprint; not yet wired into any screen — that's
/// Sub-sprint 2.
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
          color: AppColors.muted,
        ),
      ),
    );
  }
}
