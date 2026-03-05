package com.egym.nfcpasswallet

import android.app.Activity
import android.content.Context
import com.google.android.gms.pay.PayApiAvailabilityStatus
import com.google.android.gms.pay.PayClient
import com.google.android.gms.pay.PayClient.SavePassesResult
import com.google.android.gms.pay.Pay

interface WalletClient {
    fun isWalletAvailable(callback: (Boolean) -> Unit)
    fun savePassToWallet(jwt: String, activity: Activity, callback: (SavePassesResult?) -> Unit)
}

private class GoogleWalletClient(context: Context) : WalletClient {
    private val payClient: PayClient = Pay.getClient(context)

    override fun isWalletAvailable(callback: (Boolean) -> Unit) {
        payClient.getPayApiAvailabilityStatus(PayClient.RequestType.SAVE_PASSES)
            .addOnSuccessListener { status ->
                callback(status == PayApiAvailabilityStatus.AVAILABLE)
            }
            .addOnFailureListener {
                callback(false)
            }
    }

    override fun savePassToWallet(jwt: String, activity: Activity, callback: (SavePassesResult?) -> Unit) {
        payClient.savePassesJwt(jwt, activity, 1001)
        callback(null)
    }
}

class EGYMNfcPassWallet(
    private val context: Context,
    private val walletClient: WalletClient = GoogleWalletClient(context),
) {

    fun isWalletAvailable(callback: (Boolean) -> Unit) {
        walletClient.isWalletAvailable(callback)
    }

    fun savePassToWallet(jwt: String, callback: (SavePassesResult?) -> Unit) {
        val activity = context as? Activity
            ?: throw IllegalStateException("Context must be an Activity to save passes")
        walletClient.savePassToWallet(jwt, activity, callback)
    }

    fun readPassFromWallet(): Result<Boolean> {
        return Result.failure(UnsupportedOperationException("NOT_SUPPORTED: Android cannot read pass presence"))
    }
}
