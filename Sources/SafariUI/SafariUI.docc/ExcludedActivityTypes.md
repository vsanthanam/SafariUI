# ``SafariView/ExcludedActivityTypes``

## Overview

You can initialize instances of this type using an array literal of `UIActivity.ActivityType` values. For example:

```swift
let excluded: SafariView.ExcludedActivityTypes = [.addToReadingList, .airDrop, .print, .sharePlay]
```

To change the excluded activity types used by ``SafariView`` at the current scope, use the ``SwiftUICore/View/safariViewExcludedActivityTypes(_:)-(SafariView.ExcludedActivityTypes)`` view modifier to replace the current value, or the ``SwiftUICore/View/excludingSafariViewActivityTypes(_:)-(SafariView.ExcludedActivityTypes)`` view modifier to append to it.

## Topics

### Initializers

- ``init(_:)-([UIActivity.ActivityType])``
- ``init(_:)-3s2tk``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``init(arrayLiteral:)``
- ``ArrayLiteralElement``
