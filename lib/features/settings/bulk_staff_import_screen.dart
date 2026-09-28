import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';

/// Bulk staff import (2026-09-28, direct founder request — "every staff
/// member gets added one at a time" was the disclosed gap). Reads a plain
/// CSV, previews every row with its own validation state, then creates
/// them one at a time through the SAME `UserRepository.createStaffMember()`
/// every other "Add Staff" entry point already uses — so this gets
/// backend-mode's real account creation (and Roster re-pricing) for free,
/// with zero new repository/backend surface.
///
/// Expected columns (a header row is optional and auto-detected):
/// `name, job_title, role_tier, job_role, pin` — only `name`/`job_title`/
/// `role_tier` are required per row; `job_role` defaults to Chef/Cook and
/// `pin` is randomly generated if left blank, matching the single-add
/// dialog's own defaults. Deliberately simple comma-splitting, not a full
/// CSV parser (no quoted-field support) — a staff name/job title
/// containing a literal comma is an edge case rare enough not to justify
/// a new dependency for this first version.
class BulkStaffImportScreen extends ConsumerStatefulWidget {
  const BulkStaffImportScreen({
    super.key,
    required this.siteId,
    required this.allowedTiers,
  });

  final int siteId;
  final List<RoleTier> allowedTiers;

  @override
  ConsumerState<BulkStaffImportScreen> createState() =>
      _BulkStaffImportScreenState();
}

enum _RowStatus { pending, invalid, importing, success, failed }

class _ImportRow {
  _ImportRow({
    required this.rowNumber,
    required this.name,
    required this.jobTitle,
    required this.roleTier,
    required this.jobRole,
    required this.pin,
    this.status = _RowStatus.pending,
    this.error,
  });

  final int rowNumber;
  final String name;
  final String jobTitle;
  final RoleTier roleTier;
  final JobRole jobRole;
  final String pin;
  _RowStatus status;
  String? error;
}

