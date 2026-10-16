package app.buddy.assistant

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.graphics.Path
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

class BuddyService : AccessibilityService() {

    companion object {
        var instance: BuddyService? = null
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Event processing for screen updates
    }

    override fun onInterrupt() {
        instance = null
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
    }

    fun readScreenText(): String {
        val root = rootInActiveWindow ?: return "Screen unreachable"
        val sb = StringBuilder()
        traverseNodes(root, sb)
        return if (sb.isNotEmpty()) sb.toString() else "Empty screen content"
    }

    private fun traverseNodes(node: AccessibilityNodeInfo?, sb: StringBuilder) {
        if (node == null) return
        val text = node.text?.toString()
        val desc = node.contentDescription?.toString()
        if (!text.isNullOrBlank()) {
            sb.append(text).append("\n")
        } else if (!desc.isNullOrBlank()) {
            sb.append(desc).append("\n")
        }
        for (i in 0 until node.childCount) {
            traverseNodes(node.getChild(i), sb)
        }
    }

    fun tapLocation(x: Float, y: Float): Boolean {
        val path = Path().apply { moveTo(x, y) }
        val gesture = GestureDescription.Builder()
            .addStroke(GestureDescription.StrokeDescription(path, 0, 100))
            .build()
        return dispatchGesture(gesture, null, null)
    }

    fun scroll(direction: String): Boolean {
        val action = if ("up".equals(direction, ignoreCase = true)) {
            AccessibilityNodeInfo.ACTION_SCROLL_BACKWARD
        } else {
            AccessibilityNodeInfo.ACTION_SCROLL_FORWARD
        }
        val root = rootInActiveWindow ?: return false
        return root.performAction(action)
    }

    fun typeText(text: String): Boolean {
        val root = rootInActiveWindow ?: return false
        val focused = root.findFocus(AccessibilityNodeInfo.FOCUS_INPUT) ?: return false
        val arguments = android.os.Bundle().apply {
            putCharSequence(AccessibilityNodeInfo.ACTION_ARGUMENT_SET_TEXT_CHARSEQUENCE, text)
        }
        return focused.performAction(AccessibilityNodeInfo.ACTION_SET_TEXT, arguments)
    }

    fun openAppByPackage(packageName: String): Boolean {
        val intent = packageManager.getLaunchIntentForPackage(packageName)
        return if (intent != null) {
            intent.addFlags(android.content.Intent.FLAG_ACTIVITY_NEW_TASK)
            startActivity(intent)
            true
        } else {
            false
        }
    }
}
