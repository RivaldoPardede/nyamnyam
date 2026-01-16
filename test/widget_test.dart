import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyamnyam/main.dart';

void main() {
  testWidgets(
    'App should render home page with bottom navigation bar',
    (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const NyamNyamApp());

      // Verify that the app title is displayed (in SliverAppBar)
      expect(find.text('NyamNyam'), findsOneWidget);

      // Verify Bottom Navigation Bar icons exist
      // Home is selected by default, so it uses the filled icon
      expect(find.byIcon(Icons.home), findsOneWidget);

      // Others are unselected, so they use outlined icons
      expect(find.byIcon(Icons.search_outlined), findsOneWidget);
      expect(find.byIcon(Icons.favorite_outline), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);

      // Verify "Let's find your favorite food!" header text exists
      expect(find.textContaining("Let's find your"), findsOneWidget);
    },
  );
}
