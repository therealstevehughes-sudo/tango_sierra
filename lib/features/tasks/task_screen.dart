import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/unit_conversion.dart';
import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/notification_rule_providers.dart';
import '../../shared/providers/shift_handover_providers.dart';
import '../../shared/providers/task_schedule_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import '../../shared/providers/task_template_providers.dart';
import '../../shared/providers/venue_setup_providers.dart';
import 'end_of_session_summary_screen.dart';
import 'task_controller.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  late final TaskController controller;
  bool loading = true;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String result = "PASS";
  String? selectedChoice;

  bool correctiveDone = false;
  bool photoTaken = false;

  String? error;

  @override
  void initState() {
    super.initState();
    controller = TaskController(
      ref.read(taskSubmissionRepositoryProvider),
      ref.read(taskScheduleRepositoryProvider),
      ref.read(taskTemplateRepositoryProvider),
      ref.read(equipmentRepositoryProvider),
      ref.read(currentUserProvider)!,
      ref.read(notificationRuleRepositoryProvider),
      ref.read(triggerNotificationRepositoryProvider),
      ref.read(userRepositoryProvider),
    );
    numberController.addListener(_onFormChanged);
    notesController.addListener(_onFormChanged);
    _load();
  }

  Future<void> _load() async {
    await controller.loadTasks();
    if (!mounted) return;
    setState(() => loading = false);

    final handoverRepo = ref.read(shiftHandoverRepositoryProvider);
    final latestNote = await handoverRepo.getLatest();
    if (!mounted || latestNote == null) return;

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Handover Notes'),
        content: Text(latestNote.note),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    numberController.removeListener(_onFormChanged);
    notesController.removeListener(_onFormChanged);
    numberController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  bool get _displayInFahrenheit {
    final task = controller.getCurrentTask();
    final currentUser = ref.read(currentUserProvider);
    return task.unit == 'celsius' &&
        currentUser?.preferredTemperatureUnit == TemperatureUnit.fahrenheit;
  }

  String get _numericFieldLabel {
    final task = controller.getCurrentTask();
    if (task.unit == null) return "Enter value";
    final unitLabel = _displayInFahrenheit
        ? '°F'
        : (task.unit == 'celsius' ? '°C' : task.unit!);
    return "Enter value ($unitLabel)";
  }

  double? get _numberInTemplateUnit {
    final parsed = double.tryParse(numberController.text.trim());
    if (parsed == null) return null;
    return _displayInFahrenheit ? fahrenheitToCelsius(parsed) : parsed;
  }

  String? get _derivedResultFromNumber {
    final task = controller.getCurrentTask();
    if (!task.hasNumericRange) return null;
    final value = _numberInTemplateUnit;
    if (value == null) return null;
    final withinRange = value >= task.minLimit! && value <= task.maxLimit!;
    return withinRange ? "PASS" : "FAIL";
  }

  String get effectiveResult {
    final task = controller.getCurrentTask();
    if (task.hasNumericRange) {
      return _derivedResultFromNumber ?? "PASS";
    }
    return result;
  }

  String? get _rangeWarning {
    final task = controller.getCurrentTask();
    if (!task.hasNumericRange) return null;
    if (_derivedResultFromNumber != "FAIL") return null;
    return task.fixInstructions ?? "Reading is outside the safe range.";
  }

  bool get canSubmit {
    final task = controller.getCurrentTask();

    if (task.hasNumericRange && _numberInTemplateUnit == null) {
      return false;
    }
    if (task.hasChoice && selectedChoice == null) {
      return false;
    }
    if (task.requiresNotes && notesController.text.trim().isEmpty) {
      return false;
    }
    if (task.requiresPhoto && !photoTaken) {
      return false;
    }
    if (task.requiresCorrectiveActionOnFail &&
        effectiveResult == "FAIL" &&
        !correctiveDone) {
      return false;
    }

    return true;
  }

  Future<void> validateAndSubmit() async {
    final task = controller.getCurrentTask();

    setState(() {
      error = null;
    });

    if (task.hasNumericRange && _numberInTemplateUnit == null) {
      setState(() => error = "A valid numeric value is required");
      return;
    }

    if (task.hasChoice && selectedChoice == null) {
      setState(() => error = "Please select an option");
      return;
    }

    if (task.requiresNotes && notesController.text.trim().isEmpty) {
      setState(() => error = "Notes required");
      return;
    }

    if (task.requiresPhoto && !photoTaken) {
      setState(() => error = "Photo required");
      return;
    }

    if (task.requiresCorrectiveActionOnFail &&
        effectiveResult == "FAIL" &&
        !correctiveDone) {
      setState(() => error = "Corrective action must be completed");
      return;
    }

    await submitTask();
  }

  Future<void> submitTask() async {
    final task = controller.getCurrentTask();
    final numericValue = _numberInTemplateUnit;

    await controller.logTaskSubmission(
      task: task,
      status: effectiveResult,
      numericValue: numericValue?.toString(),
      photoAttached: photoTaken,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
      customFieldValuesJson: selectedChoice == null
          ? null
          : jsonEncode({'selected': selectedChoice}),
    );

    if (!mounted) return;

    final hasNext = controller.nextTask();

    if (hasNext) {
      setState(() {
        numberController.clear();
        notesController.clear();
        result = "PASS";
        selectedChoice = null;
        correctiveDone = false;
        photoTaken = false;
        error = null;
      });
    } else {
      final stats = await controller.buildSessionStats();
      if (!mounted) return;

      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EndOfSessionSummaryScreen(stats: stats),
        ),
      );

      if (!mounted) return;

      ref.read(currentUserProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final currentUser = ref.watch(currentUserProvider);
    final canSeeManagerView =
        currentUser?.roleTier == RoleTier.mid ||
        currentUser?.roleTier == RoleTier.top;

    if (!controller.hasTasks) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Task"),
          actions: canSeeManagerView
              ? [
                  IconButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/manager');
                    },
                    icon: const Icon(Icons.visibility),
                    tooltip: 'Manager View',
                  ),
                ]
              : null,
        ),
        body: const Center(child: Text("No tasks assigned yet.")),
      );
    }

    final task = controller.getCurrentTask();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task"),
        actions: canSeeManagerView
            ? [
                IconButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/manager');
                  },
                  icon: const Icon(Icons.visibility),
                  tooltip: 'Manager View',
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(task.displayTitle, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            if (task.hasNumericRange)
              TextField(
                controller: numberController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: true,
                ),
                decoration: InputDecoration(labelText: _numericFieldLabel),
              ),
            if (task.hasNumericRange && _numberInTemplateUnit != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _derivedResultFromNumber == "PASS"
                      ? "Within range — PASS"
                      : "Outside range — FAIL",
                  style: TextStyle(
                    color: _derivedResultFromNumber == "PASS"
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (task.hasChoice)
              DropdownButtonFormField<String>(
                initialValue: selectedChoice,
                decoration: const InputDecoration(labelText: "Select option"),
                items: task.choiceOptions!
                    .map(
                      (option) => DropdownMenuItem(
                        value: option,
                        child: Text(option),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() => selectedChoice = value);
                },
              ),
            if (task.requiresNotes)
              TextField(
                controller: notesController,
                decoration: const InputDecoration(labelText: "Notes"),
              ),
            if (task.requiresPhoto)
              ElevatedButton(
                onPressed: () {
                  setState(() => photoTaken = true);
                },
                child: Text(photoTaken ? "Photo Added" : "Add Photo"),
              ),
            const SizedBox(height: 20),
            if (!task.hasNumericRange)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => result = "PASS"),
                    child: const Text("PASS"),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => setState(() => result = "FAIL"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("FAIL"),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (_rangeWarning != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  _rangeWarning!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            if (task.requiresCorrectiveActionOnFail &&
                effectiveResult == "FAIL")
              Column(
                children: [
                  if (task.fixInstructions != null)
                    Text(
                      "Corrective Action Required:\n${task.fixInstructions}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  CheckboxListTile(
                    title: const Text("Corrective action completed"),
                    value: correctiveDone,
                    onChanged: (val) {
                      setState(() => correctiveDone = val ?? false);
                    },
                  ),
                ],
              ),
            if (error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(error!, style: const TextStyle(color: Colors.red)),
              ),
            const Spacer(),
            ElevatedButton(
              onPressed: canSubmit ? validateAndSubmit : null,
              child: const Text("SUBMIT"),
            ),
          ],
        ),
      ),
    );
  }
}
