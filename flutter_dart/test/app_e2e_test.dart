import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buddy_flutter/main.dart';

void main() {
  testWidgets('Full End-To-End User Flow Test for Flutter Buddy App', (WidgetTester tester) async {
    // 1. Launch Buddy App
    await tester.pumpWidget(const BuddyApp());
    await tester.pumpAndSettle();

    // Verify main screen loaded
    expect(find.text('Buddy'), findsWidgets);

    // 2. Test Tab Navigation -> Sessions
    await tester.tap(find.byIcon(Icons.memory_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Session ID: ses-101'), findsOneWidget);

    // 3. Open Terminal Screen
    final terminalButton = find.byIcon(Icons.terminal);
    expect(terminalButton, findsOneWidget);
    await tester.tap(terminalButton);
    await tester.pumpAndSettle();

    expect(find.text('Terminal'), findsOneWidget);
    expect(find.textContaining('Buddy Linux Environment'), findsOneWidget);

    // Enter terminal command
    await tester.enterText(find.byType(TextField), 'help');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.textContaining('Available commands'), findsOneWidget);

    // Close terminal
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // 4. Test Tab Navigation -> Settings
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Setup Guide'), findsOneWidget);
    expect(find.text('Agents'), findsOneWidget);
    expect(find.text('Voice'), findsOneWidget);

    // Scroll down to Developer Mode
    final devModeFinder = find.text('Developer Mode');
    await tester.scrollUntilVisible(devModeFinder, 200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    expect(devModeFinder, findsOneWidget);

    // Toggle Developer Mode
    await tester.tap(devModeFinder);
    await tester.pumpAndSettle();

    // Scroll back up to Setup Guide
    final setupGuideFinder = find.text('Setup Guide');
    await tester.scrollUntilVisible(setupGuideFinder, -200, scrollable: find.byType(Scrollable).first);
    await tester.pumpAndSettle();

    // Open Setup Guide
    await tester.tap(setupGuideFinder);
    await tester.pumpAndSettle();

    expect(find.text('Choose your agent'), findsOneWidget);

    // Back from Setup Guide
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    // 5. Test Tab Navigation -> Chats & Chat Interaction
    await tester.tap(find.byIcon(Icons.chat_bubble_outline));
    await tester.pumpAndSettle();

    // Tap existing chat
    await tester.tap(find.text('Welcome & System Setup'));
    await tester.pumpAndSettle();

    expect(find.text('Hello! I am Buddy. I can help control your phone, manage tasks, and run AI models locally.'), findsOneWidget);

    // Send a message
    await tester.enterText(find.byType(TextField), 'Test E2E message');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    expect(find.text('Test E2E message'), findsOneWidget);

    // Wait for simulated agent response
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
    expect(find.textContaining('Operating task completed'), findsOneWidget);
  });
}
