import 'package:flutter/material.dart';

class BrewCategory {
  const BrewCategory({
    required this.slug,
    required this.name,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  final String slug;
  final String name;
  final String subtitle;
  final IconData icon;
  final Color color;
}

const brewCategories = <BrewCategory>[
  BrewCategory(
    slug: 'filter',
    name: 'Pour-over & Filter',
    subtitle: 'V60, Chemex, Kalita',
    icon: Icons.water_drop_outlined,
    color: Color(0xFFC96E4B),
  ),
  BrewCategory(
    slug: 'immersion',
    name: 'Immersion',
    subtitle: 'French press, AeroPress, cold brew',
    icon: Icons.hourglass_bottom_outlined,
    color: Color(0xFF5C3D2E),
  ),
  BrewCategory(
    slug: 'espresso',
    name: 'Espresso',
    subtitle: 'Espresso, latte, cappuccino',
    icon: Icons.coffee_outlined,
    color: Color(0xFF231710),
  ),
  BrewCategory(
    slug: 'regional',
    name: 'Regional',
    subtitle: 'South Indian filter, Turkish, phin',
    icon: Icons.public_outlined,
    color: Color(0xFF784B35),
  ),
  BrewCategory(
    slug: 'moka',
    name: 'Moka & Stovetop',
    subtitle: 'Moka pot, percolator',
    icon: Icons.local_fire_department_outlined,
    color: Color(0xFF8F4E00),
  ),
  BrewCategory(
    slug: 'instant',
    name: 'Instant',
    subtitle: 'Classic, iced, whipped styles',
    icon: Icons.bolt_outlined,
    color: Color(0xFFE5A93B),
  ),
];

BrewCategory? brewCategoryBySlug(String slug) {
  for (final category in brewCategories) {
    if (category.slug == slug) return category;
  }
  return null;
}
