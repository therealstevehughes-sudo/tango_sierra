// A single ingredient entry on a MenuItem's draft ingredient list (Phase 2,
// allergen module, 2026-09-30). Always points at a real Ingredient row -
// kitchen staff either pick an existing one or type a new name, which
// creates a new Ingredient on the fly (same "type it, it becomes a real
// reusable entry" pattern as Supplier/Department creation elsewhere in
// this app) - there is no separate free-text-only entry, so every
// ingredient on every dish is always allergen-lookup-able.
class MenuItemIngredient {
  final int? id;
  final int menuItemId;
  final int ingredientId;

  const MenuItemIngredient({
    required this.id,
    required this.menuItemId,
    required this.ingredientId,
  });
}
