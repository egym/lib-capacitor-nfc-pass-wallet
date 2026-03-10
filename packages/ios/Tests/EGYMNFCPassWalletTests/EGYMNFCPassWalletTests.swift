import XCTest
@testable import EGYMNFCPassWallet

private struct MockWalletAvailabilityChecker: WalletAvailabilityChecking {
    let canAddPassesResult: Bool

    func canAddPasses() -> Bool {
        canAddPassesResult
    }
}

private final class MockPassKitManager: PassKitManaging {
    var containsPassResult = false
    var containsPassError: Error?
    var presentAddPassesCalled = false

    func containsPass(passData _: Data) throws -> Bool {
        if let containsPassError {
            throw containsPassError
        }

        return containsPassResult
    }

    func presentAddPasses(passData _: Data) throws {
        presentAddPassesCalled = true
    }
}

final class EGYMNFCPassWalletTests: XCTestCase {
    func testThrowsForEmptyPayload() {
        let sdk = EGYMNFCPassWallet()
        XCTAssertThrowsError(try sdk.savePassToWallet(iosPkPassBase64: ""))
    }

    func testIsWalletAvailableReturnsTrueWhenCheckerReturnsTrue() {
        let sdk = EGYMNFCPassWallet(
            walletAvailabilityChecker: MockWalletAvailabilityChecker(canAddPassesResult: true)
        )

        XCTAssertTrue(sdk.isWalletAvailable())
    }

    func testIsWalletAvailableReturnsFalseWhenCheckerReturnsFalse() {
        let sdk = EGYMNFCPassWallet(
            walletAvailabilityChecker: MockWalletAvailabilityChecker(canAddPassesResult: false)
        )

        XCTAssertFalse(sdk.isWalletAvailable())
    }

    func testReadPassFromWalletThrowsForEmptyPayload() {
        let sdk = EGYMNFCPassWallet()

        XCTAssertThrowsError(try sdk.readPassFromWallet(iosPkPassBase64: ""))
    }

    func testReadPassFromWalletReturnsFalseForNonEmptyPayload() throws {
        let passKitManager = MockPassKitManager()
        passKitManager.containsPassResult = false
        let sdk = EGYMNFCPassWallet(
            passKitManager: passKitManager
        )

        let result = try sdk.readPassFromWallet(iosPkPassBase64: "AQID")

        XCTAssertFalse(result)
    }

    func testSavePassToWalletThrowsUnavailableWhenWalletUnavailable() {
        let sdk = EGYMNFCPassWallet(
            walletAvailabilityChecker: MockWalletAvailabilityChecker(canAddPassesResult: false)
        )

        XCTAssertThrowsError(try sdk.savePassToWallet(iosPkPassBase64: "AQID"))
    }

    func testSavePassToWalletChecksPassPresenceWhenWalletAvailable() throws {
        let passKitManager = MockPassKitManager()
        passKitManager.containsPassResult = true

        let sdk = EGYMNFCPassWallet(
            walletAvailabilityChecker: MockWalletAvailabilityChecker(canAddPassesResult: true),
            passKitManager: passKitManager
        )

        XCTAssertNoThrow(try sdk.savePassToWallet(iosPkPassBase64: "AQID"))
        XCTAssertFalse(passKitManager.presentAddPassesCalled)
    }

    func testSavePassToWalletPresentsAddPassesWhenPassMissing() throws {
        let passKitManager = MockPassKitManager()
        passKitManager.containsPassResult = false

        let sdk = EGYMNFCPassWallet(
            walletAvailabilityChecker: MockWalletAvailabilityChecker(canAddPassesResult: true),
            passKitManager: passKitManager
        )

        XCTAssertNoThrow(try sdk.savePassToWallet(iosPkPassBase64: "AQID"))
        XCTAssertTrue(passKitManager.presentAddPassesCalled)
    }
}
