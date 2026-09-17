import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/coffee.dart';
import '../../../core/models/recipe.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../../data/providers/database_providers.dart';

class PreparationGuideScreen extends ConsumerWidget {
  const PreparationGuideScreen({
    super.key,
    required this.coffeeId,
    required this.methodId,
  });

  final int coffeeId;
  final int methodId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detailAsync = ref.watch(brewMethodDetailProvider(methodId));
    final coffeeAsync = ref.watch(coffeeByIdProvider(coffeeId));

    return detailAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Could not load brew guide: $error')),
      ),
      data: (detail) {
        if (detail == null) {
          return const Scaffold(body: Center(child: Text('Brew method not found')));
        }

        final coffeeName = coffeeAsync.value?.name ?? 'Coffee';

        return AdaptiveScaffold(
          title: detail.method.name,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                coffeeName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              if (detail.method.summary != null) ...[
                const SizedBox(height: 8),
                Text(detail.method.summary!),
              ],
              const SizedBox(height: 16),
              FilledButton.tonalIcon(
                onPressed: () => _forkRecipe(context, ref, coffeeName, detail),
                icon: const Icon(Icons.edit_note),
                label: const Text('Customize as my recipe'),
              ),
              const SizedBox(height: 24),
              Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...detail.ingredients.map(
                (ingredient) => ListTile(
                  dense: true,
                  title: Text(ingredient.label),
                  trailing: Text(ingredient.amount),
                ),
              ),
              const SizedBox(height: 24),
              Text('Steps', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 8),
              ...detail.steps.map(
                (step) => Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 14,
                              child: Text('${step.order}'),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                step.title,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(step.body),
                        if (step.imagePath != null) ...[
                          const SizedBox(height: 12),
                          HybridImage(
                            path: step.imagePath,
                            height: 160,
                            width: double.infinity,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _forkRecipe(
    BuildContext context,
    WidgetRef ref,
    String coffeeName,
    BrewMethodDetail detail,
  ) async {
    final repo = await ref.read(recipeRepositoryProvider.future);
    final id = await repo.saveRecipe(
      RecipeSaveInput(
        name: '$coffeeName · ${detail.method.name}',
        coffeeId: coffeeId,
        forkedFromMethodId: methodId,
        categorySlug: detail.method.categorySlug,
        notes: detail.method.summary,
        ingredients: [
          for (final i in detail.ingredients)
            RecipeDraftIngredient(label: i.label, amount: i.amount),
        ],
        steps: [
          for (final s in detail.steps)
            RecipeDraftStep(
              title: s.title,
              body: s.body,
              imagePath: s.imagePath,
            ),
        ],
      ),
    );
    ref.invalidate(recipesProvider);
    if (context.mounted) {
      context.push('/recipes/$id/edit');
    }
  }
}
