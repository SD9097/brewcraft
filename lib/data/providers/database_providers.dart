import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/coffee.dart';
import '../local/app_database.dart';
import '../repositories/coffee_repository.dart';
import '../seed/seed_loader.dart';

final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = AppDatabase();
  await SeedLoader.ensureSeeded(db);
  ref.onDispose(db.close);
  return db;
});

Future<CoffeeRepository> _repo(Ref ref) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return CoffeeRepository(db);
}

final coffeesForCategoryProvider =
    FutureProvider.family<List<CoffeeSummary>, String>((ref, categorySlug) async {
  return (await _repo(ref)).coffeesForCategory(categorySlug);
});

final coffeeByIdProvider =
    FutureProvider.family<CoffeeSummary?, int>((ref, id) async {
  return (await _repo(ref)).coffeeById(id);
});

final brewMethodsForCoffeeProvider =
    FutureProvider.family<List<BrewMethodSummary>, int>((ref, coffeeId) async {
  return (await _repo(ref)).methodsForCoffee(coffeeId);
});

final brewMethodDetailProvider =
    FutureProvider.family<BrewMethodDetail?, int>((ref, methodId) async {
  return (await _repo(ref)).methodDetail(methodId);
});
