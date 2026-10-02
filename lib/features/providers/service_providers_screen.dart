import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/service_provider.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/service_provider_providers.dart';
import 'review_text_screening.dart';

/// Trusted Service Provider directory, phase 1 (2026-09-29) — see
/// service_provider.dart's own doc comment for the full agreed design.
/// Merged with the former "Maintenance Contacts" (2026-09-29, direct
/// founder report — same job, two screens): "My Providers" is your own
/// private contact list and works everywhere, same as Maintenance
/// Contacts always did (Drift-backed locally, Supabase-backed once a real
/// backend account is signed in). "Find a Provider" — the cross-org
/// directory, blurred until unlocked — and the "share" opt-in are the
/// only parts that inherently need a real company account: there's no
/// other organisation to share with on a purely local install. No
/// vetting, no VenuRite endorsement — reviews are entirely external, from
/// venues that have actually used the provider.
class ServiceProvidersScreen extends ConsumerWidget {
  const ServiceProvidersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final hasBackendOrg =
        ref.watch(currentBackendOrganisationIdProvider) != null;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppScreenHeader(
          title: Text(l10n.serviceProvidersTitle),
          actions: const [AssistantIconButton()],
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.myProvidersTab),
              Tab(text: l10n.findProviderTab),
            ],
          ),
        ),
        drawer: ManagementDrawer(title: l10n.serviceProvidersTitle),
        body: TabBarView(
          children: [
            _MyProvidersTab(canShare: hasBackendOrg),
            hasBackendOrg
                ? const _DirectoryTab()
                : const _NoBackendAccountNotice(),
          ],
        ),
      ),
    );
  }
}

class _NoBackendAccountNotice extends StatelessWidget {
  const _NoBackendAccountNotice();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ResponsiveContent(
            maxWidth: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.cloud_off_outlined,
                  size: 40,
                  color: AppColors.muted,
                ),
                const SizedBox(height: 12),
                Text(l10n.noBackendProviderNotice1, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  l10n.noBackendProviderNotice2,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// VenuRite doesn't vet or endorse any listed provider — shown once, at
// the top of both tabs, not buried in fine print. Reviews are entirely
// external, from venues that have used the provider directly.
class _DisclaimerBanner extends StatelessWidget {
  const _DisclaimerBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.cautionBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.info_outline, color: AppColors.caution, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              AppLocalizations.of(context)!.providerDisclaimerText,
              style: const TextStyle(color: AppColors.caution, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

// Shared star-rating row (2026-09-29) — extracted so both the "Add a
// Provider" dialog and _MyProviderTile's inline rating form can use the
// exact same widget, rather than each screen re-implementing it.
class _StarRow extends StatelessWidget {
  const _StarRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        for (var i = 1; i <= 5; i++)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: Icon(
              i <= value ? Icons.star : Icons.star_border,
              color: AppColors.caution,
              size: 20,
            ),
            onPressed: () => onChanged(i),
          ),
      ],
    );
  }
}

class _MyProvidersTab extends ConsumerWidget {
  const _MyProvidersTab({required this.canShare});

