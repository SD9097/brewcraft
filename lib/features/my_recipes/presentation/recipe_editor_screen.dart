import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/models/recipe.dart';
import '../../../core/services/user_image_service.dart';
import '../../../core/widgets/adaptive_scaffold.dart';
import '../../../core/widgets/hybrid_image.dart';
import '../../../data/providers/database_providers.dart';

class RecipeEditorScreen extends ConsumerStatefulWidget {
  const RecipeEditorScreen({super.key, this.recipeId});

  final int? recipeId;

  @override
  ConsumerState<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

class _RecipeEditorScreenState extends ConsumerState<RecipeEditorScreen> {
  final _nameController = TextEditingController();
  final _notesController = TextEditingController();
  final _ingredients = <RecipeDraftIngredient>[];
  final _steps = <RecipeDraftStep>[];
  String? _coverPath;
  int? _coffeeId;
  int? _forkedFromMethodId;
  String? _categorySlug;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    if (widget.recipeId == null) {
      _ingredients.add(RecipeDraftIngredient(label: 'Coffee', amount: '15 g'));
      _ingredients.add(RecipeDraftIngredient(label: 'Water', amount: '250 ml'));
      _steps.add(RecipeDraftStep(title: 'Prepare', body: 'Rinse filter and heat water.'));
      _steps.add(RecipeDraftStep(title: 'Brew', body: 'Pour and extract to taste.'));
      setState(() => _loading = false);
      return;
    }

    final detail = await ref.read(recipeByIdProvider(widget.recipeId!).future);
    if (detail == null) {
      setState(() => _loading = false);
      return;
    }

    _nameController.text = detail.summary.name;
    _notesController.text = detail.summary.notes ?? '';
    _coverPath = detail.summary.coverImagePath;
    _coffeeId = detail.summary.coffeeId;
    _forkedFromMethodId = detail.summary.forkedFromMethodId;
    _categorySlug = detail.summary.categorySlug;
    _ingredients.addAll(detail.ingredients);
    _steps.addAll(detail.steps);
    setState(() => _loading = false);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return AdaptiveScaffold(
      title: widget.recipeId == null ? 'New recipe' : 'Edit recipe',
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
                path: _coverPath,
                height: 160,
                width: double.infinity,
                borderRadius: BorderRadius.circular(16),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: FilledButton.tonalIcon(
                  onPressed: _pickCover,
                  icon: const Icon(Icons.photo_camera_outlined, size: 18),
                  label: const Text('Cover'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Recipe name',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notesController,
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Notes',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Text('Ingredients', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(
                  () => _ingredients.add(
                    RecipeDraftIngredient(label: '', amount: ''),
                  ),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          for (var i = 0; i < _ingredients.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      initialValue: _ingredients[i].label,
                      decoration: const InputDecoration(
                        labelText: 'Label',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _ingredients[i].label = v,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextFormField(
                      initialValue: _ingredients[i].amount,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _ingredients[i].amount = v,
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _ingredients.removeAt(i)),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Steps', style: Theme.of(context).textTheme.titleLarge),
              const Spacer(),
              TextButton.icon(
                onPressed: () => setState(
                  () => _steps.add(RecipeDraftStep(title: '', body: '')),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ],
          ),
          for (var i = 0; i < _steps.length; i++)
            Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(radius: 14, child: Text('${i + 1}')),
                        const Spacer(),
                        IconButton(
                          onPressed: () => setState(() => _steps.removeAt(i)),
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    TextFormField(
                      initialValue: _steps[i].title,
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _steps[i].title = v,
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      initialValue: _steps[i].body,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Instructions',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (v) => _steps[i].body = v,
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _saving ? null : _save,
            child: Text(_saving ? 'Saving…' : 'Save recipe'),
          ),
          if (widget.recipeId != null) ...[
            const SizedBox(height: 8),
            TextButton(
              onPressed: _saving ? null : _delete,
              child: const Text('Delete recipe'),
            ),
          ],
        ],
      ),
    );
  }

  Future<void> _pickCover() async {
    final path = await UserImageService().pickAndSave(
      slot: ImageSlot.recipeCover,
      entityId: widget.recipeId ?? 0,
    );
    if (path != null) setState(() => _coverPath = path);
  }

  Future<void> _save() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Give your recipe a name.')),
      );
      return;
    }

    setState(() => _saving = true);
    final repo = await ref.read(recipeRepositoryProvider.future);
    final id = await repo.saveRecipe(
      RecipeSaveInput(
        id: widget.recipeId,
        name: name,
        coffeeId: _coffeeId,
        forkedFromMethodId: _forkedFromMethodId,
        categorySlug: _categorySlug,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        coverImagePath: _coverPath,
        ingredients: _ingredients
            .where((i) => i.label.trim().isNotEmpty || i.amount.trim().isNotEmpty)
            .toList(),
        steps: _steps
            .where((s) => s.title.trim().isNotEmpty || s.body.trim().isNotEmpty)
            .toList(),
      ),
    );
    ref.invalidate(recipesProvider);
    ref.invalidate(recipeByIdProvider(id));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe saved.')),
      );
      context.go('/my-recipes');
    }
  }

  Future<void> _delete() async {
    final id = widget.recipeId;
    if (id == null) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete recipe?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _saving = true);
    final repo = await ref.read(recipeRepositoryProvider.future);
    await repo.deleteRecipe(id);
    ref.invalidate(recipesProvider);
    if (mounted) context.go('/my-recipes');
  }
}
