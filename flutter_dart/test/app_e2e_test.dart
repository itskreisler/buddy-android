import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buddy_flutter/main.dart';
import 'package:buddy_flutter/services/app_state.dart';
import 'package:buddy_flutter/models/chat.dart';
import 'package:buddy_flutter/l10n/app_localizations.dart';

void main() {
  group('Comprehensive Realistic Flutter E2E User Flow Tests', () {
    testWidgets('Full User Workflow: Chats, Models, Approvals, Terminal, Settings & Language Switching', (WidgetTester tester) async {
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

      // Go back to Home
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // 4. Test Settings & Language Switching to Spanish
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.text('Language / Idioma'), findsOneWidget);

      // Tap Español
      await tester.tap(find.text('Español'));
      await tester.pumpAndSettle();

      // Verify UI dynamically changed to Spanish
      expect(find.text('Guía de configuración'), findsOneWidget);
      expect(find.text('Sesiones'), findsOneWidget);
      expect(find.text('Ajustes'), findsWidgets);

      // Switch back to English
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();

      expect(find.text('Setup Guide'), findsOneWidget);
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
