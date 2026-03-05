import XCTest
@testable import EGYMNFCPassWallet

private struct MockWalletAvailabilityChecker: WalletAvailabilityChecking {
    let canAddPassesResult: Bool

    func canAddPasses() -> Bool {
        canAddPassesResult
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
        let sdk = EGYMNFCPassWallet()

        let result = try sdk.readPassFromWallet(iosPkPassBase64: "base64-pkpass")

        XCTAssertFalse(result)
    }
}
