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

#if os(iOS)
    import SafariServices
#endif
import SwiftUI

@available(iOS 14.0, macCatalyst 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    /// Present a Safari view when a boolean binding becomes `true`
    ///
    /// Appearance and configuration are controlled by the environment modifiers applied to the presenting view, such as ``SwiftUICore/View/safariViewConfiguration(_:)`` and ``SwiftUICore/View/safariViewDismissButtonStyle(_:)``.
    /// - Important: The URL and the ambient ``SafariView/Configuration`` from the environment are consumed at presentation time, when `isPresented` becomes `true`. `SFSafariViewController` does not support changing its URL or configuration after creation, so changes made while the view is presented have no effect on the current presentation; they apply the next time the view is presented.
    /// - Parameters:
    ///   - presentationStyle: The presentation style to use
    ///   - isPresented: A binding that controls the presentation
    ///   - url: The URL to load
    /// - Returns: The modified view
    public func safariView(
        _ presentationStyle: SafariView.PresentationStyle = .default,
        isPresented: Binding<Bool>,
        url: URL
    ) -> some View {
        let binding = Binding<Bool?> {
            isPresented.wrappedValue ? true : nil
        } set: { newValue in
            isPresented.wrappedValue = newValue ?? false
        }
        return self.safariView(
            presentationStyle,
            item: binding,
            id: \.self
        ) { _ in
            url
        }
    }

    /// Present a Safari view when an optional, identifiable item binding becomes non-`nil`
    ///
    /// Appearance and configuration are controlled by the environment modifiers applied to the presenting view, such as ``SwiftUICore/View/safariViewConfiguration(_:)`` and ``SwiftUICore/View/safariViewDismissButtonStyle(_:)``.
    /// - Important: The URL and the ambient ``SafariView/Configuration`` from the environment are consumed at presentation time, when `item` becomes non-`nil`. If the item's identity changes while the view is presented, the current view is dismissed and a new one is presented for the new item. Changes to the item that do not change its identity have no effect on the current presentation.
    /// - Parameters:
    ///   - presentationStyle: The presentation style to use
    ///   - item: A binding to an optional item that controls the presentation
    ///   - url: A closure or key path that produces the URL to load for an item
    /// - Returns: The modified view
    public func safariView<Item>(
        _ presentationStyle: SafariView.PresentationStyle = .default,
        item: Binding<Item?>,
        url: @escaping (Item) -> URL
    ) -> some View where Item: Identifiable {
        #if os(iOS)
            modifier(
                PresentSafariModifier(
                    item: item,
                    presentationStyle: presentationStyle,
                    url: url
                )
            )
        #else
            self
        #endif
    }

    /// Present a Safari view when an optional item binding becomes non-`nil`, using a key path to identify the item
    ///
    /// Appearance and configuration are controlled by the environment modifiers applied to the presenting view, such as ``SwiftUICore/View/safariViewConfiguration(_:)`` and ``SwiftUICore/View/safariViewDismissButtonStyle(_:)``.
    /// - Important: The URL and the ambient ``SafariView/Configuration`` from the environment are consumed at presentation time, when `item` becomes non-`nil`. If the item's identity changes while the view is presented, the current view is dismissed and a new one is presented for the new item. Changes to the item that do not change its identity have no effect on the current presentation.
    /// - Parameters:
    ///   - presentationStyle: The presentation style to use
    ///   - item: A binding to an optional item that controls the presentation
    ///   - id: A key path to the item's identity
    ///   - url: A closure or key path that produces the URL to load for an item
    /// - Returns: The modified view
    public func safariView<Item, ID>(
        _ presentationStyle: SafariView.PresentationStyle = .default,
        item: Binding<Item?>,
        id: KeyPath<Item, ID>,
        url: @escaping (Item) -> URL
    ) -> some View where ID: Hashable {
        let binding = Binding<GenericIdentifiable<Item, ID>?> {
            item.wrappedValue.map { GenericIdentifiable($0, id) }
        } set: { newValue in
            item.wrappedValue = newValue?.item
        }
        return self.safariView(
            presentationStyle,
            item: binding
        ) { identifiable in
            url(identifiable.item)
        }
    }

    /// Present a Safari view when an optional URL binding becomes non-`nil`
    ///
    /// The URL serves as its own identity: if the binding's value changes to a different URL while the view is presented, the current view is dismissed and a new one is presented for the new URL. When the user dismisses the view, the binding is set back to `nil`.
    ///
    /// Appearance and configuration are controlled by the environment modifiers applied to the presenting view, such as ``SwiftUICore/View/safariViewConfiguration(_:)`` and ``SwiftUICore/View/safariViewDismissButtonStyle(_:)``.
    /// - Important: The URL and the ambient ``SafariView/Configuration`` from the environment are consumed at presentation time, when `url` becomes non-`nil`.
    /// - Parameters:
    ///   - presentationStyle: The presentation style to use
    ///   - url: A binding to an optional URL that controls the presentation
    /// - Returns: The modified view
    public func safariView(
        _ presentationStyle: SafariView.PresentationStyle = .default,
        url: Binding<URL?>
    ) -> some View {
        self.safariView(
            presentationStyle,
            item: url,
            id: \.self
        ) { url in
            url
        }
    }

}

@available(iOS 14.0, macCatalyst 14.0, *)
struct GenericIdentifiable<Item, ID>: Identifiable where ID: Hashable {

    init(
        _ item: Item,
        _ keyPath: KeyPath<Item, ID>
    ) {
        self.item = item
        self.keyPath = keyPath
    }

    let item: Item
    let keyPath: KeyPath<Item, ID>

    var id: ID {
        item[keyPath: keyPath]
    }

}

