import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/bug_report_providers.dart';

/// Report a bug (2026-10-02) — reachable from HelpScreen by any tier,
/// same placement principle as AllergenMatrixScreen: whoever hits a
/// problem should be able to tell VenuRite about it without needing
/// venueManager+ access. See admin/screens/admin_bug_reports_screen.dart
/// for the VenuRite-side view these rows feed.
class ReportBugScreen extends ConsumerStatefulWidget {
  const ReportBugScreen({super.key});

  @override
  ConsumerState<ReportBugScreen> createState() => _ReportBugScreenState();
}

class _ReportBugScreenState extends ConsumerState<ReportBugScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _submitting = false;
  bool _submitted = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final organisationId = ref.read(currentBackendOrganisationIdProvider);
    if (organisationId == null) return;
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty || description.isEmpty) return;

    final currentUser = ref.read(currentUserProvider);
    setState(() => _submitting = true);
    try {
      await ref.read(bugReportRepositoryProvider).submit(
        organisationId: organisationId,
        siteId: currentUser?.siteId,
        reportedByUserId: currentUser?.id,
        title: title,
        description: description,
        platform: defaultTargetPlatform.name,
      );
      if (!mounted) return;
      setState(() => _submitted = true);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.bugReportFailedMessage)),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final hasBackendOrg =
        ref.watch(currentBackendOrganisationIdProvider) != null;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.reportBugTitle),
        actions: const [AssistantIconButton()],
      ),
      body: SafeArea(
        child: ResponsiveContent(
          maxWidth: 480,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: !hasBackendOrg
                ? Center(child: Text(l10n.reportBugRequiresAccountText))
                : _submitted
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 48),
                        const SizedBox(height: 16),
                        Text(
                          l10n.bugReportSubmittedMessage,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        l10n.reportBugIntroText,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          labelText: l10n.bugReportTitleLabel,
                          border: const OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: l10n.bugReportDescriptionLabel,
                          border: const OutlineInputBorder(),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: _submitting ? null : _submit,
                        child: Text(l10n.submitBugReportButton),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
