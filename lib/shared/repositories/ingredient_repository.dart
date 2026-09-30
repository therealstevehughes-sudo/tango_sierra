import '../models/allergen.dart';
import '../models/ingredient.dart';

abstract class IngredientRepository {
  Future<List<Ingredient>> getForSite(int siteId);

  /// Looks up an existing ingredient by name (case-insensitive, exact
  /// match) at [siteId]; creates a new one with keyword-suggested allergens
  /// if none exists yet. See allergen_ingredient_suggestions.dart's own
  /// doc comment on why this is a starting suggestion, not a final answer.
  Future<Ingredient> findOrCreate({required int siteId, required String name});

  /// Updates an ingredient's own allergen set — e.g. a chef correcting a
  /// keyword-suggested false positive, or adding one the suggestion missed.
  /// Changes here apply the NEXT time a dish using this ingredient is
  /// (re-)approved, not retroactively to already-approved dishes' frozen
  /// tags (see MenuItemAllergenTag's own doc comment).
  Future<void> updateAllergens(int ingredientId, Set<Allergen> allergens);
}
