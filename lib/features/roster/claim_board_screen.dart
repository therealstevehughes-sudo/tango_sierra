import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/shift.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;

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
  List<Shift> _shifts = [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

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

    final shifts = await ref.read(shiftRepositoryProvider).getForSite(siteId);
    if (!mounted) return;
    setState(() {
      _addonEnabled = true;
      _shifts = shifts;
      _loading = false;
    });
  }

  Future<void> _claim(Shift shift) async {
    final user = ref.read(currentUserProvider);
    if (user == null) return;
    setState(() => _busy = true);
    final result = await ref
        .read(shiftRepositoryProvider)
        .claimShift(shiftId: shift.id, userId: user.id);
    if (!mounted) return;
    setState(() => _busy = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result == null
              ? 'Someone else just claimed that shift — sorry!'
              : 'Shift claimed.',
        ),
      ),
    );
    await _load();
  }

  Future<void> _cancel(Shift shift) async {
    final hoursUntil = shift.startsAt.difference(DateTime.now()).inHours;
    final lateWarning = hoursUntil < 24
        ? '\n\nThis is less than 24 hours before the shift starts — '
              'cancelling now may affect your reliability record.'
        : '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel this shift?'),
        content: Text(
          'You will no longer be claimed for this shift.$lateWarning',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep shift'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cancel shift'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _busy = true);
    await ref.read(shiftRepositoryProvider).cancelClaim(shiftId: shift.id);
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = ref.watch(currentUserProvider)?.id;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Shifts'),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "Shift claiming isn't switched on for this venue yet. "
                  'Ask your manager to enable it in Settings.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _shifts.isEmpty
          ? const Center(child: Text('No shifts posted yet.'))
          : ResponsiveContent(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final shift in _shifts)
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
    );
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
    final isMine =
        shift.claimedByUserId != null && shift.claimedByUserId == currentUserId;

    Widget trailing;
    if (isMine) {
      trailing = OutlinedButton(
        onPressed: busy ? null : onCancel,
        child: const Text('Cancel'),
      );
    } else if (shift.status == ShiftStatus.open) {
      trailing = ElevatedButton(
        onPressed: busy ? null : onClaim,
        child: const Text('Claim'),
      );
    } else {
      trailing = const Text('Claimed', style: TextStyle(color: AppColors.muted));
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
                    ' – $endHour:$endMinute',
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
