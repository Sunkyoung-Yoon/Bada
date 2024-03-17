package com.ssafy.bada

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {

    private val CHANNEL = "testing.flutter.android"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        GeneratedPluginRegistrant.registerWith(flutterEngine)

        // TMap 함수
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                if (call.method.equals("showActivity")) {
                    val intent = Intent(this, TMapActivity::class.java)
                    startActivity(intent)
                } else {
                    result.error("unavailable", "cannot start activity", null)
                }
            }


    }
}
