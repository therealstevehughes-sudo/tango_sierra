import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/session_summary.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../onboarding/staff_assignment_screen.dart';
import '../venue_setup/venue_setup_wizard_screen.dart';

class ManagerScreen extends ConsumerWidget {
  const ManagerScreen({super.key});

  Map<String, List<TaskSubmission>> groupEntriesByStaff(
    List<TaskSubmission> items,
  ) {
    final Map<String, List<TaskSubmission>> grouped = {};

    for (final entry in items) {
      grouped.putIfAbsent(entry.completedBy, () => []);
      grouped[entry.completedBy]!.add(entry);
    }

    return grouped;
  }

  String formatDateTime(DateTime dateTime) {
    const months = <String>[
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final day = dateTime.day;
    final month = months[dateTime.month - 1];
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return '$day $month $year $hour:$minute';
  }

  String buildLogLine(TaskSubmission entry) {
    final symbol = entry.status == 'PASS' ? '✓' : '✗';
    final statusText = entry.status == 'PASS' ? 'Pass' : 'Fail';
    final photoText = entry.photoAttached ? ' 📷' : '';

    return '$symbol ${entry.taskTitle} (${formatDateTime(entry.completedAt)}) - $statusText$photoText';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesAsync = ref.watch(taskSubmissionsStreamProvider);
    final currentUser = ref.watch(currentUserProvider);
    final sessionSummaryRepo = ref.watch(sessionSummaryRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager View'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const VenueSetupWizardScreen(),
                ),
              );
            },
            icon: const Icon(Icons.store),
            tooltip: 'Venue Setup',
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaffAssignmentScreen(),
                ),
              );
            },
            icon: const Icon(Icons.assignment_ind),
            tooltip: 'Assign Tasks',
          ),
          IconButton(
            onPressed: () {
              ref.read(currentUserProvider.notifier).state = null;
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
          ),
        ],
      ),
      body: Column(
        children: [
          if (currentUser != null)
            StreamBuilder<List<SessionSummary>>(
              stream: sessionSummaryRepo.watchForManager(currentUser.id),
              builder: (context, snapshot) {
                final summaries = snapshot.data ?? [];
                if (summaries.isEmpty) return const SizedBox.shrink();
                return _SessionSummariesBanner(
                  summaries: summaries,
                  onAcknowledge: sessionSummaryRepo.acknowledge,
                );
              },
            ),
          Expanded(
            child: entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(
                    child: Text('No completed tasks logged yet'),
                  );
                }

                final groupedEntries = groupEntriesByStaff(entries);
                final staffNames = groupedEntries.keys.toList();

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: staffNames.length,
                  itemBuilder: (context, index) {
                    final staffName = staffNames[index];
                    final staffEntries = groupedEntries[staffName]!;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            staffName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...staffEntries.map(
                            (entry) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                buildLogLine(entry),
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) =>
                  Center(child: Text('Error loading tasks: $error')),
            ),
          ),
        ],
      ),
    );
  }
}

class _SessionSummariesBanner extends StatelessWidget {
  const _SessionSummariesBanner({
    required this.summaries,
    required this.onAcknowledge,
  });

  final List<SessionSummary> summaries;
  final void Function(int id) onAcknowledge;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.amber.shade50,
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Session Summaries',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...summaries.map(
            (summary) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      '${summary.staffName} — ${summary.passCount} pass / '
                      '${summary.failCount} fail'
                      '${summary.note != null ? '\n"${summary.note}"' : ''}',
                    ),
                  ),
                  if (!summary.acknowledged)
                    TextButton(
                      onPressed: () => onAcknowledge(summary.id),
                      child: const Text('Acknowledge'),
                    )
                  else
                    const Icon(Icons.check, color: Colors.green),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
