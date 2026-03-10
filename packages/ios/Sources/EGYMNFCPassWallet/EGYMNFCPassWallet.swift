import Foundation
import PassKit
#if canImport(UIKit)
import UIKit
#endif

public enum EGYMWalletError: Error {
    case invalidPayload
    case unavailable
    case unsupported
}

public protocol WalletAvailabilityChecking {
    func canAddPasses() -> Bool
}

public protocol PassKitManaging {
    func containsPass(passData: Data) throws -> Bool
    func presentAddPasses(passData: Data) throws
}

public struct SystemWalletAvailabilityChecker: WalletAvailabilityChecking {
    public init() {}

    public func canAddPasses() -> Bool {
#if canImport(UIKit)
        PKAddPassesViewController.canAddPasses()
#else
        false
#endif
    }
}

public struct SystemPassKitManager: PassKitManaging {
    private let passLibrary: PKPassLibrary
#if canImport(UIKit)
    private let presentingViewControllerProvider: () -> UIViewController?
#endif

#if canImport(UIKit)
    public init(
        passLibrary: PKPassLibrary = PKPassLibrary(),
        presentingViewControllerProvider: @escaping () -> UIViewController? = {
            let windowScenes = UIApplication.shared.connectedScenes.compactMap { $0 as? UIWindowScene }
            let activeScene = windowScenes.first {
                $0.activationState == .foregroundActive || $0.activationState == .foregroundInactive
            }
            return activeScene?.windows.first(where: { $0.isKeyWindow })?.rootViewController
        }
    ) {
        self.passLibrary = passLibrary
        self.presentingViewControllerProvider = presentingViewControllerProvider
    }
#else
    public init(passLibrary: PKPassLibrary = PKPassLibrary()) {
        self.passLibrary = passLibrary
    }
#endif

    public func containsPass(passData: Data) throws -> Bool {
        let pass = try decodePass(passData: passData)
        return passLibrary.containsPass(pass)
    }

    public func presentAddPasses(passData: Data) throws {
#if canImport(UIKit)
        guard PKAddPassesViewController.canAddPasses() else {
            throw EGYMWalletError.unavailable
        }

        let pass = try decodePass(passData: passData)

        guard let addPassesViewController = PKAddPassesViewController(pass: pass),
                            let presentingViewController = presentingViewControllerProvider() else {
            throw EGYMWalletError.unavailable
        }

        DispatchQueue.main.async {
            presentingViewController.present(addPassesViewController, animated: true)
        }
#else
        throw EGYMWalletError.unavailable
#endif
    }

    private func decodePass(passData: Data) throws -> PKPass {
        do {
            return try PKPass(data: passData)
        } catch {
            throw EGYMWalletError.invalidPayload
        }
    }
}

public struct EGYMNFCPassWallet {
    private let walletAvailabilityChecker: WalletAvailabilityChecking
    private let passKitManager: PassKitManaging

    public init(
        walletAvailabilityChecker: WalletAvailabilityChecking = SystemWalletAvailabilityChecker(),
        passKitManager: PassKitManaging = SystemPassKitManager()
    ) {
        self.walletAvailabilityChecker = walletAvailabilityChecker
        self.passKitManager = passKitManager
    }

    public func isWalletAvailable() -> Bool {
        walletAvailabilityChecker.canAddPasses()
    }

    public func savePassToWallet(iosPkPassBase64: String) throws {
        guard !iosPkPassBase64.isEmpty else {
            throw EGYMWalletError.invalidPayload
        }

        guard walletAvailabilityChecker.canAddPasses() else {
            throw EGYMWalletError.unavailable
        }

        let passData = Data(base64Encoded: iosPkPassBase64, options: [.ignoreUnknownCharacters]) ?? Data()

        if try passKitManager.containsPass(passData: passData) {
            return
        }

        try passKitManager.presentAddPasses(passData: passData)
    }

    public func readPassFromWallet(iosPkPassBase64: String) throws -> Bool {
        guard !iosPkPassBase64.isEmpty else {
            throw EGYMWalletError.invalidPayload
        }

        let passData = Data(base64Encoded: iosPkPassBase64, options: [.ignoreUnknownCharacters]) ?? Data()
        return try passKitManager.containsPass(passData: passData)
    }
}
