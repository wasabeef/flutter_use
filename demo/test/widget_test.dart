// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:demo/main.dart';

void main() {
  testWidgets('FlutterUseDemo app test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FlutterUseDemo());

    // Verify that the app starts with the home page
    expect(find.text('Flutter Use - Interactive Demos'), findsOneWidget);
    expect(find.text('Explore React-like hooks for Flutter'), findsOneWidget);
  });
}