  // False in local/demo mode (no real backend organisation signed in) —
  // there's no other organisation to share with, so the share toggle and
  // its inline rating-on-share flow are hidden entirely rather than
  // shown broken. Adding and privately rating your own contacts still
  // works fully either way (Drift-backed locally, same as the former
  // Maintenance Contacts screen always was).
  final bool canShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final providersAsync = ref.watch(myServiceProvidersProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ResponsiveContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _DisclaimerBanner(),
              PrimaryActionButton(
                label: l10n.addProviderButton,
                onPressed: () => _showAddProviderDialog(context, ref),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: providersAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => LoadErrorView(
                    error: e.toString(),
                    onRetry: () => ref.invalidate(myServiceProvidersProvider),
                  ),
                  data: (providers) => providers.isEmpty
                      ? Center(
                          child: Text(l10n.noProvidersYetText),
                        )
                      : ListView.builder(
                          itemCount: providers.length,
                          itemBuilder: (context, i) => _MyProviderTile(
                            provider: providers[i],
                            canShare: canShare,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showAddProviderDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final phoneController = TextEditingController();
    final emailController = TextEditingController();
    final notesController = TextEditingController();
    final reviewController = TextEditingController();
    var shared = false;
    var price = 5, punctuality = 5, quality = 5, availability = 5;
    String? error;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
            title: Text(l10n.addServiceProviderDialogTitle),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: l10n.nameAxisLabel),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: categoryController,
                    decoration: InputDecoration(
                      labelText: l10n.categoryLabel,
                      hintText: l10n.categoryHint,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: l10n.phoneOptionalLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: l10n.emailOptionalLabel,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: notesController,
                    decoration: InputDecoration(
                      labelText: l10n.notesOptionalPrivateLabel,
                    ),
                    maxLines: 2,
                  ),
                  // Hidden entirely in local/demo mode (2026-09-29) — no
                  // other organisation exists to share with on a purely
                  // local install.
                  if (canShare) ...[
                    const SizedBox(height: 8),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(l10n.happyToReviewShareLabel),
                      subtitle: Text(l10n.shareVisibilityExplanation),
                      value: shared,
                      onChanged: (v) => setDialogState(() => shared = v),
                    ),
                  ],
                  // Opens immediately once "share" is on (2026-09-29,
                  // direct founder report) — a shared listing with zero
                  // ratings isn't useful to anyone else browsing it, so
                  // sharing and rating happen in the same step rather than
                  // a separate screen visited afterward.
                  if (canShare && shared) ...[
                    const Divider(height: 24),
                    Text(
                      l10n.rateThisProviderLabel,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    _StarRow(
                      label: l10n.priceRatingLabel,
                      value: price,
                      onChanged: (v) => setDialogState(() => price = v),
                    ),
                    _StarRow(
                      label: l10n.punctualityRatingLabel,
                      value: punctuality,
                      onChanged: (v) => setDialogState(() => punctuality = v),
                    ),
                    _StarRow(
                      label: l10n.qualityRatingLabel,
                      value: quality,
                      onChanged: (v) => setDialogState(() => quality = v),
                    ),
                    _StarRow(
                      label: l10n.availabilityRatingLabel,
                      value: availability,
                      onChanged: (v) => setDialogState(() => availability = v),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: reviewController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        labelText: l10n.reviewOptionalLabel,
                        hintText: l10n.reviewHintText,
                      ),
                    ),
                  ],
                  if (error != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      error!,
                      style: const TextStyle(color: AppColors.critical),
                    ),
                  ],
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: () {
                  final found = identifyingInfoIn(reviewController.text.trim());
                  if (shared && found != null) {
                    setDialogState(
                      () => error = l10n.reviewContainsInfoWarningShort(found),
                    );
                    return;
                  }
                  Navigator.pop(context, true);
                },
                child: Text(l10n.addLabel),
              ),
            ],
          );
        },
      ),
    );

    final name = nameController.text.trim();
    final category = categoryController.text.trim();
    if (confirmed != true || name.isEmpty || category.isEmpty) return;

    // organisationId is only meaningful in backend mode — the Drift-backed
    // local repository ignores it entirely (see its own doc comment), so
    // it's only actually required to resolve when canShare is true.
    final orgId = ref.read(currentBackendOrganisationIdProvider);
    if (canShare && orgId == null) {
      // Defensive fallback — the share toggle itself is hidden without a
      // backend org, but a session could still expire mid-visit. Never
      // silently no-op again.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.sessionExpiredMessage),
          ),
        );
      }
      return;
    }
    final repo = ref.read(serviceProviderRepositoryProvider);
    final created = await repo.addProvider(
      organisationId: orgId ?? 0,
      name: name,
      phone: phoneController.text.trim().isEmpty
          ? null
          : phoneController.text.trim(),
      email: emailController.text.trim().isEmpty
          ? null
          : emailController.text.trim(),
      category: category,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      shared: shared,
    );
    if (shared) {
      final reviewText = reviewController.text.trim();
      await repo.submitReview(
        providerId: created.id,
        priceRating: price,
        punctualityRating: punctuality,
        qualityRating: quality,
        availabilityRating: availability,
        reviewText: reviewText.isEmpty ? null : reviewText,
      );
    }
    ref.invalidate(myServiceProvidersProvider);
  }
}

