class ShiftHandoverNote {
  final int id;
  final int authorUserId;
  final String note;
  final DateTime createdAt;

  const ShiftHandoverNote({
    required this.id,
    required this.authorUserId,
    required this.note,
    required this.createdAt,
  });
}
