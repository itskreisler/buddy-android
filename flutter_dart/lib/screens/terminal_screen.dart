import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../services/linux_environment.dart';

class TerminalScreen extends StatefulWidget {
  const TerminalScreen({super.key});

  @override
  State<TerminalScreen> createState() => _TerminalScreenState();
}

class _TerminalScreenState extends State<TerminalScreen> {
  late LinuxEnvironment _linux;
  final List<String> _outputLines = [
    'Buddy Linux Environment (Alpine Linux proot)',
    'Type "help" or run agent commands directly.',
    'buddy@android:~\$ ',
  ];
  final TextEditingController _cmdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _linux = LinuxEnvironment(
      filesDir: '/data/user/0/app.buddy.assistant/files',
      cacheDir: '/data/user/0/app.buddy.assistant/cache',
      nativeLibDir: '/data/app/app.buddy.assistant/lib/arm64',
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(loc.terminalTitle, style: const TextStyle(color: Colors.greenAccent)),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _outputLines.length,
              itemBuilder: (context, index) {
                return Text(
                  _outputLines[index],
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                );
              },
            ),
          ),
          Container(
            color: Colors.grey.shade900,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                const Text('\$', style: TextStyle(color: Colors.greenAccent, fontFamily: 'monospace')),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _cmdController,
                    style: const TextStyle(color: Colors.white, fontFamily: 'monospace'),
                    decoration: const InputDecoration(
                      hintText: 'Enter command...',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                    onSubmitted: _runCommand,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.greenAccent),
                  onPressed: () => _runCommand(_cmdController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _runCommand(String cmd) async {
    final trimmed = cmd.trim();
    if (trimmed.isEmpty) return;
    _cmdController.clear();

    setState(() {
      _outputLines.add('buddy@android:~\$ $trimmed');
    });

    if (trimmed == 'clear') {
      setState(() {
        _outputLines.clear();
        _outputLines.add('buddy@android:~\$ ');
      });
      return;
    }

    if (trimmed == 'help') {
      setState(() {
        _outputLines.add('Available commands: claude, codex, opencode, buddy-run, clear, help, ls, pwd');
        _outputLines.add('buddy@android:~\$ ');
      });
      return;
    }

    // Execute through Linux proot environment
    final output = await _linux.exec(trimmed);

    setState(() {
      _outputLines.add(output.trim());
      _outputLines.add('buddy@android:~\$ ');
    });
  }
}
