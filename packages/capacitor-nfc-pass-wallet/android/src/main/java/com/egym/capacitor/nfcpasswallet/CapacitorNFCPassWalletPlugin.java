package com.egym.capacitor.nfcpasswallet;

import android.content.Intent;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "CapacitorNFCPassWallet")
public class CapacitorNFCPassWalletPlugin extends Plugin {

    @PluginMethod
    public void savePassToWallet(PluginCall call) {
        String jwt = call.getString("googlePayJwt");
        String url = call.getString("saveToGooglePayUrl");

        if ((jwt == null || jwt.isEmpty()) && (url == null || url.isEmpty())) {
            call.reject("INVALID_PAYLOAD: Missing googlePayJwt or saveToGooglePayUrl");
            return;
        }

        call.resolve();
    }

    @PluginMethod
    public void readPassFromWallet(PluginCall call) {
        call.reject("NOT_SUPPORTED: Android does not support pass presence reads.");
    }

    @PluginMethod
    public void isWalletAvailable(PluginCall call) {
        JSObject result = new JSObject();
        result.put("result", true);
        call.resolve(result);
    }
}
