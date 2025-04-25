# ``SafariView/IncludedActivities``

## Overview

You can initialize instances of this type using an array literal of `UIActivity` values. For example:

```swift
let excluded: SafariView.IncludedActivities = [someActivity, someOtherActivity]
```

To change the the included activities used by ``SafariView`` at the current scope, use the ``SwiftUICore/View/includedSafariActivities(_:)-2u8l9`` view modifier, or the ``SwiftUICore/EnvironmentValues/safariViewIncludedActivities`` environment value.

## Topics

### Initializers

- ``init(_:)-([UIActivity])``
- ``init(_:)-((URL,String?)->[UIActivity])``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``init(arrayLiteral:)``
- ``ArrayLiteralElement``
