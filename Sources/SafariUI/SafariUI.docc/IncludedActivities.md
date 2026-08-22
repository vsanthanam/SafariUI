# ``SafariView/IncludedActivities``

## Overview

You can initialize instances of this type using an array literal of `UIActivity` values. For example:

```swift
let included: SafariView.IncludedActivities = [someActivity, someOtherActivity]
```

To change the included activities used by ``SafariView`` at the current scope, use the ``SwiftUICore/View/safariViewIncludedActivities(_:)-(SafariView.IncludedActivities)`` view modifier to replace the current value, or the ``SwiftUICore/View/includingSafariViewActivities(_:)-(SafariView.IncludedActivities)`` view modifier to append to it.

## Topics

### Initializers

- ``init(_:)-([UIActivity])``
- ``init(_:)-f33s``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``init(arrayLiteral:)``
- ``ArrayLiteralElement``
