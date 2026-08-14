import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/utils/date_format.dart';
import '../../shared/models/site.dart';
import '../../shared/models/task_submission.dart';
import '../../shared/models/training_record.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/training_record_providers.dart';
import '../../shared/repositories/site_repository.dart';
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

class EhoExportService {
  EhoExportService(
    this._submissionRepository,
    this._templateRepository,
    this._siteRepository,
    this._overdueSummaryService,
    this._trainingRecordRepository,
    this._userRepository,
  );

  final TaskSubmissionRepository _submissionRepository;
  final TaskTemplateRepository _templateRepository;
  final SiteRepository _siteRepository;
  final OverdueSummaryService _overdueSummaryService;
  final TrainingRecordRepository _trainingRecordRepository;
  final UserRepository _userRepository;

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

    doc.addPage(
      pw.MultiPage(
        // Space efficiency: full header only on page 1, one condensed
        // line on every page after — a multi-page compliance record
        // shouldn't spend real estate re-stating the same block on
        // every page.
        header: (context) => context.pageNumber == 1
            ? _buildFullHeader(
                siteName,
                site?.address,
                start,
                end,
                generatedByName,
              )
            : _buildCondensedHeader(siteName, start, end),
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
          ),
          pw.SizedBox(height: 12),
          _buildExceptionsSection(
            failEntries: failEntries,
            notCompletedEntries: notCompletedEntries,
            outstanding: outstanding,
            expiredTraining: expiredTraining,
          ),
          if (includeFullLog) ...[
            pw.SizedBox(height: 16),
            pw.Text(
              'Full Detailed Log',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
              ),
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
        ],
      ),
    );

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

  pw.Widget _buildFullHeader(
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
          'Kitchen Control — Compliance Export',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
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
        pw.Divider(),
      ],
    );
  }

  pw.Widget _buildCondensedHeader(
    String siteName,
    DateTime start,
    DateTime end,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          'Kitchen Control — $siteName — ${formatDate(start)} to '
          '${formatDate(end)}',
          style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700),
        ),
        pw.SizedBox(height: 4),
        pw.Divider(thickness: 0.5),
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
          _buildExceptionTable(notCompletedEntries, showCorrectiveAction: false),
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
        _buildOutstandingSection(outstanding),
      ],
    );
  }

  pw.Widget _buildExceptionTable(
    List<TaskSubmission> entries, {
    required bool showCorrectiveAction,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
      columnWidths: showCorrectiveAction
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
            },
      children: [
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: [
            _cell('Date/Time', bold: true),
            _cell('Task', bold: true),
            _cell('Staff', bold: true),
            if (showCorrectiveAction) _cell('Corrective action', bold: true),
          ],
        ),
        for (final entry in entries)
          pw.TableRow(
            children: [
              _cell(formatDateTime(entry.completedAt)),
              _cell(entry.taskTitle),
              _cell(entry.completedBy),
              if (showCorrectiveAction)
                _cell(_notesAndCorrectiveAction(entry)),
            ],
          ),
      ],
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
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          segment,
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 2),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
          columnWidths: const {
            0: pw.FlexColumnWidth(2),
            1: pw.FlexColumnWidth(3),
            2: pw.FlexColumnWidth(2),
            3: pw.FlexColumnWidth(1.5),
            4: pw.FlexColumnWidth(4),
          },
          children: [
            pw.TableRow(
              decoration: const pw.BoxDecoration(color: PdfColors.grey200),
              children: [
                _cell('Date/Time', bold: true),
                _cell('Task', bold: true),
                _cell('Staff', bold: true),
                _cell('Result', bold: true),
                _cell('Notes / corrective action', bold: true),
              ],
            ),
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
          ],
        ),
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
  );
});
