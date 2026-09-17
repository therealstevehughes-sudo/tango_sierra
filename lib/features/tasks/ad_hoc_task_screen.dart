import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/widgets/app_card.dart';
import '../../core/widgets/responsive_content.dart';
import '../../shared/models/supplier.dart';
import '../../shared/models/task_template.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/problem_register_providers.dart';
import '../../shared/providers/supplier_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import 'ad_hoc_task_kind.dart';
import 'delivery_detail_form.dart';
import 'task_controller.dart';
import 'task_model.dart';
import 'verified_threshold_judgment.dart';

// Ad-hoc task path (Sprint 038 follow-on, 2026-09-17) — a worker does
// something that was never scheduled (a delivery nobody set up a check
// for, an off-schedule temperature spot-check), picked directly from the
// task library rather than from TaskController's schedule-driven carousel.
// Reuses TaskController.logTaskSubmission unchanged (same notifications /
// Problems Register lifecycle a scheduled submission gets) by constructing
// a schedule-less ResolvedTask (`scheduleId: null` — see task_model.dart).
class AdHocTaskScreen extends ConsumerStatefulWidget {
  const AdHocTaskScreen({super.key});

  @override
  ConsumerState<AdHocTaskScreen> createState() => _AdHocTaskScreenState();
}

class _AdHocTaskScreenState extends ConsumerState<AdHocTaskScreen> {
  late final TaskController _controller;
  bool _loading = true;
  Map<AdHocTaskKind, List<TaskTemplate>> _templatesByKind = {};
  List<Supplier> _suppliers = [];

  AdHocTaskKind? _selectedKind;
  TaskTemplate? _selectedTemplate;

  // Delivery form state.
  String _deliveryResult = 'PASS';
  DeliveryDetailValue _deliveryValue = const DeliveryDetailValue();

