import '../../core/errors/friendly_error.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/backend_shift_log.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_shift_log_providers.dart';
import '../../shared/providers/site_providers.dart'
    show siteRepositoryProvider, currentSiteProvider, activeSiteProvider;

// Shift verification queue (2026-10-02) — the supervisor-facing side of
// shift verification photos: every clock-in/out where the staff member
// declined the photo lands here until any supervisor+ (on any device —
// the whole reason this moved to the backend) confirms it actually
// happened. See shift_verification_flow.dart's own doc comment for why
// "decline" is a real, no-detriment alternative, not just a formality.
class ShiftVerificationQueueScreen extends ConsumerStatefulWidget {
  const ShiftVerificationQueueScreen({super.key});

  @override
  ConsumerState<ShiftVerificationQueueScreen> createState() =>
      _ShiftVerificationQueueScreenState();
}

class _ShiftVerificationQueueScreenState
    extends ConsumerState<ShiftVerificationQueueScreen> {
  bool _loading = true;
  String? _error;
  bool _addonEnabled = true;
  List<BackendShiftLog> _logs = [];
  Map<int, String> _staffNames = {};
  final _busyIds = <String>{};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final activeSite = ref.read(activeSiteProvider);
      final currentUser = ref.read(currentUserProvider);
      final siteId =
          activeSite?.id ??
          currentUser?.siteId ??
          (await ref.read(currentSiteProvider.future)).id;

      final site = await ref.read(siteRepositoryProvider).getById(siteId);
      if (!mounted) return;
      if (site == null || !site.shiftVerificationPhotosEnabled) {
        setState(() {
          _addonEnabled = false;
          _loading = false;
        });
        return;
      }

      final repo = ref.read(backendShiftLogRepositoryProvider);
      final logs = await repo.getRecentForSite(siteId, limit: 200);
      // Lazy retention purge — see BackendShiftLogRepository's own doc
      // comment: this backend has no cron, so viewing this screen is the
      // trigger point. Best-effort; a failure here never blocks the
      // queue itself from showing.
      try {
        await repo.purgeExpiredPhotos(
          logs: logs,
          retentionDays: site.shiftPhotoRetentionDays,
        );
      } catch (_) {}

      final staff = await ref.read(userRepositoryProvider).getForSite(siteId);
      if (!mounted) return;
      setState(() {
        _logs = logs;
        _staffNames = {for (final u in staff) u.id: u.name};
        _addonEnabled = true;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = friendlyErrorMessage(AppLocalizations.of(context)!, e);
        _loading = false;
      });
    }
  }

  Future<void> _verify(BackendShiftLog log, String which) async {
    final busyKey = '${log.id}-$which';
    setState(() => _busyIds.add(busyKey));
    try {
      await ref
          .read(backendShiftLogRepositoryProvider)
          .verify(shiftLogId: log.id, which: which);
      await _load();
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(friendlyErrorMessage(l10n, e))));
    } finally {
      if (mounted) setState(() => _busyIds.remove(busyKey));
    }
  }

  String _staffName(int userId) => _staffNames[userId] ?? '—';

  String _formatDateTime(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.day}/${d.month} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pending = _logs
        .where((l) => l.clockInPending || l.clockOutPending)
        .toList();

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.shiftVerificationQueueTitle),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? LoadErrorView(error: _error!, onRetry: _load)
          : !_addonEnabled
          ? Center(child: Text(l10n.shiftVerificationNotEnabledText))
          : SafeArea(
              child: ResponsiveContent(
                child: pending.isEmpty
                    ? Center(child: Text(l10n.noPendingVerificationsText))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: pending.length,
                        itemBuilder: (context, index) {
                          final log = pending[index];
                          return AppCard(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _staffName(log.userId),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (log.clockInPending)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              l10n.pendingClockInLabel(
                                                _formatDateTime(
                                                  log.clockInAt,
                                                ),
                                              ),
                                            ),
                                          ),
                                          OutlinedButton(
                                            onPressed:
                                                _busyIds.contains(
                                                  '${log.id}-in',
                                                )
                                                ? null
                                                : () => _verify(log, 'in'),
                                            child: Text(
                                              l10n.confirmHappenedButton,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (log.clockOutPending)
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            l10n.pendingClockOutLabel(
                                              _formatDateTime(
                                                log.clockOutAt!,
                                              ),
                                            ),
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed:
                                              _busyIds.contains(
                                                '${log.id}-out',
                                              )
                                              ? null
                                              : () => _verify(log, 'out'),
                                          child: Text(
                                            l10n.confirmHappenedButton,
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
    );
  }
}
