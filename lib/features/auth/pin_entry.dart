import 'package:flutter/material.dart';

import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../shared/models/user.dart';

/// PIN-entry step shared by the main login screen and Leadership Access
/// (Sprint 031) — identical UI and logic in both flows, not just similar
/// looking, so extracted rather than duplicated per this project's usual
/// "share what's genuinely identical, duplicate what only resembles"
/// convention.
class PinEntry extends StatelessWidget {
  const PinEntry({
    super.key,
    required this.user,
    required this.controller,
    required this.error,
    required this.submitting,
    required this.onSubmit,
    required this.onBack,
  });

  final User user;
  final TextEditingController controller;
  final String? error;
  final bool submitting;
  final VoidCallback onSubmit;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          user.name,
          style: Theme.of(context).textTheme.headlineMedium,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          obscureText: true,
          textAlign: TextAlign.center,
          decoration: const InputDecoration(labelText: "Enter PIN"),
        ),
        const SizedBox(height: 20),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: StatusBadge(kind: StatusKind.critical, label: error!),
          ),
        PrimaryActionButton(
          label: "LOGIN",
          onPressed: submitting ? null : onSubmit,
        ),
        TextButton(onPressed: onBack, child: const Text("Back")),
      ],
    );
  }
}
