import 'package:flutter/material.dart';

import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../onboarding/contact_venurite_screen.dart';
import 'ask_question_screen.dart';
import 'faq_screen.dart';
import 'troubleshooting_screen.dart';
import '../../core/widgets/app_screen_header.dart';

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
    builder: (context) {
      final l10n = AppLocalizations.of(context)!;
      return AlertDialog(
        title: Text(l10n.couldntReachAssistant),
        content: Text(l10n.aiOfflineBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.okLabel),
          ),
        ],
      );
    },
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
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.helpTitle)),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 480,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: Text(l10n.askQuestionTitle),
                  subtitle: Text(l10n.askQuestionSubtitle),
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
                  title: Text(l10n.faqTitle),
                  subtitle: Text(l10n.faqSubtitle),
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
                  title: Text(l10n.troubleshootingTitle),
                  subtitle: Text(l10n.troubleshootingSubtitle),
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
                  title: Text(l10n.contactVenuriteTitle),
                  subtitle: Text(l10n.contactVenuriteSubtitle),
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
