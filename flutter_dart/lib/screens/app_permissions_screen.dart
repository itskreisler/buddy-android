import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class AppPermissionsScreen extends StatefulWidget {
  const AppPermissionsScreen({super.key});

  @override
  State<AppPermissionsScreen> createState() => _AppPermissionsScreenState();
}

class _AppPermissionsScreenState extends State<AppPermissionsScreen> {
  final Map<String, String> _appRules = {
    'WhatsApp': 'Hard',
    'Amazon': 'Hard',
    'Gmail': 'Hard',
    'Browser': 'Trust',
    'Settings': 'Smart',
  };

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.appPermissionsTitle),
      ),
      body: ListView(
        children: _appRules.entries.map((entry) {
          return ListTile(
            title: Text(entry.key),
            subtitle: Text('Safety rule: ${entry.value}'),
            trailing: DropdownButton<String>(
              value: entry.value,
              items: const [
                DropdownMenuItem(value: 'Hard', child: Text('Hard limit')),
                DropdownMenuItem(value: 'Trust', child: Text('Trust')),
                DropdownMenuItem(value: 'Smart', child: Text('Smart review')),
              ],
              onChanged: (val) {
                if (val != null) {
                  setState(() => _appRules[entry.key] = val);
                }
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
