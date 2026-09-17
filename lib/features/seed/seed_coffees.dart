class SeedCoffee {
  const SeedCoffee({
    required this.id,
    required this.name,
    required this.region,
    required this.roastLevel,
    required this.flavorNotes,
    required this.heroImagePath,
    required this.categorySlugs,
    required this.methodIds,
  });

  final int id;
  final String name;
  final String region;
  final String roastLevel;
  final List<String> flavorNotes;
  final String? heroImagePath;
  final List<String> categorySlugs;
  final List<int> methodIds;
}

const _allSeedCoffees = <SeedCoffee>[
  SeedCoffee(
    id: 1,
    name: 'Ethiopian Yirgacheffe',
    region: 'Gedeo Zone, Ethiopia',
    roastLevel: 'Light',
    flavorNotes: ['Jasmine', 'Bergamot', 'Peach'],
    heroImagePath: null,
    categorySlugs: ['filter', 'immersion'],
    methodIds: [101, 102],
  ),
  SeedCoffee(
    id: 2,
    name: 'Colombian Huila Pitalito',
    region: 'Huila, Colombia',
    roastLevel: 'Medium',
    flavorNotes: ['Cacao', 'Toffee', 'Apple'],
    heroImagePath: null,
    categorySlugs: ['filter', 'immersion', 'espresso'],
    methodIds: [201],
  ),
  SeedCoffee(
    id: 3,
    name: 'Indian Monsooned Malabar',
    region: 'Karnataka, India',
    roastLevel: 'Medium',
    flavorNotes: ['Earthy', 'Spice', 'Low acidity'],
    heroImagePath: null,
    categorySlugs: ['regional', 'immersion', 'espresso'],
    methodIds: [301],
  ),
  SeedCoffee(
    id: 4,
    name: 'Sumatra Mandheling',
    region: 'North Sumatra, Indonesia',
    roastLevel: 'Dark',
    flavorNotes: ['Cocoa', 'Licorice', 'Herbal'],
    heroImagePath: null,
    categorySlugs: ['immersion', 'espresso', 'moka'],
    methodIds: [401],
  ),
  SeedCoffee(
    id: 5,
    name: 'Turkish Blend',
    region: 'Anatolia, Turkey',
    roastLevel: 'Dark',
    flavorNotes: ['Cardamom', 'Bold', 'Syrupy'],
    heroImagePath: null,
    categorySlugs: ['regional'],
    methodIds: [501],
  ),
  SeedCoffee(
    id: 6,
    name: 'Everyday Instant Coffee',
    region: 'Global',
    roastLevel: 'Medium',
    flavorNotes: ['Chocolate', 'Nutty'],
    heroImagePath: null,
    categorySlugs: ['instant'],
    methodIds: [601, 602],
  ),
];

List<SeedCoffee> seedCoffeesForCategory(String categorySlug) {
  return _allSeedCoffees.where((c) => c.categorySlugs.contains(categorySlug)).toList();
}

SeedCoffee? seedCoffeeById(int id) {
  for (final coffee in _allSeedCoffees) {
    if (coffee.id == id) return coffee;
  }
  return null;
}
