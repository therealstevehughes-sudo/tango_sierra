import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/brand_header.dart';

// Sprint 042 (First-Open Experience, 2026-09-21) — shown once per real app
// launch, never on a subsequent logout/login within the same session (see
// MyApp's own doc comment for why that's a state-lifetime decision, not
// this widget's concern). Teal ground, the app mark, gone in ~1.5s —
// deliberately no spinner, no tagline, no interaction: a splash screen's
// only job is to be quick and look considered, not to communicate.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.teal,
      body: Center(
        child: _WhiteVenuRiteMark(),
      ),
    );
  }
}

// The real logo asset (VenuRiteMark) is tuned for a light background —
// on the solid teal splash ground the plain PNG would look muddy, so this
// wraps it in a white rounded card instead of trying to recolour the
// asset itself.
class _WhiteVenuRiteMark extends StatelessWidget {
  const _WhiteVenuRiteMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: const VenuRiteMark(),
    );
  }
}
