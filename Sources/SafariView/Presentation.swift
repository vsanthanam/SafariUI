// SafariView
// Presentation.swift
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

@available(iOS 15.0, *)
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
    ///         .safari(isPresented: $isShowingSafari,
    ///                 onDismiss: didDismiss) {
    ///             SafariView(url: licenseAgreementURL)
    ///         }
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
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari(
        isPresented: Binding<Bool>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder safariView: @escaping () -> SafariView
    ) -> some View {
        let modifier = SafariView.BoolModifier(isPresented: isPresented,
                                               build: safariView,
                                               onDismiss: onDismiss ?? {})
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Presents a ``SafariView`` using the given item as a data source for the ``SafariView``'s content
    ///
    /// Use this method when you need to present a ``SafariView`` with content from a custom data source. The example below shows a custom data source `InventoryItem` that the closure uses to populate the ``SafariView`` before it is shown to the user:
    ///
    /// ```swift
    /// import Foundation
    /// import SafariView
    /// import SwiftUI
    ///
    /// struct InventoryItem: Identifiable {
    ///     let id: Int
    ///     let title: String
    ///     let url: URL
    /// }
    ///
    /// struct InventoryList: View {
    ///
    ///     init(inventory: [InventoryItem]) {
    ///         self.inventory = inventory
    ///     }
    ///
    ///     var inventory: [InventoryItem]
    ///
    ///     @State private var selectedItem: InventoryItem?
    ///
    ///     var body: some View {
    ///         List(inventory) { inventoryItem in
    ///             Button(action: {
    ///                 self.selectedItem = inventoryItem
    ///             }) {
    ///                 Text(inventoryItem.title)
    ///             }
    ///         }
    ///         .safari(item: $selectedItem,
    ///                 onDismiss: dismissAction) { item in
    ///             SafariView(url: item.url)
    ///         }
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
    ///   - item: A binding to an optional source of truth for the ``SafariView``. When item is non-nil, the system passes the item’s content to the modifier’s closure. You display this content in a ``SafariView`` that you create that the system displays to the user. If item changes, the system dismisses the ``SafariView`` and replaces it with a new one using the same process.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari<Item>(
        item: Binding<Item?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder safariView: @escaping (Item) -> SafariView
    ) -> some View where Item: Identifiable {
        let modifier = SafariView.IdentifiableItemModitifer(
            item: item,
            build: safariView,
            onDismiss: onDismiss ?? {}
        )
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Presents a ``SafariView`` using the given item as a data source for the ``SafariView``'s content
    ///
    /// Use this method when you need to present a ``SafariView`` with content from a custom data source. The example below shows a custom data source `InventoryItem` that the closure uses to populate the ``SafariView`` before it is shown to the user:
    ///
    /// ```swift
    /// import Foundation
    /// import SafariView
    /// import SwiftUI
    ///
    /// struct InventoryItem {
    ///     let id: Int
    ///     let title: String
    ///     let url: URL
    /// }
    ///
    /// struct InventoryList: View {
    ///
    ///     init(inventory: [InventoryItem]) {
    ///         self.inventory = inventory
    ///     }
    ///
    ///     var inventory: [InventoryItem]
    ///
    ///     @State private var selectedItem: InventoryItem?
    ///
    ///     var body: some View {
    ///         List(inventory) { inventoryItem in
    ///             Button(action: {
    ///                 self.selectedItem = inventoryItem
    ///             }) {
    ///                 Text(inventoryItem.title)
    ///             }
    ///         }
    ///         .safari(item: $selectedItem,
    ///                 id: \.id,
    ///                 onDismiss: dismissAction) { item in
    ///             SafariView(url: item.url)
    ///         }
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
    ///   - item: A binding to an optional source of truth for the ``SafariView``. When item is non-nil, the system passes the item’s content to the modifier’s closure. You display this content in a ``SafariView`` that you create that the system displays to the user. If item changes, the system dismisses the ``SafariView`` and replaces it with a new one using the same process.
    ///   - id: A keypath used to generate stable identifier for instances of `Item`.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari<Item>(
        item: Binding<Item?>,
        id: KeyPath<Item, some Hashable>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder safariView: @escaping (Item) -> SafariView
    ) -> some View {
        let modifier = SafariView.ItemModifier(
            item: item,
            id: id,
            onDismiss: onDismiss,
            safariView: safariView
        )
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Presents a ``SafariView`` using the given URL as a data source for the ``SafariView``'s content
    ///
    /// Use this method when you need to present a ``SafariView`` with content from a custom data source. The example below shows a custom data source `InventoryItem` that the closure uses to populate the ``SafariView`` before it is shown to the user:
    ///
    /// ```swift
    /// import Foundation
    /// import SafariView
    /// import SwiftUI
    ///
    /// struct InventoryItem {
    ///     let title: String
    ///     let url: URL
    /// }
    ///
    /// struct InventoryList: View {
    ///
    ///     init(inventory: [InventoryItem]) {
    ///         self.inventory = inventory
    ///     }
    ///
    ///     var inventory: [InventoryItem]
    ///
    ///     @State private var selectedURL: URL?
    ///
    ///     var body: some View {
    ///         List(inventory.indices, id: \.self) { index in
    ///             Button(action: {
    ///                 self.selectedURL = inventory[index].url
    ///             }) {
    ///                 Text(inventory[index].title)
    ///             }
    ///         }
    ///         .safari(item: $selectedURL,
    ///                 onDismiss: dismissAction) { url in
    ///             SafariView(url: url)
    ///         }
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
    ///   - item: A binding to an optional source of truth for the ``SafariView``. When the URL is non-nil, the system passes the URL to the modifier’s closure. You display this content in a ``SafariView`` that you create that the system displays to the user. If the URL changes, the system dismisses the ``SafariView`` and replaces it with a new one using the same process.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari(
        url: Binding<URL?>,
        onDismiss: (() -> Void)? = nil,
        @ViewBuilder safariView: @escaping (URL) -> SafariView
    ) -> some View {
        safari(
            item: url,
            id: \.hashValue,
            onDismiss: onDismiss,
            safariView: safariView
        )
    }

}
