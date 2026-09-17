import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:brewcraft/app/app.dart';

void main() {
  testWidgets('Home screen loads brew categories', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: BrewCraftApp()));
    await tester.pumpAndSettle();

    expect(find.text('How are you brewing today?'), findsOneWidget);
  });
}
