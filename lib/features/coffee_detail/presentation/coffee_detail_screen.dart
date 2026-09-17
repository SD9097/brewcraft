import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/user_image_service.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../seed/seed_coffees.dart';

class CoffeeDetailScreen extends StatelessWidget {
  const CoffeeDetailScreen({super.key, required this.coffeeId});

  final int coffeeId;

  @override
  Widget build(BuildContext context) {
    final coffee = seedCoffeeById(coffeeId);
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
                  onPressed: () => _changePhoto(context),
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
            children: coffee.flavorNotes.map((n) => Chip(label: Text(n))).toList(),
          ),
          const SizedBox(height: 24),
          Text('Brew methods', style: Theme.of(context).textTheme.titleLarge),
          ...coffee.methodIds.map(
            (methodId) => Card(
              child: ListTile(
                title: Text('Method #$methodId'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.push('/coffee/$coffeeId/brew/$methodId'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _changePhoto(BuildContext context) async {
    final path = await UserImageService().pickAndSave(
      slot: ImageSlot.coffeeHero,
      entityId: coffeeId,
    );
    if (path != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Photo saved locally.')),
      );
    }
  }
}
