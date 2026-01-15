import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nyamnyam/main.dart';

void main() {
  testWidgets('App should render restaurant list page with search and refresh',
      (WidgetTester tester) async {
    await tester.pumpWidget(const NyamNyamApp());

    // Verify that the app title is displayed in AppBar
    expect(find.text('NyamNyam'), findsOneWidget);

    // Verify search button exists
    expect(find.byIcon(Icons.search), findsOneWidget);

    // Verify refresh button exists
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });
}
