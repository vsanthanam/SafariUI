// SafariView
// ViewExtensions.swift
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
    ///         Button(action: {
    ///             isShowingSafari.toggle()
    ///         }) {
    ///             Text("Show License Agreement")
    ///         }
    ///         .safari(isPresented: $isShowingSafari) {
    ///             SafariView(url: licenseAgreementURL)
    ///         }
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the ``SafariView`` that you create in the modifier’s content closure.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari(isPresented: Binding<Bool>,
                onDismiss: (() -> Void)? = nil,
                safariView: @escaping () -> SafariView) -> some View {
        let modifier = SafariView.Modifier(isPresented: isPresented,
                                           build: safariView,
                                           onDismiss: onDismiss ?? {})
        return ModifiedContent(content: self, modifier: modifier)
    }

    func safari<Item>(item: Binding<Item?>,
                      onDismiss: (() -> Void)? = nil,
                      safariView: @escaping (Item) -> SafariView) -> some View where Item: Identifiable {
        let modifier = SafariView.ItemModitifer(item: item,
                                                build: safariView,
                                                onDismiss: onDismiss ?? {})
        return ModifiedContent(content: self, modifier: modifier)
    }

    func safari(url: Binding<URL?>,
                onDismiss: (() -> Void)? = nil,
                safariView: @escaping (URL) -> SafariView) -> some View {
        let modifier = SafariView.URLModifier(url: url,
                                              build: safariView,
                                              onDismiss: onDismiss ?? {})
        return ModifiedContent(content: self, modifier: modifier)
    }

}
