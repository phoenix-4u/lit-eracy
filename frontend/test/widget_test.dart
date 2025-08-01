import 'package:flutter_test/flutter_test.dart';
import 'package:lit_eracy/main.dart';
import 'package:lit_eracy/presentation/pages/login_page.dart';

void main() {
  testWidgets('App starts with LoginPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that LoginPage is displayed.
    expect(find.byType(LoginPage), findsOneWidget);
  });
}
