# SafariUI

[![MIT License](https://img.shields.io/github/license/vsanthanam/SafariUI)](https://github.com/vsanthanam/SafariUI/blob/main/LICENSE)
[![Package Releases](https://img.shields.io/github/v/release/vsanthanam/SafariUI)](https://github.com/vsanthanam/SafariUI/releases)
[![Build Status](https://img.shields.io/github/actions/workflow/status/vsanthanam/SafariUI/xcodebuild-build-test.yml)](https://github.com/vsanthanam/SafariUI/actions)
[![Swift Version](https://img.shields.io/badge/swift-5.8-critical)](https://swift.org)
[![Supported Platforms](https://img.shields.io/badge/platform-iOS%2014.0%20%7C%20Catalyst%2014.0-lightgrey)](https://developer.apple.com)

A SwiftUI wrappers for `SFSafariViewController` and `ASWebAuthenticationSession`

## Installation

SafariUI currently distributed exclusively through the [Swift Package Manager](https://www.swift.org/package-manager/). 

To add SafariUI as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/vsanthanam/SafariUI.git", .upToNextMajor(from: "2.0.0"))
]
```

To add SafariUI as a dependency to an Xcode Project: 

- Choose `File` → `Add Packages...`
- Enter package URL `https://github.com/vsanthanam/SafariUI.git` and select your release and of choice.

Other distribution mechanisms like CocoaPods or Carthage may be added in the future.

*Note: The package contains multiple modules. You can import all of the provided tools using the `SwiftUI` modules, or individual modules like `SafariView` and `WebAuthentication` as needed.*

## Usage & Documentation

SafariUI's documentation is built with [DocC](https://developer.apple.com/documentation/docc) and included in the repository as a DocC archive. The latest version is hosted on [GitHub Pages](https://pages.github.com) and is available [here](https://vsanthanam.github.io/SafariUI/docs/documentation/safariui).

Additional installation instructions are available on the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/SafariUI)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FSafariUI%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/vsanthanam/SafariUI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FSafariUI%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/vsanthanam/SafariUI)

Explore [the documentation](https://vsanthanam.github.io/SafariUI/docs/documentation/safariui) for more details.

## License

**SafariUI** is available under the MIT license. See the LICENSE file for more information.
