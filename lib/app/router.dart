import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/brew_category/presentation/brew_category_home_screen.dart';
import '../features/coffee_detail/presentation/coffee_detail_screen.dart';
import '../features/coffee_list/presentation/coffee_list_screen.dart';
import '../features/my_recipes/presentation/my_recipes_screen.dart';
import '../features/preparation/presentation/preparation_guide_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const BrewCategoryHomeScreen(),
    ),
    GoRoute(
      path: '/explore/:categorySlug',
      name: 'explore',
      builder: (context, state) {
        final slug = state.pathParameters['categorySlug']!;
        return CoffeeListScreen(categorySlug: slug);
      },
    ),
    GoRoute(
      path: '/coffee/:id',
      name: 'coffee-detail',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return CoffeeDetailScreen(coffeeId: id);
      },
    ),
    GoRoute(
      path: '/coffee/:coffeeId/brew/:methodId',
      name: 'brew-guide',
      builder: (context, state) {
        final coffeeId = int.parse(state.pathParameters['coffeeId']!);
        final methodId = int.parse(state.pathParameters['methodId']!);
        return PreparationGuideScreen(
          coffeeId: coffeeId,
          methodId: methodId,
        );
      },
    ),
    GoRoute(
      path: '/my-recipes',
      name: 'my-recipes',
      builder: (context, state) => const MyRecipesScreen(),
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(child: Text('Page not found: ${state.uri}')),
  ),
);
