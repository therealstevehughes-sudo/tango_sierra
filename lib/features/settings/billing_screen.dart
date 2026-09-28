import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/subscription.dart';
import '../../shared/providers/subscription_providers.dart';
import '../../shared/repositories/subscription_repository.dart';
import '../../shared/services/billing_service.dart';
import '../../core/widgets/app_screen_header.dart';

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
  final _discountCodeController = TextEditingController();
  bool _startingSetup = false;
  String? _error;
  String? _discountNote;

  // Free-access code (2026-09-25, direct user request) — separate from
  // the Direct Debit discount code above: this one grants full access
  // with no mandate at all, for testing. See Subscription
  // .freeAccessGranted's own doc comment.
  final _freeAccessCodeController = TextEditingController();
  bool _redeemingFreeAccess = false;
  String? _freeAccessError;

  @override
  void dispose() {
    _discountCodeController.dispose();
    _freeAccessCodeController.dispose();
    super.dispose();
  }

  Future<void> _redeemFreeAccessCode(int organisationId) async {
    final code = _freeAccessCodeController.text.trim();
    if (code.isEmpty) return;
    setState(() {
      _redeemingFreeAccess = true;
      _freeAccessError = null;
    });
    try {
      final granted = await ref
          .read(subscriptionRepositoryProvider)
          .redeemFreeAccessCode(organisationId, code);
      if (!mounted) return;
      if (granted) {
        _freeAccessCodeController.clear();
        // The subscription provider watches this org's row — invalidate
        // so the screen re-fetches and shows the granted state without
        // needing a manual pull-to-refresh.
        ref.invalidate(currentSubscriptionProvider);
      } else {
        setState(() => _freeAccessError = 'That code was not recognised.');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _freeAccessError = 'Could not reach the server.');
    } finally {
      if (mounted) setState(() => _redeemingFreeAccess = false);
    }
  }

  Future<void> _startDirectDebitSetup() async {
    setState(() {
      _startingSetup = true;
      _error = null;
      _discountNote = null;
    });
    try {
      final code = _discountCodeController.text.trim();
      final result = await ref
          .read(subscriptionRepositoryProvider)
          .startDirectDebitSetup(discountCode: code.isEmpty ? null : code);
      if (result.discountError != null && mounted) {
        setState(() => _discountNote = result.discountError);
      } else if (result.discountApplied && mounted) {
        setState(() => _discountNote = 'Discount code applied.');
      }
      final launched = await launchUrl(
        Uri.parse(result.redirectUrl),
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
      appBar: AppScreenHeader(
        title: const Text('Billing'),
        actions: const [AssistantIconButton()],
      ),
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
                    const SizedBox(height: 16),
                    _buildFreeAccessCard(subscription),
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
    final pricePence = totalMonthlyPricePence(
      subscription.billedSiteCount,
      foundingOffer: subscription.foundingOffer,
    );
    final branches = subscription.billedSiteCount;
    final priceLabel =
        '£${(pricePence / 100).toStringAsFixed(2)}/month '
        '($branches branch${branches == 1 ? '' : 'es'} billed)';
    final state = effectiveBillingState(subscription);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                planDisplayName(subscription.planName),
                style: Theme.of(context).textTheme.titleLarge,
              ),
              if (subscription.foundingOffer) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.tealTint,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    'Discount applied',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.tealInk,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ],
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
              'GoCardless - VenuRite never sees your bank details directly.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _discountCodeController,
              decoration: const InputDecoration(
                labelText: 'Discount code (optional)',
                hintText: "Have a 'Friends' code? Enter it here",
                border: OutlineInputBorder(),
              ),
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
            if (_discountNote != null) ...[
              const SizedBox(height: 8),
              Text(_discountNote!),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Text(_error!, style: const TextStyle(color: AppColors.critical)),
            ],
          ],
        ],
      ),
    );
  }

  // Free-access code (2026-09-25, direct user request) — a separate,
  // always-visible card (not folded into the Direct Debit one above,
  // which is about a real mandate) so it's usable regardless of whether
  // a mandate exists yet.
  Widget _buildFreeAccessCard(Subscription subscription) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free-access code',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (subscription.freeAccessGranted)
            const Text(
              'Free access is active for this organisation - no Direct '
              'Debit or card payment required.',
            )
          else ...[
            const Text(
              'Have a free-access code? Enter it here to use the full app '
              'without setting up payment.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _freeAccessCodeController,
              decoration: const InputDecoration(
                labelText: 'Free-access code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: _redeemingFreeAccess
                  ? null
                  : () => _redeemFreeAccessCode(subscription.organisationId),
              child: _redeemingFreeAccess
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Redeem code'),
            ),
            if (_freeAccessError != null) ...[
              const SizedBox(height: 8),
              Text(
                _freeAccessError!,
                style: const TextStyle(color: AppColors.critical),
              ),
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
      BillingState.normal when subscription.status == 'trialing' => (
        subscription.trialEndsAt == null
            ? 'On trial'
            : 'On trial until ${_formatDate(subscription.trialEndsAt!)}',
        AppColors.muted,
      ),
      BillingState.normal => ('Active', AppColors.pass),
      BillingState.pastDueGrace => (
        'A recent payment failed. Please update your Direct Debit - '
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

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';
}
