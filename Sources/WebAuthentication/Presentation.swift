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

import AuthenticationServices
import Combine
import SwiftUI
#if os(iOS)
    import UIKit
#elseif os(macOS)
    import AppKit
#endif

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, tvOS 16.0, watchOS 7.0, *)
extension View {

    /// Begin a ``WebAuthentication`` session when a boolean binding becomes `true`
    ///
    /// When the session completes, fails, or is canceled by the user, the binding is set back to `false` after the session's completion handler is invoked.
    /// - Note: On tvOS, a session that has already started cannot be canceled programmatically; setting the binding back to `false` has no effect on it.
    /// - Parameters:
    ///   - isPresented: A binding that controls the session
    ///   - webAuthentication: A closure that produces the ``WebAuthentication`` session to begin
    /// - Returns: The modified view
    public func webAuthentication(
        _ isPresented: Binding<Bool>,
        webAuthentication: @escaping () -> WebAuthentication
    ) -> some View {
        let binding = Binding<Bool?> {
            isPresented.wrappedValue ? true : nil
        } set: { newValue in
            isPresented.wrappedValue = newValue ?? false
        }
        return self.webAuthentication(
            binding,
            id: \.self
        ) { _ in
            webAuthentication()
        }
    }

    /// Begin a ``WebAuthentication`` session when an optional, identifiable item binding becomes non-`nil`
    ///
    /// A running session cannot be changed: if the item's identity changes while a session is in progress, the current session is canceled and a new one begins for the new item. When the session completes, fails, or is canceled by the user, the binding is set back to `nil` after the session's completion handler is invoked.
    /// - Note: On tvOS, a session that has already started cannot be canceled programmatically; setting the binding back to `nil` has no effect on it.
    /// - Parameters:
    ///   - item: A binding to an optional item that controls the session
    ///   - webAuthentication: A closure that produces the ``WebAuthentication`` session to begin for an item
    /// - Returns: The modified view
    public func webAuthentication<Item>(
        _ item: Binding<Item?>,
        webAuthentication: @escaping (Item) -> WebAuthentication
    ) -> some View where Item: Identifiable {
        modifier(
            PresentWebAuthenticationModifier(
                item: item,
                webAuthentication: webAuthentication
            )
        )
    }

    /// Begin a ``WebAuthentication`` session when an optional item binding becomes non-`nil`, using a key path to identify the item
    ///
    /// A running session cannot be changed: if the item's identity changes while a session is in progress, the current session is canceled and a new one begins for the new item. When the session completes, fails, or is canceled by the user, the binding is set back to `nil` after the session's completion handler is invoked.
    /// - Note: On tvOS, a session that has already started cannot be canceled programmatically; setting the binding back to `nil` has no effect on it.
    /// - Parameters:
    ///   - item: A binding to an optional item that controls the session
    ///   - id: A key path to the item's identity
    ///   - webAuthentication: A closure that produces the ``WebAuthentication`` session to begin for an item
    /// - Returns: The modified view
    public func webAuthentication<Item, ID>(
        _ item: Binding<Item?>,
        id: KeyPath<Item, ID>,
        webAuthentication: @escaping (Item) -> WebAuthentication
    ) -> some View where ID: Hashable {
        let binding = Binding<GenericIdentifiable<Item, ID>?> {
            item.wrappedValue.map { GenericIdentifiable($0, id) }
        } set: { newValue in
            item.wrappedValue = newValue?.item
        }
        return self.webAuthentication(
            binding
        ) { identifiable in
            webAuthentication(identifiable.item)
        }
    }

}

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, tvOS 16.0, watchOS 7.0, *)
struct GenericIdentifiable<Item, ID>: Identifiable where ID: Hashable {

    init(_ item: Item, _ keyPath: KeyPath<Item, ID>) {
        self.item = item
        self.keyPath = keyPath
    }

    let item: Item
    let keyPath: KeyPath<Item, ID>

