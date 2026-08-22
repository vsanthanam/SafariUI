# ``SafariView``

## Overview

The view includes Safari features such as Reader, AutoFill, Fraudulent Website Detection, and content blocking. The user's activity and interaction with `SafariView` are not visible to your app, which cannot access AutoFill data, browsing history, or website data. You do not need to secure data between your app and Safari. If you would like to share data between your app and Safari, so it is easier for a user to log in only one time, use ``WebAuthentication`` instead.

- Important: In accordance with [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), this view must be used to visibly present information to users; the view may not be hidden or obscured by other views or layers. Additionally, an app may not use `SafariView` to track users without their knowledge and consent.

UI features include the following:
- A read-only address field with a security indicator and a Reader button
- An Action button that invokes an activity view controller offering custom services from your app, and activities, such as messaging, from the system and other extensions
- A Done button, back and forward navigation buttons, and a button to open the page directly in Safari

- Note: In Mac apps built with Mac Catalyst, SafariView launches the default web browser instead of displaying a modal window. SafariView's API is visible on macOS, tvOS, and watchOS, but marked unavailable.

You can present a `SafariView` using the built-in presentation view modifiers:

- ``SwiftUICore/View/safariView(_:isPresented:url:)``
- ``SwiftUICore/View/safariView(_:item:url:)``
- ``SwiftUICore/View/safariView(_:item:id:url:)``
- ``SwiftUICore/View/safariView(_:url:)``

These modifiers use the standard presentation mechanism that you would otherwise use to present an `SFSafariViewController` in a UIKit application. To customize the behavior of the modifiers, see the ``SafariView/PresentationStyle`` enumeration.

A `SafariView` is also a regular SwiftUI view, and can be embedded in your view hierarchy or presented through any other mechanism of your choice. The view always displays its current `url`: if the value changes, the view is recreated to load the new URL.

Appearance and configuration are controlled with environment-based view modifiers applied to the presenting view, such as ``SwiftUICore/View/safariViewConfiguration(_:)`` and ``SwiftUICore/View/safariViewDismissButtonStyle(_:)``. Delegate callbacks are surfaced the same way, using modifiers such as ``SwiftUICore/View/safariViewOnDismiss(_:)``.

## Topics

### Creating a Safari View

- ``init(url:)``

### Configuration

- ``Configuration``

### Appearance

- ``DismissButtonStyle``

### Presentation Options

- ``PresentationStyle``

### Connection Prewarming

- ``prewarmConnections(to:)``
- ``PrewarmingToken``

### Data Management

- ``clearWebsiteData()``

### Custom Activities

- ``IncludedActivities``
- ``ExcludedActivityTypes``
- ``ActivityButton``
