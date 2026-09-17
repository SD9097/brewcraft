import 'package:flutter/material.dart';

import 'router.dart';
import 'theme/app_theme.dart';

class BrewCraftApp extends StatelessWidget {
  const BrewCraftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BrewCraft',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: appRouter,
    );
  }
}
