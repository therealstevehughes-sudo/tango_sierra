import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/subscription.dart';
import '../../shared/providers/subscription_providers.dart';
import '../../shared/repositories/subscription_repository.dart';
import '../../shared/services/billing_service.dart';

// GoCardless billing (2026-09-21) -- executive-only (enforced both by
// Venue Details only linking here for that tier, and server-side by
// gocardless-start-mandate itself). Shows the organisation's plan/status
// and, if Direct Debit isn't set up yet, a button that hands off to
// GoCardless's own hosted authorization page in the system browser --
// this app never collects or sees real bank details itself.
class BillingScreen extends ConsumerStatefulWidget {
  const BillingScreen({super.key});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  bool _startingSetup = false;
  String? _error;

  Future<void> _startDirectDebitSetup() async {
    setState(() {
      _startingSetup = true;
      _error = null;
    });
    try {
      final url = await ref
          .read(subscriptionRepositoryProvider)
          .startDirectDebitSetup();
      final launched = await launchUrl(
        Uri.parse(url),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        setState(() => _error = 'Could not open the browser');
      }
    } on DirectDebitSetupException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Could not reach the server');
    } finally {
      if (mounted) setState(() => _startingSetup = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionAsync = ref.watch(currentSubscriptionProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Billing')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: subscriptionAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text('Could not load billing details: $err')),
              data: (subscription) {
                if (subscription == null) {
                  return const AppCard(
                    child: Text('No subscription found for this organisation.'),
                  );
                }
                return ListView(
                  children: [
                    _buildStatusCard(subscription),
                    const SizedBox(height: 16),
                    _buildDirectDebitCard(subscription),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(Subscription subscription) {
    final pricePence = planMonthlyPricePence(subscription.planName);
    final priceLabel = pricePence == null
        ? 'Price not set yet'
        : '£${(pricePence / 100).toStringAsFixed(2)}/month';
    final state = effectiveBillingState(subscription);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            planDisplayName(subscription.planName),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(priceLabel, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 12),
          _StatusBanner(subscription: subscription, state: state),
        ],
      ),
    );
  }

  Widget _buildDirectDebitCard(Subscription subscription) {
    final hasMandate =
        subscription.gocardlessMandateId != null &&
        subscription.mandateStatus == 'active';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Direct Debit', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (hasMandate)
            const Text('Direct Debit is set up for this organisation.')
          else ...[
            const Text(
              "You haven't set up Direct Debit yet. You'll be taken to "
              'GoCardless — VenuRite never sees your bank details directly.',
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: _startingSetup ? null : _startDirectDebitSetup,
              child: _startingSetup
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Set up Direct Debit'),
            ),
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.critical)),
            ],
          ],
        ],
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.subscription, required this.state});

  final Subscription subscription;
  final BillingState state;

  @override
  Widget build(BuildContext context) {
    final (String message, Color color) = switch (state) {
      BillingState.normal when subscription.status == 'trialing' =>
        (
          subscription.trialEndsAt == null
              ? 'On trial'
              : 'On trial until ${_formatDate(subscription.trialEndsAt!)}',
          AppColors.muted,
        ),
      BillingState.normal => ('Active', AppColors.pass),
      BillingState.pastDueGrace => (
        'A recent payment failed. Please update your Direct Debit — '
        'access continues during this grace period.',
        AppColors.caution,
      ),
      BillingState.restricted when subscription.status == 'cancelled' => (
        'Your Direct Debit was cancelled. Access is restricted to '
        'read-only until billing is set up again.',
        AppColors.critical,
      ),
      BillingState.restricted => (
        'Payment has been overdue too long. Access is restricted to '
        'read-only until this is resolved.',
        AppColors.critical,
      ),
    };

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(message, style: TextStyle(color: color)),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';
}
