import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/assistant_icon_button.dart';
import '../../core/widgets/app_screen_header.dart';
import '../../core/widgets/responsive_content.dart';
import '../../l10n/app_localizations.dart';
import '../../shared/models/department.dart';
import '../../shared/models/job_role.dart';
import '../../shared/models/shift_period.dart';
import '../../shared/models/shift_requirement.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/department_providers.dart';
import '../../shared/providers/shift_period_providers.dart';
import '../../shared/providers/shift_requirement_providers.dart';

const _weekdayNames = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];

// Rota calendar, Sprint 3 (2026-10-01) — "master rota": leadership
// defines recurring staffing requirements (e.g. "every Friday evening,
// Bar needs 3 + 1 standby"), then generates real shifts for a given week
// from them in one action. Reuses the exact same Shift claim/assign/
// cert-check machinery downstream - this screen only ever creates plain
// open Shift rows.
class ShiftRequirementsScreen extends ConsumerStatefulWidget {
  const ShiftRequirementsScreen({super.key});

  @override
  ConsumerState<ShiftRequirementsScreen> createState() =>
      _ShiftRequirementsScreenState();
}

class _ShiftRequirementsScreenState
    extends ConsumerState<ShiftRequirementsScreen> {
  bool _loading = true;
  int? _siteId;
  List<ShiftRequirement> _requirements = [];
  List<ShiftPeriod> _periods = [];
  List<Department> _departments = [];
  bool _generating = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final currentUser = ref.read(currentUserProvider);
    final siteId = currentUser?.siteId;
    if (siteId == null) {
      setState(() => _loading = false);
      return;
    }
    final requirements = await ref
        .read(shiftRequirementRepositoryProvider)
        .getForSite(siteId);
    final periods = await ref
        .read(shiftPeriodRepositoryProvider)
        .getForSite(siteId);
    final departments = await ref
        .read(departmentRepositoryProvider)
        .getForSite(siteId);
    if (!mounted) return;
    setState(() {
      _siteId = siteId;
      _requirements = requirements;
      _periods = periods;
      _departments = departments;
      _loading = false;
    });
  }

  Future<void> _addRequirement() async {
    final l10n = AppLocalizations.of(context)!;
    if (_periods.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.setUpShiftPeriodsFirstText)),
      );
      return;
    }
    Department? department;
    JobRole? jobRole;
    var period = _periods.first;
    var dayOfWeek = 1;
    var requiredCount = 1;
    var standbyCount = 0;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          final l10n = AppLocalizations.of(context)!;
          return AlertDialog(
          title: Text(l10n.addStaffingRequirementTitle),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Department?>(
                  initialValue: department,
                  decoration: InputDecoration(labelText: l10n.anyDepartmentLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.anyDepartmentLabel)),
                    for (final dept in _departments)
                      DropdownMenuItem(value: dept, child: Text(dept.name)),
                  ],
                  onChanged: (v) => setDialogState(() => department = v),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<JobRole?>(
                  initialValue: jobRole,
                  decoration: InputDecoration(labelText: l10n.anyRoleLabel),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.anyRoleLabel)),
                    for (final role in JobRole.values)
                      DropdownMenuItem(value: role, child: Text(jobRoleDisplayName(role, l10n))),
                  ],
                  onChanged: (v) => setDialogState(() => jobRole = v),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<ShiftPeriod>(
                  initialValue: period,
                  decoration: InputDecoration(labelText: l10n.rotaFilterPeriodLabel),
                  items: [
                    for (final p in _periods)
                      DropdownMenuItem(value: p, child: Text(p.name)),
                  ],
                  onChanged: (v) => setDialogState(() => period = v ?? period),
                ),
                const SizedBox(height: 8),
                DropdownButtonFormField<int>(
                  initialValue: dayOfWeek,
                  decoration: InputDecoration(labelText: l10n.dayLabel),
                  items: [
                    for (var i = 1; i <= 7; i++)
                      DropdownMenuItem(value: i, child: Text(_weekdayNames[i - 1])),
                  ],
                  onChanged: (v) => setDialogState(() => dayOfWeek = v ?? dayOfWeek),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: Text(l10n.staffNeededLabel)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: requiredCount > 1
                          ? () => setDialogState(() => requiredCount--)
                          : null,
                    ),
                    Text('$requiredCount'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setDialogState(() => requiredCount++),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(child: Text(l10n.standbyNeededLabel)),
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline),
                      onPressed: standbyCount > 0
                          ? () => setDialogState(() => standbyCount--)
                          : null,
                    ),
                    Text('$standbyCount'),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline),
                      onPressed: () => setDialogState(() => standbyCount++),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l10n.saveButton),
            ),
          ],
        );
        },
      ),
    );

    if (confirmed != true || _siteId == null) return;
    await ref.read(shiftRequirementRepositoryProvider).create(
      ShiftRequirement(
        id: null,
        siteId: _siteId!,
        departmentId: department?.id,
        jobRole: jobRole,
        periodId: period.id!,
        dayOfWeek: dayOfWeek,
        requiredCount: requiredCount,
        standbyCount: standbyCount,
      ),
    );
    await _load();
  }

  Future<void> _deleteRequirement(ShiftRequirement requirement) async {
    await ref.read(shiftRequirementRepositoryProvider).delete(requirement.id!);
    await _load();
  }

  DateTime _mondayOf(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday - 1));
  }

  Future<void> _generate({required bool nextWeek}) async {
    final l10n = AppLocalizations.of(context)!;
    final currentUser = ref.read(currentUserProvider);
    final siteId = _siteId;
    if (siteId == null || currentUser == null) return;
    final weekStart = _mondayOf(DateTime.now()).add(
      Duration(days: nextWeek ? 7 : 0),
    );
    setState(() => _generating = true);
    try {
      final count = await ref
          .read(shiftRequirementRepositoryProvider)
          .generateShiftsForWeek(
            siteId: siteId,
            weekStart: weekStart,
            createdByUserId: currentUser.id,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shiftsGeneratedMessage(count))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.shiftGenerationFailedMessage(e.toString()))),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  String _describe(ShiftRequirement req, AppLocalizations l10n) {
    final period = _periods.where((p) => p.id == req.periodId).firstOrNull;
    final dept = req.departmentId == null
        ? l10n.anyDepartmentLabel
        : _departments.where((d) => d.id == req.departmentId).firstOrNull?.name ??
            l10n.unknownDepartmentLabel;
    final role = req.jobRole == null ? l10n.anyRoleLabel : jobRoleDisplayName(req.jobRole!, l10n);
    final standby = req.standbyCount > 0
        ? l10n.plusStandbyCountLabel(req.standbyCount)
        : '';
    return '${_weekdayNames[req.dayOfWeek - 1]} ${period?.name ?? '?'} - '
        '$dept, $role: ${req.requiredCount}$standby';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppScreenHeader(
        title: Text(l10n.masterRotaSettingsTitle),
        actions: const [AssistantIconButton()],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ResponsiveContent(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        l10n.masterRotaSettingsDescription,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ),
                    Expanded(
                      child: _requirements.isEmpty
                          ? Center(child: Text(l10n.noRequirementsYetText))
                          : ListView(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              children: [
                                for (final req in _requirements)
                                  Card(
                                    child: ListTile(
                                      title: Text(_describe(req, l10n)),
                                      trailing: IconButton(
                                        icon: const Icon(Icons.delete_outline),
                                        onPressed: () => _deleteRequirement(req),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _addRequirement,
                            icon: const Icon(Icons.add),
                            label: Text(l10n.addRequirementButton),
                          ),
                          OutlinedButton.icon(
                            onPressed: _generating || _requirements.isEmpty
                                ? null
                                : () => _generate(nextWeek: false),
                            icon: const Icon(Icons.event_available_outlined),
                            label: Text(l10n.generateThisWeekButton),
                          ),
                          OutlinedButton.icon(
                            onPressed: _generating || _requirements.isEmpty
                                ? null
                                : () => _generate(nextWeek: true),
                            icon: const Icon(Icons.event_available_outlined),
                            label: Text(l10n.generateNextWeekButton),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
