//
//  File.swift
//  
//
//  Created by Varun Santhanam on 7/26/22.
//

import SwiftUI

public extension View {
    
    func safari(isPresented: Binding<Bool>,
                _ safariView: @escaping () -> SafariView) -> some View {
        modifier(SafariView.Modifier(isPresented: isPresented,
                                     onDismiss: {},
                                     builder: safariView))
    }
    
    func safari(isPresented: Binding<Bool>,
                _ safariView: @escaping () -> SafariView,
                onDismiss: @escaping () -> Void) -> some View {
        modifier(SafariView.Modifier(isPresented: isPresented,
                                     onDismiss: onDismiss,
                                     builder: safariView))
    }
    
    func safari<Item>(item: Binding<Item?>,
                      safariView: @escaping (Item) -> SafariView) -> some View where Item: Identifiable {
        modifier(SafariView.ItemModitifer(item: item,
                                          onDismiss: {},
                                          builder: safariView))
    }
    
    func safari<Item>(item: Binding<Item?>,
                      safariView: @escaping (Item) -> SafariView,
                      onDismiss: @escaping () -> Void) -> some View where Item: Identifiable {
        modifier(SafariView.ItemModitifer(item: item,
                                          onDismiss: onDismiss,
                                          builder: safariView))
    }
    
}
