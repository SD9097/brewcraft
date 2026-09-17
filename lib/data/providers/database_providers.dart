import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/coffee.dart';
import '../../core/models/recipe.dart';
import '../local/app_database.dart';
import '../repositories/coffee_repository.dart';
import '../repositories/recipe_repository.dart';
import '../seed/seed_loader.dart';

final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = AppDatabase();
  await SeedLoader.ensureSeeded(db);
  ref.onDispose(db.close);
  return db;
});

Future<CoffeeRepository> _coffeeRepo(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return CoffeeRepository(db);
}

Future<RecipeRepository> _recipeRepo(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return RecipeRepository(db);
}

final coffeesForCategoryProvider =
    FutureProvider.family<List<CoffeeSummary>, String>((ref, categorySlug) async {
  return (await _coffeeRepo(ref)).coffeesForCategory(categorySlug);
});

final coffeeByIdProvider =
    FutureProvider.family<CoffeeSummary?, int>((ref, id) async {
  return (await _coffeeRepo(ref)).coffeeById(id);
});

final brewMethodsForCoffeeProvider =
    FutureProvider.family<List<BrewMethodSummary>, int>((ref, coffeeId) async {
  return (await _coffeeRepo(ref)).methodsForCoffee(coffeeId);
});

final brewMethodDetailProvider =
    FutureProvider.family<BrewMethodDetail?, int>((ref, methodId) async {
  return (await _coffeeRepo(ref)).methodDetail(methodId);
});

final coffeeRepositoryProvider = FutureProvider<CoffeeRepository>((ref) async {
  return _coffeeRepo(ref);
});

final recipesProvider = FutureProvider<List<RecipeSummary>>((ref) async {
  return (await _recipeRepo(ref)).listRecipes();
});

final recipeByIdProvider =
    FutureProvider.family<RecipeDetail?, int>((ref, id) async {
  return (await _recipeRepo(ref)).recipeById(id);
});

final recipeRepositoryProvider = FutureProvider<RecipeRepository>((ref) async {
  return _recipeRepo(ref);
});

final favoriteCoffeesProvider = FutureProvider<List<CoffeeSummary>>((ref) async {
  return (await _coffeeRepo(ref)).favoriteCoffees();
});

final isFavoriteProvider = FutureProvider.family<bool, int>((ref, coffeeId) async {
  return (await _coffeeRepo(ref)).isFavorite(coffeeId);
});
