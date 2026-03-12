package com.egym.flutter.nfcpasswallet

import android.app.Activity
import android.content.Context
import android.net.Uri
import com.google.android.gms.pay.Pay
import com.google.android.gms.pay.PayApiAvailabilityStatus
import com.google.android.gms.pay.PayClient
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class EgymNfcPassWalletPlugin : FlutterPlugin, MethodCallHandler, ActivityAware {
    private lateinit var channel: MethodChannel
    private var applicationContext: Context? = null
    private var activity: Activity? = null

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = flutterPluginBinding.applicationContext
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "CapacitorNFCPassWallet")
        channel.setMethodCallHandler(this)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "savePassToWallet" -> savePassToWallet(call, result)
            "readPassFromWallet" -> result.error("NOT_SUPPORTED", "Android does not support readPassFromWallet", null)
            "isWalletAvailable" -> isWalletAvailable(result)
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        applicationContext = null
        channel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    private fun savePassToWallet(call: MethodCall, result: Result) {
        val jwt = resolveGooglePayJwt(
            call.argument<String>("googlePayJwt"),
            call.argument<String>("saveToGooglePayUrl"),
            call.argument<String>("androidPassJwt"),
        )

        if (jwt == null) {
            result.error("INVALID_PAYLOAD", "Missing googlePayJwt or saveToGooglePayUrl", null)
            return
        }

        val currentActivity = activity
        val context = applicationContext
        if (currentActivity == null || context == null) {
            result.error("NATIVE_ERROR", "Missing activity context", null)
            return
        }

        try {
            Pay.getClient(context).savePassesJwt(jwt, currentActivity, 1001)
            result.success(null)
        } catch (exception: RuntimeException) {
            result.error("NATIVE_ERROR", "Failed to launch Google Wallet", exception.message)
        }
    }

    private fun isWalletAvailable(result: Result) {
        val context = applicationContext
        if (context == null) {
            result.success(mapOf("result" to false))
            return
        }

        Pay.getClient(context)
            .getPayApiAvailabilityStatus(PayClient.RequestType.SAVE_PASSES)
            .addOnSuccessListener { status ->
                result.success(mapOf("result" to (status == PayApiAvailabilityStatus.AVAILABLE)))
            }
            .addOnFailureListener {
                result.success(mapOf("result" to false))
            }
    }

    private fun resolveGooglePayJwt(
        googlePayJwt: String?,
        saveToGooglePayUrl: String?,
        legacyAndroidPassJwt: String?,
    ): String? {
        normalizeValue(googlePayJwt)?.let { return it }
        extractJwtFromValue(saveToGooglePayUrl)?.let { return it }
        return extractJwtFromValue(legacyAndroidPassJwt)
    }

    private fun extractJwtFromValue(value: String?): String? {
        val normalized = normalizeValue(value) ?: return null
        if (!normalized.contains("://")) {
            return normalized
        }

        return Uri.parse(normalized).getQueryParameter("jwt")?.trim()?.takeIf { it.isNotEmpty() }
    }

    private fun normalizeValue(value: String?): String? = value?.trim()?.takeIf { it.isNotEmpty() }
}
