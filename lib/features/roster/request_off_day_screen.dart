import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../shared/providers/site_providers.dart'
    show organisationRepositoryProvider, currentSiteProvider, activeSiteProvider;

// Off-day requests (R5, 2026-09-27) — staff-facing: pick a date, optionally
// say why, submit; see your own past requests and their outcome. Mirrors
// ClaimBoardScreen's structure (addon gate, ResponsiveContent + ListView of
// AppCards) since it's the same "self-service roster action" shape.
// Reachable from the drawer (supervisor+) and WorkerHubScreen (base tier),
// same dual-entry pattern as Claim Shifts.
class RequestOffDayScreen extends ConsumerStatefulWidget {
  const RequestOffDayScreen({super.key});

  @override
  ConsumerState<RequestOffDayScreen> createState() =>
      _RequestOffDayScreenState();
}

class _RequestOffDayScreenState extends ConsumerState<RequestOffDayScreen> {
  bool _loading = true;
  bool _addonEnabled = false;
  int? _siteId;
  List<OffDayRequest> _myRequests = [];
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

    final myRequests = currentUser == null
        ? <OffDayRequest>[]
        : await ref
              .read(offDayRequestRepositoryProvider)
              .getForUser(currentUser.id);

    if (!mounted) return;
    setState(() {
      _addonEnabled = true;
      _siteId = siteId;
      _myRequests = myRequests;
      _loading = false;
    });
  }

  Future<void> _requestOffDay() async {
    final siteId = _siteId;
    final user = ref.read(currentUserProvider);
    if (siteId == null || user == null) return;

    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date == null || !mounted) return;

    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Request ${formatDate(date)} off'),
        content: TextField(
          controller: reasonController,
          decoration: const InputDecoration(labelText: 'Reason (optional)'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Submit request'),
          ),
        ],
      ),
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true) return;

    setState(() => _busy = true);
    await ref
        .read(offDayRequestRepositoryProvider)
        .request(
          siteId: siteId,
          userId: user.id,
          requestedDate: date,
          reason: reason.isEmpty ? null : reason,
        );
    if (!mounted) return;
    setState(() => _busy = false);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request a day off'),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  "Off-day requests aren't switched on for this venue yet. "
                  'Ask your manager to enable Roster in Settings.',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : ResponsiveContent(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  FilledButton.icon(
                    onPressed: _busy ? null : _requestOffDay,
                    icon: const Icon(Icons.event_busy_outlined),
                    label: const Text('Request a day off'),
                  ),
                  const SizedBox(height: 20),
                  if (_myRequests.isEmpty)
                    const Text('You have no off-day requests yet.')
                  else ...[
                    Text(
                      'Your requests',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    for (final request in _myRequests)
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
                                      formatDate(request.requestedDate),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w600,
                                          ),
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
                              _StatusChip(status: request.status),
                            ],
                          ),
                        ),
                      ),
                  ],
                ],
              ),
            ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

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
