import 'package:drift/drift.dart';

import 'connect.dart';
import 'tables.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Coffees,
    CoffeeCategoryLinks,
    FlavorNotes,
    BrewMethods,
    BrewSteps,
    BrewIngredients,
    ImageOverrides,
    UserRecipes,
    UserRecipeIngredients,
    UserRecipeSteps,
    AppMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connectExecutor());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(userRecipes);
            await m.createTable(userRecipeIngredients);
            await m.createTable(userRecipeSteps);
          }
        },
      );
}
