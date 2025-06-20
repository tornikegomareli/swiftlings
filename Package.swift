// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Swiftlings",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "swiftlings",
            targets: ["Swiftlings"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.5.0"),
        .package(url: "https://github.com/onevcat/Rainbow", from: "4.0.0"),
        .package(url: "https://github.com/JohnSundell/ShellOut", from: "2.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "Swiftlings",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Rainbow", package: "Rainbow"),
                .product(name: "ShellOut", package: "ShellOut"),
            ]),
        .testTarget(
            name: "SwiftlingsTests",
            dependencies: ["Swiftlings"]
        ),
    ]
)
