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

public struct EGYMNFCPassWallet {
    private let walletAvailabilityChecker: WalletAvailabilityChecking

    public init(walletAvailabilityChecker: WalletAvailabilityChecking = SystemWalletAvailabilityChecker()) {
        self.walletAvailabilityChecker = walletAvailabilityChecker
    }

    public func isWalletAvailable() -> Bool {
        walletAvailabilityChecker.canAddPasses()
    }

    public func savePassToWallet(iosPkPassBase64: String) throws {
        guard !iosPkPassBase64.isEmpty else {
            throw EGYMWalletError.invalidPayload
        }
    }

    public func readPassFromWallet(iosPkPassBase64: String) throws -> Bool {
        guard !iosPkPassBase64.isEmpty else {
            throw EGYMWalletError.invalidPayload
        }
        return false
    }
}
