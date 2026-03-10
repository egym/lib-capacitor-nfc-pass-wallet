// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "EGYMNFCPassWallet",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "EGYMNFCPassWallet", targets: ["EGYMNFCPassWallet"])
    ],
    targets: [
        .target(
            name: "EGYMNFCPassWallet",
            dependencies: []
        ),
        .testTarget(
            name: "EGYMNFCPassWalletTests",
            dependencies: ["EGYMNFCPassWallet"]
        )
    ]
)
