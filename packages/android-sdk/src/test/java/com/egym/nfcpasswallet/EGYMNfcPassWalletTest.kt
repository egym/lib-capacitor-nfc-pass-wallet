package com.egym.nfcpasswallet

import android.app.Activity
import android.content.Context
import com.google.android.gms.pay.PayClient.SavePassesResult
import io.mockk.every
import io.mockk.mockk
import io.mockk.verify
import org.junit.Assert.assertEquals
import org.junit.Assert.assertFalse
import org.junit.Assert.assertTrue
import org.junit.Test

class EGYMNfcPassWalletTest {

    @Test
    fun `isWalletAvailable forwards true from client`() {
        val context = mockk<Context>(relaxed = true)
        val walletClient = mockk<WalletClient>()
        val sdk = EGYMNfcPassWallet(context, walletClient)

        every { walletClient.isWalletAvailable(any()) } answers {
            firstArg<(Boolean) -> Unit>().invoke(true)
        }

        var value = false
        sdk.isWalletAvailable { value = it }

        assertTrue(value)
    }

    @Test
    fun `savePassToWallet delegates to client and invokes callback`() {
        val context = mockk<Activity>(relaxed = true)
        val walletClient = mockk<WalletClient>()
        val sdk = EGYMNfcPassWallet(context, walletClient)

        every { walletClient.savePassToWallet(any(), any(), any()) } answers {
            thirdArg<(SavePassesResult?) -> Unit>().invoke(null)
        }

        var callbackCalled = false
        sdk.savePassToWallet("jwt") { callbackCalled = true }

        verify(exactly = 1) { walletClient.savePassToWallet("jwt", context, any()) }
        assertTrue(callbackCalled)
    }

    @Test(expected = IllegalStateException::class)
    fun `savePassToWallet throws when context is not activity`() {
        val context = mockk<Context>(relaxed = true)
        val walletClient = mockk<WalletClient>(relaxed = true)
        val sdk = EGYMNfcPassWallet(context, walletClient)

        sdk.savePassToWallet("jwt") {}
    }

    @Test
    fun `readPassFromWallet returns unsupported failure`() {
        val context = mockk<Context>(relaxed = true)
        val walletClient = mockk<WalletClient>(relaxed = true)
        val sdk = EGYMNfcPassWallet(context, walletClient)

        val result = sdk.readPassFromWallet()

        assertTrue(result.isFailure)
        assertEquals(
            "NOT_SUPPORTED: Android cannot read pass presence",
            result.exceptionOrNull()?.message,
        )
    }
}
