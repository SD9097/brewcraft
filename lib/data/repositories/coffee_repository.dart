import 'package:drift/drift.dart';

import '../../core/models/coffee.dart' as models;
import '../../core/services/user_image_service.dart';
import '../local/app_database.dart';

class CoffeeRepository {
  CoffeeRepository(this._db);

  final AppDatabase _db;

  Future<List<models.CoffeeSummary>> coffeesForCategory(String categorySlug) async {
    final query = _db.select(_db.coffees).join([
      innerJoin(
        _db.coffeeCategoryLinks,
        _db.coffeeCategoryLinks.coffeeId.equalsExp(_db.coffees.id),
      ),
    ]);
    query.where(_db.coffeeCategoryLinks.categorySlug.equals(categorySlug));
    query.orderBy([OrderingTerm.asc(_db.coffees.name)]);

    final rows = await query.get();
    final coffees = <models.CoffeeSummary>[];
    for (final row in rows) {
      coffees.add(await _toSummary(row.readTable(_db.coffees)));
    }
    return coffees;
  }

  Future<models.CoffeeSummary?> coffeeById(int id) async {
    final row = await (_db.select(_db.coffees)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    return _toSummary(row);
  }

  Future<List<models.BrewMethodSummary>> methodsForCoffee(int coffeeId) async {
    final rows = await (_db.select(_db.brewMethods)
          ..where((t) => t.coffeeId.equals(coffeeId))
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
    return rows
        .map(
          (row) => models.BrewMethodSummary(
            id: row.id,
            coffeeId: row.coffeeId,
            name: row.name,
            categorySlug: row.categorySlug,
            summary: row.summary,
          ),
        )
        .toList();
  }

  Future<models.BrewMethodDetail?> methodDetail(int methodId) async {
    final method = await (_db.select(_db.brewMethods)
          ..where((t) => t.id.equals(methodId)))
        .getSingleOrNull();
    if (method == null) return null;

    final ingredients = await (_db.select(_db.brewIngredients)
          ..where((t) => t.methodId.equals(methodId)))
        .get();
    final steps = await (_db.select(_db.brewSteps)
          ..where((t) => t.methodId.equals(methodId))
          ..orderBy([(t) => OrderingTerm.asc(t.stepOrder)]))
        .get();

    return models.BrewMethodDetail(
      method: models.BrewMethodSummary(
        id: method.id,
        coffeeId: method.coffeeId,
        name: method.name,
        categorySlug: method.categorySlug,
        summary: method.summary,
      ),
      ingredients: ingredients
          .map((i) => models.BrewIngredient(label: i.label, amount: i.amount))
          .toList(),
      steps: steps
          .map(
            (s) => models.BrewStep(
              order: s.stepOrder,
              title: s.title,
              body: s.body,
              imagePath: s.imagePath,
            ),
          )
          .toList(),
    );
  }

  Future<void> setCoffeeHeroOverride({
    required int coffeeId,
    required String localPath,
  }) async {
    final existing = await (_db.select(_db.imageOverrides)
          ..where(
            (t) =>
                t.slot.equals(ImageSlot.coffeeHero.name) &
                t.entityType.equals('coffee') &
                t.entityId.equals(coffeeId),
          ))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.imageOverrides).insert(
            ImageOverridesCompanion.insert(
              slot: ImageSlot.coffeeHero.name,
              entityType: 'coffee',
              entityId: coffeeId,
              localPath: localPath,
            ),
          );
    } else {
      await (_db.update(_db.imageOverrides)..where((t) => t.id.equals(existing.id)))
          .write(ImageOverridesCompanion(localPath: Value(localPath)));
    }
  }

  Future<String?> _heroOverride(int coffeeId) async {
    final row = await (_db.select(_db.imageOverrides)
          ..where(
            (t) =>
                t.slot.equals(ImageSlot.coffeeHero.name) &
                t.entityType.equals('coffee') &
                t.entityId.equals(coffeeId),
          ))
        .getSingleOrNull();
    return row?.localPath;
  }

  Future<bool> isFavorite(int coffeeId) async {
    final row = await (_db.select(_db.favorites)
          ..where((t) => t.coffeeId.equals(coffeeId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> setFavorite(int coffeeId, bool favorite) async {
    if (favorite) {
      await _db.into(_db.favorites).insertOnConflictUpdate(
            FavoritesCompanion.insert(
              coffeeId: Value(coffeeId),
              createdAt: DateTime.now(),
            ),
          );
    } else {
      await (_db.delete(_db.favorites)..where((t) => t.coffeeId.equals(coffeeId)))
          .go();
    }
  }

  Future<List<models.CoffeeSummary>> favoriteCoffees() async {
    final query = _db.select(_db.coffees).join([
      innerJoin(
        _db.favorites,
        _db.favorites.coffeeId.equalsExp(_db.coffees.id),
      ),
    ]);
    query.orderBy([OrderingTerm.desc(_db.favorites.createdAt)]);
    final rows = await query.get();
    final coffees = <models.CoffeeSummary>[];
    for (final row in rows) {
      coffees.add(await _toSummary(row.readTable(_db.coffees)));
    }
    return coffees;
  }

  Future<models.CoffeeSummary> _toSummary(Coffee row) async {
    final notes = await (_db.select(_db.flavorNotes)
          ..where((t) => t.coffeeId.equals(row.id)))
        .get();
    final categories = await (_db.select(_db.coffeeCategoryLinks)
          ..where((t) => t.coffeeId.equals(row.id)))
        .get();
    final methods = await (_db.select(_db.brewMethods)
          ..where((t) => t.coffeeId.equals(row.id)))
        .get();
    final override = await _heroOverride(row.id);
    final favorite = await isFavorite(row.id);

    return models.CoffeeSummary(
      id: row.id,
      name: row.name,
      region: row.region,
      roastLevel: row.roastLevel,
      heroImagePath: override ?? row.heroImagePath,
      flavorNotes: notes.map((n) => n.note).toList(),
      categorySlugs: categories.map((c) => c.categorySlug).toList(),
      methodIds: methods.map((m) => m.id).toList(),
      isFavorite: favorite,
      description: row.description,
    );
  }
}
