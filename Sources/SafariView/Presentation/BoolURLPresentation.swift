// SafariUI
// BoolURLPresentation.swift
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

    /// Presents a ``SafariView`` when a binding to a Boolean value that you provide is `true`.
    ///
    /// Use this method when you want to present a ``SafariView`` to the user when a Boolean value you provide is true.
    /// The example below displays a modal view of the mockup for a software license agreement when the user toggles the `isShowingSafari` variable by clicking or tapping on the “Show License Agreement” button:
    ///
    /// ```swift
    /// import Foundation
    /// import SafariView
    /// import SwiftUI
    ///
    /// struct ShowLicenseAgreement: View {
    ///
    ///     let licenseAgreementURL: URL
    ///
    ///     @State private var isShowingSafari = false
    ///
    ///     var body: some View {
    ///         Button {
    ///             isShowingSafari.toggle()
    ///         } label: {
    ///             Text("Show License Agreement")
    ///         }
    ///         .safari(isPresented: $isShowingSafari,
    ///                 url: licenseAgreementURL
    ///                 onDismiss: didDismiss)
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the ``SafariView`` that you create in the modifier’s content closure.
    ///   - url: The URL to load in the presented ``SafariView``
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    /// - Returns: The modified view
    func safari(
        isPresented: Binding<Bool>,
        url: URL,
        onDismiss: (() -> Void)? = nil
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: BoolURLPresentation(
                isPresented: isPresented,
                onDismiss: onDismiss,
                url: url
            )
        )
    }

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct BoolURLPresentation: ViewModifier {

    init(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)?,
        url: URL
    ) {
        _isPresented = isPresented
        self.onDismiss = onDismiss
        self.url = url
    }

    @MainActor
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .safari(
                isPresented: $isPresented,
                onDismiss: onDismiss
            ) {
                SafariView(url: url)
            }
    }

    @Binding
    private var isPresented: Bool
    private let onDismiss: (() -> Void)?
    private let url: URL

}
