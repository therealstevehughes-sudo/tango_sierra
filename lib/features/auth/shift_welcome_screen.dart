import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/data/motivational_quote_service.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/problem_register_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import '../tasks/task_controller.dart';

// Shift welcome screen (2026-09-24, direct user request) — shown once,
// right after a PIN login succeeds, before the normal home screen
// (WorkerHubScreen/TierHomeScreen). Gated by justLoggedInForShiftProvider
// in app.dart, same "simple bool flag" shape as MyApp's own splash gate.
// Groups today's tasks by segment into three loose buckets (opening_
// procedures -> start of shift, closing_procedures -> end of shift,
// everything else -> during the shift) — reuses real, already-seeded
// segment data rather than inventing a new "shift phase" concept the
// app has no other source for.
class ShiftWelcomeScreen extends ConsumerStatefulWidget {
  const ShiftWelcomeScreen({super.key, required this.user});

  final User user;

  @override
  ConsumerState<ShiftWelcomeScreen> createState() =>
      _ShiftWelcomeScreenState();
}

class _ShiftWelcomeScreenState extends ConsumerState<ShiftWelcomeScreen> {
  bool _loading = true;
  int _startCount = 0;
  int _duringCount = 0;
  int _endCount = 0;
  // Per-person, non-repeating rotation (2026-09-24) — see
  // MotivationalQuoteService's own doc comment. Falls back to the plain
  // random picker if the lookup fails for any reason; the quote is a
  // nice-to-have, never something that should block the welcome screen.
  String _quote = '';

  @override
  void initState() {
    super.initState();
    // Habit-tracking clock-in (2026-09-24) — see ShiftLog's own doc
    // comment: this is a "did people show up" signal, not a payroll
    // record. Fire-and-forget is fine here — worst case a missed clock-in
    // row, never something that blocks the person getting to work.
    _clockIn();
    _loadQuote();
    _load();
  }

  Future<void> _loadQuote() async {
    String quote;
    try {
      quote = await motivationalQuoteService.nextQuoteFor(widget.user.id);
    } catch (_) {
      quote = randomMotivationalQuote();
    }
    if (!mounted) return;
    setState(() => _quote = quote);
  }

  Future<void> _clockIn() async {
    try {
      await ref
          .read(shiftLogRepositoryProvider)
          .clockIn(userId: widget.user.id, siteId: widget.user.siteId);
    } catch (_) {
      // Best-effort — a missed clock-in row never blocks getting to work.
    }
  }

  Future<void> _load() async {
    final controller = TaskController(
      ref.read(taskSubmissionRepositoryProvider),
      ref.read(taskScheduleRepositoryProvider),
      ref.read(taskTemplateRepositoryProvider),
      ref.read(equipmentRepositoryProvider),
      widget.user,
      ref.read(notificationRuleRepositoryProvider),
      ref.read(triggerNotificationRepositoryProvider),
      ref.read(userRepositoryProvider),
      ref.read(problemRegisterRepositoryProvider),
    );
    try {
      await controller.loadTasks();
      if (!mounted) return;
      var start = 0, during = 0, end = 0;
      for (final task in controller.tasks) {
        switch (task.segment) {
          case 'opening_procedures':
            start++;
          case 'closing_procedures':
            end++;
          default:
            during++;
        }
      }
      setState(() {
        _startCount = start;
        _duringCount = during;
        _endCount = end;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loading = false);
    }
  }

  void _continue() {
    ref.read(justLoggedInForShiftProvider.notifier).state = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.teal,
      body: SafeArea(
        child: Center(
          child: ResponsiveContent(
            maxWidth: 440,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: AppCard(
                elevated: true,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome, ${widget.user.name.split(' ').first}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Fraunces',
                        fontWeight: FontWeight.w600,
                        fontSize: 24,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _quote,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.muted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else ...[
                      const Text(
                        "Here's what's on for your shift:",
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 12),
                      _ShiftCountRow(
                        icon: Icons.wb_twilight_outlined,
                        label: 'Start of shift',
                        count: _startCount,
                      ),
                      _ShiftCountRow(
                        icon: Icons.checklist_outlined,
                        label: 'During your shift',
                        count: _duringCount,
                      ),
                      _ShiftCountRow(
                        icon: Icons.nightlight_outlined,
                        label: 'End of shift',
                        count: _endCount,
                      ),
                    ],
                    const SizedBox(height: 24),
                    PrimaryActionButton(
                      label: 'Get started',
                      onPressed: _continue,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ShiftCountRow extends StatelessWidget {
  const _ShiftCountRow({
    required this.icon,
    required this.label,
    required this.count,
  });

  final IconData icon;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: AppColors.teal, size: 20),
          const SizedBox(width: 10),
          Expanded(child: Text(label)),
          Text(
            '$count',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
