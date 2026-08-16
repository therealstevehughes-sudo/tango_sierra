import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/date_format.dart';
import '../../shared/models/branding_config.dart';
import '../../shared/models/site.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/models/training_record.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/branding_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/supplier_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/training_record_providers.dart';
import '../../shared/repositories/branding_config_repository.dart';
import '../../shared/repositories/site_repository.dart';
import '../../shared/repositories/supplier_repository.dart';
import '../../shared/repositories/task_submission_repository.dart';
import '../../shared/repositories/task_template_repository.dart';
import '../../shared/repositories/training_record_repository.dart';
import '../../shared/repositories/user_repository.dart';
import '../tasks/overdue_summary_service.dart';

// EHO/audit export (Sprint 031) — a one-tap, inspector-ready PDF of a
// venue's compliance records over a chosen date range. The #1 UK
// competitor feature this app was missing, per COMPETITIVE_ANALYSIS.md.
//
// Structure researched and agreed (see DECISIONS_LOG.md "EHO export
// format (researched)"): UK EHOs assess "Confidence in Management" —
// evidence the system runs daily and problems get corrected — not a
// paper mountain; they can assess within minutes. So this leads with
// Summary + Exceptions, not a dense everything-dump. The full detailed
// log still exists but is opt-in (includeFullLog), not the default.
//
// Training records (Sprint 031) feed this too — active-staff-only tallies
// in the Summary line and an expired-training subsection in Exceptions,
// same "never silently hidden" treatment as fails/not-completed tasks.
//
// HONEST LIMIT, stated on the export itself, not just in code: timestamps
// are device-clock (fakeable until a backend provides trusted server
// time), and "photo attached" is a marker only — no real image is
// captured or stored yet (confirmed by reading task_screen.dart: photo
// capture is still a boolean toggle, TaskSubmission.photoPath is never
// actually set). Claiming otherwise on an inspector-facing document would
// be actively misleading, not just an omission.
const _reviewSegment = 'management_compliance_oversight';

class _ExpiredTrainingEntry {
  const _ExpiredTrainingEntry({
    required this.staffName,
    required this.itemTitle,
    required this.expiredAt,
  });

  final String staffName;
  final String itemTitle;
  final DateTime expiredAt;
}

// Not-completed grouping (found live-testing: one abandoned session can
// create dozens of individual NOT_COMPLETED rows, all sharing the exact
// same completedAt timestamp — the moment of exit — since
// TaskController.logRemainingAsNotCompleted logs everything remaining in
// one pass). Grouping by (staffName, completedAt) is a correct summary of
// a real event, not a heuristic: every row in a group genuinely happened
// at the same moment for the same reason.
class _NotCompletedGroup {
  _NotCompletedGroup({required this.staffName, required this.sessionEndedAt})
    : taskCount = 1;

  final String staffName;
  final DateTime sessionEndedAt;
  int taskCount;
}

class _FlaggedDeliveryEntry {
  const _FlaggedDeliveryEntry({
    required this.completedAt,
    required this.taskTitle,
    required this.staffName,
    required this.supplierName,
    required this.approvalStatus,
  });

  final DateTime completedAt;
  final String taskTitle;
  final String staffName;
  final String supplierName;
  final SupplierApprovalStatus approvalStatus;
}

class EhoExportService {
  EhoExportService(
    this._submissionRepository,
    this._templateRepository,
    this._siteRepository,
    this._overdueSummaryService,
    this._trainingRecordRepository,
    this._userRepository,
    this._supplierRepository,
    this._brandingConfigRepository,
  );

  final TaskSubmissionRepository _submissionRepository;
  final TaskTemplateRepository _templateRepository;
  final SiteRepository _siteRepository;
  final OverdueSummaryService _overdueSummaryService;
  final SupplierRepository _supplierRepository;
  final TrainingRecordRepository _trainingRecordRepository;
  final UserRepository _userRepository;
  final BrandingConfigRepository _brandingConfigRepository;

