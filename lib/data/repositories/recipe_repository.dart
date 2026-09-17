import 'package:drift/drift.dart';

import '../../core/models/recipe.dart';
import '../local/app_database.dart';

class RecipeRepository {
  RecipeRepository(this._db);

  final AppDatabase _db;

  Future<List<RecipeSummary>> listRecipes() async {
    final rows = await (_db.select(_db.userRecipes)
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)]))
        .get();
    return rows.map(_toSummary).toList();
  }

  Future<RecipeDetail?> recipeById(int id) async {
    final row = await (_db.select(_db.userRecipes)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;

    final ingredients = await (_db.select(_db.userRecipeIngredients)
          ..where((t) => t.recipeId.equals(id))
          ..orderBy([(t) => OrderingTerm.asc(t.sortOrder)]))
        .get();
    final steps = await (_db.select(_db.userRecipeSteps)
          ..where((t) => t.recipeId.equals(id))
          ..orderBy([(t) => OrderingTerm.asc(t.stepOrder)]))
        .get();

    return RecipeDetail(
      summary: _toSummary(row),
      ingredients: ingredients
          .map((i) => RecipeDraftIngredient(label: i.label, amount: i.amount))
          .toList(),
      steps: steps
          .map(
            (s) => RecipeDraftStep(
              title: s.title,
              body: s.body,
              imagePath: s.imagePath,
            ),
          )
          .toList(),
    );
  }

  Future<int> saveRecipe(RecipeSaveInput input) async {
    final now = DateTime.now();
    return _db.transaction(() async {
      late int recipeId;
      if (input.id == null) {
        recipeId = await _db.into(_db.userRecipes).insert(
              UserRecipesCompanion.insert(
                name: input.name,
                coffeeId: Value(input.coffeeId),
                forkedFromMethodId: Value(input.forkedFromMethodId),
                categorySlug: Value(input.categorySlug),
                notes: Value(input.notes),
                coverImagePath: Value(input.coverImagePath),
                createdAt: now,
                updatedAt: now,
              ),
            );
      } else {
        recipeId = input.id!;
        await (_db.update(_db.userRecipes)..where((t) => t.id.equals(recipeId)))
            .write(
          UserRecipesCompanion(
            name: Value(input.name),
            coffeeId: Value(input.coffeeId),
            forkedFromMethodId: Value(input.forkedFromMethodId),
            categorySlug: Value(input.categorySlug),
            notes: Value(input.notes),
            coverImagePath: Value(input.coverImagePath),
            updatedAt: Value(now),
          ),
        );
        await (_db.delete(_db.userRecipeIngredients)
              ..where((t) => t.recipeId.equals(recipeId)))
            .go();
        await (_db.delete(_db.userRecipeSteps)
              ..where((t) => t.recipeId.equals(recipeId)))
            .go();
      }

      for (var i = 0; i < input.ingredients.length; i++) {
        final ingredient = input.ingredients[i];
        await _db.into(_db.userRecipeIngredients).insert(
              UserRecipeIngredientsCompanion.insert(
                recipeId: recipeId,
                label: ingredient.label,
                amount: ingredient.amount,
                sortOrder: Value(i),
              ),
            );
      }

      for (var i = 0; i < input.steps.length; i++) {
        final step = input.steps[i];
        await _db.into(_db.userRecipeSteps).insert(
              UserRecipeStepsCompanion.insert(
                recipeId: recipeId,
                stepOrder: i + 1,
                title: step.title,
                body: step.body,
                imagePath: Value(step.imagePath),
              ),
            );
      }

      return recipeId;
    });
  }

  Future<void> deleteRecipe(int id) async {
    await _db.transaction(() async {
      await (_db.delete(_db.userRecipeIngredients)
            ..where((t) => t.recipeId.equals(id)))
          .go();
      await (_db.delete(_db.userRecipeSteps)..where((t) => t.recipeId.equals(id)))
          .go();
      await (_db.delete(_db.userRecipes)..where((t) => t.id.equals(id))).go();
    });
  }

  RecipeSummary _toSummary(UserRecipe row) {
    return RecipeSummary(
      id: row.id,
      name: row.name,
      coffeeId: row.coffeeId,
      forkedFromMethodId: row.forkedFromMethodId,
      categorySlug: row.categorySlug,
      notes: row.notes,
      coverImagePath: row.coverImagePath,
      updatedAt: row.updatedAt,
    );
  }
}
