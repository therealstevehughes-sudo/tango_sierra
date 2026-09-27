import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/providers/auth_providers.dart' show backendDataEnabledProvider;
import '../../shared/providers/site_providers.dart' show organisationRepositoryProvider;
import 'roster_billing_service.dart';

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
        builder: (context) => AlertDialog(
          title: const Text('Enable Roster?'),
          content: Text(
            'Based on your current staff numbers, this will add '
            '${quote.formatted} to your monthly Direct Debit, starting '
            'with your next payment.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm and enable'),
            ),
          ],
        ),
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
        SnackBar(content: Text('Could not reach VenuRite: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Roster')),
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
                'Let staff claim their own shifts',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Post open shifts and let staff pick them up themselves - '
                'no more phone-round or WhatsApp group when someone can\'t '
                'make it in. Staff can also request days off, and you '
                'approve or decline from the same place.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 24),
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Pricing',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('£6/month per branch with fewer than 10 staff'),
                    const Text('£10/month per branch with 10 or more staff'),
                    const SizedBox(height: 8),
                    Text(
                      'Added to your existing Direct Debit - no new payment '
                      'method needed. You\'ll see the exact amount before '
                      'confirming.',
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
                    : const Text('Enable Roster'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
