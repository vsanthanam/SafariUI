# ``SafariView/SafariView/IncludedActivities``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

You can initialize instances of this type using an array literal of `UIActivity` values. For example:

```swift
let excluded: SafariView.IncludedActivities = [someActivity, someOtherActivity]
```

To change the the included activities used by ``SafariView`` at the current scope, use the ``SwiftUI/View/includedSafariActivities(_:)-2u8l9`` view modifier, or the ``SwiftUI/EnvironmentValues/safariViewIncludedActivities`` environment value.

## Topics

### Initializers

- ``init(_:)-6d955``
- ``init(_:)-9q5v6``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``init(arrayLiteral:)``
- ``ArrayLiteralElement``
