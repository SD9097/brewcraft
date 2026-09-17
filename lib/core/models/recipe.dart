class RecipeSummary {
  const RecipeSummary({
    required this.id,
    required this.name,
    this.coffeeId,
    this.forkedFromMethodId,
    this.categorySlug,
    this.notes,
    this.coverImagePath,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final int? coffeeId;
  final int? forkedFromMethodId;
  final String? categorySlug;
  final String? notes;
  final String? coverImagePath;
  final DateTime updatedAt;
}

class RecipeDraftIngredient {
  RecipeDraftIngredient({required this.label, required this.amount});

  String label;
  String amount;
}

class RecipeDraftStep {
  RecipeDraftStep({
    required this.title,
    required this.body,
    this.imagePath,
  });

  String title;
  String body;
  String? imagePath;
}

class RecipeDetail {
  const RecipeDetail({
    required this.summary,
    required this.ingredients,
    required this.steps,
  });

  final RecipeSummary summary;
  final List<RecipeDraftIngredient> ingredients;
  final List<RecipeDraftStep> steps;
}

class RecipeSaveInput {
  const RecipeSaveInput({
    this.id,
    required this.name,
    this.coffeeId,
    this.forkedFromMethodId,
    this.categorySlug,
    this.notes,
    this.coverImagePath,
    required this.ingredients,
    required this.steps,
  });

  final int? id;
  final String name;
  final int? coffeeId;
  final int? forkedFromMethodId;
  final String? categorySlug;
  final String? notes;
  final String? coverImagePath;
  final List<RecipeDraftIngredient> ingredients;
  final List<RecipeDraftStep> steps;
}
