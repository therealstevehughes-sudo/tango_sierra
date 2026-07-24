class Task {
  final String title;
  final bool requiresNumeric;
  final bool requiresPhoto;
  final bool requiresNotes;
  final bool isCritical;

  final String correctiveAction;

  Task({
    required this.title,
    this.requiresNumeric = false,
    this.requiresPhoto = false,
    this.requiresNotes = false,
    this.isCritical = false,
    this.correctiveAction = "",
  });
}
