import 'package:flutter_test/flutter_test.dart';
import 'package:nyamnyam/main.dart';

void main() {
  testWidgets('App should render placeholder home page', (WidgetTester tester) async {
    await tester.pumpWidget(const NyamNyamApp());

    // Verify that the app title is displayed
    expect(find.text('NyamNyam'), findsOneWidget);
    expect(find.text('Welcome to NyamNyam!'), findsOneWidget);
  });
}
