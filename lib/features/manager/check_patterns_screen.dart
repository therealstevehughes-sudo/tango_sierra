import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/errors/friendly_error.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_banner.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_providers.dart'
    show backendRestClientProvider;
import '../../shared/providers/site_providers.dart';
import '../../shared/repositories/integrity_repository.dart';

final integrityRepositoryProvider = Provider<IntegrityRepository>(
  (ref) => IntegrityRepository(ref.watch(backendRestClientProvider)),
);

final _overviewProvider = FutureProvider.autoDispose
    .family<IntegrityOverview, int>(
      (ref, siteId) => ref.watch(integrityRepositoryProvider).overview(siteId),
    );

final _staffProvider = FutureProvider.autoDispose.family<List<User>, int>(
  (ref, siteId) => ref.watch(userRepositoryProvider).getForSite(siteId),
);

String integrityKindLabel(AppLocalizations l10n, IntegrityKind k) =>
    switch (k) {
      IntegrityKind.tooFast => l10n.integrityKindTooFast,
      IntegrityKind.burst => l10n.integrityKindBurst,
      IntegrityKind.reusedPhoto => l10n.integrityKindReusedPhoto,
      IntegrityKind.sameReading => l10n.integrityKindSameReading,
      IntegrityKind.roundNumbers => l10n.integrityKindRoundNumbers,
      IntegrityKind.offSite => l10n.integrityKindOffSite,
      IntegrityKind.checkMismatch => l10n.integrityKindCheckMismatch,
    };

/// "Check patterns" (2026-10-17, founder-approved anti-faking plan): for
/// venue managers and above only. A pattern view per person — never a
/// public score — plus "Check this one": go and look at a real submission
/// yourself. Staff are never told they've been flagged.
class CheckPatternsScreen extends ConsumerWidget {
  const CheckPatternsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final siteId =
        ref.watch(activeSiteProvider)?.id ?? ref.watch(currentUserProvider)?.siteId;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.menuCheckPatterns)),
      body: siteId == null
          ? const SizedBox.shrink()
          : switch ((
              ref.watch(_overviewProvider(siteId)),
              ref.watch(_staffProvider(siteId)),
            )) {
              (AsyncError(:final error), _) || (_, AsyncError(:final error)) =>
                LoadErrorView(
                  error: error,
                  onRetry: () {
                    ref.invalidate(_overviewProvider(siteId));
                    ref.invalidate(_staffProvider(siteId));
                  },
                ),
              (AsyncData(value: final o), AsyncData(value: final staff)) =>
                _Body(siteId: siteId, overview: o, staff: staff),
              _ => const Center(child: CircularProgressIndicator()),
            },
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({
    required this.siteId,
    required this.overview,
    required this.staff,
  });

  final int siteId;
  final IntegrityOverview overview;
  final List<User> staff;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final people = staff.where((u) => u.active).toList()
      ..sort((a, b) {
        int open(User u) =>
            overview.flags.where((f) => f.userId == u.id && !f.reviewed).length;
        final c = open(b).compareTo(open(a));
        return c != 0 ? c : a.name.compareTo(b.name);
      });
    final anyFlags = overview.flags.isNotEmpty;
    return ResponsiveContent(
      maxWidth: 680,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AppBanner(kind: BannerKind.info, child: Text(l10n.integrityIntro)),
          const SizedBox(height: 12),
          _SpotCheckCard(siteId: siteId, overview: overview),
          const SizedBox(height: 16),
          if (!anyFlags)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text(
                l10n.integrityNoFlags,
                style: const TextStyle(color: AppColors.muted),
              ),
            ),
          for (final person in people)
            if (overview.flags.any((f) => f.userId == person.id) ||
                (overview.secondsByUser[person.id] ?? 0) > 0)
              _PersonCard(siteId: siteId, person: person, overview: overview),
        ],
      ),
    );
  }
}

class _PersonCard extends StatelessWidget {
  const _PersonCard({
    required this.siteId,
    required this.person,
    required this.overview,
  });

