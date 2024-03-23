// SafariUI
// Presentation.swift
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

@available(iOS 14.0, macCatalyst 14.0, tvOS 14.0, visionOS 1.0, *)
public extension View {

    /// Presents a ``WebAuthentication`` when a binding to a Boolean value that you provide is `true`.
    ///
    /// Use this method when you want to present a ``WebAuthentication`` to the user when a Boolean value you provide is true.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the ``WebAuthentication`` that you create in the modifier’s content closure.
    ///   - webAuthentication: A closure that returns the ``WebAuthentication`` to present
    /// - Returns: The modified view
    func webAuthentication(
        _ isPresented: Binding<Bool>,
        webAuthentication: @escaping () -> WebAuthentication
    ) -> some View {
        let modifier = WebAuthentication.BoolModifier(isPresented: isPresented, build: webAuthentication)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Presents a ``WebAuthentication`` using the given item as a data source for the ``WebAuthentication``'s content
    ///
    /// Use this method when you need to present a ``WebAuthentication`` with content from a custom data source.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the ``WebAuthentication``. When item is non-nil, the system passes the item’s content to the modifier’s closure. You display this content in a ``WebAuthentication`` that you create that the system displays to the user. If item changes, the system dismisses the ``WebAuthentication`` and replaces it with a new one using the same process.
    ///   - webAuthentication: A closure that returns the ``WebAuthentication`` to present
    /// - Returns: The modified view
    func webAuthentication<Item>(
        _ item: Binding<Item?>,
        webAuthentication: @escaping (Item) -> WebAuthentication
    ) -> some View where Item: Identifiable {
        let modifier = WebAuthentication.IdentifiableItemModitifer(item: item, build: webAuthentication)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Presents a ``WebAuthentication`` using the given item as a data source for the ``WebAuthentication``'s content
    ///
    /// Use this method when you need to present a ``WebAuthentication`` with content from a custom data source.
    ///
    /// - Parameters:
    ///   - item: A binding to an optional source of truth for the ``WebAuthentication``. When item is non-nil, the system passes the item’s content to the modifier’s closure. You display this content in a ``WebAuthentication`` that you create that the system displays to the user. If item changes, the system dismisses the ``WebAuthentication`` and replaces it with a new one using the same process.
    ///   - id: A keypath used to generate stable identifier for instances of `Item`.
    ///   - webAuthentication: A closure that returns the ``WebAuthentication`` to present.
    func webAuthentication<Item, Identifier>(
        _ item: Binding<Item?>,
        id: KeyPath<Item, Identifier>,
        webAuthentication: @escaping (Item) -> WebAuthentication
    ) -> some View where Identifier: Hashable {
        let modifier = WebAuthentication.ItemModifier(item: item, id: id, build: webAuthentication)
        return ModifiedContent(content: self, modifier: modifier)
    }

}
