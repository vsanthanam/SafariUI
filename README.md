# Safari

[![MIT License](https://img.shields.io/github/license/vsanthanam/SafariView)](https://github.com/vsanthanam/SafariView/blob/main/LICENSE)
[![Package Releases](https://img.shields.io/github/v/release/vsanthanam/SafariView)](https://github.com/vsanthanam/SafariView/releases)
[![Build Statis](https://img.shields.io/github/actions/workflow/status/vsanthanam/SafariView/xcodebuild-build-test.yml)](https://github.com/vsanthanam/SafariView/actions)
[![Swift Version](https://img.shields.io/badge/swift-5.8-critical)](https://swift.org)
[![Supported Platforms](https://img.shields.io/badge/platform-iOS%2014.0%20%7C%20Catalyst%2014.0-lightgrey)](https://developer.apple.com)

A SwiftUI wrapper around [`SafariServices`](https://developer.apple.com/documentation/safariservices/)

## Installation

Safari currently distributed exclusively through the [Swift Package Manager](https://www.swift.org/package-manager/). 

To add Safari as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/vsanthanam/SafariView.git", .upToNextMajor(from: "2.0.0"))
]
```

To add Safari as a dependency to an Xcode Project: 

- Choose `File` → `Add Packages...`
- Enter package URL `https://github.com/vsanthanam/SafariView.git` and select your release and of choice.

Other distribution mechanisms like CocoaPods or Carthage may be added in the future.

## Usage & Documentation

Safari's documentation is built with [DocC](https://developer.apple.com/documentation/docc) and included in the repository as a DocC archive. The latest version is hosted on [GitHub Pages](https://pages.github.com) and is available [here](https://vsanthanam.github.io/SafariView/docs/documentation/safari).

Additional installation instructions are available on the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/SafariView)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FSafariView%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/vsanthanam/SafariView)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FSafariView%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/vsanthanam/SafariView)

Explore [the documentation](https://vsanthanam.github.io/SafariView/docs/documentation/safari) for more details.

## License

**Safari** is available under the MIT license. See the LICENSE file for more information.