  final int siteId;
  final User person;
  final IntegrityOverview overview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final flags = overview.flags.where((f) => f.userId == person.id).toList();
    final open = flags.where((f) => !f.reviewed).toList();
    final counts = <IntegrityKind, int>{};
    for (final f in open) {
      counts[f.kind] = (counts[f.kind] ?? 0) + 1;
    }
    final minutes = ((overview.secondsByUser[person.id] ?? 0) / 60).round();
    final matched = overview.matchedByUser[person.id] ?? 0;
    final mismatched = overview.mismatchedByUser[person.id] ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AppCard(
        child: InkWell(
          onTap: flags.isEmpty
              ? null
              : () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => _PersonFlagsScreen(
                      siteId: siteId,
                      person: person,
                    ),
                  ),
                ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      person.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  if (flags.isNotEmpty) const Icon(Icons.chevron_right),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.integrityTimeOnChecks(minutes),
                style: const TextStyle(color: AppColors.muted, fontSize: 13),
              ),
              if (matched + mismatched > 0)
                Text(
                  l10n.integritySpotChecks(matched, mismatched),
                  style: const TextStyle(color: AppColors.muted, fontSize: 13),
                ),
              if (counts.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final e in counts.entries)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.cautionBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '${integrityKindLabel(l10n, e.key)} × ${e.value}',
                          style: const TextStyle(
                            color: AppColors.caution,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _PersonFlagsScreen extends ConsumerWidget {
  const _PersonFlagsScreen({required this.siteId, required this.person});

  final int siteId;
  final User person;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final overview = ref.watch(_overviewProvider(siteId));
    final me = ref.watch(currentUserProvider);
    return Scaffold(
      appBar: AppScreenHeader(title: Text(person.name)),
      body: overview.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => LoadErrorView(
          error: e,
          onRetry: () => ref.invalidate(_overviewProvider(siteId)),
        ),
        data: (o) {
          final flags = o.flags.where((f) => f.userId == person.id).toList();
          return ResponsiveContent(
            maxWidth: 680,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                for (final f in flags)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            integrityKindLabel(l10n, f.kind),
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 2),
                          Text(f.detail),
                          const SizedBox(height: 2),
                          Text(
                            formatDateTime(f.createdAt),
                            style: const TextStyle(
                              color: AppColors.muted,
                              fontSize: 13,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: f.reviewed
                                ? Text(
                                    l10n.integrityReviewed,
                                    style: const TextStyle(color: AppColors.pass),
                                  )
                                : TextButton(
                                    onPressed: me == null
                                        ? null
                                        : () async {
                                            try {
                                              await ref
                                                  .read(integrityRepositoryProvider)
                                                  .markReviewed(f.id, me.id);
                                              ref.invalidate(
                                                _overviewProvider(siteId),
                                              );
                                            } catch (e) {
                                              if (!context.mounted) return;
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        friendlyErrorMessage(
                                                          l10n,
                                                          e,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                            }
                                          },
                                    child: Text(l10n.integrityMarkReviewed),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// 7: "Check this one" — one of today's submissions, picked at random but
/// twice as likely to be from someone with an open flag.
class _SpotCheckCard extends ConsumerStatefulWidget {
  const _SpotCheckCard({required this.siteId, required this.overview});

  final int siteId;
  final IntegrityOverview overview;

  @override
  ConsumerState<_SpotCheckCard> createState() => _SpotCheckCardState();
}

class _SpotCheckCardState extends ConsumerState<_SpotCheckCard> {
  final _random = Random();
  SpotCheckCandidate? _pick;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _pickAnother();
  }

  void _pickAnother() {
    final today = widget.overview.today;
    if (today.isEmpty) {
      _pick = null;
      return;
    }
    final flagged = {
      for (final f in widget.overview.flags)
        if (!f.reviewed) f.userId,
    };
    final pool = [
      for (final c in today) ...[c, if (flagged.contains(c.userId)) c],
    ];
    _pick = pool[_random.nextInt(pool.length)];
  }

  Future<void> _record(bool matches) async {
    final l10n = AppLocalizations.of(context)!;
    final me = ref.read(currentUserProvider);
    final pick = _pick;
    if (me == null || pick == null) return;
    String? note;
    if (!matches) {
      final controller = TextEditingController();
      final ok = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(l10n.integrityMismatch),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: l10n.integrityMismatchNoteHint),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text(l10n.saveButton),
            ),
          ],
        ),
      );
      if (ok != true) return;
      note = controller.text.trim().isEmpty ? null : controller.text.trim();
    }
    setState(() => _busy = true);
    try {
      await ref
          .read(integrityRepositoryProvider)
          .recordSpotCheck(
            submissionId: pick.submissionId,
            matches: matches,
            note: note,
            managerId: me.id,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.integrityRecorded)));
      ref.invalidate(_overviewProvider(widget.siteId));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pick = _pick;
    return AppCard(
      elevated: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.fact_check_outlined, color: AppColors.teal),
              const SizedBox(width: 8),
              Text(
                l10n.integrityCheckThisOne,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            pick == null ? l10n.integrityNoneToday : l10n.integrityCheckThisOneHelp,
            style: const TextStyle(color: AppColors.muted),
          ),
          if (pick != null) ...[
            const SizedBox(height: 12),
            Text(pick.title, style: const TextStyle(fontWeight: FontWeight.w700)),
            Text(
              [
                pick.completedBy,
                formatDateTime(pick.completedAt),
                pick.status,
                if (pick.value != null) pick.value!,
              ].join(' · '),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.tonal(
                  onPressed: _busy ? null : () => _record(true),
                  child: Text(l10n.integrityMatches),
                ),
                OutlinedButton(
                  onPressed: _busy ? null : () => _record(false),
                  child: Text(l10n.integrityMismatch),
                ),
                TextButton(
                  onPressed: _busy ? null : () => setState(_pickAnother),
                  child: Text(l10n.integrityAnother),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
