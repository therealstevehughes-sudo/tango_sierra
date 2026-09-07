// Same-venue uniqueness (2026-09-06) — thrown instead of silently allowing
// a second instance with the same name at one venue, which would make the
// instance-name disambiguation added throughout the app meaningless (two
// "Fridge"s are exactly as ambiguous as no name at all). The message
// repeats the naming-guidance examples as a second, well-timed nudge —
// this is exactly the moment someone was about to take the lazy path.
class DuplicateEquipmentNameException implements Exception {
  const DuplicateEquipmentNameException(this.name);

  final String name;

  String get message =>
      'This venue already has equipment named "$name" — give this one a '
      'more specific name so staff can tell them apart, e.g. Meat Walk-in, '
      'Dessert Fridge, Bar Fryer.';

  @override
  String toString() => message;
}
