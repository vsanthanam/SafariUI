// SafariUI
// SafariView.swift
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

#if os(iOS)
    import SafariServices
#endif
import SwiftUI

@available(iOS 14.0, macCatalyst 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
public struct SafariView: View {

    /// Create a `SafariView`
    ///
    /// The view always displays the current `url`: if the value changes, the view is recreated to load the new URL, discarding any in-view navigation state. To keep showing the originally provided page instead, capture the URL in your own state and pass the captured value.
    /// - Parameter url: The URL to load
    public init(
        url: URL
    ) {
        self.url = url
    }

    @available(iOS 16.0, macCatalyst 16.0, *)
    @available(macOS, unavailable)
    @available(tvOS, unavailable)
    @available(watchOS, unavailable)
    public static func clearWebsiteData() async {
        #if os(iOS)
            await SFSafariViewController.DataStore.default.clearWebsiteData()
        #endif
    }

    public var body: some View {
        #if os(iOS)
            InlineSafariView(
                url: url
            )
            .id(url)
            .ignoresSafeArea(
                .container,
                edges: .all
            )
        #else
            EmptyView()
        #endif
    }

    let url: URL

}
