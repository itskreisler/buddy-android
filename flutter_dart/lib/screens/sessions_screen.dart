import 'package:flutter/material.dart';
import '../services/app_state.dart';
import '../l10n/app_localizations.dart';
import 'terminal_screen.dart';

class SessionsScreen extends StatelessWidget {
  final AppState appState;

  const SessionsScreen({super.key, required this.appState});

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final sessions = appState.sessions;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.tabSessions),
        actions: [
          IconButton(
            icon: const Icon(Icons.terminal),
            tooltip: loc.terminalTitle,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TerminalScreen()),
              );
            },
          ),
        ],
      ),
      body: sessions.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.memory, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    loc.noActiveSessions,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (ctx, idx) {
                final s = sessions[idx];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.play_circle_fill, color: Colors.green),
                    title: Text('Session ID: ${s.id}'),
                    subtitle: Text('Agent: ${s.agent.toUpperCase()} · Status: ${s.status}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.stop_circle, color: Colors.red),
                      tooltip: loc.actionStop,
                      onPressed: () {
                        appState.stopSession(s.id);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Stopped session ${s.id}')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
    );
  }
}
