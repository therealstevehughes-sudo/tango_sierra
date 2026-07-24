import '../../shared/models/task_submission.dart';
import '../../shared/models/user.dart';
import '../../shared/repositories/task_submission_repository.dart';
import 'task_model.dart';
import 'task_queue.dart';

class TaskController {
  TaskController(this._repository, this._currentUser);

  final TaskSubmissionRepository _repository;
  final User _currentUser;

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

  Future<void> logTaskSubmission({
    required Task task,
    required String status,
    String? numericValue,
    required bool photoAttached,
    String? notes,
  }) {
    return _repository.submit(
      TaskSubmission(
        taskTitle: task.title,
        status: status,
        completedBy: '${_currentUser.name} (${_currentUser.jobTitle})',
        completedAt: DateTime.now(),
        numericValue: numericValue,
        photoAttached: photoAttached,
        notes: notes,
      ),
    );
  }
}
