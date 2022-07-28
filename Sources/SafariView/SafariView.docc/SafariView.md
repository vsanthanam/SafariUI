# ``SafariView``

SafariServices in SwiftUI

## Overview

SafariView is a SwiftUI wrapper around [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) You can present a `SafariView` using our provided view modifiers:

Using a `Binding<Bool>`:

```swift
extension View {
    func safari(isPresented: Binding<Bool>,
                onDismiss: (() -> Void)? = nil,
                safariView: @escaping () -> SafariView) -> some View
}
```

Using a `Binding<URL>`:

```swift
extension View {
    func safari(url: Binding<URL?>,
                onDismiss: (() -> Void)? = nil,
                safariView: @escaping (URL) -> SafariView) -> some View
}
```

Using a generic `Binding`:

```swift
extension View {
    func safari<Item>(item: Binding<Item?>,
                      onDismiss: (() -> Void)? = nil,
                      safariView: @escaping (Item) -> SafariView) -> some View where Item: Identifiable
}
```

Alternatively, you can use sheet presentation or any other presentation mechanism of your choosing.

The library contains a single `View`-conforming struct, also named `SafariView`

## Topics

### Views

- ``SafariView/SafariView``
