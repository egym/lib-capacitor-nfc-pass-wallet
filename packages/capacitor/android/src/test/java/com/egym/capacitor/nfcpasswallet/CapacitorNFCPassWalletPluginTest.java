package com.egym.capacitor.nfcpasswallet;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;

import org.junit.Test;

public class CapacitorNFCPassWalletPluginTest {

    @Test
    public void resolveGooglePayJwtPrefersDirectJwt() {
        String jwt = CapacitorNFCPassWalletPlugin.resolveGooglePayJwt(
            "direct-jwt",
            "https://pay.google.com/gp/v/save/test?jwt=url-jwt",
            "legacy-jwt"
        );

        assertEquals("direct-jwt", jwt);
    }

    @Test
    public void resolveGooglePayJwtExtractsFromUrl() {
        String jwt = CapacitorNFCPassWalletPlugin.resolveGooglePayJwt(
            null,
            "https://pay.google.com/gp/v/save/test?jwt=url-jwt",
            null
        );

        assertEquals("url-jwt", jwt);
    }

    @Test
    public void resolveGooglePayJwtFallsBackToLegacyValue() {
        String jwt = CapacitorNFCPassWalletPlugin.resolveGooglePayJwt(
            null,
            null,
            "legacy-jwt"
        );

        assertEquals("legacy-jwt", jwt);
    }

    @Test
    public void resolveGooglePayJwtReturnsNullForMissingPayload() {
        String jwt = CapacitorNFCPassWalletPlugin.resolveGooglePayJwt(
            "   ",
            null,
            null
        );

        assertNull(jwt);
    }
}