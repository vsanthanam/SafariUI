# ``SafariView/ExcludedActivityTypes``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

You can initialize instances of this type using an array literal of `UIActivity.ActivityType` values. For example:

```swift
let excluded: SafariView.ExcludedActivityTypes = [.addToReadingList, .airDrop, .print, .sharePlay]
```

To change the the excluded activity types used by ``SafariView`` at the current scope, use the ``SwiftUI/View/excludedSafariActivityTypes(_:)-4omxw`` view modifier, or the ``SwiftUI/EnvironmentValues/safariViewExcludedActivityTypes`` environment value.

## Topics

### Initializers

- ``init(_:)-92zvd``
- ``init(_:)-93kn9``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``ArrayLiteralElement``
- ``init(arrayLiteral:)``
