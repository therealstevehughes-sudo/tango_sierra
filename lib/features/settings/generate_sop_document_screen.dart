import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/services/document_store.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/document.dart';
import '../../shared/models/sop_template_type.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/backend_providers.dart';
import '../../shared/providers/document_providers.dart';
import '../../shared/providers/site_providers.dart';

enum _GenerateState { pickingTemplate, generating, reviewing, saving }

// SOP/HACCP AI-assisted document generation (Phase 2, 2026-09-30) —
// reached from Document Centre's "Generate with AI" action. Deliberately
// a linear, single-purpose flow (pick template -> generate -> review/edit
// -> save), not folded into the plain upload dialog, since generation has
// a genuinely different shape (a wait step, editable AI output) that
// would clutter that simpler flow.
//
// Every generated document is explicitly framed as a first draft in the
// UI copy itself (see l10n.sopGenerationDisclaimer) - this is synthesis
// from a template, not a citation-grounded answer like the AI assistant's
// Q&A (see generate-sop-document's own doc comment for why that
// distinction matters for a compliance app).
class GenerateSopDocumentScreen extends ConsumerStatefulWidget {
  const GenerateSopDocumentScreen({super.key});

  @override
  ConsumerState<GenerateSopDocumentScreen> createState() =>
      _GenerateSopDocumentScreenState();
}

class _GenerateSopDocumentScreenState
    extends ConsumerState<GenerateSopDocumentScreen> {
  _GenerateState _state = _GenerateState.pickingTemplate;
  SopTemplateType _selectedTemplate = SopTemplateType.cleaningSchedule;
  final _extraContextController = TextEditingController();
  final _contentController = TextEditingController();
  final _titleController = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _extraContextController.dispose();
    _contentController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _generate() async {
    setState(() {
      _state = _GenerateState.generating;
      _error = null;
    });

    final site = await ref.read(currentSiteProvider.future);
    final client = ref.read(backendRestClientProvider);
    try {
      final response = await client.invokeFunction('generate-sop-document', {
        'template_type': _selectedTemplate.name,
        'site_name': site.name,
        if (_extraContextController.text.trim().isNotEmpty)
          'extra_context': _extraContextController.text.trim(),
      });
      if (!mounted) return;
      if (response['outcome'] != 'generated') {
        setState(() {
          _state = _GenerateState.pickingTemplate;
          _error = response['error']?.toString();
        });
        return;
      }
      setState(() {
        _contentController.text = response['content'] as String? ?? '';
        _titleController.text = sopTemplateTypeLabel(_selectedTemplate);
        _state = _GenerateState.reviewing;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _state = _GenerateState.pickingTemplate;
        _error = e.toString();
      });
    }
  }

  Future<void> _saveAsDocument() async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser?.siteId == null) return;
    setState(() => _state = _GenerateState.saving);

    final title = _titleController.text.trim().isEmpty
        ? sopTemplateTypeLabel(_selectedTemplate)
        : _titleController.text.trim();

    // Same bundled Roboto asset eho_export_service.dart uses, for the same
    // reason: real Unicode text needs a font that covers it, and the pdf
    // package's default base14 Helvetica does not.
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final doc = pw.Document(theme: pw.ThemeData.withFont(base: font, bold: font));
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: title),
          pw.SizedBox(height: 8),
          pw.Text(
            _contentController.text,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );

    final bytes = await doc.save();
    final filePath = await ref
        .read(documentStoreProvider)
        .persistBytes('${title.replaceAll(RegExp(r'[^\w\s-]'), '')}.pdf', bytes);

    await ref.read(documentRepositoryProvider).create(
      siteId: currentUser!.siteId!,
      title: title,
      category: DocumentCategory.procedure,
      filePath: filePath,
      uploadedByUserId: currentUser.id,
    );

    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.generateSopTitle),
        actions: const [AssistantIconButton()],
      ),
      body: SafeArea(
        child: ResponsiveContent(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppCard(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(
                      l10n.sopGenerationDisclaimer,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                if (_state == _GenerateState.pickingTemplate ||
                    _state == _GenerateState.generating) ...[
                  DropdownButtonFormField<SopTemplateType>(
                    initialValue: _selectedTemplate,
                    decoration: InputDecoration(
                      labelText: l10n.sopTemplateFieldLabel,
                    ),
                    items: SopTemplateType.values
                        .map(
                          (t) => DropdownMenuItem(
                            value: t,
                            child: Text(sopTemplateTypeLabel(t, l10n)),
                          ),
                        )
                        .toList(),
                    onChanged: _state == _GenerateState.generating
                        ? null
                        : (value) => setState(
                            () => _selectedTemplate = value ?? _selectedTemplate,
                          ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _extraContextController,
                    enabled: _state != _GenerateState.generating,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: l10n.sopExtraContextLabel,
                      hintText: l10n.sopExtraContextHint,
                    ),
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _state == _GenerateState.generating
                        ? null
                        : _generate,
                    icon: _state == _GenerateState.generating
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(
                      _state == _GenerateState.generating
                          ? l10n.generatingText
                          : l10n.generateDraftButton,
                    ),
                  ),
                ] else ...[
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: l10n.documentTitleLabel,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _contentController,
                    maxLines: 20,
                    decoration: InputDecoration(
                      labelText: l10n.reviewAndEditDraftLabel,
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _state == _GenerateState.saving
                        ? null
                        : _saveAsDocument,
                    icon: _state == _GenerateState.saving
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save_outlined),
                    label: Text(l10n.saveAsDocumentButton),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
