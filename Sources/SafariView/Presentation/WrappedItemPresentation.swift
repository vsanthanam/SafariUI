// SafariUI
// WrappedItemPresentation.swift
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

@available(iOS 14.0, macCatalyst 14.0, visionOS 1.0, *)
public extension View {

    /// Presents a ``SafariView`` using the given item as a data source for the view’s content.
    ///
    /// Use this method when you need to present a ``SafariView`` with content from a custom data source.
    /// The example below shows a custom data source `InventoryItem` that the closure uses to populate the ``SafariView`` before it is shown to the user:
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
    ///
    ///     var inventory: [InventoryItem]
    ///
    ///     @State private var selectedItem: InventoryItem?
    ///
    ///     var body: some View {
    ///         List(inventory, id: \.title) { inventoryItem in
    ///             Button(action: {
    ///                 self.selectedItem = inventoryItem
    ///             }) {
    ///                 Text(inventoryItem.title)
    ///             }
    ///         }
    ///         .safari(item: $selectedItem,
    ///                 id: \.title
    ///                 onDismiss: dismissAction) { item in
    ///             SafariView(url: item.url)
    ///         }
    ///     }
    ///
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
    ///   - id: A keypath used to generate stable identifier for instances of Item.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari<Item, ID>(
        item: Binding<Item?>,
        id: KeyPath<Item, ID>,
        onDismiss: (() -> Void)? = nil,
        safariView: @escaping (Item) -> SafariView
    ) -> some View where ID: Hashable {
        ModifiedContent(
            content: self,
            modifier: WrappedItemPresentation(
                item: item,
                id: id,
                onDismiss: onDismiss,
                safariView: safariView
            )
        )
    }

}

@available(iOS 14.0, macCatalyst 14.0, visionOS 1.0, *)
private struct WrappedItemPresentation<Item, ID>: ViewModifier where ID: Hashable {

    // MARK: - Initializer

    init(
        item: Binding<Item?>,
        id: KeyPath<Item, ID>,
        onDismiss: (() -> Void)? = nil,
        safariView: @escaping (Item) -> SafariView
    ) {
        _item = item
        self.id = id
        self.onDismiss = onDismiss
        self.safariView = safariView
    }

    // MARK: - ViewModifier

    @MainActor
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .safari(item: wrappedItem) { item in
                safariView(item.value)
            }
    }

    // MARK: - Private

    @Binding
    private var item: Item?
    private let id: KeyPath<Item, ID>
    private let onDismiss: (() -> Void)?
    private let safariView: (Item) -> SafariView

    private var wrappedItem: Binding<WrappedIdentifiable?> {
        .init {
            if let item {
                .init(value: item, path: id)
            } else {
                nil
            }
        } set: { newValue in
            item = newValue?.value
        }
    }

    struct WrappedIdentifiable: Identifiable {

        init(
            value: Item,
            path: KeyPath<Item, ID>
        ) {
            self.value = value
            self.path = path
        }

        let value: Item
        let path: KeyPath<Item, ID>

        var id: ID {
            value[keyPath: path]
        }

    }

}