class _MyProviderTile extends ConsumerWidget {
  const _MyProviderTile({required this.provider, required this.canShare});

  final ServiceProvider provider;
  // Hidden entirely in local/demo mode (2026-09-29) — no other
  // organisation exists to share with on a purely local install; rating
  // your own contact for your own reference still works either way.
  final bool canShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      provider.category,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (canShare)
                Switch(
                  value: provider.shared,
                  onChanged: (v) async {
                    await ref
                        .read(serviceProviderRepositoryProvider)
                        .setShared(provider.id, v);
                    ref.invalidate(myServiceProvidersProvider);
                    // Opens the rate/review section immediately when
                    // share turns on (2026-09-29, direct founder report)
                    // — a shared listing with zero ratings isn't useful
                    // to anyone browsing it, and making the reviewer hunt
                    // for a separate button afterward is a real,
                    // avoidable gap.
                    if (v && context.mounted) {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (context) => _ReviewSheet(
                          providerId: provider.id,
                          canRate: true,
                        ),
                      );
                    }
                  },
                ),
            ],
          ),
          if (provider.phone != null)
            Text(l10n.phonePrefixLabel(provider.phone!)),
          if (provider.email != null)
            Text(l10n.emailPrefixLabel(provider.email!)),
          const SizedBox(height: 8),
          Row(
            children: [
              if (canShare)
                Text(
                  provider.shared
                      ? l10n.sharedWithOtherVenuesLabel
                      : l10n.privateLabel,
                  style: TextStyle(
                    color: provider.shared ? AppColors.pass : AppColors.muted,
                    fontSize: 12,
                  ),
                ),
              const Spacer(),
              TextButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => _ReviewSheet(
                    providerId: provider.id,
                    canRate: true,
                  ),
                ),
                child: Text(l10n.rateReviewsButton),
              ),
            ],
          ),
        ],
      ),
    );
  }

}

class _DirectoryTab extends ConsumerStatefulWidget {
  const _DirectoryTab();

  @override
  ConsumerState<_DirectoryTab> createState() => _DirectoryTabState();
}

