import 'allergen.dart';

// A published allergen tag on an APPROVED MenuItem (Phase 2, allergen
// module, 2026-09-30). Computed by unioning the item's ingredients'
// defaultAllergens at the moment of approval, then editable by the
// approving senior chef before publishing (e.g. removing a false positive,
// or adding a "may contain" for cross-contamination that isn't
// ingredient-driven, like a shared fryer). This is the row a customer- or
// staff-facing allergen matrix actually reads - never the raw ingredient
// list directly, so an approval always freezes a deliberate, reviewed set
// of tags rather than silently drifting if the shared Ingredient library's
// own default allergens change later.
class MenuItemAllergenTag {
  final int? id;
  final int menuItemId;
  final Allergen allergen;
  final AllergenTagStatus status;

  const MenuItemAllergenTag({
    required this.id,
    required this.menuItemId,
    required this.allergen,
    required this.status,
  });
}
