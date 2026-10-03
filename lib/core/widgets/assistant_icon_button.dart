import 'package:flutter/material.dart';

/// Superseded by [AssistantFab] (2026-10-03, direct founder feedback: the
/// AI icon crowded every screen's header alongside Log out/language/etc.).
/// There's now a single floating AI button painted once at the app root
/// (see app.dart's MaterialApp.builder) instead of one icon repeated in
/// ~60 screens' own AppBar actions.
///
/// Kept as a no-op, rather than deleting it and touching every one of
/// those call sites, purely to avoid a 60-file mechanical churn for zero
/// behavioural gain — each `actions: [..., const AssistantIconButton()]`
/// still compiles and now renders nothing.
class AssistantIconButton extends StatelessWidget {
  const AssistantIconButton({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}
