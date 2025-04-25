// SafariUI
// WebAuthentication.swift
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
import SwiftUI

/// A wrapper for `ASWebAuthenticationSession` in SwiftUI
@available(iOS 14.0, macCatalyst 14.0, *)
public struct WebAuthentication {

    // MARK: - Initializers

    /// Create a web authentication session
    ///
    /// You must present a `WebAuthentication` challenge to your users using one of our provided presentation view modifiers:
    ///
    /// - ``SwiftUI/View/webAuthentication(_:webAuthentication:)-74m38``
    /// - ``SwiftUI/View/webAuthentication(_:webAuthentication:)-5x82p``
    /// - ``SwiftUI/View/webAuthentication(_:id:webAuthentication:)``
    ///
    /// For example:
    ///
    /// ```swift
    /// struct AuthenticateButton: View {
    ///     var body: some View {
    ///
    ///         @State
    ///         var isPresented = false
    ///
    ///         static let authURL = URL(string: "https://www.myserver.com/auth?argument=foo")!
    ///         static let scheme = "myserver"
    ///
    ///         Button("Connect Github") {
    ///             isPresented.toggle()
    ///         }
    ///         .webAuthentication($isPresented) {
    ///             WebAuthentication(
    ///                 url: authURL,
    ///                 callbackURLScheme: scheme
    ///             ) { result in
    ///                 do {
    ///                     let callback = try result.get()
    ///                     // Authentication complete. Perform callback.
    ///                 } catch {
    ///                     // Authentication failed. Display error message to user.
    ///                 }
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// You cannot display a `WebAuthentication` cannot be displayed any other way.
    ///
    /// - Parameters:
    ///   - url: The URL pointing to the authentication page
    ///   - callbackURLScheme: The URL scheme that the app should expect when receiving the authentication callback
    ///   - completionHandler: Completion Handler
    public init(
        url: URL,
        callbackURLScheme: String?,
        completionHandler: @escaping CompletionHandler
    ) {
        self.url = url
        self.callbackURLScheme = callbackURLScheme
        self.completionHandler = completionHandler
    }

    // MARK: - API

    /// A completion handler for the web authentication session.
    public typealias CompletionHandler = (Result<URL, any Error>) -> Void

    // MARK: - Private

    private let url: URL
    private let callbackURLScheme: String?
    private let completionHandler: CompletionHandler

    struct BoolModifier: ViewModifier {

        @Binding
        var isPresented: Bool

        let build: () -> WebAuthentication

