import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/user_image_service.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../../data/providers/database_providers.dart';

class CoffeeDetailScreen extends ConsumerWidget {
  const CoffeeDetailScreen({super.key, required this.coffeeId});

  final int coffeeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coffeeAsync = ref.watch(coffeeByIdProvider(coffeeId));
    final methodsAsync = ref.watch(brewMethodsForCoffeeProvider(coffeeId));

    return coffeeAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, _) => Scaffold(
        body: Center(child: Text('Could not load coffee: $error')),
      ),
      data: (coffee) {
        if (coffee == null) {
          return const Scaffold(body: Center(child: Text('Coffee not found')));
        }

        return AdaptiveScaffold(
          title: coffee.name,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(),
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Stack(
                children: [
                  HybridImage(
                    path: coffee.heroImagePath,
                    height: 220,
                    width: double.infinity,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  Positioned(
                    right: 12,
                    bottom: 12,
                    child: FilledButton.icon(
                      onPressed: () => _changePhoto(context, ref),
                      icon: const Icon(Icons.photo_camera_outlined, size: 18),
                      label: const Text('Change photo'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(coffee.region),
              const SizedBox(height: 8),
              Text('${coffee.roastLevel} roast'),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                children:
                    coffee.flavorNotes.map((n) => Chip(label: Text(n))).toList(),
              ),
              const SizedBox(height: 24),
              Text('Brew methods', style: Theme.of(context).textTheme.titleLarge),
              methodsAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(),
                ),
                error: (error, _) => Text('Could not load methods: $error'),
                data: (methods) => Column(
                  children: methods
                      .map(
                        (method) => Card(
                          child: ListTile(
                            title: Text(method.name),
                            subtitle: method.summary != null
                                ? Text(method.summary!)
                                : null,
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => context.push(
                              '/coffee/$coffeeId/brew/${method.id}',
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _changePhoto(BuildContext context, WidgetRef ref) async {
    final path = await UserImageService().pickAndSave(
      slot: ImageSlot.coffeeHero,
      entityId: coffeeId,
    );
    if (path == null) return;

    final repo = await ref.read(coffeeRepositoryProvider.future);
    await repo.setCoffeeHeroOverride(coffeeId: coffeeId, localPath: path);
    ref.invalidate(coffeeByIdProvider(coffeeId));
    final coffee = await ref.read(coffeeByIdProvider(coffeeId).future);
    for (final slug in coffee?.categorySlugs ?? const <String>[]) {
      ref.invalidate(coffeesForCategoryProvider(slug));
    }

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo saved and will stick after restart.')),
      );
    }
  }
}
