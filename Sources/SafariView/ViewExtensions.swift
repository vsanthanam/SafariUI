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

    func safari(isPresented: Binding<Bool>,
                _ safariView: @escaping () -> SafariView) -> some View {
        let modifier = SafariView.Modifier(isPresented: isPresented,
                                           build: safariView,
                                           onDismiss: {})
        return ModifiedContent(content: self, modifier: modifier)
    }
    
    func safari(isPresented: Binding<Bool>,
                _ safariView: @escaping () -> SafariView,
                onDismiss: @escaping () -> Void) -> some View {
        let modifier = SafariView.Modifier(isPresented: isPresented,
                                           build: safariView,
                                           onDismiss: onDismiss)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func safari<Item>(item: Binding<Item?>,
                      safariView: @escaping (Item) -> SafariView) -> some View where Item: Identifiable {
        let modifier = SafariView.ItemModitifer(item: item,
                                                build: safariView,
                                                onDismiss: {})
        return ModifiedContent(content: self, modifier: modifier)
    }

    func safari<Item>(item: Binding<Item?>,
                      safariView: @escaping (Item) -> SafariView,
                      onDismiss: @escaping () -> Void) -> some View where Item: Identifiable {
        let modifier = SafariView.ItemModitifer(item: item,
                                                build: safariView,
                                                onDismiss: onDismiss)
        return ModifiedContent(content: self, modifier: modifier)
    }

}
