import 'package:flutter/material.dart';

import '../../core/widgets/responsive_content.dart';
import '../onboarding/contact_venurite_screen.dart';
import 'faq_screen.dart';
import 'troubleshooting_screen.dart';

/// Help hub (2026-09-24; redesigned 2026-09-25 as the one omnipresent
/// destination behind AssistantIconButton on every screen). Reached from
/// every tier, including base (which otherwise has no drawer/menu at all
/// — see `WorkerHubScreen`'s own doc comment on minimalism) — a one-off
/// destination, never a new persistent nav surface.
///
/// "Ask a question" is the AI assistant's own future entry point — not
/// built yet (needs the compliance-library embedding pipeline + a live
/// backend, see DECISIONS_LOG.md), so it currently opens a plain
/// not-yet-available notice instead of erroring or silently doing
/// nothing. Once built, the SAME tile starts actually answering — this
/// hub is also the offline-degrade destination discussed with the user:
/// no network, or the AI backend down, both fall through to this same
/// FAQ/Troubleshooting/Contact content, which has zero network
/// dependency of its own.
///
/// Reuses `ContactVenuRiteScreen` unchanged (it previously only appeared
/// in first-launch onboarding) rather than duplicating its email-contact
/// logic.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  void _showAskAQuestionNotice(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ask a question'),
        content: const Text(
          "The AI assistant isn't switched on for this install yet. In "
          'the meantime, FAQ and Troubleshooting below cover the most '
          'common questions, or contact VenuRite directly.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help')),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 480,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: const Text('Ask a question'),
                  subtitle: const Text(
                    'Get a straight answer, in plain language',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showAskAQuestionNotice(context),
                ),
              ),
              const SizedBox(height: 8),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('FAQ'),
                  subtitle: const Text('Common questions, answered'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const FaqScreen()),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.build_outlined),
                  title: const Text('Troubleshooting'),
                  subtitle: const Text("Something not working? Start here"),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const TroubleshootingScreen(),
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.mail_outline),
                  title: const Text('Contact VenuRite'),
                  subtitle: const Text('Get in touch directly'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ContactVenuRiteScreen(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
