import Flutter
import UIKit
import PassKit

public class EgymNfcPassWalletPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "egym_nfc_pass_wallet", binaryMessenger: registrar.messenger())
    let instance = EgymNfcPassWalletPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "savePassToWallet":
      result(nil)
    case "readPassFromWallet":
      result(false)
    case "isWalletAvailable":
      result(PKPassLibrary.isPassLibraryAvailable())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
