import 'task_model.dart';

class TaskQueue {
  static List<Task> getTasks() {
    return [
      Task(
        title: "Check fridge temperature",
        requiresNumeric: true,
        isCritical: true,
      ),
      Task(title: "Clean prep surface", requiresPhoto: true),
      Task(
        title: "Check delivery condition",
        requiresPhoto: true,
        requiresNotes: true,
      ),
    ];
  }
}
