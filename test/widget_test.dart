import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyamnyam/main.dart';

void main() {
  testWidgets(
    'App should render restaurant list page with navigation buttons',
    (WidgetTester tester) async {
      await tester.pumpWidget(const NyamNyamApp());

      // Verify that the app title is displayed in AppBar
      expect(find.text('NyamNyam'), findsOneWidget);

      // Verify search button exists
      expect(find.byIcon(Icons.search), findsOneWidget);

      // Verify favorites button exists
      expect(find.byIcon(Icons.favorite_border), findsOneWidget);

      // Verify settings button exists
      expect(find.byIcon(Icons.settings), findsOneWidget);
    },
  );
}