#if os(iOS)

    @available(iOS 14.0, macCatalyst 14.0, *)
    struct PresentSafariModifier<Item>: ViewModifier where Item: Identifiable {

        let item: Binding<Item?>
        let presentationStyle: SafariView.PresentationStyle
        let url: (Item) -> URL

        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(
                        item: item,
                        url: item.wrappedValue.map(url),
                        presentationStyle: presentationStyle
                    )
                )
        }

        struct Presenter: UIViewRepresentable {

            @Binding
            var item: Item?
            let url: URL?
            let presentationStyle: SafariView.PresentationStyle

            typealias UIViewType = PresenterView

            func makeCoordinator() -> Coordinator {
                Coordinator(
                    presentationStyle: presentationStyle
                ) {
                    item = nil
                }
            }

            func makeUIView(
                context: Context
            ) -> PresenterView {
                context.coordinator.install(context.environment)
                context.coordinator.presentation = presentation
                return context.coordinator.presenterView
            }

            func updateUIView(
                _ uiView: PresenterView,
                context: Context
            ) {
                context.coordinator.presentationStyle = presentationStyle
                context.coordinator.nilSetter = { item = nil }
                context.coordinator.install(context.environment)
                context.coordinator.presentation = presentation
            }

            private var presentation: (id: Item.ID, url: URL)? {
                guard let item, let url else {
                    return nil
                }
                return (id: item.id, url: url)
            }

            final class Coordinator: SafariView.Delegate {

                init(
                    presentationStyle: SafariView.PresentationStyle,
                    nilSetter: @escaping () -> Void
                ) {
                    self.presentationStyle = presentationStyle
                    self.nilSetter = nilSetter
                    super.init()
                }

                private weak var safariViewController: SFSafariViewController?
                let presenterView = PresenterView()
                var nilSetter: () -> Void
                var presentationStyle: SafariView.PresentationStyle
                var configuration: SafariView.Configuration = .default
                var barTintColor: Color?
                var controlTintColor: Color?
                var dismissButtonStyle: SafariView.DismissButtonStyle = .close

                override func install(_ environment: EnvironmentValues) {
                    super.install(environment)
                    if #unavailable(iOS 26.0, macCatalyst 26.0) {
                        barTintColor = environment.safariViewBarTintColor
                        controlTintColor = environment.safariViewControlTintColor
                    }
                    configuration = environment.safariViewConfiguration
                    dismissButtonStyle = environment.safariViewDismissButtonStyle
                }

                var presentation: (id: Item.ID, url: URL)? {
                    didSet {
                        switch (oldValue, presentation) {
                        case (.none, .none):
                            break
                        case let (.none, .some(new)):
                            presentSafari(with: new.url)
                        case (.some, .none):
                            dismissSafari()
                        case let (.some(old), .some(new)):
                            if old.id == new.id {
                                updateSafari()
                            } else {
                                replaceSafari(with: new.url)
                            }
                        }
                    }
                }

                private func presentSafari(with url: URL) {
                    guard let presenting = presenterView.window?.farthestPresentedViewController else {
                        // The view isn't attached to a window yet. Defer until it is,
                        // then re-evaluate — matching SwiftUI's own presentation
                        // semantics for views that aren't currently visible.
                        presenterView.pendingPresentation = { [weak self] in
                            guard let self, presentation != nil else { return }
                            presentSafari(with: url)
                        }
                        return
                    }
                    let vc = SFSafariViewController(
                        url: url,
                        configuration: configuration.uikit
                    )
                    vc.delegate = self
                    if #unavailable(iOS 26.0, macCatalyst 26.0) {
                        vc.preferredBarTintColor = barTintColor.map(UIColor.init)
                        vc.preferredControlTintColor = controlTintColor.map(UIColor.init)
                    }
                    vc.dismissButtonStyle = dismissButtonStyle.uikit
                    switch presentationStyle {
                    case .standard:
                        break
                    case .formSheet:
                        vc.modalPresentationStyle = .formSheet
                    case .pageSheet:
                        vc.modalPresentationStyle = .pageSheet
                    }
                    presenting.present(vc, animated: true)
                    safariViewController = vc
                }

                private func dismissSafari() {
                    presenterView.pendingPresentation = nil
                    safariViewController?.dismiss(animated: true)
                }

                private func replaceSafari(with url: URL) {
                    guard let safariViewController else {
                        presentSafari(with: url)
                        return
                    }
                    safariViewController.dismiss(animated: true) { [weak self] in
                        self?.presentSafari(with: url)
                    }
                }

                private func updateSafari() {
                    if #unavailable(iOS 26.0, macCatalyst 26.0) {
                        safariViewController?.preferredBarTintColor = barTintColor.map(UIColor.init)
                        safariViewController?.preferredControlTintColor = controlTintColor.map(UIColor.init)
                    }
                    safariViewController?.dismissButtonStyle = dismissButtonStyle.uikit
                }

                override func safariViewControllerDidFinish(
                    _ controller: SFSafariViewController
                ) {
                    safariViewController = nil
                    presentation = nil
                    nilSetter()
                    super.safariViewControllerDidFinish(controller)
                }

            }

        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    final class PresenterView: UIView {

        var pendingPresentation: (() -> Void)?

        override func didMoveToWindow() {
            super.didMoveToWindow()
            guard window != nil else {
                return
            }
            pendingPresentation?()
            pendingPresentation = nil
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    extension UIWindow {

        var farthestPresentedViewController: UIViewController? {
            guard let rootViewController else {
                return nil
            }
            return sequence(first: rootViewController, next: \.presentedViewController)
                .reversed()
                .first
        }

    }

#endif
