import Foundation
import Capacitor
import PassKit
import UIKit

@objc(CapacitorNFCPassWalletPlugin)
public class CapacitorNFCPassWalletPlugin: CAPPlugin {
    @objc func savePassToWallet(_ call: CAPPluginCall) {
        guard PKAddPassesViewController.canAddPasses() else {
            call.reject("UNAVAILABLE: Wallet is not available on this device")
            return
        }

        guard let encodedPass = call.getString("iosPkPassBase64") else {
            call.reject("INVALID_PAYLOAD: Missing iosPkPassBase64")
            return
        }

        guard let pass = decodePass(encodedPass) else {
            call.reject("INVALID_PAYLOAD: Unable to decode iosPkPassBase64")
            return
        }

        DispatchQueue.main.async {
            guard let viewController = PKAddPassesViewController(pass: pass) else {
                call.reject("NATIVE_ERROR: Failed to create PKAddPassesViewController")
                return
            }

            guard let presentingViewController = self.bridge?.viewController ?? self.topViewController() else {
                call.reject("NATIVE_ERROR: Missing presenting view controller")
                return
            }

            presentingViewController.present(viewController, animated: true) {
                call.resolve()
            }
        }
    }

    @objc func readPassFromWallet(_ call: CAPPluginCall) {
        guard let encodedPass = call.getString("iosPkPassBase64") else {
            call.reject("INVALID_PAYLOAD: Missing iosPkPassBase64")
            return
        }

        guard let pass = decodePass(encodedPass) else {
            call.reject("INVALID_PAYLOAD: Unable to decode iosPkPassBase64")
            return
        }

        let response: [String: Any] = ["result": PKPassLibrary().containsPass(pass)]
        call.resolve(response)
    }

    @objc func isWalletAvailable(_ call: CAPPluginCall) {
        let response: [String: Any] = ["result": PKAddPassesViewController.canAddPasses()]
        call.resolve(response)
    }

    private func decodePass(_ encodedPass: String) -> PKPass? {
        guard let data = Data(base64Encoded: encodedPass, options: [.ignoreUnknownCharacters]) else {
            return nil
        }

        return try? PKPass(data: data)
    }

    private func topViewController(base: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .flatMap { $0.windows }
        .first(where: { $0.isKeyWindow })?.rootViewController) -> UIViewController? {
        if let navigationController = base as? UINavigationController {
            return topViewController(base: navigationController.visibleViewController)
        }

        if let tabBarController = base as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return topViewController(base: selectedViewController)
        }

        if let presentedViewController = base?.presentedViewController {
            return topViewController(base: presentedViewController)
        }

        return base
    }
}
