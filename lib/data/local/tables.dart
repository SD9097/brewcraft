import 'package:drift/drift.dart';

class Coffees extends Table {
  IntColumn get id => integer()();
  TextColumn get name => text()();
  TextColumn get region => text()();
  TextColumn get roastLevel => text()();
  TextColumn get heroImagePath => text().nullable()();
  TextColumn get description => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class CoffeeCategoryLinks extends Table {
  IntColumn get coffeeId => integer().references(Coffees, #id)();
  TextColumn get categorySlug => text()();

  @override
  Set<Column<Object>> get primaryKey => {coffeeId, categorySlug};
}

class FlavorNotes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get coffeeId => integer().references(Coffees, #id)();
  TextColumn get note => text()();
}

class BrewMethods extends Table {
  IntColumn get id => integer()();
  IntColumn get coffeeId => integer().references(Coffees, #id)();
  TextColumn get name => text()();
  TextColumn get categorySlug => text()();
  TextColumn get summary => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

class BrewSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get methodId => integer().references(BrewMethods, #id)();
  IntColumn get stepOrder => integer()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get imagePath => text().nullable()();
}

class BrewIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get methodId => integer().references(BrewMethods, #id)();
  TextColumn get label => text()();
  TextColumn get amount => text()();
}

class ImageOverrides extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get slot => text()();
  TextColumn get entityType => text()();
  IntColumn get entityId => integer()();
  TextColumn get localPath => text()();
}

class UserRecipes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get coffeeId => integer().nullable().references(Coffees, #id)();
  IntColumn get forkedFromMethodId => integer().nullable()();
  TextColumn get categorySlug => text().nullable()();
  TextColumn get notes => text().nullable()();
  TextColumn get coverImagePath => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

class UserRecipeIngredients extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(UserRecipes, #id)();
  TextColumn get label => text()();
  TextColumn get amount => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}

class UserRecipeSteps extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get recipeId => integer().references(UserRecipes, #id)();
  IntColumn get stepOrder => integer()();
  TextColumn get title => text()();
  TextColumn get body => text()();
  TextColumn get imagePath => text().nullable()();
}

class AppMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}
