import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';

/// Sprint 034 — shown after successfully creating an invite (Regions,
/// Branches, Staff management). Displays the real single-use token both
/// as text (to copy/paste into WhatsApp, email, etc.) and as a QR code
/// (so the new person can just scan it with the app's camera instead of
/// typing a long code by hand — the user's explicit request). Purely a
/// display screen: the invite already exists server-side by the time
/// this shows.
class InviteCodeScreen extends StatelessWidget {
  const InviteCodeScreen({super.key, required this.invite});

  final OrganisationInviteResult invite;

  @override
  Widget build(BuildContext context) {
    final daysLeft = invite.expiresAt.difference(DateTime.now()).inDays;
    return Scaffold(
      appBar: AppBar(title: const Text('Invite created')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 420,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppBanner(
                  kind: BannerKind.info,
                  child: Text(
                    'Share this with the person joining — it works once '
                    'and expires in $daysLeft day${daysLeft == 1 ? '' : 's'}.',
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: QrImageView(
                      data: invite.token,
                      size: 220,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Or share this code — they enter it on the "Join '
                  'existing company" screen:',
                ),
                const SizedBox(height: 8),
                SelectableText(
                  invite.token,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(fontFamily: 'monospace'),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Done'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
