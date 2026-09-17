import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/brew_category.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';

class BrewCategoryHomeScreen extends StatelessWidget {
  const BrewCategoryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = pagePaddingFor(context);
    final columns = screenSizeOf(context) == ScreenSize.mobile ? 2 : 3;

    return AdaptiveScaffold(
      title: 'BrewCraft',
      selectedNavIndex: 0,
      actions: [
        IconButton(
          tooltip: 'Favorites',
          onPressed: () => context.push('/favorites'),
          icon: const Icon(Icons.favorite_outline),
        ),
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
              padding: EdgeInsets.fromLTRB(padding, 8, padding, 20),
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
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio:
                    screenSizeOf(context) == ScreenSize.mobile ? 0.85 : 1.05,
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
      color: Colors.transparent,
      elevation: 2,
      shadowColor: const Color(0x33231710),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (category.imagePath != null)
              HybridImage(
                path: category.imagePath,
                fit: BoxFit.cover,
              )
            else
              ColoredBox(color: category.color.withValues(alpha: 0.25)),
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.05),
                    Colors.black.withValues(alpha: 0.72),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white.withValues(alpha: 0.92),
                    child: Icon(category.icon, color: category.color),
                  ),
                  const Spacer(),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    category.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
