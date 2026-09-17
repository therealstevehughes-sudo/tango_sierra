import 'package:flutter/material.dart';

// Extracted (2026-09-17) from leadership_dashboard_screen.dart's private
// click-to-drill-down sheet so Sprint 038's Supplier Scorecard can reuse
// the exact same "tap a category, see the real rows behind it" pattern
// instead of duplicating it. Deliberately dumb: a title, a count, a plain
// list — no colour-grading or per-person framing lives in here, that
// judgment stays with whoever builds the list of rows.
class BreakdownSheet extends StatelessWidget {
  const BreakdownSheet({
    super.key,
    required this.title,
    required this.count,
    required this.rows,
  });

  final String title;
  final int count;
  final List<BreakdownRow> rows;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$title ($count)',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: rows.isEmpty
                  ? const Center(child: Text('Nothing in this category.'))
                  : ListView.separated(
                      controller: scrollController,
                      itemCount: rows.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final row = rows[index];
                        return ListTile(
                          title: Text(row.title),
                          subtitle: Text(row.subtitle),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class BreakdownRow {
  const BreakdownRow({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
}
