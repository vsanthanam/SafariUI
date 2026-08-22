// SafariUI
// Modifiers.swift
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

import SwiftUI

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, watchOS 7.0, *)
@available(tvOS, unavailable)
extension View {

    /// Set whether web authentication sessions within this view should ask the browser for a private authentication session
    ///
    /// - Important: The value is consumed when a session starts. Changing it has no effect on a session that is already running; the new value applies to the next session that starts.
    /// - Parameter prefersEphemeralWebBrowserSession: Whether the session should ask the browser for a private authentication session
    /// - Returns: The modified view
    public func webAuthenticationPrefersEphemeralWebBrowserSession(
        _ prefersEphemeralWebBrowserSession: Bool = true
    ) -> some View {
        modifier(
            WebAuthenticationPrefersEphemeralWebBrowserSessionModifier(
                prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession
            )
        )
    }

}

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, watchOS 7.0, *)
@available(tvOS, unavailable)
private struct WebAuthenticationPrefersEphemeralWebBrowserSessionModifier: ViewModifier {

    let prefersEphemeralWebBrowserSession: Bool

    func body(content: Content) -> some View {
        content
            .environment(
                \.webAuthenticationPrefersEphemeralWebBrowserSession,
                prefersEphemeralWebBrowserSession
            )
    }

}
