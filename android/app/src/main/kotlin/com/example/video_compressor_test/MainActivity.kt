package com.example.video_compressor_test
import android.os.BatteryManager
import android.os.Build
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "samples.flutter.dev/battery"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getBatteryInfo") {
                val batteryInfo = getBatteryInfo()
                if (batteryInfo != null) {
                    result.success(batteryInfo)
                } else {
                    result.error("UNAVAILABLE", "Battery info not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getBatteryInfo(): Map<String, Any>? {
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        val batteryLevel: Int = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
        val deviceName = Build.MODEL ?: "Unknown Device"
        return mapOf("battery" to batteryLevel, "device" to deviceName)
    }
}
