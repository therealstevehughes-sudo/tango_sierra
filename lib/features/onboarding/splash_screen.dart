import 'dart:ui';

import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/brand_header.dart';

// Sprint 042 (First-Open Experience, 2026-09-21) — shown once per real app
// launch, never on a subsequent logout/login within the same session (see
// MyApp's own doc comment for why that's a state-lifetime decision, not
// this widget's concern).
//
// Visual pass (2026-09-22, "considered lift" onboarding redesign) — the
// original flat teal ground read as sterile per direct user feedback.
// Replaced with a heavily blurred, teal-duotone kitchen photo behind the
// mark for warmth and depth, plus a gentle fade/scale entrance on the
// logo card — still quick (~1.5s, unchanged), still no spinner/tagline/
// interaction, just less flat.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _opacity = 0;
  double _scale = 0.92;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _opacity = 1;
        _scale = 1;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: Stack(
        fit: StackFit.expand,
        children: [
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Opacity(
              opacity: 0.55,
              child: ColorFiltered(
                colorFilter: const ColorFilter.mode(
                  AppColors.tealInk,
                  BlendMode.multiply,
                ),
                child: Image.asset(
                  'assets/images/kitchen.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.teal.withValues(alpha: 0.75),
                  AppColors.teal.withValues(alpha: 0.9),
                ],
              ),
            ),
          ),
          Center(
            child: AnimatedOpacity(
              opacity: _opacity,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              child: AnimatedScale(
                scale: _scale,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                child: const _WhiteVenuRiteMark(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// The real logo asset (VenuRiteMark) is tuned for a light background —
// on the solid teal splash ground the plain PNG would look muddy, so this
// wraps it in a white rounded card instead of trying to recolour the
// asset itself. Given a soft shadow (2026-09-22) so it reads as raised
// above the new photographic background, not pasted flat onto it.
class _WhiteVenuRiteMark extends StatelessWidget {
  const _WhiteVenuRiteMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 32,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const VenuRiteMark(),
    );
  }
}
