import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../l10n/app_localizations.dart';
import 'onboarding_screen.dart';
import 'app_permissions_screen.dart';

class SettingsScreen extends StatelessWidget {
  final AppState appState;

  const SettingsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    String currentLangCode = appState.locale?.languageCode ?? 'system';

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.settingsTitle),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.handshake_outlined, color: Colors.blue),
            title: Text(loc.setupGuide),
            subtitle: const Text('Open step-by-step setup onboarding'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const OnboardingScreen()),
              );
            },
          ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text('Language / Idioma', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            title: const Text('System Default'),
            leading: Radio<String>(
              value: 'system',
              // ignore: deprecated_member_use
              groupValue: currentLangCode,
              // ignore: deprecated_member_use
              onChanged: (_) => appState.setLocale(null),
            ),
            onTap: () => appState.setLocale(null),
          ),
          ListTile(
            title: const Text('English'),
            leading: Radio<String>(
              value: 'en',
              // ignore: deprecated_member_use
              groupValue: currentLangCode,
              // ignore: deprecated_member_use
              onChanged: (_) => appState.setLocale(const Locale('en')),
            ),
            onTap: () => appState.setLocale(const Locale('en')),
          ),
          ListTile(
            title: const Text('Español'),
            leading: Radio<String>(
              value: 'es',
              // ignore: deprecated_member_use
              groupValue: currentLangCode,
              // ignore: deprecated_member_use
              onChanged: (_) => appState.setLocale(const Locale('es')),
            ),
            onTap: () => appState.setLocale(const Locale('es')),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(loc.agentsTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            title: const Text('Claude Code'),
            subtitle: Text(appState.agentClaudeStatus),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          ListTile(
            title: const Text('Codex'),
            subtitle: Text(appState.agentCodexStatus),
            trailing: OutlinedButton(
              onPressed: () {},
              child: const Text('Sign in'),
            ),
          ),
          ListTile(
            title: const Text('OpenCode'),
            subtitle: Text(appState.agentOpenCodeStatus),
            trailing: const Icon(Icons.check_circle, color: Colors.green),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(loc.voiceTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          ListTile(
            title: const Text('Phone Recognizer'),
            subtitle: const Text('Android built-in speech engine'),
            leading: Radio<String>(
              value: 'phone',
              // ignore: deprecated_member_use
              groupValue: appState.voiceEngine,
              // ignore: deprecated_member_use
              onChanged: (val) => appState.setVoiceEngine(val!),
            ),
            onTap: () => appState.setVoiceEngine('phone'),
          ),
          ListTile(
            title: const Text('Claude Dictation'),
            subtitle: const Text('Anthropic voice dictation'),
            leading: Radio<String>(
              value: 'claude',
              // ignore: deprecated_member_use
              groupValue: appState.voiceEngine,
              // ignore: deprecated_member_use
              onChanged: (val) => appState.setVoiceEngine(val!),
            ),
            onTap: () => appState.setVoiceEngine('claude'),
          ),
          ListTile(
            title: const Text('ChatGPT Voice'),
            subtitle: const Text('OpenAI Whisper & ChatGPT voices'),
            leading: Radio<String>(
              value: 'chatgpt',
              // ignore: deprecated_member_use
              groupValue: appState.voiceEngine,
              // ignore: deprecated_member_use
              onChanged: (val) => appState.setVoiceEngine(val!),
            ),
            onTap: () => appState.setVoiceEngine('chatgpt'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(loc.bubbleTitle, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          SwitchListTile(
            title: const Text('Floating Bubble'),
            subtitle: const Text('Show floating bubble over other apps'),
            value: appState.bubbleEnabled,
            onChanged: (val) => appState.toggleBubble(val),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.security),
            title: Text(loc.appPermissionsTitle),
            subtitle: const Text('Hard limits & trust settings per app'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AppPermissionsScreen()),
              );
            },
          ),
          SwitchListTile(
            secondary: const Icon(Icons.developer_mode),
            title: Text(loc.developerModeTitle),
            subtitle: const Text('Build signed APKs locally inside Buddy'),
            value: appState.developerMode,
            onChanged: (val) => appState.toggleDeveloperMode(val),
          ),
          ListTile(
            leading: const Icon(Icons.cast_connected),
            title: Text(loc.remoteControlTitle),
            subtitle: const Text('Remote Control Claude Code session'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
