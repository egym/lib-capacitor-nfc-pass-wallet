package com.egym.capacitor.nfcpasswallet;

import android.app.Activity;
import android.content.Intent;

import androidx.annotation.Nullable;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;
import com.google.android.gms.pay.Pay;
import com.google.android.gms.pay.PayApiAvailabilityStatus;
import com.google.android.gms.pay.PayClient;

import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;

@CapacitorPlugin(name = "CapacitorNFCPassWallet")
public class CapacitorNFCPassWalletPlugin extends Plugin {
    private static final int SAVE_PASSES_REQUEST_CODE = 1001;

    @PluginMethod
    public void savePassToWallet(PluginCall call) {
        String jwt = resolveGooglePayJwt(
            call.getString("googlePayJwt"),
            call.getString("saveToGooglePayUrl"),
            call.getString("androidPassJwt")
        );

        if (jwt == null || jwt.isEmpty()) {
            call.reject("INVALID_PAYLOAD: Missing googlePayJwt or saveToGooglePayUrl");
            return;
        }

        Activity activity = getActivity();
        if (activity == null) {
            call.reject("NATIVE_ERROR: Missing activity context");
            return;
        }

        try {
            Pay.getClient(getContext()).savePassesJwt(jwt, activity, SAVE_PASSES_REQUEST_CODE);
            call.resolve();
        } catch (RuntimeException exception) {
            call.reject("NATIVE_ERROR: Failed to launch Google Wallet", exception);
        }
    }

    @PluginMethod
    public void readPassFromWallet(PluginCall call) {
        call.reject("NOT_SUPPORTED: Android does not support pass presence reads.");
    }

    @PluginMethod
    public void isWalletAvailable(PluginCall call) {
        PayClient payClient = Pay.getClient(getContext());
        payClient.getPayApiAvailabilityStatus(PayClient.RequestType.SAVE_PASSES)
            .addOnSuccessListener(status -> {
                JSObject result = new JSObject();
                result.put("result", status == PayApiAvailabilityStatus.AVAILABLE);
                call.resolve(result);
            })
            .addOnFailureListener(exception -> {
                JSObject result = new JSObject();
                result.put("result", false);
                call.resolve(result);
            });
    }

    @Nullable
    static String resolveGooglePayJwt(
        @Nullable String googlePayJwt,
        @Nullable String saveToGooglePayUrl,
        @Nullable String legacyAndroidPassJwt
    ) {
        String directJwt = normalizeValue(googlePayJwt);
        if (directJwt != null) {
            return directJwt;
        }

        String urlJwt = extractJwtFromValue(saveToGooglePayUrl);
        if (urlJwt != null) {
            return urlJwt;
        }

        return extractJwtFromValue(legacyAndroidPassJwt);
    }

    @Nullable
    private static String extractJwtFromValue(@Nullable String value) {
        String normalized = normalizeValue(value);
        if (normalized == null) {
            return null;
        }

        if (!normalized.contains("://")) {
            return normalized;
        }

        int queryStart = normalized.indexOf('?');
        if (queryStart < 0 || queryStart == normalized.length() - 1) {
            return null;
        }

        String query = normalized.substring(queryStart + 1);
        for (String part : query.split("&")) {
            int separatorIndex = part.indexOf('=');
            String key = separatorIndex >= 0 ? part.substring(0, separatorIndex) : part;

            if (!"jwt".equals(key)) {
                continue;
            }

            String rawValue = separatorIndex >= 0 ? part.substring(separatorIndex + 1) : "";
            String decodedValue = URLDecoder.decode(rawValue, StandardCharsets.UTF_8);
            return normalizeValue(decodedValue);
        }

        return null;
    }

    @Nullable
    private static String normalizeValue(@Nullable String value) {
        if (value == null) {
            return null;
        }

        String trimmed = value.trim();
        return trimmed.isEmpty() ? null : trimmed;
    }
}
