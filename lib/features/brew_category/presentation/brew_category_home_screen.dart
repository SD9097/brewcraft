import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/brew_category.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/adaptive_scaffold.dart';

class BrewCategoryHomeScreen extends StatelessWidget {
  const BrewCategoryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = pagePaddingFor(context);
    final columns = screenSizeOf(context) == ScreenSize.mobile ? 2 : 3;

    return AdaptiveScaffold(
      title: 'BrewCraft',
      actions: [
        IconButton(
          tooltip: 'My recipes',
          onPressed: () => context.push('/my-recipes'),
          icon: const Icon(Icons.menu_book_outlined),
        ),
      ],
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How are you brewing today?',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Choose a method to see matching coffees, guides, and tips.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio:
                    screenSizeOf(context) == ScreenSize.mobile ? 0.95 : 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final category = brewCategories[index];
                  return _BrewCategoryCard(
                    category: category,
                    onTap: () => context.push('/explore/${category.slug}'),
                  );
                },
                childCount: brewCategories.length,
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}

class _BrewCategoryCard extends StatelessWidget {
  const _BrewCategoryCard({required this.category, required this.onTap});

  final BrewCategory category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLowest,
      elevation: 1,
      shadowColor: const Color(0x0D231710),
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: category.color.withValues(alpha: 0.15),
                child: Icon(category.icon, color: category.color),
              ),
              const Spacer(),
              Text(
                category.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                category.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