    var id: ID {
        item[keyPath: keyPath]
    }

}

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, tvOS 16.0, watchOS 7.0, *)
struct PresentWebAuthenticationModifier<Item>: ViewModifier where Item: Identifiable {

    let item: Binding<Item?>
    let webAuthentication: (Item) -> WebAuthentication

    #if os(iOS) || os(macOS)

        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(
                        item: item,
                        authentication: item.wrappedValue.map(webAuthentication)
                    )
                )
        }

    #else

        // watchOS and tvOS sessions present automatically without an anchor, so no
        // representable view is required — or available, on watchOS.

        @StateObject
        private var coordinator = Coordinator()

        #if os(watchOS)
            @Environment(\.webAuthenticationPrefersEphemeralWebBrowserSession)
            private var prefersEphemeralWebBrowserSession: Bool
        #endif

        func body(content: Content) -> some View {
            content
                .onAppear {
                    synchronize()
                }
                .onChange(of: item.wrappedValue?.id) { _ in
                    synchronize()
                }
        }

        private func synchronize() {
            coordinator.nilSetter = { item.wrappedValue = nil }
            #if os(watchOS)
                coordinator.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
            #endif
            coordinator.presentation = item.wrappedValue.map { item in
                (id: item.id, authentication: webAuthentication(item))
            }
        }

    #endif

    #if os(iOS)

        struct Presenter: UIViewRepresentable {

            @Binding
            var item: Item?
            let authentication: WebAuthentication?

            typealias UIViewType = AnchorView

            func makeCoordinator() -> Coordinator {
                Coordinator()
            }

            func makeUIView(
                context: Context
            ) -> AnchorView {
                context.coordinator.nilSetter = { item = nil }
                context.coordinator.prefersEphemeralWebBrowserSession = context.environment.webAuthenticationPrefersEphemeralWebBrowserSession
                context.coordinator.presentation = presentation
                return context.coordinator.anchorView
            }

            func updateUIView(
                _ uiView: AnchorView,
                context: Context
            ) {
                context.coordinator.nilSetter = { item = nil }
                context.coordinator.prefersEphemeralWebBrowserSession = context.environment.webAuthenticationPrefersEphemeralWebBrowserSession
                context.coordinator.presentation = presentation
            }

            private var presentation: (id: Item.ID, authentication: WebAuthentication)? {
                guard let item, let authentication else {
                    return nil
                }
                return (id: item.id, authentication: authentication)
            }

        }

    #elseif os(macOS)

        struct Presenter: NSViewRepresentable {

            @Binding
            var item: Item?
            let authentication: WebAuthentication?

            typealias NSViewType = AnchorView

            func makeCoordinator() -> Coordinator {
                Coordinator()
            }

            func makeNSView(
                context: Context
            ) -> AnchorView {
                context.coordinator.nilSetter = { item = nil }
                context.coordinator.prefersEphemeralWebBrowserSession = context.environment.webAuthenticationPrefersEphemeralWebBrowserSession
                context.coordinator.presentation = presentation
                return context.coordinator.anchorView
            }

            func updateNSView(
                _ nsView: AnchorView,
                context: Context
            ) {
                context.coordinator.nilSetter = { item = nil }
                context.coordinator.prefersEphemeralWebBrowserSession = context.environment.webAuthenticationPrefersEphemeralWebBrowserSession
                context.coordinator.presentation = presentation
            }

            private var presentation: (id: Item.ID, authentication: WebAuthentication)? {
                guard let item, let authentication else {
                    return nil
                }
                return (id: item.id, authentication: authentication)
            }

        }

    #endif

    @MainActor
    final class Coordinator: WebAuthenticationContextProvider {

        var nilSetter: () -> Void = {}
        var prefersEphemeralWebBrowserSession = false

        var presentation: (id: Item.ID, authentication: WebAuthentication)? {
            didSet {
                switch (oldValue, presentation) {
                case (.none, .none):
                    break
                case let (.none, .some(new)):
                    startSession(new.authentication, for: new.id)
                case (.some, .none):
                    cancelSession()
                case let (.some(old), .some(new)):
                    if old.id == new.id {
                        break // a running session cannot be changed
                    } else {
                        cancelSession()
                        startSession(new.authentication, for: new.id)
                    }
                }
            }
        }

        // MARK: - Private

        /// Strong on purpose — the session must be retained while it runs,
        /// or it is torn down when the session deallocates.
        private var session: ASWebAuthenticationSession?

        private func startSession(
            _ authentication: WebAuthentication,
            for id: Item.ID
        ) {
            #if os(iOS) || os(macOS)
                guard anchorView.window != nil else {
                    // The anchor isn't attached to a window yet. Defer until it
                    // is, then re-evaluate — matching SwiftUI's own presentation
                    // semantics for views that aren't currently visible.
                    anchorView.pendingSession = { [weak self] in
                        guard let self, let presentation else { return }
                        startSession(presentation.authentication, for: presentation.id)
                    }
                    return
                }
            #endif
            let completionHandler: ASWebAuthenticationSession.CompletionHandler = { [weak self] callbackURL, error in
                MainActor.assumeIsolated {
                    if let callbackURL {
                        authentication.completionHandler(.success(callbackURL))
                    } else {
                        authentication.completionHandler(.failure(error ?? UnknownError()))
                    }
                    // A replaced session's completion must not disturb the
                    // presentation that replaced it.
                    guard let self, self.presentation?.id == id else { return }
                    self.session = nil
                    self.presentation = nil
                    self.nilSetter()
                }
            }
            let session = if #available(iOS 17.4, macCatalyst 17.4, macOS 14.4, tvOS 17.4, watchOS 10.4, *),
                             let callback = authentication.callback {
                ASWebAuthenticationSession(
                    url: authentication.url,
                    callback: callback,
                    completionHandler: completionHandler
                )
            } else {
                ASWebAuthenticationSession(
                    url: authentication.url,
                    callbackURLScheme: authentication.callbackURLScheme,
                    completionHandler: completionHandler
                )
            }
            #if os(iOS) || os(macOS)
                session.presentationContextProvider = self
            #endif
            #if !os(tvOS)
                session.prefersEphemeralWebBrowserSession = prefersEphemeralWebBrowserSession
            #endif
            session.start()
            self.session = session
        }

        private func cancelSession() {
            #if os(iOS) || os(macOS)
                anchorView.pendingSession = nil
            #endif
            #if !os(tvOS)
                session?.cancel()
            #endif
            session = nil
        }

    }

}

