// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Safari",
    platforms: [
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "Safari",
            targets: ["Safari"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", exact: "0.51.7")
    ],
    targets: [
        .target(
            name: "Safari",
            dependencies: []
        ),
        .testTarget(
            name: "SafariTests",
            dependencies: ["Safari"]
        ),
    ]
)
