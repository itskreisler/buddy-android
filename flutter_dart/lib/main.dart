import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'services/app_state.dart';
import 'screens/chats_screen.dart';
import 'screens/sessions_screen.dart';
import 'screens/settings_screen.dart';

void main() {
  runApp(const BuddyApp());
}

class BuddyApp extends StatefulWidget {
  const BuddyApp({super.key});

  @override
  State<BuddyApp> createState() => _BuddyAppState();
}

class _BuddyAppState extends State<BuddyApp> {
  final AppState _appState = AppState();

  @override
  void initState() {
    super.initState();
    _appState.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeMode mode;
    switch (_appState.themeMode) {
      case 'light':
        mode = ThemeMode.light;
        break;
      case 'dark':
        mode = ThemeMode.dark;
        break;
      case 'system':
      default:
        mode = ThemeMode.system;
    }

    return MaterialApp(
      title: 'Buddy',
      debugShowCheckedModeBanner: false,
      locale: _appState.locale,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepOrange,
        brightness: Brightness.dark,
      ),
      themeMode: mode,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('es', ''),
      ],
      home: MainNavigation(appState: _appState),
    );
  }
}

class MainNavigation extends StatefulWidget {
  final AppState appState;

  const MainNavigation({super.key, required this.appState});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    final pages = [
      ChatsScreen(appState: widget.appState),
      SessionsScreen(appState: widget.appState),
      SettingsScreen(appState: widget.appState),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() => _currentIndex = idx);
        },
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.chat_bubble_outline),
            selectedIcon: const Icon(Icons.chat_bubble),
            label: loc.tabChats,
          ),
          NavigationDestination(
            icon: const Icon(Icons.memory_outlined),
            selectedIcon: const Icon(Icons.memory),
            label: loc.tabSessions,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: loc.tabSettings,
          ),
        ],
      ),
    );
  }
}
