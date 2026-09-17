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
    AppMeta,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(connectExecutor());

  @override
  int get schemaVersion => 1;
}
