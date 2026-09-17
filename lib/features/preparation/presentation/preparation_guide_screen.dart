import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/adaptive_scaffold.dart';

class PreparationGuideScreen extends StatelessWidget {
  const PreparationGuideScreen({
    super.key,
    required this.coffeeId,
    required this.methodId,
  });

  final int coffeeId;
  final int methodId;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      title: 'Brew guide',
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => context.pop(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('Coffee #$coffeeId · Method #$methodId'),
          const SizedBox(height: 24),
          for (var i = 1; i <= 4; i++)
            Card(
              child: ListTile(
                leading: CircleAvatar(child: Text('$i')),
                title: Text('Step $i'),
              ),
            ),
        ],
      ),
    );
  }
}
