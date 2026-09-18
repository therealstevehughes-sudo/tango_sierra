// Teams (2026-09-18) — a finer subdivision within a Department, e.g. "Night
// Team"/"Day Team" inside "Kitchen". Same editable shape as Department;
// distinct from the "Branch Team Structure" reporting-line org chart.
class Team {
  final int? id;
  final String name;
  final int departmentId;
  final bool active;
  final DateTime createdAt;

  const Team({
    this.id,
    required this.name,
    required this.departmentId,
    this.active = true,
    required this.createdAt,
  });
}
