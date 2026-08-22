// SafariUI
// WebAuthentication.swift
//
// MIT License
//
// Copyright (c) 2023 Varun Santhanam
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the  Software), to deal
//
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED  AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import AuthenticationServices
import Foundation

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, tvOS 16.0, watchOS 7.0, *)
public struct WebAuthentication {

    /// Create a web authentication session with a custom callback URL scheme
    ///
    /// A `WebAuthentication` can only be displayed using one of the provided presentation view modifiers; it cannot be displayed any other way.
    /// - Parameters:
    ///   - url: The URL pointing to the authentication page
    ///   - callbackURLScheme: The custom URL scheme that the app expects when receiving the authentication callback
    ///   - completionHandler: The closure invoked with the callback URL when the session completes, or with an error if the session fails or is canceled
    public init(
        url: URL,
        callbackURLScheme: String?,
        completionHandler: @escaping CompletionHandler
    ) {
        self.url = url
        self.callbackURLScheme = callbackURLScheme
        self.completionHandler = completionHandler
    }

    /// Create a web authentication session with a callback
    ///
    /// Unlike the callback URL scheme initializer, a ``Callback`` can also match `https` callbacks with a specific host and path.
    ///
    /// A `WebAuthentication` can only be displayed using one of the provided presentation view modifiers; it cannot be displayed any other way.
    /// - Parameters:
    ///   - url: The URL pointing to the authentication page
    ///   - callback: The callback that the app expects when the authentication completes
    ///   - completionHandler: The closure invoked with the callback URL when the session completes, or with an error if the session fails or is canceled
    @available(iOS 17.4, macCatalyst 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *)
    public init(
        url: URL,
        callback: Callback,
        completionHandler: @escaping CompletionHandler
    ) {
        self.url = url
        callbackURLScheme = nil
        storedCallback = callback
        self.completionHandler = completionHandler
    }

    /// A completion handler for the web authentication session.
    public typealias CompletionHandler = @MainActor (Result<URL, any Error>) -> Void

    /// A convenience typealias for [`ASWebAuthenticationSession.Callback`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession/callback)
    @available(iOS 17.4, macCatalyst 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *)
    public typealias Callback = ASWebAuthenticationSession.Callback

    let url: URL
    let callbackURLScheme: String?
    let completionHandler: CompletionHandler

    @available(iOS 17.4, macCatalyst 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *)
    var callback: Callback? {
        guard let storedCallback else {
            return nil
        }
        return unsafeDowncast(
            storedCallback,
            to: Callback.self
        )
    }

    /// Stored type-erased because stored properties cannot be availability-gated.
    private var storedCallback: AnyObject?

}
