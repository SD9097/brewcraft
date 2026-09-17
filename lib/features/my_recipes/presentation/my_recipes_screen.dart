import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../../data/providers/database_providers.dart';

class MyRecipesScreen extends ConsumerWidget {
  const MyRecipesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recipesAsync = ref.watch(recipesProvider);
    final dateFormat = DateFormat.yMMMd().add_jm();

    return AdaptiveScaffold(
      title: 'My recipes',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.canPop() ? context.pop() : context.go('/'),
      ),
      body: recipesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Could not load recipes: $error')),
        data: (recipes) {
          if (recipes.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No custom recipes yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Fork a brew guide with “Customize as my recipe”, or create one from scratch.',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: () => context.push('/recipes/new'),
                      icon: const Icon(Icons.add),
                      label: const Text('New recipe'),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: recipes.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: FilledButton.icon(
                      onPressed: () => context.push('/recipes/new'),
                      icon: const Icon(Icons.add),
                      label: const Text('New recipe'),
                    ),
                  ),
                );
              }

              final recipe = recipes[index - 1];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: HybridImage(
                      path: recipe.coverImagePath,
                      width: 56,
                      height: 56,
                    ),
                  ),
                  title: Text(recipe.name),
                  subtitle: Text(dateFormat.format(recipe.updatedAt)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/recipes/${recipe.id}/edit'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
