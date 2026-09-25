import 'package:flutter/material.dart';

import '../../features/help/help_screen.dart';

/// The one omnipresent help/AI-assistant entry point (2026-09-25, direct
/// user request) — added to every screen's own AppBar actions, replacing
/// the plain "?" icon that used to be base tier's own one-off addition.
/// Sparkle glyph rather than a lightbulb (reads as "insight/tip" in
/// dashboard contexts) or a literal head (looks odd at AppBar size) — the
/// closest thing to a recognised "AI feature" convention right now.
///
/// Always opens the same HelpScreen hub regardless of whether the AI
/// backend exists yet — see that screen's own doc comment on the
/// offline/not-yet-built degrade behaviour. One destination, one icon,
/// everywhere; nothing here depends on network state itself.
class AssistantIconButton extends StatelessWidget {
  const AssistantIconButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const HelpScreen()),
      ),
      icon: const Icon(Icons.auto_awesome),
      tooltip: 'Help & Assistant',
    );
  }
}
