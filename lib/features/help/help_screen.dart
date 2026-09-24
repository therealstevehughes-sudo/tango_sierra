import 'package:flutter/material.dart';

import '../../core/widgets/responsive_content.dart';
import '../onboarding/contact_venurite_screen.dart';
import 'faq_screen.dart';
import 'troubleshooting_screen.dart';

/// Help hub (2026-09-24) — one shared destination for every tier,
/// including base (which otherwise has no drawer/menu at all - see
/// `WorkerHubScreen`'s own doc comment on minimalism). Reached via a
/// single "?" icon everywhere, so it stays a one-off destination rather
/// than a new persistent nav surface, consistent with that rule.
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
