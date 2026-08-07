import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/theme/app_colors.dart';
import '../../core/utils/unit_conversion.dart';
import '../../core/widgets/app_card.dart';
import '../../core/widgets/primary_action_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/user_title.dart';
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
  final TextEditingController correctiveNoteController =
      TextEditingController();

  String result = "PASS";
  String? selectedChoice;

  // Corrective-action redesign (Sprint 031, Sub-sprint 4): 'fixed' or
  // 'reported' — replaces the old single "completed" checkbox, which forced
  // a worker to tick something they often couldn't actually do themselves.
  String? correctiveActionOutcome;
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
    correctiveNoteController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {});
  }

  // Visual/UX pass, Sub-sprint 3: Log Out is now always visible in the app
  // bar on every state of this screen (previously only the empty-task
  // state had a way out at all) — a small, secondary-styled action so it
  // doesn't compete with SUBMIT as the screen's one primary action.
  List<Widget> _appBarActions(bool canSeeManagerView) {
    return [
      if (canSeeManagerView)
        IconButton(
          onPressed: () => Navigator.pushNamed(context, '/manager'),
          icon: const Icon(Icons.visibility),
          tooltip: 'Manager View',
        ),
      TextButton.icon(
        onPressed: () => ref.read(currentUserProvider.notifier).state = null,
        icon: const Icon(Icons.logout, size: 18),
        label: const Text('Log out'),
      ),
    ];
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
        correctiveActionOutcome == null) {
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
        correctiveActionOutcome == null) {
      setState(() => error = "Choose how the corrective action was handled");
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
      correctiveActionOutcome: correctiveActionOutcome,
      correctiveActionNote: correctiveNoteController.text.trim().isEmpty
          ? null
          : correctiveNoteController.text.trim(),
    );

    if (!mounted) return;

    final hasNext = controller.nextTask();

    if (hasNext) {
      setState(() {
        numberController.clear();
        notesController.clear();
        correctiveNoteController.clear();
        result = "PASS";
        selectedChoice = null;
        correctiveActionOutcome = null;
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
        currentUser != null && currentUser.roleTier != RoleTier.base;

    if (!controller.hasTasks) {
      return Scaffold(
        appBar: AppBar(
          title: currentUser != null
              ? UserTitle(user: currentUser)
              : const Text("Task"),
          actions: _appBarActions(canSeeManagerView),
        ),
        body: const Center(child: Text("No tasks assigned yet.")),
      );
    }

    final task = controller.getCurrentTask();

    return Scaffold(
      appBar: AppBar(
        title: currentUser != null
            ? UserTitle(user: currentUser)
            : const Text("Task"),
        actions: _appBarActions(canSeeManagerView),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        // Corrective-action redesign (Sprint 031, Sub-sprint 4): the body
        // was never wrapped in a scroll view — fine when the corrective-
        // action block was one badge + one line + one checkbox, but the
        // new prominent fixInstructions card + two-path row is taller, and
        // on a shorter window (or a long fixInstructions string) the fixed
        // Column overflowed at the bottom. SingleChildScrollView fixes it;
        // the Spacer-pinned-to-bottom SUBMIT button is gone with it — it
        // now sits naturally after the last content block instead, same
        // pattern already used on the end-of-session summary screen.
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Visual/UX pass, Sub-sprint 3: task title + inputs grouped in
              // one AppCard (Layout Rule's "consistent card structure"),
              // scoped narrowly to the content itself — PASS/FAIL, warnings,
              // and SUBMIT stay outside as the screen's action zone.
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.displayTitle,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 20),
                    if (task.hasNumericRange)
                      TextField(
                        controller: numberController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                          signed: true,
                        ),
                        decoration: InputDecoration(
                          labelText: _numericFieldLabel,
                        ),
                      ),
                    if (task.hasNumericRange && _numberInTemplateUnit != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: StatusBadge(
                          kind: _derivedResultFromNumber == "PASS"
                              ? StatusKind.pass
                              : StatusKind.critical,
                          label: _derivedResultFromNumber == "PASS"
                              ? "Within range — PASS"
                              : "Outside range — FAIL",
                        ),
                      ),
                    if (task.hasChoice)
                      DropdownButtonFormField<String>(
                        initialValue: selectedChoice,
                        decoration: const InputDecoration(
                          labelText: "Select option",
                        ),
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
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() => photoTaken = true);
                          },
                          child: Text(photoTaken ? "Photo Added" : "Add Photo"),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // PASS/FAIL as an equal-width segmented pair, not two competing
              // buttons — large touch targets for wet hands, and colour is
              // never the only signal (icon + word always accompany it).
              if (!task.hasNumericRange)
                Row(
                  children: [
                    Expanded(
                      child: _ResultOption(
                        label: 'PASS',
                        icon: Icons.check_circle_outline,
                        color: AppColors.pass,
                        bgColor: AppColors.passBg,
                        selected: result == 'PASS',
                        onTap: () => setState(() => result = 'PASS'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _ResultOption(
                        label: 'FAIL',
                        icon: Icons.cancel_outlined,
                        color: AppColors.critical,
                        bgColor: AppColors.criticalBg,
                        selected: result == 'FAIL',
                        onTap: () => setState(() => result = 'FAIL'),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              if (_rangeWarning != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Text(_rangeWarning!, textAlign: TextAlign.center),
                ),
              // Corrective-action redesign (Sprint 031, Sub-sprint 4): fix
              // instructions promoted to a prominent, unmissable card (not
              // fine print), and the old single "completed" checkbox —
              // which blocked a worker behind something they often couldn't
              // actually do themselves — replaced with two recorded paths.
              // Neither is a silent skip; SUBMIT still requires picking one.
              if (task.requiresCorrectiveActionOnFail &&
                  effectiveResult == "FAIL")
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const StatusBadge(
                      kind: StatusKind.critical,
                      label: 'Corrective action required',
                    ),
                    if (task.fixInstructions != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.criticalBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColors.critical),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Here's what to do:",
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(color: AppColors.critical),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.fixInstructions!,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _ResultOption(
                            label: 'I fixed it',
                            icon: Icons.build_circle_outlined,
                            color: AppColors.pass,
                            bgColor: AppColors.passBg,
                            selected: correctiveActionOutcome == 'fixed',
                            onTap: () => setState(
                              () => correctiveActionOutcome = 'fixed',
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ResultOption(
                            label: 'Reported to manager',
                            icon: Icons.campaign_outlined,
                            color: AppColors.teal,
                            bgColor: AppColors.tealTint,
                            selected: correctiveActionOutcome == 'reported',
                            onTap: () => setState(
                              () => correctiveActionOutcome = 'reported',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (correctiveActionOutcome == 'fixed') ...[
                      const SizedBox(height: 12),
                      TextField(
                        controller: correctiveNoteController,
                        decoration: const InputDecoration(
                          labelText: 'What did you do? (optional)',
                        ),
                      ),
                    ],
                    if (correctiveActionOutcome == 'reported') ...[
                      const SizedBox(height: 12),
                      Text(
                        'Your manager will be notified.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              if (error != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    error!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: PrimaryActionButton(
                  label: "SUBMIT",
                  icon: Icons.check,
                  onPressed: canSubmit ? validateAndSubmit : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One half of the PASS/FAIL segmented pair — large touch target, and
/// colour is never the only signal: icon + word are always present, even
/// unselected (muted, not just absent), per DESIGN_SYSTEM_LOCK's
/// Accessibility Rule.
class _ResultOption extends StatelessWidget {
  const _ResultOption({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? bgColor : AppColors.card,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? color : AppColors.line,
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? color : AppColors.muted, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                color: selected ? color : AppColors.muted,
                fontWeight: FontWeight.w700,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