  Future<String> generate({
    required int siteId,
    required DateTime start,
    required DateTime end,
    required String generatedByName,
    required bool includeFullLog,
  }) async {
    final sites = await _siteRepository.getAll();
    Site? site;
    for (final s in sites) {
      if (s.id == siteId) {
        site = s;
        break;
      }
    }
    final siteName = site?.name ?? 'Unknown site';

    // Branding (Sprint 031, finalized beta build order item 7) — a
    // branded compliance PDF reads as more professional to an inspector.
    // Only the company name and the brand accent colour (used for
    // heading text/rule colour) come from BrandingConfig — every FAIL/
    // NOT_COMPLETED/etc. row colour below stays exactly as hardcoded,
    // same "safety colours never overridden by brand" boundary as the
    // live app theme.
    final BrandingConfig? branding = site == null
        ? null
        : await _brandingConfigRepository.getCurrent(site.organisationId);
    final companyName = branding?.companyName ?? 'Kitchen Control';
    final accentColor = branding == null
        ? PdfColors.black
        : PdfColor.fromInt(branding.primaryColorArgb);

    final submissions = await _submissionRepository.getForSiteAndDateRange(
      siteId: siteId,
      start: start,
      end: end,
    );
    final templates = await _templateRepository.getAllCurrentVersions();
    final segmentByGroupId = {
      for (final t in templates) t.templateGroupId: t.segment,
    };

    final failEntries = submissions.where((s) => s.status == 'FAIL').toList();
    final notCompletedEntries = submissions
        .where((s) => s.status == 'NOT_COMPLETED')
        .toList();
    final passCount = submissions.where((s) => s.status == 'PASS').length;
    final fixedCount = failEntries
        .where((s) => s.correctiveActionOutcome == 'fixed')
        .length;
    final reportedCount = failEntries
        .where((s) => s.correctiveActionOutcome == 'reported')
        .length;
    final reviewEntries = submissions
        .where(
          (s) => segmentByGroupId[s.taskTemplateGroupId] == _reviewSegment,
        )
        .toList();

    final totalDays = end.difference(start).inDays;
    final daysWithSubmissions = submissions
        .map(
          (s) => DateTime(
            s.completedAt.year,
            s.completedAt.month,
            s.completedAt.day,
          ),
        )
        .toSet()
        .length;

    final outstanding = await _overdueSummaryService.getSummaryForSite(
      siteId,
    );

    // Training records (Sprint 031) — active staff only: a departed
    // member's lapsed training isn't a live "Confidence in Management"
    // gap for this venue today. Each staff member's history is reduced to
    // their latest record per item (a renewal supersedes the status of an
    // earlier expired one, even though the old row itself stays on file).
    final allUsers = await _userRepository.getAll();
    final activeStaff = allUsers
        .where((u) => u.siteId == siteId && u.active)
        .toList();
    final activeStaffIds = activeStaff.map((u) => u.id).toSet();
    final trainingRecords = await _trainingRecordRepository.getForSite(
      siteId,
    );
    final trainingByUser = <int, List<TrainingRecord>>{};
    for (final record in trainingRecords) {
      if (!activeStaffIds.contains(record.userId)) continue;
      trainingByUser.putIfAbsent(record.userId, () => []).add(record);
    }
    var trainingCurrentCount = 0;
    var trainingExpiringSoonCount = 0;
    var trainingExpiredCount = 0;
    final expiredTraining = <_ExpiredTrainingEntry>[];
    for (final user in activeStaff) {
      final latest = latestPerItem(trainingByUser[user.id] ?? []);
      for (final record in latest) {
        switch (computeTrainingStatus(record.expiresAt)) {
          case TrainingStatus.current:
            trainingCurrentCount++;
          case TrainingStatus.expiringSoon:
            trainingExpiringSoonCount++;
          case TrainingStatus.expired:
            trainingExpiredCount++;
            expiredTraining.add(
              _ExpiredTrainingEntry(
                staffName: user.name,
                itemTitle: record.displayTitle,
                expiredAt: record.expiresAt!,
              ),
            );
        }
      }
    }

    // Supplier register + traceability (Sprint 031, finalized beta build
    // order item 4, Sub-sprint B) — a due-diligence tally (active suppliers
    // by approval status) plus a flagged-deliveries subsection for any
    // submission in this date range that named a pending/suspended
    // supplier. Same "never silently hidden" treatment as expired training.
    final allSuppliers = await _supplierRepository.getForSite(siteId);
    final activeSuppliers = allSuppliers.where((s) => s.active).toList();
    final suppliersById = {for (final s in allSuppliers) s.id: s};
    final approvedSupplierCount = activeSuppliers
        .where((s) => s.approvalStatus == SupplierApprovalStatus.approved)
        .length;
    final pendingSupplierCount = activeSuppliers
        .where((s) => s.approvalStatus == SupplierApprovalStatus.pending)
        .length;
    final suspendedSupplierCount = activeSuppliers
        .where((s) => s.approvalStatus == SupplierApprovalStatus.suspended)
        .length;

    final flaggedDeliveries = <_FlaggedDeliveryEntry>[];
    for (final submission in submissions) {
      if (submission.supplierId == null) continue;
      final supplier = suppliersById[submission.supplierId];
      if (supplier == null ||
          supplier.approvalStatus == SupplierApprovalStatus.approved) {
        continue;
      }
      flaggedDeliveries.add(
        _FlaggedDeliveryEntry(
          completedAt: submission.completedAt,
          taskTitle: submission.taskTitle,
          staffName: submission.completedBy,
          supplierName: supplier.name,
          approvalStatus: supplier.approvalStatus,
        ),
      );
    }

    final bySegment = <String, List<TaskSubmission>>{};
    for (final submission in submissions) {
      final segment =
          segmentByGroupId[submission.taskTemplateGroupId] ?? 'Other';
      bySegment.putIfAbsent(segment, () => []).add(submission);
    }
    final sortedSegments = bySegment.keys.toList()..sort();

    // Real Unicode text (accented names, curly quotes, em-dashes in a
    // corrective-action note) needs a font that actually covers it — the
    // default base14 Helvetica does not. Roboto (OFL-licensed, bundled as
    // an asset — see assets/fonts/Roboto-OFL.txt) covers it correctly.
    // It's currently only available as a single variable-font file (no
    // separate static Bold from the source repo), so bold text renders
    // at regular weight for now — a disclosed, cosmetic-only trade-off,
    // not the defect being fixed here.
    final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final doc = pw.Document(
      theme: pw.ThemeData.withFont(base: font, bold: font),
    );

    // Resilience (found live-testing: a wide date range + heavy test-data
    // churn produced 81 submissions, pushing the full detailed log past the
    // `pdf` package's MultiPage page-count safety cap and throwing
    // PdfTooBigPageException with NOTHING saved at all — not even the
    // summary, the part an inspector actually reads). Two fixes, kept
    // together deliberately (see DECISIONS_LOG.md for the full source-code
    // investigation):
    //   1. Root cause: `pdf` 3.13.0's `Table` widget (`table.dart`) has
    //      `bool get hasMoreWidgets => true` hardcoded — a Table never
    //      correctly signals to MultiPage that it has finished spanning
    //      across pages, so a table needing genuine multi-page continuation
    //      (our 56-row Not-Completed table did; no single segment table did)
    //      makes MultiPage allocate blank pages forever until it hits the
    //      cap. `TableHelper.fromTextArray` does NOT fix this — verified in
    //      source, it constructs the identical Table class. The real fix is
    //      `_chunkedTable` below: never let a single Table need to span more
    //      than one page in the first place.
    //   2. Even with chunking, some future pathological volume could still
    //      overflow — Block A (limitations + Summary + Exceptions, what an
    //      inspector actually reads) must never be lost to that. Verified in
    //      source that `Document.addPage` commits a MultiPage's pages
    //      directly into the real PdfDocument as it lays out, with no
    //      rollback if it later throws — so a plain try/catch around
    //      `doc.addPage(...)` leaves the failed attempt's blank pages
    //      behind. Fixed by attempting each block in a throwaway `Document`
    //      first; only on success is an equivalent fresh widget (MultiPage
    //      keeps mutable state on itself between calls — confirmed via
    //      source, `_pages` is an instance field — so the exact same widget
    //      instance can't safely be reused; each attempt gets its own via
    //      the builder closures) added to the real output document.
    const maxPages = 150;

    void addResilientPage(
      pw.Document target,
      pw.MultiPage Function() build,
      pw.MultiPage Function() fallback, {
      bool Function(Object error)? isRecoverable,
    }) {
      final scratch = pw.Document();
      try {
        scratch.addPage(build());
      } catch (e) {
        if (isRecoverable != null && !isRecoverable(e)) rethrow;
        target.addPage(fallback());
        return;
      }
      target.addPage(build());
    }

    addResilientPage(
      doc,
      () => pw.MultiPage(
        maxPages: maxPages,
        header: (context) => context.pageNumber == 1
            ? _buildFullHeader(
                companyName,
                accentColor,
                siteName,
                site?.address,
                start,
                end,
                generatedByName,
              )
            : _buildCondensedHeader(companyName, accentColor, siteName, start, end),
        build: (context) => [
          _buildLimitationsNotice(),
          pw.SizedBox(height: 12),
          _buildSummarySection(
            totalSubmissions: submissions.length,
            passCount: passCount,
            failCount: failEntries.length,
            notCompletedCount: notCompletedEntries.length,
            totalDays: totalDays,
            daysWithSubmissions: daysWithSubmissions,
            fixedCount: fixedCount,
            reportedCount: reportedCount,
            reviewEntries: reviewEntries,
            activeStaffCount: activeStaff.length,
            trainingCurrentCount: trainingCurrentCount,
            trainingExpiringSoonCount: trainingExpiringSoonCount,
            trainingExpiredCount: trainingExpiredCount,
            activeSupplierCount: activeSuppliers.length,
            approvedSupplierCount: approvedSupplierCount,
            pendingSupplierCount: pendingSupplierCount,
            suspendedSupplierCount: suspendedSupplierCount,
          ),
          pw.SizedBox(height: 12),
          _buildExceptionsSection(
            failEntries: failEntries,
            notCompletedEntries: notCompletedEntries,
            outstanding: outstanding,
            expiredTraining: expiredTraining,
            flaggedDeliveries: flaggedDeliveries,
          ),
        ],
      ),
      () => pw.MultiPage(
        maxPages: maxPages,
        header: (context) => _buildCondensedHeader(companyName, accentColor, siteName, start, end),
        build: (context) => [
          pw.Text(
            'Export summary could not be generated for this date range — '
            'narrow the date range and try again.',
          ),
        ],
      ),
    );

    if (includeFullLog) {
      addResilientPage(
        doc,
        () => pw.MultiPage(
          maxPages: maxPages,
          // Always condensed — this block is a continuation of Block A
          // above, never really "page 1" of the export, even though
          // MultiPage restarts its own internal page numbering here.
          header: (context) => _buildCondensedHeader(companyName, accentColor, siteName, start, end),
          build: (context) => [
            pw.Text(
              'Full Detailed Log',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            if (sortedSegments.isEmpty)
              pw.Text(
                'No records in this date range.',
                style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
              ),
            for (final segment in sortedSegments) ...[
              _buildSegmentSection(segment, bySegment[segment]!),
              pw.SizedBox(height: 6),
            ],
          ],
        ),
        () => pw.MultiPage(
          maxPages: maxPages,
          header: (context) => _buildCondensedHeader(companyName, accentColor, siteName, start, end),
          build: (context) => [
            pw.Text(
              'Full Detailed Log — omitted',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              'This date range has too much activity to list in full '
              '(${sortedSegments.length} segments, ${submissions.length} '
              'records). Narrow the date range and regenerate, or leave '
              '"Include full detailed log" unchecked for the summary '
              'view above.',
            ),
          ],
        ),
        // All-or-nothing per block, deliberately — the pdf package has no
        // "here's what fit" callback, so a real partial cutoff would mean
        // hand-rolling pagination prediction. A clear notice beats a table
        // stopping mid-row. Only catch the specific page-cap exception here
        // — anything else is a real bug that should still surface.
        isRecoverable: (e) => e is PdfTooBigPageException,
      );
    }

    final documentsDir = await getApplicationDocumentsDirectory();
    final exportsDir = Directory(
      p.join(documentsDir.path, 'KitchenControlExports'),
    );
    if (!await exportsDir.exists()) {
      await exportsDir.create(recursive: true);
    }
    final timestamp = _formatFileTimestamp(DateTime.now());
    final filename = 'eho_export_${_sanitizeForFilename(siteName)}_'
        '$timestamp.pdf';
    final path = p.join(exportsDir.path, filename);
    await File(path).writeAsBytes(await doc.save());
    return path;
  }

  // Branding (Sprint 031, finalized beta build order item 7): companyName/
  // accentColor come from BrandingConfig when set, falling back to
  // "Kitchen Control"/black otherwise. Only the heading text/divider
  // colour are branded — every FAIL/critical-styled row elsewhere in this
  // document stays hardcoded, untouched by brand colour.
  pw.Widget _buildFullHeader(
    String companyName,
    PdfColor accentColor,
    String siteName,
    String? siteAddress,
    DateTime start,
    DateTime end,
    String generatedByName,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '$companyName — Compliance Export',
          style: pw.TextStyle(
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: accentColor,
          ),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          siteAddress == null ? siteName : '$siteName — $siteAddress',
        ),
        pw.Text('Records from ${formatDate(start)} to ${formatDate(end)}'),
        pw.Text(
          'Generated ${formatDateTime(DateTime.now())} by $generatedByName',
          style: const pw.TextStyle(color: PdfColors.grey700),
        ),
        pw.Divider(color: accentColor),
      ],
    );
  }

  pw.Widget _buildCondensedHeader(
    String companyName,
    PdfColor accentColor,
    String siteName,
    DateTime start,
    DateTime end,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          '$companyName — $siteName — ${formatDate(start)} to '
          '${formatDate(end)}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 0.5, color: accentColor),
      ],
    );
  }

  pw.Widget _buildLimitationsNotice() {
    return pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: PdfColors.amber50,
        border: pw.Border.all(color: PdfColors.amber700),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Notes on this record',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
          ),
          pw.Text(
            '- Timestamps reflect the recording device\'s local clock. '
            'This app does not yet use a trusted server time source.',
          ),
          pw.Text(
            '- "Photo attached" indicates a photo was marked as taken at '
            'the time of the check. This beta does not yet store or embed '
            'the actual photo image.',
          ),
        ],
      ),
    );
  }

  // Summary (Sprint 031, researched restructure) — the "Confidence in
  // Management" evidence an EHO actually looks for: is the system run
  // daily, and are problems corrected. Deliberately not a
  // schedule-vs-actual completion rate yet (that needs new period-based
  // computation against TaskSchedule, similar to Sub-sprint A's
  // due/overdue logic) — flagged as a real, agreed later refinement, not
  // a shortcut taken silently.
  pw.Widget _buildSummarySection({
    required int totalSubmissions,
    required int passCount,
    required int failCount,
    required int notCompletedCount,
    required int totalDays,
    required int daysWithSubmissions,
    required int fixedCount,
    required int reportedCount,
    required List<TaskSubmission> reviewEntries,
    required int activeStaffCount,
    required int trainingCurrentCount,
    required int trainingExpiringSoonCount,
    required int trainingExpiredCount,
    required int activeSupplierCount,
    required int approvedSupplierCount,
    required int pendingSupplierCount,
    required int suspendedSupplierCount,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Summary',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          '$totalSubmissions checks recorded: $passCount pass, $failCount '
          'fail, $notCompletedCount not completed.',
        ),
        pw.Text(
          'Daily activity: $daysWithSubmissions of $totalDays days in '
          'range had at least one recorded check.',
        ),
        pw.Text(
          failCount == 0
              ? 'No fails recorded in this period.'
              : '$failCount fail${failCount == 1 ? '' : 's'} recorded: '
                    '$fixedCount fixed on the spot, $reportedCount '
                    'reported to manager.',
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Staff training: $activeStaffCount active staff, '
          '$trainingCurrentCount training record'
          '${trainingCurrentCount == 1 ? '' : 's'} current, '
          '$trainingExpiringSoonCount expiring within 30 days, '
          '$trainingExpiredCount expired.',
        ),
        pw.Text(
          'Supplier due diligence: $activeSupplierCount active suppliers, '
          '$approvedSupplierCount approved, $pendingSupplierCount pending, '
          '$suspendedSupplierCount suspended.',
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          'Management review / oversight evidence',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (reviewEntries.isEmpty)
          pw.Text(
            'None recorded in this period.',
            style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
          )
        else
          for (final entry in reviewEntries)
            pw.Text(
              '  - ${entry.taskTitle} — ${formatDateTime(entry.completedAt)}'
              ' (${entry.completedBy})',
            ),
      ],
    );
  }

  // Exceptions (Sprint 031, researched restructure) — what EHOs actually
  // focus on. Fails and not-completed are kept as distinct subsections
  // deliberately, not merged: a fail was caught and (per the summary
  // above) addressed one way or another; a not-completed task was simply
  // never reached — a different kind of gap, read differently by an
  // inspector.
  pw.Widget _buildExceptionsSection({
    required List<TaskSubmission> failEntries,
    required List<TaskSubmission> notCompletedEntries,
    required List<OverdueSummaryEntry> outstanding,
    required List<_ExpiredTrainingEntry> expiredTraining,
    required List<_FlaggedDeliveryEntry> flaggedDeliveries,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Exceptions',
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Fails & corrective actions',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (failEntries.isEmpty)
          pw.Text(
            'None recorded in this period.',
            style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
          )
        else
          _buildExceptionTable(failEntries, showCorrectiveAction: true),
        pw.SizedBox(height: 8),
        pw.Text(
          'Not completed / abandoned mid-shift',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (notCompletedEntries.isEmpty)
          pw.Text(
            'None recorded in this period.',
            style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
          )
        else
          // Grouped by (staff, exact exit timestamp) — every row in a
          // group genuinely happened at the same moment for the same
          // reason (TaskController.logRemainingAsNotCompleted logs
          // everything remaining in one pass on exit), so this is a
          // correct summary of one real event, not a heuristic. Found
          // live-testing: one abandoned 20-task session otherwise produced
          // 16+ individual rows — noisy for an inspector to read and part
          // of what pushed a real table into needing multi-page spanning.
          for (final group in _groupNotCompleted(notCompletedEntries))
            pw.Text(
              '  - ${group.staffName}: session ended '
              '${formatDateTime(group.sessionEndedAt)} — '
              '${group.taskCount} task${group.taskCount == 1 ? '' : 's'} '
              'not completed',
              style: const pw.TextStyle(color: PdfColors.grey700),
            ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Training expired',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (expiredTraining.isEmpty)
          pw.Text(
            'None.',
            style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
          )
        else
          for (final entry in expiredTraining)
            pw.Text(
              '  - ${entry.staffName}: ${entry.itemTitle} '
              '(expired ${formatDate(entry.expiredAt)})',
              style: const pw.TextStyle(color: PdfColors.red800),
            ),
        pw.SizedBox(height: 8),
        pw.Text(
          'Deliveries from an unapproved supplier',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (flaggedDeliveries.isEmpty)
          pw.Text(
            'None.',
            style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
          )
        else
          for (final entry in flaggedDeliveries)
            pw.Text(
              '  - ${formatDateTime(entry.completedAt)}: ${entry.taskTitle} '
              '(${entry.staffName}) — ${entry.supplierName} '
              '(${supplierApprovalStatusLabel(entry.approvalStatus)})',
              style: const pw.TextStyle(color: PdfColors.red800),
            ),
        pw.SizedBox(height: 8),
        _buildOutstandingSection(outstanding),
      ],
    );
  }

  // Not-completed grouping (Sprint 031, EHO export resilience fix) — see
  // _NotCompletedGroup's own doc comment for why (staffName, completedAt)
  // is a correct grouping key, not a heuristic.
  List<_NotCompletedGroup> _groupNotCompleted(List<TaskSubmission> entries) {
    final byKey = <String, _NotCompletedGroup>{};
    for (final entry in entries) {
      final key =
          '${entry.completedBy}|${entry.completedAt.millisecondsSinceEpoch}';
      final existing = byKey[key];
      if (existing == null) {
        byKey[key] = _NotCompletedGroup(
          staffName: entry.completedBy,
          sessionEndedAt: entry.completedAt,
        );
      } else {
        existing.taskCount++;
      }
    }
    final groups = byKey.values.toList()
      ..sort((a, b) => b.sessionEndedAt.compareTo(a.sessionEndedAt));
    return groups;
  }

  // Chunking (Sprint 031, EHO export resilience fix) — routes around a
  // real `pdf` 3.13.0 package bug rather than fighting it: `Table`'s
  // `hasMoreWidgets` is hardcoded `true` (confirmed by reading
  // table.dart), so MultiPage never learns a Table has finished laying out
  // once it needs to continue onto a second page, and allocates blank
  // pages until it hits the page cap. A Table that only ever needs ONE
  // page never reaches that broken path. 25 rows/chunk stays just under
  // the ~28-row tables already proven to render correctly on their own.
  List<pw.Widget> _chunkedTable(
    List<pw.TableRow> rows,
    pw.TableRow headerRow,
    Map<int, pw.TableColumnWidth> columnWidths, {
    int chunkSize = 25,
  }) {
    if (rows.isEmpty) return const [];
    final widgets = <pw.Widget>[];
    for (var i = 0; i < rows.length; i += chunkSize) {
      final end = (i + chunkSize < rows.length) ? i + chunkSize : rows.length;
      widgets.add(
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          columnWidths: columnWidths,
          children: [headerRow, ...rows.sublist(i, end)],
        ),
      );
      if (end < rows.length) widgets.add(pw.SizedBox(height: 4));
    }
    return widgets;
  }

  pw.Widget _buildExceptionTable(
    List<TaskSubmission> entries, {
    required bool showCorrectiveAction,
  }) {
    final columnWidths = showCorrectiveAction
        ? const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(4),
          }
        : const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(2),
          };
    final headerRow = pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        _cell('Date/Time', bold: true),
        _cell('Task', bold: true),
        _cell('Staff', bold: true),
        if (showCorrectiveAction) _cell('Corrective action', bold: true),
      ],
    );
    final rows = [
      for (final entry in entries)
        pw.TableRow(
          children: [
            _cell(formatDateTime(entry.completedAt)),
            _cell(entry.taskTitle),
            _cell(entry.completedBy),
            if (showCorrectiveAction) _cell(_notesAndCorrectiveAction(entry)),
          ],
        ),
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: _chunkedTable(rows, headerRow, columnWidths),
    );
  }

  pw.Widget _buildOutstandingSection(List<OverdueSummaryEntry> entries) {
    final byStaff = <String, List<OverdueSummaryEntry>>{};
    for (final entry in entries) {
      byStaff.putIfAbsent(entry.staffName, () => []).add(entry);
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          'Currently outstanding (as of export time)',
          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
        ),
        if (byStaff.isEmpty)
          pw.Text(
            'None.',
            style: const pw.TextStyle(fontStyle: pw.FontStyle.italic),
          )
        else
          for (final staffName in byStaff.keys) ...[
            pw.Text(
              staffName,
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            for (final entry in byStaff[staffName]!)
              pw.Text(
                '  - ${entry.taskTitle}'
                '${entry.overdueSince == null ? '' : ' (overdue since ${formatDate(entry.overdueSince!)})'}',
                style: const pw.TextStyle(color: PdfColors.red800),
              ),
          ],
      ],
    );
  }

  pw.Widget _buildSegmentSection(
    String segment,
    List<TaskSubmission> submissions,
  ) {
    const columnWidths = {
      0: pw.FlexColumnWidth(2),
      1: pw.FlexColumnWidth(3),
      2: pw.FlexColumnWidth(2),
      3: pw.FlexColumnWidth(1.5),
      4: pw.FlexColumnWidth(4),
    };
    final headerRow = pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        _cell('Date/Time', bold: true),
        _cell('Task', bold: true),
        _cell('Staff', bold: true),
        _cell('Result', bold: true),
        _cell('Notes / corrective action', bold: true),
      ],
    );
    final rows = [
      for (final submission in submissions)
        pw.TableRow(
          children: [
            _cell(formatDateTime(submission.completedAt)),
            _cell(
              '${submission.taskTitle}'
              '${submission.numericValue == null ? '' : ' (${submission.numericValue})'}'
              '${submission.photoAttached ? ' [Photo attached]' : ''}',
            ),
            _cell(submission.completedBy),
            _cell(
              submission.status,
              color: switch (submission.status) {
                'FAIL' => PdfColors.red800,
                'NOT_COMPLETED' => PdfColors.grey700,
                _ => null,
              },
            ),
            _cell(_notesAndCorrectiveAction(submission)),
          ],
        ),
    ];
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          segment,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        ..._chunkedTable(rows, headerRow, columnWidths),
      ],
    );
  }

  String _notesAndCorrectiveAction(TaskSubmission submission) {
    final parts = <String>[
      if (submission.notes != null && submission.notes!.isNotEmpty)
        submission.notes!,
      if (submission.correctiveActionOutcome != null)
        'Corrective action: ${submission.correctiveActionOutcome}'
        '${submission.correctiveActionNote == null ? '' : ' — ${submission.correctiveActionNote}'}',
    ];
    return parts.join(' | ');
  }

  pw.Widget _cell(String text, {bool bold = false, PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(2),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 8,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          color: color,
        ),
      ),
    );
  }

  String _formatFileTimestamp(DateTime dt) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${dt.year}${two(dt.month)}${two(dt.day)}'
        '_${two(dt.hour)}${two(dt.minute)}${two(dt.second)}';
  }

  // Mirrors BackupRepository's own filename sanitisation exactly.
  String _sanitizeForFilename(String name) {
    return name.replaceAll(RegExp(r'[<>:"/\\|?*]'), '');
  }
}

final ehoExportServiceProvider = Provider<EhoExportService>((ref) {
  return EhoExportService(
    ref.watch(taskSubmissionRepositoryProvider),
    ref.watch(taskTemplateRepositoryProvider),
    ref.watch(siteRepositoryProvider),
    ref.watch(overdueSummaryServiceProvider),
    ref.watch(trainingRecordRepositoryProvider),
    ref.watch(userRepositoryProvider),
    ref.watch(supplierRepositoryProvider),
    ref.watch(brandingConfigRepositoryProvider),
  );
});