        @ViewBuilder
        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(
                        isPresented: $isPresented,
                        prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
                        build: build
                    )
                )
        }

        @Environment(\.webAuthenticationPrefersEphemeralWebBrowserSession)
        private var prefersEphemeralWebBrowserSession: Bool

        private struct Presenter: UIViewRepresentable {

            @Binding
            var isPresented: Bool

            let prefersEphemeralWebBrowserSession: Bool
            let build: () -> WebAuthentication

            // MARK: - UIViewRepresentable

            func makeCoordinator() -> Coordinator {
                Coordinator(parent: self)
            }

            func makeUIView(context: Context) -> UIView {
                context.coordinator.view
            }

            func updateUIView(_ uiView: UIView, context: Context) {
                context.coordinator.parent = self
                context.coordinator.isPresented = isPresented
            }

            @MainActor
            final class Coordinator: NSObject, WebAuthenticationCoordinator {
                init(parent: Presenter) {
                    self.parent = parent
                }

                let view = UIView()
                var parent: Presenter

                var isPresented: Bool = false {
                    didSet {
                        guard isPresented != oldValue else { return }
                        if isPresented {
                            start()
                        } else {
                            session?.cancel()
                        }
                    }
                }

                private lazy var contextProvider = ContextProvider<Coordinator>(coordinator: self)

                private weak var session: ASWebAuthenticationSession?

                private func start() {
                    let representation = parent.build()
                    let session = ASWebAuthenticationSession(
                        url: representation.url,
                        callbackURLScheme: representation.callbackURLScheme
                    ) { callback, error in
                        self.parent.isPresented = false
                        if let callback {
                            representation.completionHandler(.success(callback))
                        } else if let error {
                            representation.completionHandler(.failure(error))
                        } else {
                            representation.completionHandler(.failure(UnknownError()))
                        }
                    }

                    session.presentationContextProvider = contextProvider
                    session.prefersEphemeralWebBrowserSession = parent.prefersEphemeralWebBrowserSession

                    session.start()

                    self.session = session
                }
            }
        }
    }

    struct IdentifiableItemModitifer<Item>: ViewModifier where Item: Identifiable {

        // MARK: - API

        @Binding
        var item: Item?

        let build: (Item) -> WebAuthentication

        // MARK: - ViewModifier

        @ViewBuilder
        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(
                        item: $item,
                        prefersEphemeralWebBrowserSession: prefersEphemeralWebBrowserSession,
                        build: build
                    )
                )
        }

        // MARK: - Private

        @Environment(\.webAuthenticationPrefersEphemeralWebBrowserSession)
        private var prefersEphemeralWebBrowserSession: Bool

        private struct Presenter: UIViewRepresentable {

            // MARK: - API

            @Binding
            var item: Item?

            let prefersEphemeralWebBrowserSession: Bool
            let build: (Item) -> WebAuthentication

            // MARK: - UIViewRepresentable

            func makeCoordinator() -> Coordinator {
                Coordinator(parent: self)
            }

            func makeUIView(context: Context) -> UIView {
                context.coordinator.view
            }

            func updateUIView(_ uiView: UIView, context: Context) {
                context.coordinator.parent = self
                context.coordinator.item = item
            }

            @MainActor
            final class Coordinator: NSObject, WebAuthenticationCoordinator {

                // MARK: - Initializers

                init(parent: Presenter) {
                    self.parent = parent
                }

                // MARK: - API

                let view = UIView()
                var parent: Presenter

                var item: Item? {
                    didSet {
                        guard item?.id != oldValue?.id else {
                            return
                        }
                        switch (oldValue, item) {
                        case (.none, .none):
                            break
                        case let (.none, .some(new)):
                            start(new)
                        case (.some, .some):
                            break
                        case (.some, .none):
                            session?.cancel()
                        }
                    }
                }

                // MARK: - Private

                private lazy var contextProvider = ContextProvider<Coordinator>(coordinator: self)

                private weak var session: ASWebAuthenticationSession?

                private func start(_ item: Item) {
                    let representation = parent.build(item)
                    let session = ASWebAuthenticationSession(
                        url: representation.url,
                        callbackURLScheme: representation.callbackURLScheme
                    ) { callback, error in
                        self.parent.item = nil
                        if let callback {
                            representation.completionHandler(.success(callback))
                        } else if let error {
                            representation.completionHandler(.failure(error))
                        } else {
                            representation.completionHandler(.failure(UnknownError()))
                        }
                    }

                    session.presentationContextProvider = contextProvider
                    session.prefersEphemeralWebBrowserSession = parent.prefersEphemeralWebBrowserSession

                    session.start()

                    self.session = session
                }
            }
        }
    }

    struct ItemModifier<Item, Identifier>: ViewModifier where Identifier: Hashable {

        // MARK: - Initializers

        @Binding
        var item: Item?

        let id: KeyPath<Item, Identifier>
        let build: (Item) -> WebAuthentication

        // MARK: - ViewModifier

        @ViewBuilder
        func body(content: Content) -> some View {
            content
                .webAuthentication(wrapped) { item in
                    build(item.wrapped)
                }
        }

        // MARK: - Private

        private struct WrappedItem: Identifiable {
            let wrapped: Item
            let path: KeyPath<Item, Identifier>
            var id: Identifier { wrapped[keyPath: path] }
        }

        private var wrapped: Binding<WrappedItem?> {
            Binding<WrappedItem?> {
                item.map(wrap)
            } set: { newValue in
                item = newValue?.wrapped
            }
        }

        private func wrap(_ item: Item) -> WrappedItem {
            .init(wrapped: item, path: id)
        }
    }
}

@MainActor
private final class ContextProvider<T: WebAuthenticationCoordinator>: NSObject, ASWebAuthenticationPresentationContextProviding {

    // MARK: - Initializers

    init(coordinator: T) {
        self.coordinator = coordinator
    }

    // MARK: - API

    unowned var coordinator: T

    // MARK: - ASWebAuthenticationPresentationContextProviding

    nonisolated func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        MainActor.assumeIsolated {
            coordinator.view.window ?? ASPresentationAnchor()
        }
    }
}

private protocol WebAuthenticationCoordinator: NSObject {
    var view: UIView { get }
}

private struct UnknownError: Error {}
