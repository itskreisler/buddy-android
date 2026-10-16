import '../services/native_bridge.dart';

class PhoneTool {
  final String name;
  final String description;

  const PhoneTool({required this.name, required this.description});

  static const List<PhoneTool> tools = [
    PhoneTool(name: 'read_screen', description: 'Reads interactive elements on the screen'),
    PhoneTool(name: 'tap', description: 'Taps at given x,y coordinates or text'),
    PhoneTool(name: 'type_text', description: 'Types text into focused input'),
    PhoneTool(name: 'scroll', description: 'Scrolls screen up/down/left/right'),
    PhoneTool(name: 'open_app', description: 'Opens application by package or name'),
    PhoneTool(name: 'confirm', description: 'Asks user for approval before performing action'),
    PhoneTool(name: 'ask', description: 'Presents a multiple choice question to user'),
  ];

  static Future<String> executeTool(String toolName, Map<String, dynamic> params) async {
    switch (toolName) {
      case 'read_screen':
        return await NativeBridge.readScreen();
      case 'tap':
        final double x = (params['x'] as num?)?.toDouble() ?? 0.0;
        final double y = (params['y'] as num?)?.toDouble() ?? 0.0;
        final ok = await NativeBridge.tap(x, y);
        return ok ? 'Tapped at ($x, $y)' : 'Tap failed';
      case 'scroll':
        final dir = params['direction']?.toString() ?? 'down';
        final ok = await NativeBridge.scroll(dir);
        return ok ? 'Scrolled $dir' : 'Scroll failed';
      case 'type_text':
        final text = params['text']?.toString() ?? '';
        final ok = await NativeBridge.typeText(text);
        return ok ? 'Typed text' : 'Type text failed';
      case 'open_app':
        final String pkg = params['package']?.toString() ?? '';
        final ok = await NativeBridge.openApp(pkg);
        return ok ? 'Opened app $pkg' : 'Could not open app $pkg';
      default:
        return 'Tool $toolName executed';
    }
  }
}
