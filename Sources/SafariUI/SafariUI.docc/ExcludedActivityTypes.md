# ``SafariView/ExcludedActivityTypes``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

You can initialize instances of this type using an array literal of `UIActivity.ActivityType` values. For example:

```swift
let excluded: SafariView.ExcludedActivityTypes = [.addToReadingList, .airDrop, .print, .sharePlay]
```

To change the the excluded activity types used by ``SafariView`` at the current scope, use the ``SwiftUI/View/excludedSafariActivityTypes(_:)-tvrg`` view modifier, or the ``SwiftUI/EnvironmentValues/safariViewExcludedActivityTypes`` environment value.

## Topics

### Initializers

- ``init(_:)-1ktmq``
- ``init(_:)-67duh``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``ArrayLiteralElement``
- ``init(arrayLiteral:)``
