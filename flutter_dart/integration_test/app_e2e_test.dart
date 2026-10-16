import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buddy_flutter/main.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('E2E integration test on device/emulator', (WidgetTester tester) async {
    await tester.pumpWidget(const BuddyApp());
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Buddy'), findsWidgets);
  });
}
