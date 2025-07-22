import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lit_eracy/main.dart';

void main() {
  testWidgets('App starts at login page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the login page is displayed.
    expect(find.text('Login'), findsOneWidget);
  });
}
