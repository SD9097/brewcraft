import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/brew_category.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../seed/seed_coffees.dart';

class CoffeeListScreen extends StatelessWidget {
  const CoffeeListScreen({super.key, required this.categorySlug});

  final String categorySlug;

  @override
  Widget build(BuildContext context) {
    final category = brewCategoryBySlug(categorySlug);
    final coffees = seedCoffeesForCategory(categorySlug);
    final padding = pagePaddingFor(context);
    final columns = gridColumnsFor(context);

    return AdaptiveScaffold(
      title: category?.name ?? 'Explore',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.go('/'),
      ),
      body: coffees.isEmpty
          ? const Center(child: Text('No coffees for this brew method yet.'))
          : GridView.builder(
              padding: EdgeInsets.all(padding),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemCount: coffees.length,
              itemBuilder: (context, index) {
                final coffee = coffees[index];
                return Card(
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () => context.push('/coffee/${coffee.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HybridImage(
                          path: coffee.heroImagePath,
                          height: 140,
                          width: double.infinity,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(24),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                coffee.name,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              Text(
                                coffee.region,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
