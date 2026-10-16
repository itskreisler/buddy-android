import 'package:flutter/services.dart';

/// MethodChannel bridge connecting Flutter UI directly to native Android AccessibilityService and system tools.
class NativeBridge {
  static const MethodChannel _channel = MethodChannel('app.buddy.assistant/bridge');

  /// Checks if Buddy Accessibility Service is enabled in Android settings.
  static Future<bool> isAccessibilityEnabled() async {
    try {
      final bool enabled = await _channel.invokeMethod('isAccessibilityEnabled');
      return enabled;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Reads current on-screen text nodes via native Android AccessibilityService.
  static Future<String> readScreen() async {
    try {
      final String text = await _channel.invokeMethod('readScreen');
      return text;
    } on PlatformException catch (e) {
      return 'Accessibility Service unavailable (${e.message})';
    }
  }

  /// Taps screen location x,y via native GestureDescription.
  static Future<bool> tap(double x, double y) async {
    try {
      final bool success = await _channel.invokeMethod('tap', {'x': x, 'y': y});
      return success;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Opens application by package name.
  static Future<bool> openApp(String packageName) async {
    try {
      final bool success = await _channel.invokeMethod('openApp', {'package': packageName});
      return success;
    } on PlatformException catch (_) {
      return false;
    }
  }
}
