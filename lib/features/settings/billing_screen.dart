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
import '../../l10n/app_localizations.dart';

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
        setState(
          () => _freeAccessError = AppLocalizations.of(context)!.codeNotRecognisedText,
        );
      }
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _freeAccessError = AppLocalizations.of(context)!.couldNotReachServerText,
      );
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
        setState(
          () => _discountNote = AppLocalizations.of(context)!.discountAppliedText,
        );
      }
      final launched = await launchUrl(
        Uri.parse(result.redirectUrl),
        mode: LaunchMode.externalApplication,
      );
      if (!launched && mounted) {
        setState(
          () => _error = AppLocalizations.of(context)!.couldNotOpenBrowserText,
        );
      }
    } on DirectDebitSetupException catch (e) {
      if (!mounted) return;
      setState(() => _error = e.message);
    } catch (_) {
      if (!mounted) return;
      setState(
        () => _error = AppLocalizations.of(context)!.couldNotReachServerText,
      );
    } finally {
      if (mounted) setState(() => _startingSetup = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final subscriptionAsync = ref.watch(currentSubscriptionProvider);

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.billingLabel),
        actions: const [AssistantIconButton()],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: subscriptionAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) =>
                  Center(child: Text(l10n.couldNotLoadBillingDetailsError(err.toString()))),
              data: (subscription) {
                if (subscription == null) {
                  return AppCard(
                    child: Text(l10n.noSubscriptionFoundText),
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
    final l10n = AppLocalizations.of(context)!;
    final pricePence = totalMonthlyPricePence(
      subscription.billedSiteCount,
      foundingOffer: subscription.foundingOffer,
    );
    final branches = subscription.billedSiteCount;
    final priceLabel = l10n.pricePerMonthBilledLabel(
      (pricePence / 100).toStringAsFixed(2),
      branches,
    );
    final state = effectiveBillingState(subscription);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                planDisplayName(subscription.planName, l10n),
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
                    l10n.discountAppliedBadge,
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
    final l10n = AppLocalizations.of(context)!;
    final hasMandate =
        subscription.gocardlessMandateId != null &&
        subscription.mandateStatus == 'active';

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.directDebitTitle, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          if (hasMandate)
            Text(l10n.directDebitSetUpText)
          else ...[
            Text(l10n.directDebitNotSetUpText),
            const SizedBox(height: 12),
            TextField(
              controller: _discountCodeController,
              decoration: InputDecoration(
                labelText: l10n.discountCodeOptionalLabel,
                hintText: l10n.discountCodeHintText,
                border: const OutlineInputBorder(),
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
                  : Text(l10n.setUpDirectDebitButton),
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
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.freeAccessCodeTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (subscription.freeAccessGranted)
            Text(l10n.freeAccessActiveText)
          else ...[
            Text(l10n.freeAccessPromptText),
            const SizedBox(height: 12),
            TextField(
              controller: _freeAccessCodeController,
              decoration: InputDecoration(
                labelText: l10n.freeAccessCodeTitle,
                border: const OutlineInputBorder(),
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
                  : Text(l10n.redeemCodeButton),
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
    final l10n = AppLocalizations.of(context)!;
    final (String message, Color color) = switch (state) {
      BillingState.normal when subscription.status == 'trialing' => (
        subscription.trialEndsAt == null
            ? l10n.onTrialText
            : l10n.onTrialUntilText(_formatDate(subscription.trialEndsAt!)),
        AppColors.muted,
      ),
      BillingState.normal => (l10n.activeLabel, AppColors.pass),
      BillingState.pastDueGrace => (
        l10n.paymentFailedGraceText,
        AppColors.caution,
      ),
      BillingState.restricted when subscription.status == 'cancelled' => (
        l10n.directDebitCancelledRestrictedText,
        AppColors.critical,
      ),
      BillingState.restricted => (
        l10n.paymentOverdueRestrictedText,
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
