import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/certification_requirement.dart';
import '../../shared/models/shift.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;
import '../../shared/providers/site_role_certification_requirement_providers.dart';
import '../../shared/providers/training_record_providers.dart';
import '../../shared/models/training_item.dart';
import 'shift_reliability_service.dart';
import '../../core/widgets/app_screen_header.dart';

// Roster add-on, Phase R3 (2026-09-27) — the staff-facing side: browse
// open shifts at your own site, claim one (race-safe — see
// ShiftRepository.claimShift's own doc comment), or cancel a shift you've
// already claimed. Reachable from WorkerHubScreen (base tier, which has no
// drawer at all) and the drawer (supervisor+), same dual-entry pattern
// Report Issue already uses. Resolves its own site (same fallback chain as
// RosterBoardScreen) rather than taking one as a constructor param, since
// the drawer's _DrawerItemDef only supplies a plain WidgetBuilder.
class ClaimBoardScreen extends ConsumerStatefulWidget {
  const ClaimBoardScreen({super.key});

  @override
  ConsumerState<ClaimBoardScreen> createState() => _ClaimBoardScreenState();
}

class _ClaimBoardScreenState extends ConsumerState<ClaimBoardScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  int? _siteId;
  bool _busy = false;
  ShiftReliabilityStanding? _ownStanding;

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Resolves addon-enabled/siteId/own-standing once — the shift LIST itself
  // is no longer loaded here (R7, 2026-09-27): build() watches
  // shiftsStreamForSiteProvider instead, which polls on its own.
  Future<void> _load() async {
    final org = await ref.read(organisationRepositoryProvider).getDefault();
    if (!mounted) return;
    if (!org.rosterAddonEnabled) {
      setState(() {
        _addonEnabled = false;
        _loading = false;
      });
      return;
    }

    final activeSite = ref.read(activeSiteProvider);
    final currentUser = ref.read(currentUserProvider);
    final siteId =
        activeSite?.id ??
        currentUser?.siteId ??
        (await ref.read(currentSiteProvider.future)).id;

    final standing = currentUser == null
        ? null
        : (await ref
                  .read(shiftReliabilityServiceProvider)
                  .computeForUser(currentUser.id))
              .standing;
    if (!mounted) return;
    setState(() {
      _addonEnabled = true;
      _siteId = siteId;
      _ownStanding = standing;
      _loading = false;
    });
  }

  Future<void> _claim(Shift shift) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;

    // Certification-expiry shift eligibility (Phase 2, 2026-09-30) —
    // client-side check for a clear, specific "you need X" message before
    // even attempting the claim. Not the real enforcement on its own (see
    // claim_shift RPC follow-up) - just the honest UX for the normal path.
    final records = await ref
        .read(trainingRecordRepositoryProvider)
        .getForUser(user.id);
    final siteAdditions = await ref.read(
      siteRoleCertificationRequirementsForSiteProvider(shift.siteId).future,
    );
    final missing = missingCertificationsForRole(
      role: user.jobRole,
      records: records,
      siteAdditions: siteAdditions,
    );
    if (!mounted) return;
    if (missing.isNotEmpty) {
      final l10n = AppLocalizations.of(context)!;
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(l10n.cannotClaimShiftTitle),
          content: Text(
            l10n.missingCertificationsMessage(
              missing.map((t) => trainingItemTypeLabel(t, l10n)).join(', '),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.okLabel),
            ),
          ],
        ),
      );
      return;
    }

    setState(() => _busy = true);
    final result = await ref
        .read(shiftRepositoryProvider)
        .claimShift(shiftId: shift.id, userId: user.id);
    if (!mounted) return;
    setState(() => _busy = false);
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result == null
              ? l10n.someoneElseClaimedShift
              : l10n.shiftClaimedMessage,
        ),
      ),
    );
    await _load();
  }

  Future<void> _cancel(Shift shift) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    final hoursUntil = shift.startsAt.difference(DateTime.now()).inHours;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        final lateWarning = hoursUntil < 24
            ? l10n.cancelShiftLateWarning
            : '';
        return AlertDialog(
          title: Text(l10n.cancelThisShiftTitle),
          content: Text(l10n.willNoLongerBeClaimed(lateWarning)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.keepShiftButton),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.cancelShiftButton),
            ),
          ],
        );
      },
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    await ref
        .read(shiftRepositoryProvider)
        .cancelClaim(shiftId: shift.id, userId: user.id);
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentUserId = ref.watch(currentUserProvider)?.id;
    final shiftsAsync = _siteId == null
        ? const AsyncValue<List<Shift>>.loading()
        : ref.watch(shiftsStreamForSiteProvider(_siteId!));

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.availableShiftsTitle),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.shiftClaimingNotEnabled,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : shiftsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text(l10n.couldNotLoadShifts('$error'))),
              data: (shifts) => shifts.isEmpty
                  ? Center(child: Text(l10n.noShiftsPostedYet))
                  : ResponsiveContent(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          if (_ownStanding != null &&
                              _ownStanding !=
                                  ShiftReliabilityStanding
                                      .buildingTrackRecord) ...[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: _OwnStandingChip(standing: _ownStanding!),
                            ),
                            const SizedBox(height: 12),
                          ],
                          for (final shift in shifts)
                            _ShiftCard(
                              shift: shift,
                              currentUserId: currentUserId,
                              busy: _busy,
                              onClaim: () => _claim(shift),
                              onCancel: () => _cancel(shift),
                            ),
                        ],
                      ),
                    ),
            ),
    );
  }
}

