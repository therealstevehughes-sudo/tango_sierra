import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/management_drawer.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/responsive_content.dart';
import '../../core/widgets/section_header.dart';
import '../../shared/models/area.dart';
import '../../shared/models/equipment.dart';
import '../../shared/models/task_schedule.dart';
import '../../shared/providers/site_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';

/// Manager-configured execution order (Task-reorder, 2026-09-12).
///
/// One screen, grouped by Area (a venue's zones). Within each group the
/// manager can move a task up or down; the visible order as displayed is
/// the order the worker's carousel will follow. Saving writes contiguous
/// 1..n `sortOrder` values per group so reads that sort by `sortOrder`
/// (nulls-last, stable) reproduce exactly this list.
///
/// Scope: this screen never reaches across venues — it operates on exactly
/// one site's schedules (the active site, falling back to the current
/// user's own / default site). RLS additionally protects the backend path.
class ReorderTasksScreen extends ConsumerStatefulWidget {
  const ReorderTasksScreen({super.key});

  @override
  ConsumerState<ReorderTasksScreen> createState() =>
      _ReorderTasksScreenState();
}

class _ReorderTasksScreenState extends ConsumerState<ReorderTasksScreen> {
  bool _loading = true;
  bool _saving = false;
  int? _siteId;

  // Working groups: area id (null = ungrouped) → ordered rows. Only
  // active schedules are offered — a deactivated one appears in no group
  // and is simply never in the queue.
  final List<_OrderGroup> _groups = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final site =
        ref.read(activeSiteProvider) ??
        (await ref.read(currentSiteProvider.future));
    if (site == null) {
      if (!mounted) return;
      setState(() => _loading = false);
      return;
    }

    final templateRepo = ref.read(taskTemplateRepositoryProvider);
    final equipmentRepo = ref.read(equipmentRepositoryProvider);
    final areaRepo = ref.read(areaRepositoryProvider);
    final scheduleRepo = ref.read(taskScheduleRepositoryProvider);

    final templates = await templateRepo.getAllCurrentVersions();
    final areas = await areaRepo.getForSite(site.id);
    final equipment = await equipmentRepo.getForSite(site.id);
    final schedules = await scheduleRepo.getForSite(site.id);

    if (!mounted) return;

    // Template title by templateGroupId — the schedule stores the group,
    // and the same title spans versions.
    final titleByGroupId = {
      for (final t in templates) t.templateGroupId: t.title,
    };
    final equipmentById = {for (final e in equipment) e.id: e};
    final areaById = {for (final a in areas) a.id: a};
    final equipmentToArea = <int, int?>{
      for (final e in equipment) e.id: e.areaId,
    };

