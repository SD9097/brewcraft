import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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
}