// Own-standing chip (R4, 2026-09-27) — descriptive only, never a number,
// never shown for anyone but the viewer themselves. See
// shift_reliability_service.dart's doc comment for the anti-gaming rule
// this enforces.
class _OwnStandingChip extends StatelessWidget {
  const _OwnStandingChip({required this.standing});

  final ShiftReliabilityStanding standing;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final (StatusKind kind, String label) = switch (standing) {
      ShiftReliabilityStanding.reliable => (
        StatusKind.pass,
        l10n.yourShiftRecordReliable,
      ),
      ShiftReliabilityStanding.needsImprovement => (
        StatusKind.caution,
        l10n.yourShiftRecordNeedsImprovement,
      ),
      ShiftReliabilityStanding.buildingTrackRecord => (
        StatusKind.caution,
        l10n.yourShiftRecordBuilding,
      ),
    };
    return StatusBadge(kind: kind, label: label);
  }
}

class _ShiftCard extends StatelessWidget {
  const _ShiftCard({
    required this.shift,
    required this.currentUserId,
    required this.busy,
    required this.onClaim,
    required this.onCancel,
  });

  final Shift shift;
  final int? currentUserId;
  final bool busy;
  final VoidCallback onClaim;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isMine =
        shift.claimedByUserId != null && shift.claimedByUserId == currentUserId;

    Widget trailing;
    if (isMine) {
      trailing = OutlinedButton(
        onPressed: busy ? null : onCancel,
        child: Text(l10n.cancel),
      );
    } else if (shift.status == ShiftStatus.open) {
      trailing = ElevatedButton(
        onPressed: busy ? null : onClaim,
        child: Text(l10n.claimLabel),
      );
    } else {
      trailing = Text(l10n.claimedLabel, style: const TextStyle(color: AppColors.muted));
    }

    final startHour = shift.startsAt.hour.toString().padLeft(2, '0');
    final startMinute = shift.startsAt.minute.toString().padLeft(2, '0');
    final endHour = shift.endsAt.hour.toString().padLeft(2, '0');
    final endMinute = shift.endsAt.minute.toString().padLeft(2, '0');

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: AppCard(
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${formatDate(shift.startsAt)}, $startHour:$startMinute'
                    ' - $endHour:$endMinute',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  if (shift.category != null)
                    Text(
                      shift.category!,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
