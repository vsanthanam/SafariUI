// SafariUI
// PrewarmingToken.swift
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

import Foundation
#if os(iOS)
    import SafariServices
#endif

@available(iOS 15.0, macCatalyst 15.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension SafariView {

    @discardableResult
    public static func prewarmConnections(to URLs: [URL]) -> PrewarmingToken {
        #if os(iOS)
            let token = SFSafariViewController.prewarmConnections(to: URLs)
            return .init(token, urls: URLs)
        #else
            fatalError("unavailable")
        #endif
    }

    /// A type created when SafariServices begins prewarming a connection.
    public final class PrewarmingToken {

        /// The URLs who's connections are being prewarmed.
        public let urls: [URL]

        /// Invalidate the prewarmed connections.
        public func invalidate() {
            #if os(iOS)
                let token = unsafeDowncast(
                    token,
                    to: SFSafariViewController.PrewarmingToken.self
                )
                token.invalidate()
            #endif
        }

        init(
            _ token: AnyObject,
            urls: [URL]
        ) {
            self.token = token
            self.urls = urls
        }

        /// Stored type-erased so the class can be declared on platforms
        /// where SafariServices' token type does not exist.
        private let token: AnyObject

    }

}
