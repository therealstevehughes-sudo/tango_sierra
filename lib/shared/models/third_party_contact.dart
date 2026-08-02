class ThirdPartyContact {
  final int id;
  final String name;
  final String? company;
  final String? specialty;
  final String? phone;
  final String? email;
  final String? notes;
  // Null means visible org-wide, same pattern as NotificationRule.siteId.
  final int? siteId;
  final int createdByUserId;
  final DateTime createdAt;
  final bool active;

  const ThirdPartyContact({
    required this.id,
    required this.name,
    this.company,
    this.specialty,
    this.phone,
    this.email,
    this.notes,
    this.siteId,
    required this.createdByUserId,
    required this.createdAt,
    required this.active,
  });
}
