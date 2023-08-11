# ``SafariView/IncludedActivities``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

You can initialize instances of this type using an array literal of `UIActivity` values. For example:

```swift
let excluded: SafariView.IncludedActivities = [someActivity, someOtherActivity]
```

To change the the included activities used by ``SafariView`` at the current scope, use the ``SwiftUI/View/includedSafariActivities(_:)-7buso`` view modifier, or the ``SwiftUI/EnvironmentValues/safariViewIncludedActivities`` environment value.

## Topics

### Initializers

- ``init(_:)-6ig8b``
- ``init(_:)-43y6f``

### Operators

- ``+(_:_:)``

### Literal Expression Support

- ``init(arrayLiteral:)``
- ``ArrayLiteralElement``
