import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/widgets/responsive_content.dart';

/// First-launch "Contact VenuRite" (2026-09-14) — for anyone who doesn't
/// fit cleanly into "sign up" or "join an existing company" (an
/// enterprise prospect, a confused visitor, or VenuRite staff setting up
/// an assisted onboarding for a large client). Just an email contact
/// point today — no support ticketing system exists to build against.
class ContactVenuRiteScreen extends StatelessWidget {
  const ContactVenuRiteScreen({super.key});

  static const _email = 'hello@venurite.com';

  Future<void> _emailUs() async {
    final uri = Uri(scheme: 'mailto', path: _email);
    await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact VenuRite')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 380,
            alignment: Alignment.center,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.mail_outline, size: 48),
                const SizedBox(height: 16),
                const Text(
                  "Whether you're a large group wanting a hand setting up, "
                  "or just have a question — we're happy to help.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                SelectableText(
                  _email,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _emailUs,
                  icon: const Icon(Icons.email_outlined),
                  label: const Text('Email us'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
