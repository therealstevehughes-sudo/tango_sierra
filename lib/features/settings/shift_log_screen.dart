import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/shift_log.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/site_providers.dart';

// Shift log (2026-09-24, direct user request) — a plain "who clocked in/
// out when" list for management, a habit-tracking signal (see ShiftLog's
// own doc comment), never a graded score — same anti-gaming shape the
// leadership dashboard's own per-person lookup already uses (a list, not
// a colour-graded bar).
class ShiftLogScreen extends ConsumerStatefulWidget {
  const ShiftLogScreen({super.key});

  @override
  ConsumerState<ShiftLogScreen> createState() => _ShiftLogScreenState();
}

class _ShiftLogScreenState extends ConsumerState<ShiftLogScreen> {
  bool _loading = true;
  List<ShiftLog> _logs = [];
  Map<int, User> _usersById = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final site = await ref.read(currentSiteProvider.future);
    final logs = await ref
        .read(shiftLogRepositoryProvider)
        .getRecentForSite(site.id);
    final staff = await ref.read(userRepositoryProvider).getForSite(site.id);
    if (!mounted) return;
    setState(() {
      _logs = logs;
      _usersById = {for (final u in staff) u.id: u};
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shift Log'),
        actions: const [AssistantIconButton()],
      ),
      drawer: const ManagementDrawer(title: 'Shift Log'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _logs.isEmpty
                ? const AppCard(
                    child: Text('No clock-ins recorded yet.'),
                  )
                : ListView.separated(
                    itemCount: _logs.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) =>
                        _ShiftLogTile(
                          log: _logs[index],
                          user: _usersById[_logs[index].userId],
                        ),
                  ),
          ),
        ),
      ),
    );
  }
}

class _ShiftLogTile extends StatelessWidget {
  const _ShiftLogTile({required this.log, required this.user});

  final ShiftLog log;
  final User? user;

  @override
  Widget build(BuildContext context) {
    final duration = log.duration;
    return AppCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Unknown',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  'In: ${formatDateTime(log.clockInAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  log.clockOutAt == null
                      ? 'Still clocked in'
                      : 'Out: ${formatDateTime(log.clockOutAt!)}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: log.clockOutAt == null ? AppColors.teal : null,
                  ),
                ),
              ],
            ),
          ),
          if (duration != null)
            Text(
              '${duration.inHours}h ${duration.inMinutes % 60}m',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
        ],
      ),
    );
  }
}
