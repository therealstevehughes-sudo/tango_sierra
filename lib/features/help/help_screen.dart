import 'package:flutter/material.dart';

import '../../core/widgets/responsive_content.dart';
import '../onboarding/contact_venurite_screen.dart';
import 'ask_question_screen.dart';
import 'faq_screen.dart';
import 'troubleshooting_screen.dart';

/// Shown when the AI assistant genuinely can't be reached — no network, or
/// the backend itself is down/misconfigured (never for "limit reached",
/// which is a normal, handled outcome with its own honest UI inside
/// `AskQuestionScreen`, not an error). Public (not private to one screen)
/// since both `HelpScreen`'s pre-2026-09-27 placeholder and
/// `AskQuestionScreen`'s real error path show the exact same message —
/// the same "AI down, here's what still works" destination discussed with
/// the user before the backend existed.
void showAiOfflineNotice(BuildContext context) {
  showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Couldn't reach the assistant"),
      content: const Text(
        "The AI assistant isn't reachable right now - could be your "
        'connection, or the service is temporarily down. In the '
        'meantime, FAQ and Troubleshooting below cover the most common '
        'questions, or contact VenuRite directly.',
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

/// Help hub (2026-09-24; redesigned 2026-09-25 as the one omnipresent
/// destination behind AssistantIconButton on every screen). Reached from
/// every tier, including base (which otherwise has no drawer/menu at all
/// — see `WorkerHubScreen`'s own doc comment on minimalism) — a one-off
/// destination, never a new persistent nav surface.
///
/// "Ask a question" now opens the real `AskQuestionScreen` (2026-09-27) —
/// see that file for the RAG backend it talks to. A genuine connectivity/
/// backend failure there falls through to `showAiOfflineNotice` above,
/// preserving the exact offline-degrade design agreed before the backend
/// was built: no network, or the AI backend down, both fall through to
/// this same FAQ/Troubleshooting/Contact content, which has zero network
/// dependency of its own.
///
/// Reuses `ContactVenuRiteScreen` unchanged (it previously only appeared
/// in first-launch onboarding) rather than duplicating its email-contact
/// logic.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AskQuestionScreen(),
                    ),
                  ),
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
