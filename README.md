# SafariUI

[![MIT License](https://img.shields.io/github/license/vsanthanam/SafariUI)](https://github.com/vsanthanam/SafariUI/blob/main/LICENSE)
[![GitHub Release](https://img.shields.io/github/v/release/vsanthanam/SafariUI?include_prereleases)](https://github.com/vsanthanam/SafariUI/releases)
[![Build Status](https://img.shields.io/github/check-runs/vsanthanam/SafariUI/main)](https://github.com/vsanthanam/SafariUI/actions)
[![Swift Version](https://img.shields.io/badge/swift-6.1-critical)](https://swift.org)
[![Documentation](https://img.shields.io/badge/Documentation-GitHub-8A2BE2)](https://www.safariui.com/docs/documentation/safariui)

SwiftUI wrappers for `SFSafariViewController` and `ASWebAuthenticationSession`

## Installation

SafariUI currently distributed exclusively through the [Swift Package Manager](https://www.swift.org/package-manager/). 

To add SafariUI as a dependency to an existing Swift package, add the following line of code to the `dependencies` parameter of your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/vsanthanam/SafariUI.git", .upToNextMajor(from: "4.0.0"))
]
```

To add SafariUI as a dependency to an Xcode Project: 

- Choose `File` → `Add Packages...`
- Enter package URL `https://github.com/vsanthanam/SafariUI.git` and select your release and of choice.

Other distribution mechanisms like CocoaPods or Carthage may be added in the future.

*Note: The package contains multiple modules. You can depend on the whole library by importing the `SwiftUI` module, or you can depend on individual modules like `SafariView` or `WebAuthentication` as needed.*

## Usage & Documentation

SafariUI's documentation is built with [DocC](https://developer.apple.com/documentation/docc) and included in the repository as a DocC archive. The latest version is hosted on [GitHub Pages](https://pages.github.com) and is available [here](https://www.safariui.com/docs/documentation/safariui)).

Additional installation instructions are available on the [Swift Package Index](https://swiftpackageindex.com/vsanthanam/SafariUI)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FSafariUI%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/vsanthanam/SafariUI)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fvsanthanam%2FSafariUI%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/vsanthanam/SafariUI)

Explore [the documentation](https://www.safariui.com/docs/documentation/safariui) for more details.

## License

**SafariUI** is available under the [MIT license](https://en.wikipedia.org/wiki/MIT_License). See the [LICENSE](https://github.com/vsanthanam/SafariUI/blob/main/LICENSE) file for more information.