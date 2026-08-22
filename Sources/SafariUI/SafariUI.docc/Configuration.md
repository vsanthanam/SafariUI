# ``SafariView/Configuration``

## Overview

Use a `Configuration` to control the behavior of a ``SafariView``, such as whether it should enter Reader mode automatically or collapse its bars when the user scrolls.

Apply a configuration to the views at the current scope using the ``SwiftUICore/View/safariViewConfiguration(_:)`` view modifier:

```swift
Text("Read Article")
    .safariView(isPresented: $isPresented, url: articleURL)
    .safariViewConfiguration(
        .init(entersReaderIfAvailable: true)
    )
```

- Important: Configuration values are consumed once, when the underlying `SFSafariViewController` is created — when an embedded ``SafariView`` first appears, or when a presentation modifier presents one. Changing them after that point has no effect on an existing view; the new values apply to the next Safari view that is created or presented.

## Topics

### Creating a Configuration

- ``init(entersReaderIfAvailable:barCollapsingEnabled:)``
- ``init(entersReaderIfAvailable:barCollapsingEnabled:activityButton:)``
- ``init(entersReaderIfAvailable:barCollapsingEnabled:activityButton:eventAttribution:)``
- ``default``

### Configuration Options

- ``entersReaderIfAvailable``
- ``barCollapsingEnabled``
- ``activityButton``
- ``eventAttribution``
