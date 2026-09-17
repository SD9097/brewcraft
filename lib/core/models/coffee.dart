class CoffeeSummary {
  const CoffeeSummary({
    required this.id,
    required this.name,
    required this.region,
    required this.roastLevel,
    required this.heroImagePath,
    required this.flavorNotes,
    required this.categorySlugs,
    required this.methodIds,
    this.isFavorite = false,
    this.description,
  });

  final int id;
  final String name;
  final String region;
  final String roastLevel;
  final String? heroImagePath;
  final List<String> flavorNotes;
  final List<String> categorySlugs;
  final List<int> methodIds;
  final bool isFavorite;
  final String? description;

  CoffeeSummary copyWith({bool? isFavorite}) {
    return CoffeeSummary(
      id: id,
      name: name,
      region: region,
      roastLevel: roastLevel,
      heroImagePath: heroImagePath,
      flavorNotes: flavorNotes,
      categorySlugs: categorySlugs,
      methodIds: methodIds,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description,
    );
  }
}

class BrewMethodSummary {
  const BrewMethodSummary({
    required this.id,
    required this.coffeeId,
    required this.name,
    required this.categorySlug,
    this.summary,
  });

  final int id;
  final int coffeeId;
  final String name;
  final String categorySlug;
  final String? summary;
}

class BrewIngredient {
  const BrewIngredient({required this.label, required this.amount});

  final String label;
  final String amount;
}

class BrewStep {
  const BrewStep({
    required this.order,
    required this.title,
    required this.body,
    this.imagePath,
  });

  final int order;
  final String title;
  final String body;
  final String? imagePath;
}

class BrewMethodDetail {
  const BrewMethodDetail({
    required this.method,
    required this.ingredients,
    required this.steps,
  });

  final BrewMethodSummary method;
  final List<BrewIngredient> ingredients;
  final List<BrewStep> steps;
}
