import Foundation
import Capacitor
import PassKit

@objc(CapacitorNFCPassWalletPlugin)
public class CapacitorNFCPassWalletPlugin: CAPPlugin {
    @objc func savePassToWallet(_ call: CAPPluginCall) {
        guard let _ = call.getString("iosPkPassBase64") else {
            call.reject("INVALID_PAYLOAD: Missing iosPkPassBase64")
            return
        }

        call.resolve()
    }

    @objc func readPassFromWallet(_ call: CAPPluginCall) {
        let response: [String: Any] = ["result": false]
        call.resolve(response)
    }

    @objc func isWalletAvailable(_ call: CAPPluginCall) {
        let response: [String: Any] = ["result": PKPassLibrary.isPassLibraryAvailable()]
        call.resolve(response)
    }
}
