# ``SafariView/ExcludedActivityTypes``

## Overview

You can initialize instances of this type using an array literal of `UIActivity.ActivityType` values. For example:

```swift
let excluded: SafariView.ExcludedActivityTypes = [.addToReadingList, .airDrop, .print, .sharePlay]
```

To change the the excluded activity types used by ``SafariView`` at the current scope, use the ``SwiftUICore/View/excludedSafariActivityTypes(_:)-tvrg`` view modifier, or the ``SwiftUICore/EnvironmentValues/safariViewExcludedActivityTypes`` environment value.

## Topics

### Initializers

- ``init(_:)-([UIActivity.ActivityType])``
- ``init(_:)-((URL,String?)->[UIActivity.ActivityType])``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``ArrayLiteralElement``
- ``init(arrayLiteral:)``
