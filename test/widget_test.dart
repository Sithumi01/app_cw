// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:water_tank_app/main.dart';

void main() {
  testWidgets('App shows Dashboard app bar', (WidgetTester tester) async {
    // Build the app and settle animations.
    await tester.pumpWidget(const WaterTankApp());
    await tester.pumpAndSettle();

  // Verify the Dashboard screen is shown.
  // There may be multiple Text widgets with the same label (app bar / semantics), so assert at least one exists.
  expect(find.text('Dashboard'), findsWidgets);
  });
}
