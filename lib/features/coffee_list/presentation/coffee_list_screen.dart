import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/brew_category.dart';
import '../../../core/models/coffee.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../../data/providers/database_providers.dart';

class CoffeeListScreen extends ConsumerWidget {
  const CoffeeListScreen({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = brewCategoryBySlug(categorySlug);
    final coffeesAsync = ref.watch(coffeesForCategoryProvider(categorySlug));
    final padding = pagePaddingFor(context);
    final columns = gridColumnsFor(context);

    return AdaptiveScaffold(
      title: category?.name ?? 'Explore',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/'),
      ),
      body: coffeesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => EmptyState(
          icon: Icons.error_outline,
          title: 'Could not load coffees',
          message: '$error',
          actionLabel: 'Retry',
          onAction: () => ref.invalidate(coffeesForCategoryProvider(categorySlug)),
        ),
        data: (coffees) => coffees.isEmpty
            ? EmptyState(
                icon: Icons.coffee_outlined,
                title: 'No coffees yet',
                message: 'Nothing is linked to this brew method in the seed data.',
                actionLabel: 'Back home',
                onAction: () => context.go('/'),
              )
            : GridView.builder(
                padding: EdgeInsets.all(padding),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.68,
                ),
                itemCount: coffees.length,
                itemBuilder: (context, index) {
                  final coffee = coffees[index];
                  return _CoffeeCard(
                    coffee: coffee,
                    onOpen: () => context.push('/coffee/${coffee.id}'),
                    onToggleFavorite: () => _toggleFavorite(ref, coffee),
                  );
                },
              ),
      ),
    );
  }

  Future<void> _toggleFavorite(WidgetRef ref, CoffeeSummary coffee) async {
    final repo = await ref.read(coffeeRepositoryProvider.future);
    await repo.setFavorite(coffee.id, !coffee.isFavorite);
    ref.invalidate(coffeesForCategoryProvider(categorySlug));
    ref.invalidate(coffeeByIdProvider(coffee.id));
    ref.invalidate(favoriteCoffeesProvider);
    ref.invalidate(isFavoriteProvider(coffee.id));
  }
}

class _CoffeeCard extends StatelessWidget {
  const _CoffeeCard({
    required this.coffee,
    required this.onOpen,
    required this.onToggleFavorite,
  });

  final CoffeeSummary coffee;
  final VoidCallback onOpen;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onOpen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                HybridImage(
                  path: coffee.heroImagePath,
                  height: 140,
                  width: double.infinity,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      tooltip: coffee.isFavorite ? 'Unfavorite' : 'Favorite',
                      onPressed: onToggleFavorite,
                      icon: Icon(
                        coffee.isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: coffee.isFavorite
                            ? Theme.of(context).colorScheme.secondary
                            : Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coffee.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coffee.region,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                    const Spacer(),
                    if (coffee.flavorNotes.isNotEmpty)
                      Text(
                        coffee.flavorNotes.take(3).join(' · '),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
