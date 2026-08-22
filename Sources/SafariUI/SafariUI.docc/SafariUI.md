# ``SafariUI``

SafariServices in SwiftUI

## Overview

`SafariUI` is a package that allows you to display instances of Safari inside your SwiftUI applications. Use ``WebAuthentication`` when using Safari to authenticate users, and ``SafariView`` for a standard Safari experience.

Both `WebAuthentication` and `SafariView` are separate modules that can be imported individually, or together using the `SafariUI` module.

- Note: The package contains multiple modules. You can depend on the whole library by importing the `SafariUI` module, or you can depend on individual modules like `SafariView` or `WebAuthentication` as needed.

`SafariView` is available on iOS and Mac Catalyst. `WebAuthentication` is available on iOS, Mac Catalyst, macOS, watchOS, and tvOS. Both modules declare their API on every platform; API that cannot be supported on a given platform is marked unavailable.

## Topics

### Views

- ``SafariView``

### Structures

- ``WebAuthentication``

### View Modifiers

- ``SwiftUICore/View``
