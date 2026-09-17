import 'package:drift/drift.dart';

import '../../core/models/coffee.dart' as models;
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

    return models.CoffeeSummary(
      id: row.id,
      name: row.name,
      region: row.region,
      roastLevel: row.roastLevel,
      heroImagePath: row.heroImagePath,
      flavorNotes: notes.map((n) => n.note).toList(),
      categorySlugs: categories.map((c) => c.categorySlug).toList(),
      methodIds: methods.map((m) => m.id).toList(),
    );
  }
}
