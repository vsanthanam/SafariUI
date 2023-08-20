#  ``WebAuthentication``

@Metadata {
    @DocumentationExtension(mergeBehavior: append)
}

## Overview

Use a `WebAuthentication` instance to authenticate a user through a web service, including one run by a third party. Initialize the session with a URL that points to the authentication webpage. When the user starts the authentication session, the operating system shows a modal view telling them which domain the app is authenticating with and asking whether to proceed. If the user proceeds with the authentication attempt, a browser loads and displays the page, from which the user can authenticate. In iOS, the browser is a secure, embedded web view. In macOS, the system opens the user’s default browser if it supports web authentication sessions, or Safari otherwise.

On completion, the service sends a callback URL to the session with an authentication token. The session passes this URL back to the app through a completion handler. `AuthenticationSession` ensures that only the calling app’s session receives the authentication callback, even when more than one app registers the same callback URL scheme.

`WebAuthentication` is not a normal SwiftUI view. Unlike ``SafariView``, **must** be presented using one of the following included view modifiers:

- ``SwiftUI/View/webAuthentication(_:webAuthentication:)-74m38``
- ``SwiftUI/View/webAuthentication(_:webAuthentication:)-5x82p``
- ``SwiftUI/View/webAuthentication(_:id:webAuthentication:)``
