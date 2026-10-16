package app.buddy.assistant

import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "app.buddy.assistant/bridge"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "isAccessibilityEnabled" -> {
                    val service = "${packageName}/${BuddyService::class.java.canonicalName}"
                    val enabledServices = Settings.Secure.getString(
                        contentResolver,
                        Settings.Secure.ENABLED_ACCESSIBILITY_SERVICES
                    )
                    val enabled = enabledServices?.contains(service) == true
                    result.success(enabled)
                }
                "readScreen" -> {
                    val service = BuddyService.instance
                    if (service != null) {
                        result.success(service.readScreenText())
                    } else {
                        result.error("UNAVAILABLE", "Accessibility Service not running", null)
                    }
                }
                "tap" -> {
                    val service = BuddyService.instance
                    val x = call.argument<Double>("x")?.toFloat() ?: 0f
                    val y = call.argument<Double>("y")?.toFloat() ?: 0f
                    if (service != null) {
                        val success = service.tapLocation(x, y)
                        result.success(success)
                    } else {
                        result.error("UNAVAILABLE", "Accessibility Service not running", null)
                    }
                }
                "scroll" -> {
                    val service = BuddyService.instance
                    val dir = call.argument<String>("direction") ?: "down"
                    if (service != null) {
                        result.success(service.scroll(dir))
                    } else {
                        result.error("UNAVAILABLE", "Accessibility Service not running", null)
                    }
                }
                "typeText" -> {
                    val service = BuddyService.instance
                    val text = call.argument<String>("text") ?: ""
                    if (service != null) {
                        result.success(service.typeText(text))
                    } else {
                        result.error("UNAVAILABLE", "Accessibility Service not running", null)
                    }
                }
                "openApp" -> {
                    val service = BuddyService.instance
                    val pkg = call.argument<String>("package") ?: ""
                    if (service != null) {
                        val success = service.openAppByPackage(pkg)
                        result.success(success)
                    } else {
                        result.error("UNAVAILABLE", "Accessibility Service not running", null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }
}
