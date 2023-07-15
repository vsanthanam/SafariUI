#  ``SafariView/SafariView``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

A SafariView is best presented by using one the `safari` view modifiers, or via sheet presentation, though it does work in other scenarios as well. For configuration, appearance, and presentation options, see the documentation for the included view modifiers here: ``SwiftUI/View``.

## Topics

### Creating a Safari View

- ``init(url:onInitialLoad:onInitialRedirect:onOpenInBrowser:)``

### Configuring the View

- ``Configuration``
- ``ActivityButton``
- ``DismissButtonStyle``

### Custom Activities

- ``IncludedActivities``
- ``ExcludedActivityTypes``

### Connection Prewarming

- ``prewarmConnections(to:)``
- ``PrewarmingToken``

### Data Management

- ``clearWebsiteData()``
- ``clearWebsiteData(completionHandler:)``
