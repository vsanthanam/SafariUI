// swift-tools-version: 6.1
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
            targets: [
                "SafariUI"
            ]
        ),
        .library(
            name: "SafariView",
            targets: [
                "SafariView"
            ]
        ),
        .library(
            name: "WebAuthentication",
            targets: [
                "WebAuthentication"
            ]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-docc-plugin",
            from: "1.0.0"
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            exact: "0.55.5"
        )
    ],
    targets: [
        .target(
            name: "SafariUI",
            dependencies: [
                "SafariView",
                "WebAuthentication"
            ],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .target(
            name: "SafariView",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
        .target(
            name: "WebAuthentication",
            dependencies: [],
            swiftSettings: [
                .enableUpcomingFeature("StrictConcurrency=complete")
            ]
        ),
    ]
)
