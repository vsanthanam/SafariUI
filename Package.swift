// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SafariUI",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "SafariUI",
            targets: ["SafariUI"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.51.15")
    ],
    targets: [
        .target(
            name: "SafariUI",
            dependencies: []
        ),
        .testTarget(
            name: "SafariUITests",
            dependencies: ["SafariUI"]
        ),
    ]
)
