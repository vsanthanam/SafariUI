# ``SafariView/IncludedActivities``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

You can initialize instances of this type using an array literal of `UIActivity` values. For example:

```swift
let excluded: SafariView.IncludedActivities = [someActivity, someOtherActivity]
```

To change the the included activities used by ``SafariView`` at the current scope, use the ``SwiftUI/View/includedSafariActivities(_:)-5y6z0`` view modifier, or the ``SwiftUI/EnvironmentValues/safariViewIncludedActivities`` environment value.

## Topics

### Initializers

- ``init(_:)-b58a``
- ``init(_:)-7gbd7``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``init(arrayLiteral:)``
- ``ArrayLiteralElement``
