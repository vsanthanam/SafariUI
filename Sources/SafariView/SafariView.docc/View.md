#  ``SafariView/SafariView``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

A `SafariView` is a wrapper around [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) for use within SwiftUI applications. The view includes Safari features such as Reader, AutoFill, Fraudulent Website Detection, and content blocking. The user's activity and interaction with `SafariView` are not visible to your app, which cannot access AutoFill data, browsing history, or website data. You do not need to secure data between your app and Safari. If you would like to share data between your app and Safari, so it is easier for a user to log in only one time, use [`ASWebAuthenticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) instead.

- Important: In accordance with [App Store Review Guidelines](https://developer.apple.com/app-store/review/guidelines/), this view must be used to visibly present information to users; the view may not be hidden or obscured by other views or layers. Additionally, an app may not use `SafariView` to track users without their knowledge and consent.

UI features include the following:
- A read-only address field with a security indicator and a Reader button
- An Action button that invokes an activity view controller offering custom services from your app, and activities, such as messaging, from the system and other extensions
- A Done button, back and forward navigation buttons, and a button to open the page directly in Safari
- On devices that support 3D Touch, automatic Peek and Pop for links and detected data

To learn about 3D Touch, see [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines/) and [Adopting 3D Touch on iPhone](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/Adopting3DTouchOniPhone/index.html#//apple_ref/doc/uid/TP40016543).

You can present a `SafariView` using one of our provided view modifiers, like so:

```swift
import Foundation
import SafariView
import SwiftUI

struct ShowLicenseAgreement: View {

    let licenseAgreementURL: URL

    @State private var isShowingSafari = false

    var body: some View {
        Button(action: {
            isShowingSafari.toggle()
        }) {
            Text("Show License Agreement")
        }
       .safari(isPresented: $isShowingSafari,
               onDismiss: didDismiss) {
           SafariView(url: licenseAgreementURL)
        }
    }

}
```

You can also use sheet presentation, or any other presentation mechanism of your choice.

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
