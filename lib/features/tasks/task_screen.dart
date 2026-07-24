import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/user.dart';
import '../../shared/providers/auth_providers.dart';
import '../../shared/providers/task_submission_providers.dart';
import 'task_controller.dart';
import 'task_model.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  late final TaskController controller;

  final TextEditingController numberController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  String result = "PASS";

  bool correctiveDone = false;
  bool photoTaken = false;

  String? error;

  @override
  void initState() {
    super.initState();
    controller = TaskController(
      ref.read(taskSubmissionRepositoryProvider),
      ref.read(currentUserProvider)!,
    );
  }

  @override
  void dispose() {
    numberController.dispose();
    notesController.dispose();
    super.dispose();
  }

  Future<void> validateAndSubmit() async {
    Task task = controller.getCurrentTask();

    setState(() {
      error = null;
    });

    if (task.requiresNumeric && numberController.text.isEmpty) {
      setState(() => error = "Numeric value required");
      return;
    }

    if (task.requiresNotes && notesController.text.isEmpty) {
      setState(() => error = "Notes required");
      return;
    }

    if (task.requiresPhoto && !photoTaken) {
      setState(() => error = "Photo required");
      return;
    }

    if (task.isCritical && result == "FAIL" && !correctiveDone) {
      setState(() => error = "Corrective action must be completed");
      return;
    }

    await submitTask();
  }

  Future<void> submitTask() async {
    final task = controller.getCurrentTask();

    await controller.logTaskSubmission(
      task: task,
      status: result,
      numericValue: numberController.text.trim().isEmpty
          ? null
          : numberController.text.trim(),
      photoAttached: photoTaken,
      notes: notesController.text.trim().isEmpty
          ? null
          : notesController.text.trim(),
    );

    if (!mounted) return;

    final hasNext = controller.nextTask();

    if (hasNext) {
      setState(() {
        numberController.clear();
        notesController.clear();
        result = "PASS";
        correctiveDone = false;
        photoTaken = false;
        error = null;
      });
    } else {
      await showDialog(
        context: context,
        builder: (_) => const AlertDialog(title: Text("All tasks complete")),
      );

      if (!mounted) return;

      ref.read(currentUserProvider.notifier).state = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    Task task = controller.getCurrentTask();
    final currentUser = ref.watch(currentUserProvider);
    final isManager = currentUser?.roleTier == RoleTier.manager;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Task"),
        actions: isManager
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
            Text(task.title, style: const TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            if (task.requiresNumeric)
              TextField(
                controller: numberController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Enter value"),
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
            if (task.isCritical && result == "FAIL")
              Column(
                children: [
                  Text(
                    "Corrective Action Required:\n${task.correctiveAction}",
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
              onPressed: validateAndSubmit,
              child: const Text("SUBMIT"),
            ),
          ],
        ),
      ),
    );
  }
}
