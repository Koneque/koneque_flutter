package com.example.koneque_apk

import android.content.Intent
import android.net.Uri
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "koneque.app/deep_links"
    
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Configurar el canal para deep links
        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
            MethodChannel(messenger, CHANNEL).setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialLink" -> {
                        val initialLink = getInitialLink()
                        result.success(initialLink)
                    }
                    else -> result.notImplemented()
                }
            }
        }
        
        // Manejar el intent inicial
        handleIntent(intent)
    }
    
    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        handleIntent(intent)
    }
    
    private fun handleIntent(intent: Intent?) {
        intent?.data?.let { uri ->
            // Manejar deep links de WalletConnect
            if (uri.scheme == "koneque") {
                // Notificar a Flutter sobre el deep link
                flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                    MethodChannel(messenger, CHANNEL).invokeMethod("onDeepLink", uri.toString())
                }
            }
        }
    }
    
    private fun getInitialLink(): String? {
        return intent?.data?.toString()
    }
}
