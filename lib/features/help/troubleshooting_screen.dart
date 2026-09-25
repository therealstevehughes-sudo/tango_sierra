import 'package:flutter/material.dart';

import '../../core/widgets/responsive_content.dart';
import 'help_content.dart';

/// Help section (2026-09-24) — same shape as `FaqScreen`, separate screen
/// since "what does X mean" and "something's not working" are different
/// intents even though both render as an expandable list.
class TroubleshootingScreen extends StatelessWidget {
  const TroubleshootingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Troubleshooting')),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 640,
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: troubleshootingEntries.length,
            itemBuilder: (context, index) {
              final entry = troubleshootingEntries[index];
              return Card(
                child: ExpansionTile(
                  // Layout fix (2026-09-25) — see faq_screen.dart's own
                  // comment on this same fix.
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
