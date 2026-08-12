import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/date_format.dart';
import '../../shared/providers/task_submission_providers.dart';

// Manager submission-log filtering (Sprint 031) — the log becomes an
// unusable wall at real scale (30 staff x 150 tasks x days). A "Filter by"
// lens (Name/Date/Task) reshapes three cascading dropdowns below it, each
// narrowed to only the values that actually co-occur with what's already
// selected above it. Extracted from manager_screen.dart: this is
// self-contained cascade state that manager_screen.dart doesn't need to
// know the mechanics of — it only cares about the resolved
// [LogFilterSelection] this widget reports via [onChanged].
enum LogFilterAxis { name, date, task }

class LogFilterSelection {
  const LogFilterSelection({this.axis, this.name, this.date, this.task});

  final LogFilterAxis? axis;
  final String? name;
  final DateTime? date;
  final String? task;

  bool get isActive => name != null || date != null || task != null;
}

class ManagerLogFilter extends ConsumerStatefulWidget {
  const ManagerLogFilter({super.key, required this.onChanged});

  final ValueChanged<LogFilterSelection> onChanged;

  @override
  ConsumerState<ManagerLogFilter> createState() => _ManagerLogFilterState();
}

class _ManagerLogFilterState extends ConsumerState<ManagerLogFilter> {
  LogFilterAxis? axis;
  String? name;
  DateTime? date;
  String? task;

  List<String> nameOptions = [];
  List<DateTime> dateOptions = [];
  List<String> taskOptions = [];

  void _emit() {
    widget.onChanged(
      LogFilterSelection(axis: axis, name: name, date: date, task: task),
    );
  }

  Future<void> _selectAxis(LogFilterAxis? newAxis) async {
    setState(() {
      axis = newAxis;
      name = null;
      date = null;
      task = null;
      nameOptions = [];
      dateOptions = [];
      taskOptions = [];
    });
    _emit();
    if (newAxis == null) return;

    final repo = ref.read(taskSubmissionRepositoryProvider);
    switch (newAxis) {
      case LogFilterAxis.name:
        final options = await repo.getDistinctNames();
        if (mounted) setState(() => nameOptions = options);
        break;
      case LogFilterAxis.date:
        final options = await repo.getDistinctDates();
        if (mounted) setState(() => dateOptions = options);
        break;
      case LogFilterAxis.task:
        final options = await repo.getDistinctTasks();
        if (mounted) setState(() => taskOptions = options);
        break;
    }
  }

  void _clear() => _selectAxis(null);

  // --- Filter by Name: Name -> Date -> Task ---

  Future<void> _onNameChanged(String? value) async {
    setState(() {
      name = value;
      date = null;
      task = null;
      dateOptions = [];
      taskOptions = [];
    });
    _emit();
    if (value == null) return;
    final options = await ref
        .read(taskSubmissionRepositoryProvider)
        .getDistinctDates(name: value);
    if (mounted) setState(() => dateOptions = options);
  }

  Future<void> _onDateAfterNameChanged(DateTime? value) async {
    setState(() {
      date = value;
      task = null;
      taskOptions = [];
    });
    _emit();
    if (value == null) return;
    final options = await ref
        .read(taskSubmissionRepositoryProvider)
        .getDistinctTasks(name: name, date: value);
    if (mounted) setState(() => taskOptions = options);
  }

  void _onTaskAfterNameDateChanged(String? value) {
    setState(() => task = value);
    _emit();
  }

  // --- Filter by Date: Date -> Staff -> Task ---

  Future<void> _onDateChanged(DateTime? value) async {
    setState(() {
      date = value;
      name = null;
      task = null;
      nameOptions = [];
      taskOptions = [];
    });
    _emit();
    if (value == null) return;
    final options = await ref
        .read(taskSubmissionRepositoryProvider)
        .getDistinctNames(date: value);
    if (mounted) setState(() => nameOptions = options);
  }

  Future<void> _onNameAfterDateChanged(String? value) async {
    setState(() {
      name = value;
      task = null;
      taskOptions = [];
    });
    _emit();
    if (value == null) return;
    final options = await ref
        .read(taskSubmissionRepositoryProvider)
        .getDistinctTasks(name: value, date: date);
    if (mounted) setState(() => taskOptions = options);
  }

  void _onTaskAfterDateNameChanged(String? value) {
    setState(() => task = value);
    _emit();
  }

  // --- Filter by Task: Task -> Staff -> Date ---

  Future<void> _onTaskChanged(String? value) async {
    setState(() {
      task = value;
      name = null;
      date = null;
      nameOptions = [];
      dateOptions = [];
    });
    _emit();
    if (value == null) return;
    final options = await ref
        .read(taskSubmissionRepositoryProvider)
        .getDistinctNames(task: value);
    if (mounted) setState(() => nameOptions = options);
  }

  Future<void> _onNameAfterTaskChanged(String? value) async {
    setState(() {
      name = value;
      date = null;
      dateOptions = [];
    });
    _emit();
    if (value == null) return;
    final options = await ref
        .read(taskSubmissionRepositoryProvider)
        .getDistinctDates(name: value, task: task);
    if (mounted) setState(() => dateOptions = options);
  }

