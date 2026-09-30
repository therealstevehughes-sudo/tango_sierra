import 'allergen.dart';
import 'ingredient.dart';
import 'menu_item_allergen_tag.dart';

// Keyword-based allergen suggestion (Phase 2, allergen module, 2026-09-30)
// — when a brand-new ingredient is typed for the first time, this suggests
// a starting set of allergens from its name, which a senior chef then
// reviews/adjusts on the ingredient itself (see Ingredient.defaultAllergens)
// before it's ever used on an approved dish. Deliberately simple keyword
// matching, not real ML/AI — matches this app's honest positioning versus
// FoodDocs' own "AI" claim (see PHASE_2_ROADMAP.md's competitor research
// notes: automation of setup speed, not predictive risk AI). A starting
// point to reduce blank-slate typing, never a substitute for the chef's
// own review — this is why every ingredient's allergens stay fully
// editable rather than locked to whatever this function guesses.
final Map<Allergen, List<String>> _allergenKeywords = {
  Allergen.celery: ['celery', 'celeriac'],
  Allergen.gluten: [
    'wheat', 'flour', 'bread', 'pasta', 'barley', 'rye', 'oat', 'breadcrumb',
    'batter', 'couscous', 'noodle', 'bun', 'pastry', 'malt',
  ],
  Allergen.crustaceans: ['prawn', 'shrimp', 'crab', 'lobster', 'crayfish'],
  Allergen.eggs: ['egg', 'mayonnaise', 'mayo', 'meringue'],
  Allergen.fish: ['fish', 'anchovy', 'salmon', 'tuna', 'cod', 'haddock', 'sardine'],
  Allergen.lupin: ['lupin', 'lupine'],
  Allergen.milk: [
    'milk', 'cheese', 'butter', 'cream', 'yoghurt', 'yogurt', 'whey',
    'casein', 'ghee',
  ],
  Allergen.molluscs: ['mussel', 'squid', 'oyster', 'scallop', 'snail', 'clam', 'octopus'],
  Allergen.mustard: ['mustard'],
  Allergen.treeNuts: [
    'almond', 'hazelnut', 'walnut', 'cashew', 'pecan', 'pistachio',
    'macadamia', 'brazil nut',
  ],
  Allergen.peanuts: ['peanut', 'groundnut'],
  Allergen.sesame: ['sesame', 'tahini'],
  Allergen.soya: ['soy', 'soya', 'tofu', 'edamame'],
  Allergen.sulphites: ['sulphite', 'sulfite', 'wine', 'dried fruit', 'dried apricot'],
};

/// Suggests allergens from an ingredient's own name via simple keyword
/// matching (case-insensitive substring match) — a starting point only,
/// see this file's own doc comment.
Set<Allergen> suggestAllergensForIngredientName(String name) {
  final lower = name.toLowerCase();
  final suggested = <Allergen>{};
  for (final entry in _allergenKeywords.entries) {
    if (entry.value.any((keyword) => lower.contains(keyword))) {
      suggested.add(entry.key);
    }
  }
  return suggested;
}

/// Unions every [ingredients] entry's own defaultAllergens into a starting
/// set of "contains" tags for a dish built from them — the pre-fill a
/// senior chef reviews/edits before approving (never auto-published as-is,
/// see MenuItemRepository.approve's own doc comment). Ingredient-driven
/// detection is always "contains", never "may contain" — cross-
/// contamination risk (a shared fryer, etc.) isn't derivable from an
/// ingredient list, so that has to be added manually by the reviewer.
List<MenuItemAllergenTag> suggestedTagsFromIngredients({
  required int menuItemId,
  required List<Ingredient> ingredients,
}) {
  final allergens = <Allergen>{};
  for (final ingredient in ingredients) {
    allergens.addAll(ingredient.defaultAllergens);
  }
  return allergens
      .map(
        (a) => MenuItemAllergenTag(
          id: null,
          menuItemId: menuItemId,
          allergen: a,
          status: AllergenTagStatus.contains,
        ),
      )
      .toList();
}
