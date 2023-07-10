# ``SafariView``

SafariServices in SwiftUI

## Overview

`SafariView` is a wrapper around [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) for use within SwiftUI applications. The view includes Safari features such as Reader, AutoFill, Fraudulent Website Detection, and content blocking. The user's activity and interaction with `SafariView` are not visible to your app, which cannot access AutoFill data, browsing history, or website data. You do not need to secure data between your app and Safari. If you would like to share data between your app and Safari, so it is easier for a user to log in only one time, use [`ASWebAuthenticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instead.

- Important: In accordance with [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), this view must be used to visibly present information to users; the view may not be hidden or obscured by other views or layers. Additionally, an app may not use `SafariView` to track users without their knowledge and consent.

UI features include the following:
- A read-only address field with a security indicator and a Reader button
- An Action button that invokes an activity view controller offering custom services from your app, and activities, such as messaging, from the system and other extensions
- A Done button, back and forward navigation buttons, and a button to open the page directly in Safari

The library contains a single `View`-conforming struct, also named `SafariView`, as well as several view modifiers used to control the appearance, behavior and presentation of a ``SafariView/SafariView``

- Note: In Mac apps built with Mac Catalyst, SafariView launches the default web browser instead of displaying a modal window. SafariView is not compatible with macOS, tvOS, or watchOS.

## Topics

### Views

- ``SafariView``

### Modifiers

- ``SwiftUI/View``

### Environment

- ``SwiftUI/EnvironmentValues``
