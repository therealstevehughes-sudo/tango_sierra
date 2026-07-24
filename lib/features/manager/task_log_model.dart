class TaskLogEntry {
  final String taskTitle;
  final String status;
  final String completedBy;
  final DateTime completedAt;
  final String? numericValue;
  final bool photoAttached;
  final String? notes;

  const TaskLogEntry({
    required this.taskTitle,
    required this.status,
    required this.completedBy,
    required this.completedAt,
    this.numericValue,
    required this.photoAttached,
    this.notes,
  });
}

class TaskLogStore {
  static final List<TaskLogEntry> _entries = [];

  static List<TaskLogEntry> getEntries() {
    return List.unmodifiable(_entries.reversed.toList());
  }

  static void addEntry(TaskLogEntry entry) {
    _entries.add(entry);
  }
}