class _DirectoryTabState extends ConsumerState<_DirectoryTab> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Search + category grouping (2026-09-29, direct founder question —
  // "is Find a Provider searchable and grouped by type?"). Matches
  // category always (visible pre-unlock); matches name too once a
  // listing is revealed, so unlocking a provider doesn't make it harder
  // to find again later. The backend already returns rows ordered by
  // category (see list_shared_service_providers' own ORDER BY), so a
  // category header just needs to render whenever the category changes.
  List<SharedProviderListing> _filtered(List<SharedProviderListing> all) {
    if (_query.isEmpty) return all;
    final q = _query.toLowerCase();
    return all
        .where(
          (l) =>
              l.category.toLowerCase().contains(q) ||
              (l.name?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final directoryAsync = ref.watch(sharedProviderDirectoryProvider);
    final unlockCountAsync = ref.watch(unlocksThisMonthProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ResponsiveContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _DisclaimerBanner(),
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: l10n.searchByCategoryOrNameHint,
                  prefixIcon: const Icon(Icons.search),
                  isDense: true,
                ),
                onChanged: (v) => setState(() => _query = v.trim()),
              ),
              const SizedBox(height: 8),
              // Running count (2026-09-29, agreed placement: on the
              // screen it's about, not Settings/Account) — awareness
              // without a checkout flow, per the founder's own "impulse
              // buy, forgotten by next payment run" reasoning: enough
              // visibility to stay a deterrent, not a friction point.
              unlockCountAsync.maybeWhen(
                data: (count) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    count == 0
                        ? l10n.noContactsUnlockedThisMonth
                        : l10n.contactsUnlockedThisMonth(count),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.muted,
                    ),
                  ),
                ),
                orElse: () => const SizedBox.shrink(),
              ),
              Expanded(
                child: directoryAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => LoadErrorView(
                    error: e.toString(),
                    onRetry: () =>
                        ref.invalidate(sharedProviderDirectoryProvider),
                  ),
                  data: (allListings) {
                    final listings = _filtered(allListings);
                    if (allListings.isEmpty) {
                      return Center(
                        child: Text(l10n.noSharedProvidersYetText),
                      );
                    }
                    if (listings.isEmpty) {
                      return Center(
                        child: Text(l10n.noProvidersMatchSearchText),
                      );
                    }
                    return ListView.builder(
                      itemCount: listings.length,
                      itemBuilder: (context, i) {
                        final listing = listings[i];
                        final showHeader =
                            i == 0 ||
                            listings[i - 1].category != listing.category;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (showHeader)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: i == 0 ? 0 : 12,
                                  bottom: 4,
                                ),
                                child: Text(
                                  listing.category,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.muted,
                                    fontSize: 12,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ),
                            _DirectoryTile(listing: listing),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DirectoryTile extends ConsumerWidget {
  const _DirectoryTile({required this.listing});

  final SharedProviderListing listing;

  String _ratingLine(AppLocalizations l10n) {
    final parts = <String>[];
    if (listing.avgPrice != null) {
      parts.add(l10n.priceValueLabel(listing.avgPrice!.toString()));
    }
    if (listing.avgPunctuality != null) {
      parts.add(l10n.punctualityValueLabel(listing.avgPunctuality!.toString()));
    }
    if (listing.avgQuality != null) {
      parts.add(l10n.qualityValueLabel(listing.avgQuality!.toString()));
    }
    if (listing.avgAvailability != null) {
      parts.add(l10n.availabilityValueLabel(listing.avgAvailability!.toString()));
    }
    return parts.isEmpty
        ? l10n.noRatingsYetText
        : l10n.ratingReviewCountSuffix(parts.join(' - '), listing.reviewCount);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.isRevealed
                          ? (listing.name ?? l10n.unnamedPlaceholder)
                          : l10n.hiddenUntilUnlockedText,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontStyle: listing.isRevealed
                            ? FontStyle.normal
                            : FontStyle.italic,
                        color: listing.isRevealed ? null : AppColors.muted,
                      ),
                    ),
                    Text(
                      listing.category,
                      style: const TextStyle(color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              if (!listing.isRevealed)
                const Icon(Icons.lock_outline, color: AppColors.muted),
            ],
          ),
          const SizedBox(height: 4),
          Text(_ratingLine(l10n), style: const TextStyle(fontSize: 13)),
          if (listing.isRevealed) ...[
            if (listing.phone != null) Text(l10n.phonePrefixLabel(listing.phone!)),
            if (listing.email != null) Text(l10n.emailPrefixLabel(listing.email!)),
          ],
          const SizedBox(height: 8),
          Row(
            children: [
              TextButton(
                onPressed: () => showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => _ReviewSheet(
                    providerId: listing.id,
                    canRate: listing.isOwn,
                  ),
                ),
                child: Text(l10n.readReviewsButton),
              ),
              const Spacer(),
              if (!listing.isOwn && !listing.isUnlocked)
                FilledButton(
                  onPressed: () async {
                    final billed = await ref
                        .read(serviceProviderRepositoryProvider)
                        .unlockProvider(listing.id);
                    ref.invalidate(sharedProviderDirectoryProvider);
                    ref.invalidate(unlocksThisMonthProvider);
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          billed
                              ? l10n.unlockFeeChargedMessage
                              : l10n.unlockFeeNotChargedMessage,
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.unlockContactDetailsButton),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// Shared between both tabs: a scrollable list of existing reviews plus
// (for the owning organisation only) a form to add a new one.
class _ReviewSheet extends ConsumerStatefulWidget {
  const _ReviewSheet({required this.providerId, required this.canRate});

  final int providerId;
  // Only the owning organisation can actually submit a rating (RLS
  // enforces this server-side regardless) — hidden here too so a viewer
  // who can't use the form never sees it at all, rather than filling it
  // in and hitting a raw RLS error.
  final bool canRate;

  @override
  ConsumerState<_ReviewSheet> createState() => _ReviewSheetState();
}

class _ReviewSheetState extends ConsumerState<_ReviewSheet> {
  int price = 5, punctuality = 5, quality = 5, availability = 5;
  final _reviewController = TextEditingController();
  bool _submitting = false;
  String? _error;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final text = _reviewController.text.trim();
    final found = identifyingInfoIn(text);
    if (found != null) {
      setState(
        () => _error =
            AppLocalizations.of(context)!.reviewContainsInfoWarningLong(found),
      );
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await ref.read(serviceProviderRepositoryProvider).submitReview(
        providerId: widget.providerId,
        priceRating: price,
        punctualityRating: punctuality,
        qualityRating: quality,
        availabilityRating: availability,
        reviewText: text.isEmpty ? null : text,
      );
      ref.invalidate(providerReviewsProvider(widget.providerId));
      ref.invalidate(sharedProviderDirectoryProvider);
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _reviewController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _submitting = false;
        _error = e.toString();
      });
    }
  }

  Widget _starRow(String label, int value, ValueChanged<int> onChanged) {
    return Row(
      children: [
        SizedBox(width: 90, child: Text(label)),
        for (var i = 1; i <= 5; i++)
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
            icon: Icon(
              i <= value ? Icons.star : Icons.star_border,
              color: AppColors.caution,
              size: 20,
            ),
            onPressed: () => onChanged(i),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reviewsAsync = ref.watch(providerReviewsProvider(widget.providerId));
    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.reviewsTitle,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: reviewsAsync.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Text(e.toString()),
                data: (reviews) => ListView(
                  controller: scrollController,
                  children: [
                    if (reviews.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Text(l10n.noReviewsYetText),
                      )
                    else
                      for (final r in reviews)
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.reviewRatingsLine(
                                    r.priceRating,
                                    r.punctualityRating,
                                    r.qualityRating,
                                    r.availabilityRating,
                                  ),
                                  style: const TextStyle(fontSize: 12),
                                ),
                                if (r.reviewText != null &&
                                    r.reviewText!.isNotEmpty) ...[
                                  const SizedBox(height: 4),
                                  Text(r.reviewText!),
                                ],
                              ],
                            ),
                          ),
                        ),
                    if (widget.canRate) ...[
                      const Divider(height: 32),
                      Text(
                        l10n.addYourRatingLabel,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      _starRow(
                        l10n.priceRatingLabel,
                        price,
                        (v) => setState(() => price = v),
                      ),
                      _starRow(
                        l10n.punctualityRatingLabel,
                        punctuality,
                        (v) => setState(() => punctuality = v),
                      ),
                      _starRow(
                        l10n.qualityRatingLabel,
                        quality,
                        (v) => setState(() => quality = v),
                      ),
                      _starRow(
                        l10n.availabilityRatingLabel,
                        availability,
                        (v) => setState(() => availability = v),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reviewController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: l10n.reviewOptionalLabel,
                          hintText: l10n.reviewHintText,
                        ),
                      ),
                      if (_error != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          style: const TextStyle(color: AppColors.critical),
                        ),
                      ],
                      const SizedBox(height: 12),
                      PrimaryActionButton(
                        label: _submitting
                            ? l10n.submittingEllipsis
                            : l10n.submitRatingButton,
                        onPressed: _submitting ? null : _submit,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
