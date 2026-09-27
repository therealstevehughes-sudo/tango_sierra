import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/models/shift.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/shift_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;

// Roster add-on, Phase R2 (2026-09-27) — the manager-facing side: post
// shifts, see who's claimed what, remove a claim, or assign someone
// directly. Menu-based actions, same convention as the branch organogram
// (this app has no drag-and-drop precedent) — a shift's own PopupMenuButton
// carries "Assign directly" and "Remove claim/cancel."
//
// Second tab added (R5, 2026-09-27): pending off-day requests, approve/deny
// via the same PopupMenuButton pattern the Shifts tab already uses.
class RosterBoardScreen extends ConsumerStatefulWidget {
  const RosterBoardScreen({super.key});

  @override
  ConsumerState<RosterBoardScreen> createState() => _RosterBoardScreenState();
}

class _RosterBoardScreenState extends ConsumerState<RosterBoardScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  int? _siteId;
  List<User> _staff = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  // Resolves addon-enabled/siteId/staff once — the shift LIST itself is no
  // longer loaded here (R7, 2026-09-27): build() watches
  // shiftsStreamForSiteProvider instead, which polls on its own, so
  // mutations below no longer need to call this again just to refresh the
  // list.
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

    final staff = await ref.read(userRepositoryProvider).getForSite(siteId);

    if (!mounted) return;
    setState(() {
      _addonEnabled = true;
      _siteId = siteId;
      _staff = staff.where((u) => u.active).toList();
      _loading = false;
    });
  }

  Future<void> _postShift() async {
    final siteId = _siteId;
    final manager = ref.read(currentUserProvider);
    if (siteId == null || manager == null) return;

    DateTime? startsAt;
    DateTime? endsAt;
    final categoryController = TextEditingController();
    final notesController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Post a shift'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(
                    labelText: 'Category (e.g. opening, closing)',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    startsAt == null
                        ? 'Pick start time'
                        : formatDateTime(startsAt!),
                  ),
                  trailing: const Icon(Icons.calendar_today, size: 18),
                  onTap: () async {
                    final picked = await _pickDateTime(context);
                    if (picked != null) {
                      setDialogState(() => startsAt = picked);
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    endsAt == null ? 'Pick end time' : formatDateTime(endsAt!),
                  ),
                  trailing: const Icon(Icons.calendar_today, size: 18),
                  onTap: () async {
                    final picked = await _pickDateTime(context);
                    if (picked != null) {
                      setDialogState(() => endsAt = picked);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes (optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: startsAt != null && endsAt != null
                  ? () => Navigator.pop(context, true)
                  : null,
              child: const Text('Post'),
            ),
          ],
        ),
      ),
    );

    final category = categoryController.text.trim();
    final notes = notesController.text.trim();
    categoryController.dispose();
    notesController.dispose();

    if (confirmed != true || startsAt == null || endsAt == null) return;

    await ref.read(shiftRepositoryProvider).postShift(
      siteId: siteId,
      category: category.isEmpty ? null : category,
      startsAt: startsAt!,
      endsAt: endsAt!,
      notes: notes.isEmpty ? null : notes,
      createdByUserId: manager.id,
    );
    // No manual reload — shiftsStreamForSiteProvider picks this up on its
    // next poll (within 20s, see R7's doc comment on that provider).
  }

  Future<DateTime?> _pickDateTime(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !context.mounted) return null;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> _assign(Shift shift) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    final selected = await showDialog<User>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Assign this shift to'),
        children: [
          for (final u in _staff)
            SimpleDialogOption(
              onPressed: () => Navigator.pop(context, u),
              child: Text(u.name),
            ),
        ],
      ),
    );
    if (selected == null) return;

    await ref.read(shiftRepositoryProvider).managerAssign(
      shiftId: shift.id,
      userId: selected.id,
      assignedByUserId: manager.id,
    );
    // No manual reload — see _postShift's comment.
  }

  Future<void> _remove(Shift shift) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null || shift.claimedByUserId == null) return;
    await ref.read(shiftRepositoryProvider).managerRemove(
      shiftId: shift.id,
      removedUserId: shift.claimedByUserId!,
      removedByUserId: manager.id,
    );
    // No manual reload — see _postShift's comment.
  }

  String _staffName(int? userId) {
    if (userId == null) return '';
    return _staff.where((u) => u.id == userId).firstOrNull?.name ?? 'Unknown';
  }

  Future<void> _decideOffDay(int requestId, OffDayRequestStatus status) async {
    final manager = ref.read(currentUserProvider);
    if (manager == null) return;
    await ref
        .read(offDayRequestRepositoryProvider)
        .decide(
          requestId: requestId,
          status: status,
          decidedByUserId: manager.id,
        );
    // Off-day requests still use the one-shot provider (no polling stream
    // for these — a lower-frequency, less time-sensitive list than the
    // shift board), so an explicit invalidate is needed here.
    if (_siteId != null) {
      ref.invalidate(offDayRequestsForSiteProvider(_siteId!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final shiftsAsync = _siteId == null
        ? const AsyncValue<List<Shift>>.loading()
        : ref.watch(shiftsStreamForSiteProvider(_siteId!));
    final offDayRequestsAsync = _siteId == null
        ? const AsyncValue<List<OffDayRequest>>.loading()
        : ref.watch(offDayRequestsForSiteProvider(_siteId!));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Roster Board'),
          actions: [
            if (_addonEnabled)
              IconButton(
                icon: const Icon(Icons.add),
                tooltip: 'Post a shift',
                onPressed: _postShift,
              ),
            const AssistantIconButton(),
          ],
          bottom: _addonEnabled
              ? const TabBar(
                  tabs: [
                    Tab(text: 'Shifts'),
                    Tab(text: 'Off-Day Requests'),
                  ],
                )
              : null,
        ),
        drawer: const ManagementDrawer(title: 'Roster Board'),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : !_addonEnabled
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'The Roster add-on isn\'t switched on for this venue. '
                    'Enable it in Settings > Company to start posting shifts.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : TabBarView(
                children: [
                  _buildShiftsTab(context, shiftsAsync),
                  _buildOffDayRequestsTab(context, offDayRequestsAsync),
                ],
              ),
      ),
    );
  }

  Widget _buildShiftsTab(
    BuildContext context,
    AsyncValue<List<Shift>> shiftsAsync,
  ) {
    return shiftsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) =>
                  Center(child: Text('Could not load shifts: $error')),
              data: (shifts) => shifts.isEmpty
                  ? const Center(
                      child: Text('No shifts posted yet. Tap + to add one.'),
                    )
                  : ResponsiveContent(
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          for (final shift in shifts)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AppCard(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '${formatDateTime(shift.startsAt)} - '
                                            '${shift.endsAt.hour.toString().padLeft(2, '0')}:'
                                            '${shift.endsAt.minute.toString().padLeft(2, '0')}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                          Text(
                                            [
                                              if (shift.category != null)
                                                shift.category!,
                                              shift.status == ShiftStatus.open
                                                  ? 'Open'
                                                  : '${shift.status == ShiftStatus.assigned ? 'Assigned' : 'Claimed'} - ${_staffName(shift.claimedByUserId)}',
                                            ].join(' · '),
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                    PopupMenuButton<String>(
                                      onSelected: (action) {
                                        if (action == 'assign') {
                                          _assign(shift);
                                        }
                                        if (action == 'remove') {
                                          _remove(shift);
                                        }
                                      },
                                      itemBuilder: (context) => [
                                        const PopupMenuItem(
                                          value: 'assign',
                                          child: Text('Assign directly'),
                                        ),
                                        if (shift.status != ShiftStatus.open)
                                          const PopupMenuItem(
                                            value: 'remove',
                                            child: Text('Remove claim'),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
            );
  }

  Widget _buildOffDayRequestsTab(
    BuildContext context,
    AsyncValue<List<OffDayRequest>> requestsAsync,
  ) {
    return requestsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) =>
          Center(child: Text('Could not load off-day requests: $error')),
      data: (requests) => requests.isEmpty
          ? const Center(child: Text('No off-day requests.'))
          : ResponsiveContent(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  for (final request in requests)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: AppCard(
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_staffName(request.userId)} - '
                                    '${formatDate(request.requestedDate)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  if (request.reason != null)
                                    Text(
                                      request.reason!,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodySmall,
                                    ),
                                ],
                              ),
                            ),
                            if (request.status == OffDayRequestStatus.pending)
                              PopupMenuButton<String>(
                                onSelected: (action) {
                                  if (action == 'approve') {
                                    _decideOffDay(
                                      request.id,
                                      OffDayRequestStatus.approved,
                                    );
                                  }
                                  if (action == 'deny') {
                                    _decideOffDay(
                                      request.id,
                                      OffDayRequestStatus.denied,
                                    );
                                  }
                                },
                                itemBuilder: (context) => const [
                                  PopupMenuItem(
                                    value: 'approve',
                                    child: Text('Approve'),
                                  ),
                                  PopupMenuItem(
                                    value: 'deny',
                                    child: Text('Deny'),
                                  ),
                                ],
                              )
                            else
                              _OffDayStatusChip(status: request.status),
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

class _OffDayStatusChip extends StatelessWidget {
  const _OffDayStatusChip({required this.status});

  final OffDayRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (StatusKind kind, String label) = switch (status) {
      OffDayRequestStatus.approved => (StatusKind.pass, 'Approved'),
      OffDayRequestStatus.denied => (StatusKind.critical, 'Denied'),
      OffDayRequestStatus.pending => (StatusKind.caution, 'Pending'),
    };
    return StatusBadge(kind: kind, label: label);
  }
}
