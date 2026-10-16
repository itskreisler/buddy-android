import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.onboardingTitle),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 4) {
            setState(() => _currentStep++);
          } else {
            Navigator.pop(context);
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep--);
          } else {
            Navigator.pop(context);
          }
        },
        steps: const [
          Step(
            title: Text('Choose your agent'),
            content: Text('Select Claude Code, Codex or OpenCode free models.'),
          ),
          Step(
            title: Text('Accessibility Service'),
            content: Text('Enable Buddy assistant in Android Accessibility settings to read screen and tap buttons.'),
          ),
          Step(
            title: Text('Install and Sign In'),
            content: Text('Download Linux environment and sign in to Anthropic / OpenAI.'),
          ),
          Step(
            title: Text('Battery Optimization'),
            content: Text('Set battery usage to Unrestricted so Android does not stop Buddy.'),
          ),
          Step(
            title: Text('Try it out'),
            content: Text('Setup complete! Start your first chat with Buddy.'),
          ),
        ],
      ),
    );
  }
}
