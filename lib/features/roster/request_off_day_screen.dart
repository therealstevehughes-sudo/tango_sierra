import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/status_badge.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/off_day_request.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/off_day_request_providers.dart';
import '../../core/widgets/app_screen_header.dart';
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
      builder: (context) {
        final l10n = AppLocalizations.of(context)!;
        return AlertDialog(
          title: Text(l10n.requestDateOffTitle(formatDate(date))),
          content: TextField(
            controller: reasonController,
            decoration: InputDecoration(labelText: l10n.reasonOptionalLabel),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.submitRequestButton),
            ),
          ],
        );
      },
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.requestADayOff),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : !_addonEnabled
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.offDayRequestsNotEnabled,
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
                    label: Text(l10n.requestADayOff),
                  ),
                  const SizedBox(height: 20),
                  if (_myRequests.isEmpty)
                    Text(l10n.noOffDayRequestsYet)
                  else ...[
                    Text(
                      l10n.yourRequestsLabel,
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
    final l10n = AppLocalizations.of(context)!;
    final (StatusKind kind, String label) = switch (status) {
      OffDayRequestStatus.approved => (StatusKind.pass, l10n.approvedLabel),
      OffDayRequestStatus.denied => (StatusKind.critical, l10n.deniedLabel),
      OffDayRequestStatus.pending => (StatusKind.caution, l10n.pendingLabel),
    };
    return StatusBadge(kind: kind, label: label);
  }
}
