// SafariUI
// Modifiers.swift
//
// MIT License
//
// Copyright (c) 2021 Varun Santhanam
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

public extension View {

    /// Set the private authentication requirements for authentication sessions within this view.
    ///
    /// This modifier is the equivelent of the of the [`prefersEphemeralWebBrowserSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession/3237231-prefersephemeralwebbrowsersessio) property of a [`ASWebAuthnticationSession`](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession)
    ///
    /// - Parameter prefersEphemeralWebBrowserSession: Whether or not the web authentication session should ask for a private authentication session.
    /// - Returns: The modified view
    func webAuthenticationPrefersEphemeralWebBrowserSession(_ prefersEphemeralWebBrowserSession: Bool = true) -> some View {
        let modifer = WebAuthenticationPrefersEphemeralWebBrowserSessionModifier(prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession)
        return ModifiedContent(content: self, modifier: modifer)
    }

}

private struct WebAuthenticationPrefersEphemeralWebBrowserSessionModifier: ViewModifier {

    // MARK: - Initializers

    init(prefersEphemeralWebBrowserSession: Bool) {
        self.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.webAuthenticationPrefersEphemeralWebBrowserSession, prefersEphemeralWebBrowserSession)
    }

    // MARK: - Private

    private let prefersEphemeralWebBrowserSession: Bool
}
