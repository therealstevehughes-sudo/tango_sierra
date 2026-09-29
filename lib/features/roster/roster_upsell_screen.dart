import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart' show backendDataEnabledProvider;
import '../../shared/providers/site_providers.dart' show organisationRepositoryProvider;
import 'roster_billing_service.dart';
import '../../core/widgets/app_screen_header.dart';

// Roster add-on upsell (2026-09-27) — what a locked drawer entry (see
// management_drawer.dart's _LockedNavTile) opens instead of the real
// screen. Real UX principle behind this whole feature: a manager who's
// never heard of Roster should DISCOVER it exists via a normal-looking
// (if visibly locked) menu item, land here to actually understand what
// it does and what it costs, then make one deliberate, informed purchase
// decision — never a silent free flip of a hidden setting.
class RosterUpsellScreen extends ConsumerStatefulWidget {
  const RosterUpsellScreen({super.key});

  @override
  ConsumerState<RosterUpsellScreen> createState() =>
      _RosterUpsellScreenState();
}

class _RosterUpsellScreenState extends ConsumerState<RosterUpsellScreen> {
  bool _busy = false;

  Future<void> _enable() async {
    final backendEnabled = ref.read(backendDataEnabledProvider);
    setState(() => _busy = true);

    if (!backendEnabled) {
      // Local/demo install — no real billing system exists at all, so
      // there's nothing to charge. Matches how every other local-only
      // feature in this app behaves (e.g. Billing itself hides for local
      // installs elsewhere).
      final org = await ref.read(organisationRepositoryProvider).getDefault();
      await ref
          .read(organisationRepositoryProvider)
          .setRosterAddonEnabled(org.id, true);
      if (!mounted) return;
      setState(() => _busy = false);
      Navigator.pop(context, true);
      return;
    }

    try {
      final quote = await ref.read(rosterBillingServiceProvider).getQuote();
      if (!mounted) return;
      setState(() => _busy = false);

      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.enableRosterQuestion),
            content: Text(l10n.rosterQuoteBody(quote.formatted)),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l10n.confirmAndEnable),
              ),
            ],
          );
        },
      );
      if (confirmed != true) return;

      setState(() => _busy = true);
      final error = await ref.read(rosterBillingServiceProvider).enable();
      if (!mounted) return;
      setState(() => _busy = false);

      if (error != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error)));
        return;
      }
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!.couldNotReachVenurite('$e'),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.rosterSection)),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 480,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Icon(
                Icons.event_available_outlined,
                size: 48,
                color: AppColors.tealInk,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.letStaffClaimShifts,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.rosterPitchBody,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.pricingLabel,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.priceUnder10Staff),
                    Text(l10n.price10PlusStaff),
                    const SizedBox(height: 8),
                    Text(
                      l10n.addedToDirectDebitNote,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.muted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _busy ? null : _enable,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.enableRosterButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
