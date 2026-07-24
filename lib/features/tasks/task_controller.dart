import '../manager/task_log_model.dart';
import 'task_model.dart';
import 'task_queue.dart';

class TaskController {
  int currentIndex = 0;
  final List<Task> tasks = TaskQueue.getTasks();

  static const List<String> _mockStaff = [
    'Steve Hughes (Kitchen Porter)',
    'Aisha Khan (Line Chef)',
    'Marta Nowak (Prep Chef)',
    'Lewis Grant (Sous Chef)',
    'Elena Petrov (Commis Chef)',
    'Samir Ali (Grill Chef)',
  ];

  int _mockStaffIndex = 0;

  Task getCurrentTask() => tasks[currentIndex];

  bool nextTask() {
    if (currentIndex < tasks.length - 1) {
      currentIndex++;
      return true;
    }
    return false;
  }

  String getNextMockStaffMember() {
    final staffMember = _mockStaff[_mockStaffIndex];
    _mockStaffIndex = (_mockStaffIndex + 1) % _mockStaff.length;
    return staffMember;
  }

  void logTaskSubmission({
    required Task task,
    required String status,
    required String completedBy,
    String? numericValue,
    required bool photoAttached,
    String? notes,
  }) {
    TaskLogStore.addEntry(
      TaskLogEntry(
        taskTitle: task.title,
        status: status,
        completedBy: completedBy,
        completedAt: DateTime.now(),
        numericValue: numericValue,
        photoAttached: photoAttached,
        notes: notes,
      ),
    );
  }
}
