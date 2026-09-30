import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../core/widgets/app_banner.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/repositories/tenant_provisioning_repository.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../l10n/app_localizations.dart';

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
    final l10n = AppLocalizations.of(context)!;
    final daysLeft = invite.expiresAt.difference(DateTime.now()).inDays;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.inviteCreatedTitle),
        actions: const [AssistantIconButton()],
      ),
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
                  child: Text(l10n.shareInviteExpiresText(daysLeft)),
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
                Text(l10n.orShareCodeText),
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
                  child: Text(l10n.doneButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
