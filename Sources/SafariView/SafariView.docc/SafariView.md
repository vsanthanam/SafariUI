# ``SafariView``

SafariServices in SwiftUI

## Overview

SafariView is a SwiftUI wrapper around [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) You can present a `SafariView` using our provided view modifiers:

- Using a `Binding<Bool>`: `safari(isPresented:onDismiss:safariView)`
- Using a generic `Binding`: `safari(item:onDismiss:safariView)`
- Using a `Binding<URL>`: `safari(url:onDismiss:safariView)`
s
Alternatively, you can use sheet presentation or any other presentation mechanism of your choosing.

The library contains a single `View`-conforming struct, also named `SafariView`

## Topics

### Views

- ``SafariView/SafariView``