class _BulkStaffImportScreenState
    extends ConsumerState<BulkStaffImportScreen> {
  String? fileName;
  List<_ImportRow> rows = [];
  bool importing = false;
  bool get _hasValidRows =>
      rows.any((r) => r.status == _RowStatus.pending);

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv', 'txt'],
      withData: true,
    );
    final file = result?.files.single;
    if (file == null) return;

    final bytes = file.bytes;
    if (bytes == null) return;
    final content = String.fromCharCodes(bytes);
    setState(() {
      fileName = file.name;
      rows = _parse(content);
    });
  }

  List<_ImportRow> _parse(String content) {
    final lines = content
        .split(RegExp(r'\r?\n'))
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
    if (lines.isEmpty) return [];

    var startIndex = 0;
    final firstFields = lines.first.split(',');
    if (firstFields.isNotEmpty &&
        firstFields.first.trim().toLowerCase() == 'name') {
      startIndex = 1; // header row, skip it
    }

    final parsed = <_ImportRow>[];
    for (var i = startIndex; i < lines.length; i++) {
      final fields = lines[i].split(',').map((f) => f.trim()).toList();
      final rowNumber = i + 1;
      final name = fields.isNotEmpty ? fields[0] : '';
      final jobTitle = fields.length > 1 ? fields[1] : '';
      final roleTierRaw = fields.length > 2 ? fields[2] : '';
      final jobRoleRaw = fields.length > 3 ? fields[3] : '';
      final pinRaw = fields.length > 4 ? fields[4] : '';

      String? error;
      if (name.isEmpty) error = 'Missing name';
      if (error == null && jobTitle.isEmpty) error = 'Missing job title';

      RoleTier? roleTier;
      if (error == null) {
        roleTier = RoleTier.values
            .where((t) => t.name.toLowerCase() == roleTierRaw.toLowerCase())
            .firstOrNull;
        if (roleTier == null) {
          error =
              "Role tier must be one of: ${RoleTier.values.map((t) => t.name).join(', ')}";
        } else if (!widget.allowedTiers.contains(roleTier)) {
          error = "You aren't allowed to create a ${roleTier.name} account";
        }
      }

      JobRole jobRole = JobRole.chefCook;
      if (error == null && jobRoleRaw.isNotEmpty) {
        final match = JobRole.values
            .where((r) => r.name.toLowerCase() == jobRoleRaw.toLowerCase())
            .firstOrNull;
        if (match == null) {
          error =
              "Job role must be one of: ${JobRole.values.map((r) => r.name).join(', ')}";
        } else {
          jobRole = match;
        }
      }

      var pin = pinRaw;
      if (error == null) {
        if (pin.isEmpty) {
          pin = _randomPin();
        } else if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
          error = 'PIN must be exactly 4 digits (or left blank)';
        }
      }

      parsed.add(
        _ImportRow(
          rowNumber: rowNumber,
          name: name,
          jobTitle: jobTitle,
          roleTier: roleTier ?? RoleTier.base,
          jobRole: jobRole,
          pin: pin,
          status: error == null ? _RowStatus.pending : _RowStatus.invalid,
          error: error,
        ),
      );
    }
    return parsed;
  }

  String _randomPin() {
    final n = DateTime.now().microsecondsSinceEpoch % 9000 + 1000;
    return n.toString();
  }

  Future<void> _importAll() async {
    setState(() => importing = true);
    final repo = ref.read(userRepositoryProvider);
    // Sequential, not parallel — mirrors how a manager adding staff one at
    // a time would naturally happen, and avoids firing Roster's re-pricing
    // check many times over in a tight burst.
    for (final row in rows) {
      if (row.status != _RowStatus.pending) continue;
      setState(() => row.status = _RowStatus.importing);
      try {
        await repo.createStaffMember(
          name: row.name,
          jobTitle: row.jobTitle,
          roleTier: row.roleTier,
          jobRole: row.jobRole,
          pin: row.pin,
          siteId: widget.siteId,
        );
        if (!mounted) return;
        setState(() => row.status = _RowStatus.success);
      } catch (e) {
        if (!mounted) return;
        setState(() {
          row.status = _RowStatus.failed;
          row.error = e.toString();
        });
      }
    }
    if (!mounted) return;
    setState(() => importing = false);
  }

  @override
  Widget build(BuildContext context) {
    final successCount = rows.where((r) => r.status == _RowStatus.success).length;
    final invalidCount = rows.where((r) => r.status == _RowStatus.invalid).length;
    final failedCount = rows.where((r) => r.status == _RowStatus.failed).length;

    return Scaffold(
      appBar: AppScreenHeader(
        title: const Text('Bulk Staff Import'),
        actions: const [AssistantIconButton()],
      ),
      drawer: const ManagementDrawer(title: 'Staff Management'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            maxWidth: 640,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'CSV columns: name, job title, role tier, job role '
                        '(optional), pin (optional). A header row is fine — '
                        "it's detected automatically. Leave the PIN blank "
                        'to have one generated for you.',
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Example: Jane Smith, Waiter, base, frontOfHouse, 1234',
                        style: TextStyle(
                          color: AppColors.muted,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrimaryActionButton(
                        label: fileName == null
                            ? 'Choose CSV file'
                            : 'Choose a different file',
                        onPressed: importing ? null : _pickFile,
                      ),
                      if (fileName != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '$fileName - ${rows.length} row(s) found'
                          '${invalidCount > 0 ? ', $invalidCount need fixing' : ''}',
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (rows.isNotEmpty) ...[
                  Expanded(
                    child: ListView.builder(
                      itemCount: rows.length,
                      itemBuilder: (context, i) => _RowTile(row: rows[i]),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (successCount + failedCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text(
                        '$successCount created'
                        '${failedCount > 0 ? ', $failedCount failed' : ''}.'
                        '${successCount > 0 ? ' Note down each PIN below before leaving this screen.' : ''}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  PrimaryActionButton(
                    label: importing
                        ? 'Importing...'
                        : 'Import ${rows.where((r) => r.status == _RowStatus.pending).length} staff member(s)',
                    onPressed: (!importing && _hasValidRows) ? _importAll : null,
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

class _RowTile extends StatelessWidget {
  const _RowTile({required this.row});

  final _ImportRow row;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (row.status) {
      _RowStatus.pending => (Icons.radio_button_unchecked, AppColors.muted),
      _RowStatus.invalid => (Icons.error_outline, AppColors.critical),
      _RowStatus.importing => (Icons.hourglass_top, AppColors.caution),
      _RowStatus.success => (Icons.check_circle, AppColors.pass),
      _RowStatus.failed => (Icons.cancel, AppColors.critical),
    };

    return Card(
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(row.name.isEmpty ? 'Row ${row.rowNumber}' : row.name),
        subtitle: Text(
          row.error ??
              '${row.jobTitle} - ${row.roleTier.name}'
                  '${row.status == _RowStatus.success ? ' - PIN: ${row.pin}' : ''}',
          style: row.error != null
              ? const TextStyle(color: AppColors.critical)
              : null,
        ),
      ),
    );
  }
}
