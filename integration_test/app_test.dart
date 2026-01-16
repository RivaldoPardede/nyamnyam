import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:nyamnyam/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('App navigation and scroll integration test', (
    WidgetTester tester,
  ) async {
    // Start app
    app.main();
    await tester.pumpAndSettle();

    // Verify Home Page loads
    expect(find.text('NyamNyam'), findsOneWidget);
    expect(find.textContaining("Let's find your"), findsOneWidget);

    // Verify List View exists
    expect(find.byType(CustomScrollView), findsOneWidget);

    // Scroll down
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -300));
    await tester.pumpAndSettle();

    // Verify Bottom Navigation exists
    expect(find.byType(NavigationBar), findsOneWidget);

    // Navigate to Favorites
    await tester.tap(find.byIcon(Icons.favorite_outline));
    await tester.pumpAndSettle();

    // Verify Favorites Page
    expect(find.text('Favorites'), findsOneWidget);

    // Navigate back to Home
    await tester.tap(find.byIcon(Icons.home_outlined));
    await tester.pumpAndSettle();
  });
}
