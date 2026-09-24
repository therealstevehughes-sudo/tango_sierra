import 'package:flutter/material.dart';

import '../../shared/models/job_role.dart';

// Visual pass experiment (2026-09-22, direct user request) — a faint
// (10% — started at 5%, user asked to bump it after trying it) full-bleed
// department photo behind a screen's content, never behind
// buttons/cards themselves (those stay on the solid AppColors.paper ground
// via their own opaque backgrounds — this paints UNDER everything, at the
// Scaffold body level, so it never affects legibility or contrast). Trying
// this on the two daily hub screens first, per the user's own "can we try
// it to see" — not yet a decided app-wide pattern.
//
// Section image choice is a simple, deliberately coarse guess from the
// signed-in user's own JobRole — the app has no per-screen "department"
// concept yet (departments are free-text/org-managed, not a fixed enum;
// see Department model), so this is the best available signal, not a
// real section-aware system. Revisit once/if the departments sprint
// (Maintenance/Housekeeping/Reception/Security) adds real per-user
// section assignment.
String sectionBackgroundImageFor(JobRole? jobRole) {
  switch (jobRole) {
    case JobRole.frontOfHouse:
    case JobRole.bar:
    case JobRole.reception:
      return 'assets/images/front_of_house.png';
    case JobRole.maintenance:
      return 'assets/images/maintenance.png';
    case JobRole.housekeeping:
      return 'assets/images/housekeeping.png';
    case JobRole.security:
      return 'assets/images/security.png';
    case JobRole.chefCook:
    case JobRole.kitchenPorter:
    case JobRole.management:
    case JobRole.everyone:
    case null:
      return 'assets/images/kitchen.png';
  }
}

class SectionBackground extends StatelessWidget {
  const SectionBackground({super.key, required this.jobRole, this.opacity = 0.10});

  final JobRole? jobRole;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            sectionBackgroundImageFor(jobRole),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
