import 'dart:io';

import 'package:flutter/material.dart';

import '../../shared/models/branding_config.dart';

/// Shared branded header (2026-09-13, v2): the client's company logo and
/// branch name sit front and centre as the dominant element — staff identify
/// with *their* venue, not the software vendor. The VenuRite square mark
/// sits top-left as a "built with" signature (72px per user request,
/// full opacity).
///
/// Used at the top of:
/// - the login screen (pre-auth — shows the default organisation's
///   branding, no branch context yet);
/// - tier-home (post-auth — shows the signed-in organisation's branding
///   and the current branch's name).
///
/// Pure presentation: reads state already resolved by the caller
/// (`BrandingConfig` + optional site/branch name); no auth, repo, or
/// backend behavior here.
class BrandHeader extends StatelessWidget {
  const BrandHeader({
    super.key,
    required this.branding,
    this.siteName,
    this.showAppMark = true,
  });

  /// The organisation's current `BrandingConfig`, or null when none is set
  /// yet (falls back to the app mark alone).
  final BrandingConfig? branding;

  /// Optional branch (site) name rendered under the client branding — e.g.
  /// "Manchester Kitchen". Null on the pre-auth login screen.
  final String? siteName;

  /// False when the caller places `VenuRiteMark` itself, elsewhere on the
  /// screen (2026-09-14: tier-home now anchors it to the true top-left
  /// corner of the screen rather than the branding card's own inset
  /// corner — placing it here too would double it up).
  final bool showAppMark;

  @override
  Widget build(BuildContext context) {
    final logo = branding;
    final clientLogoPath = logo?.logoPath;

    // IntrinsicHeight forces the Stack below to take a real, finite height
    // (derived from its content) instead of the infinite height a Column
    // hands its children by default — without this, the Stack's `Center`
    // child tries to expand to fill unbounded space and Flutter throws
    // "A Stack requires bounded constraints from its parent" the instant
    // this header is placed inside login_screen.dart's/tier_home_screen
    // .dart's Column (a real crash on every launch, found while verifying
    // the app runs, not caught by `flutter analyze` or the widget tests
    // since it's a runtime layout failure, not a static or logic one).
    return IntrinsicHeight(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
        // VenuRite app mark — top-left signature, now 72px (doubled from
        // 36px per user request, 2026-09-13) and full opacity so it stays
        // visible without dominating over the client's brand.
        if (showAppMark)
          const Positioned(top: 0, left: 0, child: VenuRiteMark()),
        // Client branding — centred as the main header element. When a
        // Director has set branding, this shows the company name, client
        // logo (64px, sizing confirmed via brain stand-in 2026-09-13),
        // and branch name. Without branding, nothing renders (the login
        // screen's own "Welcome to VenuRite" text handles that case).
        if (logo != null || siteName != null)
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (clientLogoPath != null) ...[
                  Image.file(
                    File(clientLogoPath),
                    height: 64,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 8),
                ],
                if (logo?.companyName != null) ...[
                  Text(
                    logo!.companyName!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
                if (siteName != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    siteName!,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ],
            ),
          ),
      ],
      ),
    );
  }
}

/// The VenuRite square mark alone — extracted from `BrandHeader`
/// (2026-09-14) so a screen can anchor it independently of the client
/// branding card (see `BrandHeader.showAppMark`). Same 72px/full-opacity
/// treatment either way.
class VenuRiteMark extends StatelessWidget {
  const VenuRiteMark({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/logos/VR_square.png',
      height: 72,
      fit: BoxFit.contain,
    );
  }
}
