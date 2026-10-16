import 'package:flutter_test/flutter_test.dart';
import 'package:buddy_flutter/main.dart';

void main() {
  testWidgets('BuddyApp renders bottom navigation and tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const BuddyApp());
    await tester.pump(const Duration(milliseconds: 100));

    // Verify main app title "Buddy" is displayed
    expect(find.text('Buddy'), findsWidgets);

    // Verify bottom navigation tabs exist
    expect(find.text('Chats'), findsWidgets);
    expect(find.text('Sessions'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