  void _onDateAfterTaskNameChanged(DateTime? value) {
    setState(() => date = value);
    _emit();
  }

  // Collapsed by default, per the layout fix logged in DECISIONS_LOG.md —
  // the cascade's up-to-4 dropdowns permanently open was squeezing the
  // actual log (the point of the screen) into a sliver at the bottom.
  // Card+ExpansionTile matches the existing pattern already used for
  // preset_management_screen.dart's preset cards, rather than a new
  // one-off collapse mechanism.
  String _summary() {
    if (axis == null) return 'Today + all fails';
    final parts = <String>[
      ?name,
      if (date != null) formatDate(date!),
      ?task,
    ];
    if (parts.isEmpty) return 'By ${_axisLabel(axis!)}';
    return parts.join(' · ');
  }

  String _axisLabel(LogFilterAxis axis) {
    switch (axis) {
      case LogFilterAxis.name:
        return 'Name';
      case LogFilterAxis.date:
        return 'Date';
      case LogFilterAxis.task:
        return 'Task';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        title: const Text('Filter'),
        subtitle: Text(_summary()),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<LogFilterAxis>(
                  initialValue: axis,
                  decoration: const InputDecoration(labelText: 'Filter by'),
                  hint: const Text('Today + all fails'),
                  items: const [
                    DropdownMenuItem(
                      value: LogFilterAxis.name,
                      child: Text('Name'),
                    ),
                    DropdownMenuItem(
                      value: LogFilterAxis.date,
                      child: Text('Date'),
                    ),
                    DropdownMenuItem(
                      value: LogFilterAxis.task,
                      child: Text('Task'),
                    ),
                  ],
                  onChanged: _selectAxis,
                ),
              ),
              if (axis != null)
                TextButton(
                  onPressed: _clear,
                  child: const Text('Clear filters'),
                ),
            ],
          ),
          if (axis == LogFilterAxis.name) ..._buildNameAxis(),
          if (axis == LogFilterAxis.date) ..._buildDateAxis(),
          if (axis == LogFilterAxis.task) ..._buildTaskAxis(),
        ],
      ),
    );
  }

  List<Widget> _buildNameAxis() {
    return [
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        initialValue: name,
        decoration: const InputDecoration(labelText: 'Staff'),
        items: nameOptions
            .map((n) => DropdownMenuItem(value: n, child: Text(n)))
            .toList(),
        onChanged: _onNameChanged,
      ),
      if (name != null) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<DateTime>(
          initialValue: date,
          decoration: const InputDecoration(labelText: 'Date'),
          items: dateOptions
              .map(
                (d) =>
                    DropdownMenuItem(value: d, child: Text(formatDate(d))),
              )
              .toList(),
          onChanged: _onDateAfterNameChanged,
        ),
      ],
      if (date != null) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: task,
          decoration: const InputDecoration(labelText: 'Task'),
          items: taskOptions
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: _onTaskAfterNameDateChanged,
        ),
      ],
    ];
  }

  List<Widget> _buildDateAxis() {
    return [
      const SizedBox(height: 12),
      DropdownButtonFormField<DateTime>(
        initialValue: date,
        decoration: const InputDecoration(labelText: 'Date'),
        items: dateOptions
            .map(
              (d) => DropdownMenuItem(value: d, child: Text(formatDate(d))),
            )
            .toList(),
        onChanged: _onDateChanged,
      ),
      if (date != null) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: name,
          decoration: const InputDecoration(labelText: 'Staff'),
          items: nameOptions
              .map((n) => DropdownMenuItem(value: n, child: Text(n)))
              .toList(),
          onChanged: _onNameAfterDateChanged,
        ),
      ],
      if (name != null) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: task,
          decoration: const InputDecoration(labelText: 'Task'),
          items: taskOptions
              .map((t) => DropdownMenuItem(value: t, child: Text(t)))
              .toList(),
          onChanged: _onTaskAfterDateNameChanged,
        ),
      ],
    ];
  }

  List<Widget> _buildTaskAxis() {
    return [
      const SizedBox(height: 12),
      DropdownButtonFormField<String>(
        initialValue: task,
        decoration: const InputDecoration(labelText: 'Task'),
        items: taskOptions
            .map((t) => DropdownMenuItem(value: t, child: Text(t)))
            .toList(),
        onChanged: _onTaskChanged,
      ),
      if (task != null) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: name,
          decoration: const InputDecoration(labelText: 'Staff'),
          items: nameOptions
              .map((n) => DropdownMenuItem(value: n, child: Text(n)))
              .toList(),
          onChanged: _onNameAfterTaskChanged,
        ),
      ],
      if (name != null) ...[
        const SizedBox(height: 12),
        DropdownButtonFormField<DateTime>(
          initialValue: date,
          decoration: const InputDecoration(labelText: 'Date'),
          items: dateOptions
              .map(
                (d) =>
                    DropdownMenuItem(value: d, child: Text(formatDate(d))),
              )
              .toList(),
          onChanged: _onDateAfterTaskNameChanged,
        ),
      ],
    ];
  }
}
