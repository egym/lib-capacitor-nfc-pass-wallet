import Flutter
import UIKit
import PassKit

public class EgymNfcPassWalletPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "CapacitorNFCPassWallet", binaryMessenger: registrar.messenger())
    let instance = EgymNfcPassWalletPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "savePassToWallet":
      savePassToWallet(call, result: result)
    case "readPassFromWallet":
      readPassFromWallet(call, result: result)
    case "isWalletAvailable":
      result(["result": PKAddPassesViewController.canAddPasses()])
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func savePassToWallet(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard PKAddPassesViewController.canAddPasses() else {
      result(FlutterError(code: "UNAVAILABLE", message: "Wallet is not available on this device", details: nil))
      return
    }

    guard let arguments = call.arguments as? [String: Any],
          let encodedPass = arguments["iosPkPassBase64"] as? String else {
      result(FlutterError(code: "INVALID_PAYLOAD", message: "Missing iosPkPassBase64", details: nil))
      return
    }

    guard let pass = decodePass(encodedPass) else {
      result(FlutterError(code: "INVALID_PAYLOAD", message: "Unable to decode iosPkPassBase64", details: nil))
      return
    }

    DispatchQueue.main.async {
      guard let viewController = PKAddPassesViewController(pass: pass) else {
        result(FlutterError(code: "NATIVE_ERROR", message: "Failed to create PKAddPassesViewController", details: nil))
        return
      }

      guard let presentingViewController = self.topViewController() else {
        result(FlutterError(code: "NATIVE_ERROR", message: "Missing presenting view controller", details: nil))
        return
      }

      presentingViewController.present(viewController, animated: true) {
        result(nil)
      }
    }
  }

  private func readPassFromWallet(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    guard let arguments = call.arguments as? [String: Any],
          let encodedPass = arguments["iosPkPassBase64"] as? String else {
      result(FlutterError(code: "INVALID_PAYLOAD", message: "Missing iosPkPassBase64", details: nil))
      return
    }

    guard let pass = decodePass(encodedPass) else {
      result(FlutterError(code: "INVALID_PAYLOAD", message: "Unable to decode iosPkPassBase64", details: nil))
      return
    }

    result(["result": PKPassLibrary().containsPass(pass)])
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
