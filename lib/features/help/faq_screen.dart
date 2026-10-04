import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import 'help_content.dart';
import '../../core/widgets/app_screen_header.dart';

/// Help section (2026-09-24, expanded 2026-10-04 — see help_content.dart's
/// own doc comment) — an expandable Q&A list, grouped under category
/// headers once the list grew past a handful of generic entries, reachable
/// from every tier (see `HelpScreen`). Fully bundled with the app, no
/// network dependency — this is what a worker has when there's no
/// internet for the AI assistant to reach.
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final entries = faqEntries(l10n);
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.faqTitle),
      ),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 640,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              final previousCategory = index == 0 ? null : entries[index - 1].category;
              final showHeader = entry.category != null && entry.category != previousCategory;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (showHeader)
                    Padding(
                      padding: EdgeInsets.fromLTRB(4, index == 0 ? 0 : 16, 4, 8),
                      child: Text(
                        entry.category!,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.muted,
                        ),
                      ),
                    ),
                  Card(
                    child: ExpansionTile(
                      // Layout fix (2026-09-25, direct user report) —
                      // ExpansionTile draws its own plain rectangular
                      // border when expanded by default, which clashes
                      // visibly with the Card's rounded corners ("little
                      // lines on the corners"). No border needed; the
                      // Card already frames it.
                      shape: const RoundedRectangleBorder(side: BorderSide.none),
                      collapsedShape: const RoundedRectangleBorder(
                        side: BorderSide.none,
                      ),
                      title: Text(
                        entry.question,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(entry.answer),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
