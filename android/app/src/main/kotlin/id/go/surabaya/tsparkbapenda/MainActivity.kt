package id.go.surabaya.tsparkbapenda

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.bapenda.parkir/app_retain"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->

            if (call.method == "sendToBackground") {
                moveTaskToBack(true)
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
    }

    // Cegah FlutterActivity meneruskan Intent (termasuk custom scheme
    // seperti tspark://) sebagai route push otomatis ke go_router.
    // Deep link tetap ditangkap manual oleh app_links/uni_links
    // lewat DeeplinkService, jadi ini aman — go_router tidak akan
    // pernah mencoba mem-parse tspark:// sebagai route lagi.
    override fun shouldHandleDeeplinking(): Boolean {
        return false
    }
}