// SafariUI
// URLPresentation.swift
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
import SwiftUI

@available(iOS 14.0, macCatalyst 14.0, *)
public extension View {

    /// Presents a ``SafariView`` using the given URL.
    ///
    /// Use this method when you need to present a ``SafariView`` with content from URL.
    /// The example below shows a list of buttons, each of which provide a different URL to the view.
    ///
    /// ```swift
    /// struct InformationView: View {
    ///
    ///     @State var url: URL?
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Button("Terms of service") {
    ///                 url = URL(string: "https://www.myservice.com/terms-of-service")!
    ///             }
    ///             Button("Warranty") {
    ///                 url = URL(string: "https://www.myservice.com/warranty")!
    ///             }
    ///             Button("Support") {
    /// `                url = URL(string: "https://www.myservice.com/help")!
    ///             }
    ///         }
    ///         .safari(url: $url, onDismiss: dismissAction)
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    /// }
    /// ```
    /// - Parameters:
    ///   - url: The URL used to load the view
    ///   - presentationStyle: The ``SafariView/PresentationStyle`` used to present the ``SafariView``.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    /// - Returns: The modified view
    func safari(
        url: Binding<URL?>,
        presentationStyle: SafariView.PresentationStyle = .default,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: URLPresentation(
                url: url,
                presentationStyle: presentationStyle,
                onDismiss: onDismiss
            )
        )
    }

}

private struct URLPresentation: ViewModifier {

    init(
        url: Binding<URL?>,
        presentationStyle: SafariView.PresentationStyle,
        onDismiss: (() -> Void)?
    ) {
        _url = url
        self.presentationStyle = presentationStyle
        self.onDismiss = onDismiss
    }

    @MainActor
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .safari(
                item: $url,
                id: \.hashValue,
                presentationStyle: presentationStyle,
                onDismiss: onDismiss
            ) { url in
                SafariView(url: url)
            }
    }

    @Binding
    private var url: URL?
    private let presentationStyle: SafariView.PresentationStyle
    private let onDismiss: (() -> Void)?

}
