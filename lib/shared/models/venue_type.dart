// A venue "type" (Sprint 029) — e.g. Café, Fine Dining, Hotel — used to tag
// which tasks/presets/equipment are relevant at a given venue. Fixed seeded
// list, org-wide, not versioned. See app_database.dart.
class VenueType {
  final int id;
  final String name;

  const VenueType({required this.id, required this.name});
}
