import 'allergen.dart';

// Shared ingredient library (Phase 2, allergen module, 2026-09-30) — a
// site-wide, reusable list of ingredients, each with a system-suggested
// set of allergens (e.g. "peanut butter" -> peanuts + treeNuts). Kitchen
// staff pick from or add to this list when building a dish's ingredient
// list; the suggested allergens are a starting point a senior chef reviews
// and can override before a dish is approved — never auto-published
// without review (see MenuItem.status).
class Ingredient {
  final int? id;
  final int siteId;
  final String name;
  final Set<Allergen> defaultAllergens;
  final DateTime createdAt;

  const Ingredient({
    required this.id,
    required this.siteId,
    required this.name,
    required this.defaultAllergens,
    required this.createdAt,
  });
}
