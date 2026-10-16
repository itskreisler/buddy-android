import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buddy_flutter/main.dart';
import 'package:buddy_flutter/services/app_state.dart';
import 'package:buddy_flutter/models/chat.dart';
import 'package:buddy_flutter/l10n/app_localizations.dart';

void main() {
  group('Comprehensive Realistic Flutter E2E User Flow Tests', () {
    testWidgets('Full User Workflow: Chats, Models, Approvals, Terminal, Settings & Permissions', (WidgetTester tester) async {
      await tester.pumpWidget(const BuddyApp());
      await tester.pumpAndSettle();

      // 1. Verify Home & Tabs
      expect(find.text('Buddy'), findsWidgets);
      expect(find.text('Chats'), findsWidgets);

      // 2. Create a new chat with OpenCode free models
      await tester.tap(find.byIcon(Icons.add_comment_outlined));
      await tester.pumpAndSettle();

      expect(find.text('OpenCode'), findsOneWidget);
      await tester.tap(find.text('OpenCode'));
      await tester.pumpAndSettle();

      // Send a realistic prompt
      await tester.enterText(find.byType(TextField), 'Check my calendar and reply to Sam that I am running late');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(find.text('Check my calendar and reply to Sam that I am running late'), findsOneWidget);

      // Wait for agent reply
      await tester.pump(const Duration(milliseconds: 700));
      await tester.pumpAndSettle();
      expect(find.textContaining('Operating task completed'), findsOneWidget);

      // 3. Test Model Picker Chip
      await tester.tap(find.byIcon(Icons.arrow_drop_down));
      await tester.pumpAndSettle();

      expect(find.text('Qwen 2.5 Coder (Free)'), findsOneWidget);
      await tester.tap(find.text('DeepSeek R1 (Free)'));
      await tester.pumpAndSettle();

      // 4. Test Voice Recording Bar
      await tester.tap(find.byIcon(Icons.mic));
      await tester.pumpAndSettle();

      expect(find.text('Listening...'), findsOneWidget);
      await tester.tap(find.byIcon(Icons.close));
      await tester.pumpAndSettle();

      expect(find.text('Listening...'), findsNothing);

      // Go back to Home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // 5. Test Sessions & Terminal Screen
      await tester.tap(find.byIcon(Icons.memory_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Session ID: ses-101'), findsOneWidget);

      // Open Terminal
      await tester.tap(find.byIcon(Icons.terminal));
      await tester.pumpAndSettle();

      expect(find.text('Terminal'), findsOneWidget);
      expect(find.textContaining('Buddy Linux Environment'), findsOneWidget);

      // Run terminal commands
      await tester.enterText(find.byType(TextField), 'help');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      expect(find.textContaining('Available commands'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'clear');
      await tester.tap(find.byIcon(Icons.send));
      await tester.pumpAndSettle();

      // Exit Terminal
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Stop Active Session
      await tester.tap(find.byIcon(Icons.stop_circle));
      await tester.pumpAndSettle();

      expect(find.text('No active sessions'), findsOneWidget);

      // 6. Test Settings & App Permissions
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Setup Guide'), findsOneWidget);
      expect(find.text('Agents'), findsOneWidget);

      // Switch Voice Engine to ChatGPT Voice
      final chatGptVoiceFinder = find.text('ChatGPT Voice');
      await tester.scrollUntilVisible(chatGptVoiceFinder, 200, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();

      await tester.tap(chatGptVoiceFinder);
      await tester.pumpAndSettle();

      // Open App Permissions Screen
      final appPermissionsFinder = find.text('App Permissions');
      await tester.scrollUntilVisible(appPermissionsFinder, 200, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();

      await tester.tap(appPermissionsFinder);
      await tester.pumpAndSettle();

      expect(find.text('WhatsApp'), findsOneWidget);
      expect(find.text('Amazon'), findsOneWidget);

      // Change WhatsApp safety rule
      await tester.tap(find.text('Hard limit').first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trust').last);
      await tester.pumpAndSettle();

      // Return to Settings
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // Toggle Developer Mode
      final devModeFinder = find.text('Developer Mode');
      await tester.scrollUntilVisible(devModeFinder, 200, scrollable: find.byType(Scrollable).first);
      await tester.pumpAndSettle();

      await tester.tap(devModeFinder);
      await tester.pumpAndSettle();
    });

    testWidgets('Spanish i18n Real User Flow Verification', (WidgetTester tester) async {
      final appState = AppState();

      // Inject approval message
      appState.addMessage(
        'chat-1',
        Message(
          id: 'approval-1',
          kind: MessageKind.approval,
          text: 'Buy Nintendo Switch 2 on Amazon for \$399.99',
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('es'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [Locale('en'), Locale('es')],
          home: MainNavigation(appState: appState),
        ),
      );
      await tester.pumpAndSettle();

      // Verify Spanish localized tab labels
      expect(find.text('Chats'), findsWidgets);
      expect(find.text('Sesiones'), findsOneWidget);
      expect(find.text('Ajustes'), findsOneWidget);

      // Open chat and check Spanish approval action buttons
      await tester.tap(find.text('Welcome & System Setup'));
      await tester.pumpAndSettle();

      expect(find.text('Aprobar'), findsOneWidget);
      expect(find.text('Denegar'), findsOneWidget);

      // Tap Aprobar
      await tester.tap(find.text('Aprobar'));
      await tester.pumpAndSettle();
    });
  });
}
