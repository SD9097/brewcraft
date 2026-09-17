import 'package:flutter/material.dart';

class BrewCategory {
  const BrewCategory({
    required this.slug,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
    this.imagePath,
  });

  final String slug;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
  final String? imagePath;
}

const brewCategories = <BrewCategory>[
  BrewCategory(
    slug: 'filter',
    name: 'Pour-over & Filter',
    subtitle: 'V60, Chemex, Kalita',
    icon: Icons.water_drop_outlined,
    color: Color(0xFFC96E4B),
    imagePath: 'assets/images/steps/brew_pour_over.jpg',
  ),
  BrewCategory(
    slug: 'immersion',
    name: 'Immersion',
    subtitle: 'French press, AeroPress, cold brew',
    icon: Icons.hourglass_bottom_outlined,
    color: Color(0xFF5C3D2E),
    imagePath: 'assets/images/steps/brew_french_press.jpg',
  ),
  BrewCategory(
    slug: 'espresso',
    name: 'Espresso',
    subtitle: 'Espresso, latte, cappuccino',
    icon: Icons.coffee_outlined,
    color: Color(0xFF231710),
    imagePath: 'assets/images/steps/brew_espresso.jpg',
  ),
  BrewCategory(
    slug: 'regional',
    name: 'Regional',
    subtitle: 'South Indian filter, Turkish, phin',
    icon: Icons.public_outlined,
    color: Color(0xFF784B35),
    imagePath: 'assets/images/coffees/turkish_blend.jpg',
  ),
  BrewCategory(
    slug: 'moka',
    name: 'Moka & Stovetop',
    subtitle: 'Moka pot, percolator',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFF8F4E00),
    imagePath: 'assets/images/coffees/sumatra_mandheling.jpg',
  ),
  BrewCategory(
    slug: 'instant',
    name: 'Instant',
    subtitle: 'Classic, iced, whipped styles',
    icon: Icons.bolt_outlined,
    color: Color(0xFFE5A93B),
    imagePath: 'assets/images/coffees/instant_coffee.jpg',
  ),
];

BrewCategory? brewCategoryBySlug(String slug) {
  for (final category in brewCategories) {
    if (category.slug == slug) return category;
  }
  return null;
}
