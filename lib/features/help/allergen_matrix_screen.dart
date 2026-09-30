import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/load_error_view.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/allergen.dart';
import '../../shared/models/menu_item.dart';
import '../../shared/models/menu_item_allergen_tag.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/menu_item_providers.dart';

// Staff-facing allergen matrix (Phase 2, allergen module, 2026-09-30) —
// reachable from every tier via HelpScreen (base tier's only route to
// reference content, same as FAQ/Troubleshooting — see HelpScreen's own
// doc comment on why this hub is the one thing base tier can reach
// beyond WorkerHubScreen). Read-only: only APPROVED items' published tags
// show here, never a draft's unreviewed suggestion — a server/FOH staff
// member checking this for a customer needs the reviewed answer, not a
// system guess.
//
// EHO export integration (PHASE_2_ROADMAP.md Sprint 7) deliberately NOT
// done here — eho_export_service.dart is a large, already-shipped
// compliance document; adding a section to it needs its own careful pass
// reading the full file, not a rushed addition alongside this screen.
// This screen's own PDF export below is self-contained and doesn't touch
// that file at all.
class AllergenMatrixScreen extends ConsumerWidget {
  const AllergenMatrixScreen({super.key});

  Future<void> _exportPdf(
    BuildContext context,
    WidgetRef ref,
    List<MenuItem> approvedItems,
    Map<int, List<MenuItemAllergenTag>> tagsByItem,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final doc = pw.Document();
    doc.addPage(
      pw.MultiPage(
        build: (context) => [
          pw.Header(level: 0, text: l10n.allergenMatrixTitle),
          pw.SizedBox(height: 12),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey400),
            children: [
              pw.TableRow(
                decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.all(4),
                    child: pw.Text(
                      l10n.dishNameLabel,
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ),
                  for (final allergen in Allergen.values)
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(
                        allergenDisplayName(allergen, l10n),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 8,
                        ),
                      ),
                    ),
                ],
              ),
              for (final item in approvedItems)
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(4),
                      child: pw.Text(item.name),
                    ),
                    for (final allergen in Allergen.values)
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(4),
                        child: pw.Text(
                          _cellSymbol(tagsByItem[item.id!], allergen),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                  ],
                ),
            ],
          ),
          pw.SizedBox(height: 16),
          pw.Text(
            '${l10n.allergenMatrixLegend}: '
            '${l10n.allergenStatusContains} = ✓ · '
            '${l10n.allergenStatusMayContain} = ?',
            style: const pw.TextStyle(fontSize: 9),
          ),
        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final path = p.join(
      dir.path,
      'allergen_matrix_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await File(path).writeAsBytes(await doc.save());

    if (!context.mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.exportCreatedTitle),
        content: Text(l10n.savedToLabel(path)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.okLabel),
          ),
        ],
      ),
    );
  }

  String _cellSymbol(List<MenuItemAllergenTag>? tags, Allergen allergen) {
    final tag = tags?.where((t) => t.allergen == allergen).firstOrNull;
    if (tag == null) return '';
    return tag.status == AllergenTagStatus.contains ? '✓' : '?';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.watch(currentUserProvider);
    final siteId = currentUser?.siteId;

    return Scaffold(
      appBar: AppScreenHeader(title: Text(l10n.allergenMatrixTitle)),
      body: siteId == null
          ? Center(child: Text(l10n.noSignedInUserError))
          : SafeArea(
              child: ResponsiveContent(
                child: Consumer(
                  builder: (context, ref, _) {
                    final asyncItems = ref.watch(
                      menuItemsForSiteProvider(siteId),
                    );
                    return asyncItems.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) => LoadErrorView(
                        error: error.toString(),
                        onRetry: () =>
                            ref.invalidate(menuItemsForSiteProvider(siteId)),
                      ),
                      data: (items) {
                        final approved = items
                            .where((i) => i.status == MenuItemStatus.approved)
                            .toList();
                        if (approved.isEmpty) {
                          return Center(
                            child: Text(l10n.noApprovedDishesYetText),
                          );
                        }
                        return FutureBuilder<
                          Map<int, List<MenuItemAllergenTag>>
                        >(
                          future: _loadTags(ref, approved),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            final tagsByItem = snapshot.data!;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: SingleChildScrollView(
                                      child: DataTable(
                                        columns: [
                                          DataColumn(
                                            label: Text(l10n.dishNameLabel),
                                          ),
                                          for (final allergen
                                              in Allergen.values)
                                            DataColumn(
                                              label: Text(
                                                allergenDisplayName(
                                                  allergen,
                                                  l10n,
                                                ),
                                              ),
                                            ),
                                        ],
                                        rows: [
                                          for (final item in approved)
                                            DataRow(
                                              cells: [
                                                DataCell(Text(item.name)),
                                                for (final allergen
                                                    in Allergen.values)
                                                  DataCell(
                                                    Text(
                                                      _cellSymbol(
                                                        tagsByItem[item.id!],
                                                        allergen,
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: OutlinedButton.icon(
                                    onPressed: () => _exportPdf(
                                      context,
                                      ref,
                                      approved,
                                      tagsByItem,
                                    ),
                                    icon: const Icon(Icons.picture_as_pdf_outlined),
                                    label: Text(l10n.exportAsPdfButton),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
    );
  }

  Future<Map<int, List<MenuItemAllergenTag>>> _loadTags(
    WidgetRef ref,
    List<MenuItem> items,
  ) async {
    final repo = ref.read(menuItemRepositoryProvider);
    final result = <int, List<MenuItemAllergenTag>>{};
    for (final item in items) {
      result[item.id!] = await repo.getAllergenTags(item.id!);
    }
    return result;
  }
}
