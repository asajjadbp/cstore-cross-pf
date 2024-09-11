package com.catalist.cstoreCross.cstore_flutter

import android.content.Context
import android.os.Build
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL = "auto_time_enable"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "getAutoTimeEnableStatus") {
                val context = applicationContext
                val status = isAutoTimeEnabled(context)
                result.success(status)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun isAutoTimeEnabled(context: Context): Boolean {
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.JELLY_BEAN_MR1) {
            Settings.Global.getInt(context.contentResolver, Settings.Global.AUTO_TIME, 0) == 1
        } else {
            android.provider.Settings.System.getInt(context.contentResolver, android.provider.Settings.System.AUTO_TIME, 0) == 1
        }
    }

}
