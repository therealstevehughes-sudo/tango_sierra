import '../../core/network/backend_rest_client.dart';
import '../models/allergen.dart';
import '../models/allergen_ingredient_suggestions.dart';
import '../models/ingredient.dart';
import 'ingredient_repository.dart';

class SupabaseIngredientRepository implements IngredientRepository {
  SupabaseIngredientRepository(this._client);

  final BackendRestClient _client;

  @override
  Future<List<Ingredient>> getForSite(int siteId) async {
    final rows = await _client.select(
      'ingredients',
      query: 'site_id=eq.$siteId&order=name.asc',
    );
    return rows.map(_toModel).toList();
  }

  @override
  Future<Ingredient> findOrCreate({
    required int siteId,
    required String name,
  }) async {
    final trimmed = name.trim();
    // PostgREST ilike for a case-insensitive exact match — matches this
    // app's established "select first, then insert" convention for
    // low-frequency admin-time lookups (see off_day_requests' own doc
    // comment on this same tolerance for a benign race).
    final existing = await _client.select(
      'ingredients',
      query: 'site_id=eq.$siteId&name=ilike.${Uri.encodeComponent(trimmed)}',
    );
    if (existing.isNotEmpty) return _toModel(existing.first);

    final suggested = suggestAllergensForIngredientName(trimmed);
    final row = await _client.insertOne('ingredients', {
      'site_id': siteId,
      'name': trimmed,
      'default_allergens': suggested.map((a) => a.name).toList(),
    });
    return _toModel(row);
  }

  @override
  Future<void> updateAllergens(int ingredientId, Set<Allergen> allergens) async {
    await _client.update(
      'ingredients',
      filter: 'id=eq.$ingredientId',
      body: {'default_allergens': allergens.map((a) => a.name).toList()},
    );
  }

  Ingredient _toModel(Map<String, dynamic> row) => Ingredient(
    id: row['id'] as int,
    siteId: row['site_id'] as int,
    name: row['name'] as String,
    defaultAllergens: ((row['default_allergens'] as List?) ?? [])
        .map((a) => Allergen.values.byName(a as String))
        .toSet(),
    createdAt: DateTime.parse(row['created_at'] as String),
  );
}