@available(iOS 14.0, macCatalyst 14.0, macOS 11.0, tvOS 16.0, watchOS 7.0, *)
@MainActor
class WebAuthenticationContextProvider: NSObject, ObservableObject {

    #if os(iOS) || os(macOS)
        let anchorView = AnchorView()
    #endif

}

#if os(iOS) || os(macOS)

    @available(iOS 14.0, macCatalyst 14.0, macOS 11.0, *)
    extension WebAuthenticationContextProvider: @MainActor ASWebAuthenticationPresentationContextProviding {

        func presentationAnchor(
            for session: ASWebAuthenticationSession
        ) -> ASPresentationAnchor {
            anchorView.window ?? ASPresentationAnchor()
        }

    }

#endif

#if os(iOS)

    @available(iOS 14.0, macCatalyst 14.0, *)
    final class AnchorView: UIView {

        var pendingSession: (() -> Void)?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            guard window != nil else {
                return
            }
            pendingSession?()
            pendingSession = nil
        }

    }

#elseif os(macOS)

    @available(macOS 11.0, *)
    final class AnchorView: NSView {

        var pendingSession: (() -> Void)?

        override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            guard window != nil else {
                return
            }
            pendingSession?()
            pendingSession = nil
        }

    }

#endif

struct UnknownError: Error {}
