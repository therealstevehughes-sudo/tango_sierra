import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/date_format.dart';
import '../../core/widgets/app_card.dart';
import '../../shared/models/issue.dart';
import '../../shared/providers/issue_providers.dart';
import 'issue_detail_screen.dart';

// Read-only for base tier (confirmed requirement) — lets a worker see the
// live status of things they raised without granting them any
// Process/Outcome editing power (IssueDetailScreen's [canManage]: false
// here means no update/resolve/escalate controls render at all).
// Deliberately just a status list, never a count-based or graded view of
// this person, per the governing anti-gaming rule.
class MyRaisedIssuesScreen extends ConsumerWidget {
  const MyRaisedIssuesScreen({super.key, required this.userId});

  final int userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Things I\'ve reported')),
      body: FutureBuilder<List<Issue>>(
        future: ref.read(issueRepositoryProvider).getRaisedByUser(userId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final issues = snapshot.data!;
          if (issues.isEmpty) {
            return const Center(
              child: Text('You haven\'t reported anything yet.'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: issues.length,
            separatorBuilder: (_, _) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final issue = issues[index];
              return InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        IssueDetailScreen(issue: issue, canManage: false),
                  ),
                ),
                child: AppCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              issue.subtype != null
                                  ? '${issueTypeDisplayName(issue.type)} · ${issue.subtype}'
                                  : issueTypeDisplayName(issue.type),
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              formatDateTime(issue.raisedAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      _StatusPill(status: issue.status),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final IssueStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color fg, Color bg) = switch (status) {
      IssueStatus.resolved => (AppColors.pass, AppColors.passBg),
      IssueStatus.escalated => (AppColors.critical, AppColors.criticalBg),
      IssueStatus.open => (AppColors.ink, AppColors.line),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        issueStatusDisplayName(status),
        style: Theme.of(
          context,
        ).textTheme.bodySmall?.copyWith(color: fg, fontWeight: FontWeight.w600),
      ),
    );
  }
}
