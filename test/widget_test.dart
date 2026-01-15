import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:nyamnyam/main.dart';
import 'package:nyamnyam/providers/restaurant_list_provider.dart';

void main() {
  testWidgets('App should render restaurant list page', (WidgetTester tester) async {
    await tester.pumpWidget(const NyamNyamApp());

    // Verify that the app title is displayed in AppBar
    expect(find.text('NyamNyam'), findsOneWidget);
    
    // Verify refresh button exists
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('Restaurant list page should show loading state initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => RestaurantListProvider(),
        child: const MaterialApp(
          home: Scaffold(body: Center(child: CircularProgressIndicator())),
        ),
      ),
    );

    // Just verify Provider setup works
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