  // Temperature form state.
  final _valueController = TextEditingController();
  final _noteController = TextEditingController();
  bool _submitting = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider)!;
    _controller = TaskController(
      ref.read(taskSubmissionRepositoryProvider),
      ref.read(taskScheduleRepositoryProvider),
      ref.read(taskTemplateRepositoryProvider),
      ref.read(equipmentRepositoryProvider),
      user,
      ref.read(notificationRuleRepositoryProvider),
      ref.read(triggerNotificationRepositoryProvider),
      ref.read(userRepositoryProvider),
      ref.read(problemRegisterRepositoryProvider),
    );
    _load();
  }

  @override
  void dispose() {
    _valueController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final user = ref.read(currentUserProvider)!;
    final siteId = user.siteId!;
    final schedules = await ref
        .read(taskScheduleRepositoryProvider)
        .getForSite(siteId);
    final siteTemplateGroupIds = schedules
        .map((s) => s.taskTemplateGroupId)
        .toSet();
    final allTemplates = await ref
        .read(taskTemplateRepositoryProvider)
        .getAllCurrentVersions();
    final suppliers = await ref
        .read(supplierRepositoryProvider)
        .getForSite(siteId);

    final byKind = <AdHocTaskKind, List<TaskTemplate>>{};
    for (final kind in adHocTaskKinds) {
      final matches = templatesForKind(
        kind,
        allTemplates,
        siteTemplateGroupIds,
      );
      if (matches.isNotEmpty) byKind[kind] = matches;
    }

    if (!mounted) return;
    setState(() {
      _templatesByKind = byKind;
      _suppliers = suppliers.where((s) => s.active).toList();
      _loading = false;
    });
  }

  ResolvedTask _resolvedTaskFor(TaskTemplate template) {
    final user = ref.read(currentUserProvider)!;
    return ResolvedTask(
      scheduleId: null,
      templateGroupId: template.templateGroupId,
      title: template.title,
      segment: template.segment,
      method: template.method,
      requiresPhoto: false, // Ad-hoc path doesn't collect photos (known
      // limitation — see DECISIONS_LOG.md); a template
      // that normally requires one still records the
      // reading, just without a photo attached.
      requiresNotes: false,
      minLimit: template.minLimit,
      maxLimit: template.maxLimit,
      unit: template.unit,
      isCritical: template.isCritical,
      requiresCorrectiveActionOnFail: false,
      fixInstructions: template.fixInstructions,
      guidanceText: template.guidanceText,
      assignedByUserId: user.id,
      requiresSupplierSelection: template.requiresSupplierSelection,
    );
  }

  Future<void> _submitDelivery() async {
    final template = _selectedTemplate;
    if (template == null) return;
    setState(() => _submitting = true);
    await _controller.logTaskSubmission(
      task: _resolvedTaskFor(template),
      status: _deliveryResult,
      notes: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      photoAttached: false,
      supplierId: _deliveryValue.supplierId,
      deliveryTemperatureC: _deliveryValue.temperatureC,
      deliveryShortDelivery: _deliveryValue.shortDelivery,
      deliveryDamagedStock: _deliveryValue.damagedStock,
      deliveryLateDelivery: _deliveryValue.lateDelivery,
      deliveryQualityProblem: _deliveryValue.qualityProblem,
      deliveryOutcome: _deliveryValue.outcome,
    );
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  Future<void> _submitTemperature() async {
    final template = _selectedTemplate;
    final value = double.tryParse(_valueController.text.trim());
    if (template == null || value == null) return;
    setState(() => _submitting = true);
    // The safety line: no judgment is asserted here beyond whatever
    // verifiedJudgmentFor() itself decides (null today) — see that file's
    // own doc comment for why, and what "switching it on" later means.
    final status =
        verifiedJudgmentFor(template.legalLimitCategory, value) ?? 'LOGGED';
    await _controller.logTaskSubmission(
      task: _resolvedTaskFor(template),
      status: status,
      numericValue: value.toString(),
      notes: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      photoAttached: false,
    );
    if (!mounted) return;
    setState(() {
      _submitting = false;
      _submitted = true;
    });
  }

  void _reset() {
    setState(() {
      _selectedKind = null;
      _selectedTemplate = null;
      _deliveryResult = 'PASS';
      _deliveryValue = const DeliveryDetailValue();
      _valueController.clear();
      _noteController.clear();
      _submitted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Do an ad-hoc task')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ResponsiveContent(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: _buildBody(),
              ),
            ),
    );
  }

  Widget _buildBody() {
    if (_submitted) return _buildDone();
    final template = _selectedTemplate;
    if (template != null) return _buildForm(template);
    final kind = _selectedKind;
    if (kind != null) return _buildTemplatePicker(kind);
    return _buildKindChooser();
  }

  Widget _buildKindChooser() {
    if (_templatesByKind.isEmpty) {
      return const AppCard(
        child: Text(
          'No ad-hoc task types are set up at this site yet — ask a '
          'manager to assign a delivery-check or temperature-check task '
          'template first.',
        ),
      );
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'What kind of thing are you doing?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          for (final kind in _templatesByKind.keys)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OutlinedButton(
                onPressed: () => setState(() => _selectedKind = kind),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(kind.label),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTemplatePicker(AdHocTaskKind kind) {
    final templates = _templatesByKind[kind] ?? const [];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedKind = null),
              ),
              Expanded(
                child: Text(
                  kind.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          for (final template in templates)
            ListTile(
              title: Text(template.title),
              onTap: () => setState(() => _selectedTemplate = template),
            ),
        ],
      ),
    );
  }

  Widget _buildForm(TaskTemplate template) {
    final kind = _selectedKind!;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _selectedTemplate = null),
              ),
              Expanded(
                child: Text(
                  template.title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (kind is DeliveryCheckKind) ..._buildDeliveryForm(),
          if (kind is TemperatureCheckKind) ..._buildTemperatureForm(),
        ],
      ),
    );
  }

  List<Widget> _buildDeliveryForm() {
    return [
      DeliveryDetailForm(
        suppliers: _suppliers,
        onChanged: (v) => setState(() => _deliveryValue = v),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _noteController,
        decoration: const InputDecoration(labelText: 'Notes (optional)'),
        maxLines: 2,
      ),
      const SizedBox(height: 12),
      Row(
        children: [
          Expanded(
            child: OutlinedButton(
              style: _deliveryResult == 'PASS'
                  ? OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.primary.withValues(alpha: 0.1),
                    )
                  : null,
              onPressed: () => setState(() => _deliveryResult = 'PASS'),
              child: const Text('PASS'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              style: _deliveryResult == 'FAIL'
                  ? OutlinedButton.styleFrom(
                      backgroundColor: Theme.of(
                        context,
                      ).colorScheme.error.withValues(alpha: 0.1),
                    )
                  : null,
              onPressed: () => setState(() => _deliveryResult = 'FAIL'),
              child: const Text('FAIL'),
            ),
          ),
        ],
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _submitting ? null : _submitDelivery,
        child: _submitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Submit'),
      ),
    ];
  }

  List<Widget> _buildTemperatureForm() {
    return [
      // Deliberately no "safe range" label and no PASS/FAIL badge here —
      // this records the reading only. See verified_threshold_judgment.dart.
      TextField(
        controller: _valueController,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        decoration: const InputDecoration(labelText: 'Temperature (°C)'),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _noteController,
        decoration: const InputDecoration(labelText: 'Note (optional)'),
        maxLines: 2,
      ),
      const SizedBox(height: 16),
      ElevatedButton(
        onPressed: _submitting ? null : _submitTemperature,
        child: _submitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text('Log reading'),
      ),
    ];
  }

  Widget _buildDone() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('Logged. Thanks for recording this.'),
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: _reset,
            child: const Text('Log another ad-hoc task'),
          ),
        ],
      ),
    );
  }
}
