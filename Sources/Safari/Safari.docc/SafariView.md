#  ``SafariView``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

The view includes Safari features such as Reader, AutoFill, Fraudulent Website Detection, and content blocking. The user's activity and interaction with `SafariView` are not visible to your app, which cannot access AutoFill data, browsing history, or website data. You do not need to secure data between your app and Safari. If you would like to share data between your app and Safari, so it is easier for a user to log in only one time, use [`ASWebAuthenticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instead.

- Important: In accordance with [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), this view must be used to visibly present information to users; the view may not be hidden or obscured by other views or layers. Additionally, an app may not use `SafariView` to track users without their knowledge and consent.

UI features include the following:
- A read-only address field with a security indicator and a Reader button
- An Action button that invokes an activity view controller offering custom services from your app, and activities, such as messaging, from the system and other extensions
- A Done button, back and forward navigation buttons, and a button to open the page directly in Safari

- Note: In Mac apps built with Mac Catalyst, SafariView launches the default web browser instead of displaying a modal window. SafariView is not compatible with macOS, tvOS, or watchOS.

You can present a `SafariView` using the built-in presentation view modifiers:

- ``SwiftUI/View/safari(isPresented:onDismiss:safariView:)``
- ``SwiftUI/View/safari(url:onDismiss:safariView:)``
- ``SwiftUI/View/safari(item:onDismiss:safariView:)``
- ``SwiftUI/View/safari(item:id:onDismiss:safariView:)``

You can also use sheet presentation, or any other presentation mechanism of your choice.

## Topics

### Creating a Safari View

- ``init(url:onInitialLoad:onInitialRedirect:onOpenInBrowser:)``
- ``init(url:activityButton:onInitialLoad:onInitialRedirect:onOpenInBrowser:)``
- ``init(url:activityButton:eventAttribution:onInitialLoad:onInitialRedirect:onOpenInBrowser:)``

### Configuration

- ``SwiftUI/View/safariEntersReaderIfAvailable(_:)``
- ``SwiftUI/View/safariBarCollapsingEnabled(_:)``

### Appearance

- ``SwiftUI/View/safariBarTintColor(_:)``
- ``SwiftUI/View/safariControlTintColor(_:)``
- ``SwiftUI/View/safariDismissButtonStyle(_:)``
- ``DismissButtonStyle``

### Presentation

- ``SwiftUI/View/safari(isPresented:onDismiss:safariView:)``
- ``SwiftUI/View/safari(url:onDismiss:safariView:)``
- ``SwiftUI/View/safari(item:onDismiss:safariView:)``
- ``SwiftUI/View/safari(item:id:onDismiss:safariView:)``

### Connection Prewarming

- ``prewarmConnections(to:)``
- ``PrewarmingToken``

### Data Management

- ``clearWebsiteData()``
- ``clearWebsiteData(completionHandler:)``

### Custom Activities

- ``SwiftUI/View/includedSafariActivities(_:)-6530n``
- ``SwiftUI/View/includedSafariActivities(_:)-5y6z0``
- ``IncludedActivities``
- ``SwiftUI/View/excludedSafariActivityTypes(_:)-xd5l``
- ``SwiftUI/View/excludedSafariActivityTypes(_:)-3j01b``
- ``ExcludedActivityTypes``

### Environment Values

- ``SwiftUI/EnvironmentValues/safariViewIncludedActivities``
- ``SwiftUI/EnvironmentValues/safariViewExcludedActivityTypes``
