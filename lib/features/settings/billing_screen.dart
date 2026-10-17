import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/billing_pricing.dart';
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

  bool _yearly = false;
  Future<BillingQuote?>? _quoteFuture;

  @override
  void dispose() {
    _discountCodeController.dispose();
    super.dispose();
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
          .startDirectDebitSetup(
            discountCode: code.isEmpty ? null : code,
            yearly: _yearly,
          );
      if (result.discountError != null && mounted) {
        setState(() => _discountNote = result.discountError);
      } else if (result.discountApplied && mounted) {
        setState(
          () => _discountNote = AppLocalizations.of(context)!.discountAppliedText,
        );
      }
      // Free-for-life code: nothing to pay, no Direct Debit page.
      if (result.freeAccess || result.redirectUrl == null) {
        ref.invalidate(currentSubscriptionProvider);
        return;
      }
      final launched = await launchUrl(
        Uri.parse(result.redirectUrl!),
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
                _quoteFuture ??= ref
                    .read(subscriptionRepositoryProvider)
                    .getQuote();
                return ListView(
                  children: [
                    _buildStatusCard(subscription),
                    const SizedBox(height: 16),
                    if (!subscription.freeAccessGranted)
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
    final l10n = AppLocalizations.of(context)!;
    final state = effectiveBillingState(subscription);
    final muted = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: AppColors.muted,
    );

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.billingYourPlanTitle,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          if (subscription.freeAccessGranted)
            Text(l10n.freeAccessActiveText)
          else
            FutureBuilder<BillingQuote?>(
              future: _quoteFuture,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const LinearProgressIndicator();
                }
                final quote = snap.data;
                if (quote == null) return Text(l10n.couldNotReachServerText);
                final discount = subscription.discountPercent;
                final monthly = quote.discountedMonthlyPence(discount);
                final yearly = subscription.isYearly;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final b in quote.branches)
                      _PriceLine(
                        label: '${b.name} · ${bandInfo(b.band).name}',
                        value: l10n.billingPerMonth(formatPounds(b.pricePence)),
                      ),
                    if (quote.headOffice)
                      _PriceLine(
                        label: l10n.billingHeadOfficeLine,
                        value: l10n.billingPerMonth(formatPounds(3900)),
                      ),
                    if (discount > 0)
                      _PriceLine(
                        label: subscription.discountEndsAt == null
                            ? l10n.billingDiscountForLife(discount)
                            : l10n.billingDiscountUntil(
                                discount,
                                _formatDate(subscription.discountEndsAt!),
                              ),
                        value: '-${formatPounds(quote.monthlyPence - monthly)}',
                        highlight: true,
                      ),
                    const Divider(height: 20),
                    _PriceLine(
                      label: yearly
                          ? l10n.billingTotalYearlyLabel
                          : l10n.billingTotalMonthlyLabel,
                      value: formatPounds(
                        yearly ? monthly * yearlyMonths : monthly,
                      ),
                      bold: true,
                    ),
                    const SizedBox(height: 8),
                    Text(l10n.billingBandsExplainer, style: muted),
                  ],
                );
              },
            ),
          if (subscription.billingNotice != null) ...[
            const SizedBox(height: 12),
            AppBanner(
              kind: BannerKind.caution,
              child: Text(subscription.billingNotice!),
            ),
          ],
          const SizedBox(height: 12),
          _StatusBanner(subscription: subscription, state: state),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

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
            SegmentedButton<bool>(
              segments: [
                ButtonSegment(
                  value: false,
                  label: Text(l10n.billingMonthlyOption),
                ),
                ButtonSegment(
                  value: true,
                  label: Text(l10n.billingYearlyOption),
                ),
              ],
              selected: {_yearly},
              onSelectionChanged: (v) => setState(() => _yearly = v.first),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _discountCodeController,
              decoration: InputDecoration(
                labelText: l10n.billingCodeLabel,
                hintText: 'VR-XXXX-XXXX',
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

}

class _PriceLine extends StatelessWidget {
  const _PriceLine({
    required this.label,
    required this.value,
    this.bold = false,
    this.highlight = false,
  });

  final String label;
  final String value;
  final bool bold;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
      fontSize: bold ? 17 : 14,
      color: highlight ? AppColors.pass : null,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
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
