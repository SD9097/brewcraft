import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/services.dart';

import '../local/app_database.dart';

class SeedLoader {
  static const _seedVersionKey = 'seed_version';

  static Future<void> ensureSeeded(AppDatabase db) async {
    final meta = await (db.select(db.appMeta)
          ..where((t) => t.key.equals(_seedVersionKey)))
        .getSingleOrNull();

    final asset = await rootBundle.loadString('assets/seed/coffees.json');
    final json = jsonDecode(asset) as Map<String, dynamic>;
    final targetVersion = (json['version'] as num).toInt();

    if (meta != null && int.parse(meta.value) >= targetVersion) {
      return;
    }

    await db.transaction(() async {
      await db.delete(db.brewIngredients).go();
      await db.delete(db.brewSteps).go();
      await db.delete(db.brewMethods).go();
      await db.delete(db.flavorNotes).go();
      await db.delete(db.coffeeCategoryLinks).go();
      await db.delete(db.coffees).go();

      final coffees = (json['coffees'] as List<dynamic>).cast<Map<String, dynamic>>();
      for (final coffee in coffees) {
        await db.into(db.coffees).insert(
              CoffeesCompanion.insert(
                id: Value(coffee['id'] as int),
                name: coffee['name'] as String,
                region: coffee['region'] as String,
                roastLevel: coffee['roastLevel'] as String,
                heroImagePath: Value(coffee['heroImagePath'] as String?),
                description: Value(coffee['description'] as String?),
              ),
            );

        for (final slug in (coffee['categorySlugs'] as List<dynamic>)) {
          await db.into(db.coffeeCategoryLinks).insert(
                CoffeeCategoryLinksCompanion.insert(
                  coffeeId: coffee['id'] as int,
                  categorySlug: slug as String,
                ),
              );
        }

        for (final note in (coffee['flavorNotes'] as List<dynamic>)) {
          await db.into(db.flavorNotes).insert(
                FlavorNotesCompanion.insert(
                  coffeeId: coffee['id'] as int,
                  note: note as String,
                ),
              );
        }

        for (final method in (coffee['methods'] as List<dynamic>)) {
          final methodMap = method as Map<String, dynamic>;
          await db.into(db.brewMethods).insert(
                BrewMethodsCompanion.insert(
                  id: Value(methodMap['id'] as int),
                  coffeeId: coffee['id'] as int,
                  name: methodMap['name'] as String,
                  categorySlug: methodMap['categorySlug'] as String,
                  summary: Value(methodMap['summary'] as String?),
                ),
              );

          for (final ingredient in (methodMap['ingredients'] as List<dynamic>)) {
            final ing = ingredient as Map<String, dynamic>;
            await db.into(db.brewIngredients).insert(
                  BrewIngredientsCompanion.insert(
                    methodId: methodMap['id'] as int,
                    label: ing['label'] as String,
                    amount: ing['amount'] as String,
                  ),
                );
          }

          for (final step in (methodMap['steps'] as List<dynamic>)) {
            final stepMap = step as Map<String, dynamic>;
            await db.into(db.brewSteps).insert(
                  BrewStepsCompanion.insert(
                    methodId: methodMap['id'] as int,
                    stepOrder: stepMap['order'] as int,
                    title: stepMap['title'] as String,
                    body: stepMap['body'] as String,
                    imagePath: Value(stepMap['imagePath'] as String?),
                  ),
                );
          }
        }
      }

      await db.into(db.appMeta).insertOnConflictUpdate(
            AppMetaCompanion.insert(
              key: _seedVersionKey,
              value: targetVersion.toString(),
            ),
          );
    });
  }
}
