import 'package:flutter/material.dart';

import '../../core/widgets/responsive_content.dart';
import 'help_content.dart';

/// Help section (2026-09-24) — a plain expandable Q&A list, reachable
/// from every tier (see `HelpScreen`). Content is a first-pass draft in
/// `help_content.dart`, meant to be edited, not a placeholder.
class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQ')),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 640,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: faqEntries.length,
            itemBuilder: (context, index) {
              final entry = faqEntries[index];
              return Card(
                child: ExpansionTile(
                  // Layout fix (2026-09-25, direct user report) —
                  // ExpansionTile draws its own plain rectangular border
                  // when expanded by default, which clashes visibly with
                  // the Card's rounded corners ("little lines on the
                  // corners"). No border needed; the Card already frames
                  // it.
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
              );
            },
          ),
        ),
      ),
    );
  }
}