    setState(() {
      _siteId = site.id;
      _groups
        ..clear()
        ..addAll(
          _buildGroups(
            schedules: schedules,
            equipmentToArea: equipmentToArea,
            areaById: areaById,
            titleByGroupId: titleByGroupId,
            equipmentById: equipmentById,
          ),
        );
      _loading = false;
    });
  }

  /// Groups the schedules by the area their equipment belongs to (an
  /// equipment instance without an area, or a schedule with no equipment
  /// at all, lands in "Ungrouped"). Group order follows area `sortOrder`
  /// (ordered first, then id) — the same stable rule reads use everywhere.
  List<_OrderGroup> _buildGroups({
    required List<TaskSchedule> schedules,
    required Map<int, int?> equipmentToArea,
    required Map<int, Area> areaById,
    required Map<int, String> titleByGroupId,
    required Map<int, Equipment> equipmentById,
  }) {
    final byArea = <int?, List<TaskSchedule>>{};
    for (final schedule in schedules) {
      if (!schedule.active) continue;
      final areaId =
          schedule.equipmentInstanceId == null
              ? null
              : equipmentToArea[schedule.equipmentInstanceId];
      (byArea[areaId] ??= []).add(schedule);
    }

    // Areas in the venue-setup display order: explicit sortOrder first
    // (nulls last), then id. Same rule as DriftAreaRepository.getForSite.
    final orderedAreas = areaById.values.toList()..sort((a, b) {
      final aNull = a.sortOrder == null ? 1 : 0;
      final bNull = b.sortOrder == null ? 1 : 0;
      if (aNull != bNull) return aNull - bNull;
      final byOrder = (a.sortOrder ?? 0).compareTo(b.sortOrder ?? 0);
      if (byOrder != 0) return byOrder;
      return a.id.compareTo(b.id);
    });

    final groups = <_OrderGroup>[];
    for (final area in orderedAreas) {
      final list = byArea.remove(area.id);
      if (list == null || list.isEmpty) continue;
      groups.add(
        _OrderGroup(
          areaId: area.id,
          title: area.name,
          rows: _rowsFor(
            list,
            titleByGroupId: titleByGroupId,
            equipmentById: equipmentById,
          ),
        ),
      );
    }
    // "Ungrouped" is always last, no matter the area sortOrder.
    final ungrouped = byArea.remove(null);
    if (ungrouped != null && ungrouped.isNotEmpty) {
      groups.add(
        _OrderGroup(
          areaId: null,
          title: 'Ungrouped',
          rows: _rowsFor(
            ungrouped,
            titleByGroupId: titleByGroupId,
            equipmentById: equipmentById,
          ),
        ),
      );
    }
    return groups;
  }

  List<_OrderRow> _rowsFor(
    List<TaskSchedule> schedules, {
    required Map<int, String> titleByGroupId,
    required Map<int, Equipment> equipmentById,
  }) {
    return [
      for (final schedule in schedules)
        _OrderRow(
          scheduleId: schedule.id,
          // The worker carousel skips a schedule whose template group has
          // no current version — mirror that here so the list shows only
          // realistically runnable tasks.
          title: titleByGroupId[schedule.taskTemplateGroupId] ?? 'Task',
          subtitle: _subtitleFor(schedule, equipmentById),
        ),
    ];
  }

  String _subtitleFor(
    TaskSchedule schedule,
    Map<int, Equipment> equipmentById,
  ) {
    final parts = <String>[];
    final equipment = schedule.equipmentInstanceId == null
        ? null
        : equipmentById[schedule.equipmentInstanceId];
    if (equipment != null) parts.add(equipment.name);
    parts.add(frequencyLabel(schedule.frequency));
    return parts.join(' · ');
  }

  void _move(int groupIndex, int itemIndex, int delta) {
    setState(() {
      final group = _groups[groupIndex];
      final target = itemIndex + delta;
      if (target < 0 || target >= group.rows.length) return;
      final rows = group.rows;
      final moved = rows.removeAt(itemIndex);
      rows.insert(target, moved);
    });
  }

  Future<void> _save() async {
    final scheduleRepo = ref.read(taskScheduleRepositoryProvider);
    setState(() => _saving = true);
    try {
      // Venue-wide contiguous sequence, NOT 1..n per group: the worker
      // carousel sorts by a single global sortOrder (task_controller.dart),
      // so two areas both writing "1,2,3" would collide and ties would be
      // broken by database row order — an arbitrary mix of areas. Writing
      // one rising sequence in display order (area sortOrder, then
      // ungrouped) means a staff member with tasks in several zones still
      // runs them in exactly the order shown here.
      var order = 1;
      for (final group in _groups) {
        for (final row in group.rows) {
          await scheduleRepo.setSortOrder(row.scheduleId, order);
          order++;
        }
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Task order saved.')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save task order: $e')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reorder Tasks')),
      drawer: const ManagementDrawer(title: 'Reorder Tasks'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ResponsiveContent(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_siteId == null) {
      return const AppCard(
        child: Text(
          'No venue selected yet. Set an active venue from Venue Details '
          'before reordering tasks.',
        ),
      );
    }

    if (_groups.every((g) => g.rows.isEmpty)) {
      return const AppCard(
        child: Text(
          'No active tasks to reorder yet. Assign tasks first, then return '
          'here to choose their order.',
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              for (final group in _groups)
                if (group.rows.isNotEmpty) _buildGroup(group),
            ],
          ),
        ),
        const SizedBox(height: 16),
        PrimaryActionButton(
          label: _saving ? 'Saving…' : 'Save Order',
          icon: Icons.save_outlined,
          onPressed: _saving ? null : _save,
        ),
      ],
    );
  }

  Widget _buildGroup(_OrderGroup group) {
    final index = _groups.indexOf(group);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SectionHeader(title: group.title),
          AppCard(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: [
                for (var i = 0; i < group.rows.length; i++)
                  _buildTaskRow(
                    groupIndex: index,
                    itemIndex: i,
                    count: group.rows.length,
                    row: group.rows[i],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskRow({
    required int groupIndex,
    required int itemIndex,
    required int count,
    required _OrderRow row,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      leading: CircleAvatar(
        radius: 14,
        backgroundColor: AppColors.tealTint,
        child: Text(
          '${itemIndex + 1}',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: AppColors.tealInk,
          ),
        ),
      ),
      title: Text(row.title, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: row.subtitle.isEmpty ? null : Text(row.subtitle),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_up),
            tooltip: 'Move up',
            onPressed:
                itemIndex == 0 ? null : () => _move(groupIndex, itemIndex, -1),
          ),
          IconButton(
            icon: const Icon(Icons.keyboard_arrow_down),
            tooltip: 'Move down',
            onPressed: itemIndex == count - 1
                ? null
                : () => _move(groupIndex, itemIndex, 1),
          ),
        ],
      ),
    );
  }
}

/// One ordered row within a group. Title and subtitle are resolved once at
/// load time rather than recomputed per build.
class _OrderRow {
  final int scheduleId;
  final String title;
  final String subtitle;

  const _OrderRow({
    required this.scheduleId,
    required this.title,
    required this.subtitle,
  });
}

class _OrderGroup {
  final int? areaId;
  final String title;
  final List<_OrderRow> rows;

  const _OrderGroup({
    this.areaId,
    required this.title,
    required this.rows,
  });
}