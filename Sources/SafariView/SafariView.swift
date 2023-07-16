// SafariView
// SafariView.swift
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

import SafariServices
import SwiftUI
import UIKit

/// A wrapper for `SFSafariViewController` in SwiftUI
@available(iOS 15.0, macCatalyst 15.0, *)
public struct SafariView: View {

    // MARK: - Initializers

    /// Create a SafariView
    /// - Parameters:
    ///   - url: URL to load
    ///   - activityButton: Custom activity button to include in the safari view
    ///   - onInitialLoad: Closure to execute on initial load
    ///   - onInitialRedirect: Closure to execute on intial redirect
    ///   - onOpenInBrowser: Closure to execute if a user moves from a `SafariView` to `Safari.app`
    public init(
        url: URL,
        activityButton: ActivityButton? = nil,
        onInitialLoad: ((_ didLoadSuccessfully: Bool) -> Void)? = nil,
        onInitialRedirect: ((_ url: URL) -> Void)? = nil,
        onOpenInBrowser: (() -> Void)? = nil
    ) {
        self.url = url
        self.activityButton = activityButton
        eventAttribution = nil
        self.onInitialLoad = onInitialLoad
        self.onInitialRedirect = onInitialRedirect
        self.onOpenInBrowser = onOpenInBrowser
    }

    /// Create a SafariView with tap attribution for Private Click Measurement
    ///
    /// For more information about preparing event attribution data, see [`UIEventAttribution`](https://developer.apple.com/documentation/uikit/uieventattribution)
    /// - Parameters:
    ///   - url: URL to load
    ///   - activityButton: Custom activity button to include in the safari view
    ///   - eventAttribution: An object you use to send tap event attribution data to the browser for Private Click Measurement.
    ///   - onInitialLoad: Closure to execute on initial load
    ///   - onInitialRedirect: Closure to execute on intial redirect
    ///   - onOpenInBrowser: Closure to execute if a user moves from a `SafariView` to `Safari.app`
    @available(iOS 15.2, macCatalyst 15.2, *)
    public init(
        url: URL,
        activityButton: ActivityButton? = nil,
        eventAttribution: UIEventAttribution?,
        onInitialLoad: ((_ didLoadSuccessfully: Bool) -> Void)? = nil,
        onInitialRedirect: ((_ url: URL) -> Void)? = nil,
        onOpenInBrowser: (() -> Void)? = nil
    ) {
        self.url = url
        self.activityButton = activityButton
        self.eventAttribution = eventAttribution
        self.onInitialLoad = onInitialLoad
        self.onInitialRedirect = onInitialRedirect
        self.onOpenInBrowser = onOpenInBrowser
    }

    // MARK: - API

    /// A convenience typealias for [`SFSafariViewController.DismissButtonStyle`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/dismissbuttonstyle)
    public typealias DismissButtonStyle = SFSafariViewController.DismissButtonStyle

    /// A convenience typealias for [`SFSafariViewController.ActivityButton`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/activitybutton)
    public typealias ActivityButton = SFSafariViewController.ActivityButton

    /// A convenience typealias for [`SFSafariViewController.PrewarmingToken`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/prewarmingtoken)
    ///
    /// You can generate prewarming tokens for invalidation using the ``prewarmConnections(to:)`` static method.
    public typealias PrewarmingToken = SFSafariViewController.PrewarmingToken

    /// Prewarm the connection to a list of provided URLs
    ///
    /// You can use this returned value of this method  to invalidate the prewarmed cache by invoking the `invaldate()` method on the token.
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let token = SafariView.prewarmConnections(to: [url])
    /// token.invalidate()
    /// ```
    ///
    /// - Parameter URLs: The URLs to prewarm
    /// - Returns: A prewarming token for the provided URLs.
    @discardableResult
    public static func prewarmConnections(to URLs: [URL]) -> PrewarmingToken {
        SFSafariViewController.prewarmConnections(to: URLs)
    }

    /// Clears the safari view's cache using [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/).
    @available(iOS 16.0, macCatalyst 16.0, *)
    public static func clearWebsiteData() async {
        await SFSafariViewController.DataStore.default.clearWebsiteData()
    }

    /// Clears the safari view's cache using a completion handler.
    /// - Parameter completionHandler: Closure to execute after the operation completes
    @available(iOS 16.0, macCatalyst 16.0, *)
    public static func clearWebsiteData(completionHandler: (() -> Void)?) {
        SFSafariViewController.DataStore.default.clearWebsiteData(completionHandler: completionHandler)
    }

    // MARK: - View

    public var body: some View {
        Safari(parent: self)
            .ignoresSafeArea(.container, edges: .all)
    }

    // MARK: - Private

    @Environment(\.safariViewEntersReaderIfAvailable)
    private var entersReaderIfAvailable: Bool

    @Environment(\.safariViewBarCollapsingEnabled)
    private var barCollapsingEnabled: Bool

    @Environment(\.safariViewBarTintColor)
    private var barTintColor: Color?

    @Environment(\.safariViewControlTintColor)
    private var controlTintColor: Color

    @Environment(\.safariViewDismissButtonStyle)
    private var dismissButtonStyle: DismissButtonStyle

    @Environment(\.safariViewIncludedActivities)
    private var includedActivities: IncludedActivities

    @Environment(\.safariViewExcludedActivityTypes)
    private var excludedActivityTypes: ExcludedActivityTypes

    private let activityButton: ActivityButton?
    private let eventAttribution: AnyObject?
    private let url: URL
    private let onInitialLoad: ((Bool) -> Void)?
    private let onInitialRedirect: ((URL) -> Void)?
    private let onOpenInBrowser: (() -> Void)?

    private func apply(to controller: SFSafariViewController) {
        controller.preferredBarTintColor = barTintColor.map(UIColor.init)
        controller.preferredControlTintColor = UIColor(controlTintColor)
        controller.dismissButtonStyle = dismissButtonStyle
    }

    private func buildConfiguration() -> SFSafariViewController.Configuration {
        let configuration = SFSafariViewController.Configuration()
        configuration.entersReaderIfAvailable = entersReaderIfAvailable
        configuration.barCollapsingEnabled = barCollapsingEnabled
        configuration.activityButton = activityButton
        if #available(iOS 15.2, *),
           let eventAttribution {
            configuration.eventAttribution = unsafeDowncast(eventAttribution, to: UIEventAttribution.self)
        }
        return configuration
    }

    private struct Safari: UIViewControllerRepresentable {

        // MARK: - Initializers

        init(parent: SafariView) {
            self.parent = parent
            delegate = Delegate(
                onInitialLoad: parent.onInitialLoad,
                onInitialRedirect: parent.onInitialRedirect,
                onOpenInBrowser: parent.onOpenInBrowser,
                includedActivities: parent.includedActivities,
                excludedActivityTypes: parent.excludedActivityTypes
            )
        }

        // MARK: - UIViewControllerRepresentable

        func makeUIViewController(context: Context) -> SFSafariViewController {
            let safari = SFSafariViewController(url: parent.url,
                                                configuration: parent.buildConfiguration())
            safari.modalPresentationStyle = .none
            safari.delegate = delegate
            parent.apply(to: safari)
            return safari
        }

        func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {
            parent.apply(to: uiViewController)
            uiViewController.delegate = delegate
        }

        // MARK: - Private

        private var parent: SafariView
        private let delegate: Delegate

        private final class Delegate: NSObject, SFSafariViewControllerDelegate {

            init(
                onInitialLoad: ((Bool) -> Void)?,
                onInitialRedirect: ((URL) -> Void)?,
                onOpenInBrowser: (() -> Void)?,
                includedActivities: IncludedActivities,
                excludedActivityTypes: ExcludedActivityTypes
            ) {
                self.onInitialLoad = onInitialLoad
                self.onInitialRedirect = onInitialRedirect
                self.onOpenInBrowser = onOpenInBrowser
                self.includedActivities = includedActivities
                self.excludedActivityTypes = excludedActivityTypes
            }

            // MARK: - SFSafariViewControllerDelegate

            func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                onInitialLoad?(didLoadSuccessfully)
            }

            func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                onInitialRedirect?(URL)
            }

            func safariViewController(
                _ controller: SFSafariViewController,
                activityItemsFor URL: URL,
                title: String?
            ) -> [UIActivity] {
                includedActivities(url: URL, pageTitle: title)
            }

            func safariViewController(
                _ controller: SFSafariViewController,
                excludedActivityTypesFor URL: URL,
                title: String?
            ) -> [UIActivity.ActivityType] {
                excludedActivityTypes(url: URL, pageTitle: title)
            }

            func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
                onOpenInBrowser?()
            }

            // MARK: - Private

            private let onInitialLoad: ((Bool) -> Void)?
            private let onInitialRedirect: ((URL) -> Void)?
            private let onOpenInBrowser: (() -> Void)?
            private var includedActivities: IncludedActivities
            private let excludedActivityTypes: ExcludedActivityTypes

        }

    }

    struct BoolModifier: ViewModifier {

        // MARK: - API

        @Binding
        var isPresented: Bool

        var build: () -> SafariView
        var onDismiss: () -> Void

        // MARK: - ViewModifier

        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(isPresented: $isPresented,
                              build: build,
                              onDismiss: onDismiss)
                )
        }

        // MARK: - Private

        private struct Presenter: UIViewRepresentable {

            // MARK: - API

            @Binding
            var isPresented: Bool

            var build: () -> SafariView
            var onDismiss: () -> Void

            // MARK: - UIViewRepresentable

            final class Coordinator: NSObject, SFSafariViewControllerDelegate {

                // MARK: - Initialziers

                init(parent: Presenter) {
                    self.parent = parent
                }

                // MARK: - API

                let view = UIView()

                var parent: Presenter

                var isPresented: Bool = false {
                    didSet {
                        switch (oldValue, isPresented) {
                        case (false, false):
                            break
                        case (false, true):
                            presentSafari()
                        case (true, false):
                            dismissSafari()
                        case (true, true):
                            updateSafari()
                        }
                    }
                }

                // MARK: - SFSafariViewControllerDelegate

                func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                    onInitialLoad?(didLoadSuccessfully)
                }

                func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                    onInitialRedirect?(URL)
                }

                func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                    parent.isPresented = false
                    parent.onDismiss()
                }

                func safariViewController(
                    _ controller: SFSafariViewController,
                    activityItemsFor URL: URL,
                    title: String?
                ) -> [UIActivity] {
                    includedActivities?(url: URL, pageTitle: title) ?? []
                }

                func safariViewController(
                    _ controller: SFSafariViewController,
                    excludedActivityTypesFor URL: URL,
                    title: String?
                ) -> [UIActivity.ActivityType] {
                    excludedActivityTypes?(url: URL, pageTitle: title) ?? []
                }

                func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
                    onOpenInBrowser?()
                }

                // MARK: - Private

                private weak var safari: SFSafariViewController?

                private var onInitialLoad: ((Bool) -> Void)?
                private var onInitialRedirect: ((URL) -> Void)?
                private var onOpenInBrowser: (() -> Void)?
                private var includedActivities: IncludedActivities?
                private var excludedActivityTypes: ExcludedActivityTypes?

                private func presentSafari() {
                    let rep = parent.build()
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    onOpenInBrowser = rep.onOpenInBrowser
                    includedActivities = rep.includedActivities
                    excludedActivityTypes = rep.excludedActivityTypes
                    let vc = SFSafariViewController(url: rep.url, configuration: rep.buildConfiguration())
                    vc.delegate = self
                    rep.apply(to: vc)

                    guard let presenting = view.controller else {
                        parent.isPresented = false
                        return
                    }
                    presenting.present(vc, animated: true)
                    safari = vc
                }

                private func updateSafari() {
                    guard let safari else {
                        return
                    }
                    let rep = parent.build()
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    onOpenInBrowser = rep.onOpenInBrowser
                    includedActivities = rep.includedActivities
                    excludedActivityTypes = rep.excludedActivityTypes
                    rep.apply(to: safari)
                }

                private func dismissSafari() {
                    guard let safari else {
                        return
                    }
                    safari.dismiss(animated: true) {
                        self.parent.onDismiss()
                    }
                }

            }

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

        }

    }

    struct IdentifiableItemModitifer<Item>: ViewModifier where Item: Identifiable {

        // MARK: - API

        @Binding
        var item: Item?

        var build: (Item) -> SafariView
        var onDismiss: () -> Void

        // MARK: - ViewModifier

        func body(content: Content) -> some View {
            content.background(
                Presenter(item: $item,
                          build: build,
                          onDismiss: onDismiss)
            )
        }

        // MARK: - Private

        private struct Presenter: UIViewRepresentable {

            // MARK: - API

            @Binding
            var item: Item?

            var build: (Item) -> SafariView
            var onDismiss: () -> Void

            // MARK: - UIViewRepresentable

            final class Coordinator: NSObject, SFSafariViewControllerDelegate {

                // MARK: - Initializers

                init(parent: Presenter) {
                    self.parent = parent
                }

                // MARK: - API

                let view = UIView()

                var parent: Presenter

                var item: Item? {
                    didSet {
                        switch (oldValue, item) {
                        case (.none, .none):
                            break
                        case let (.none, .some(newItem)):
                            presentSafari(with: newItem)
                        case let (.some(oldItem), .some(newItem)) where oldItem.id != newItem.id:
                            dismissSafari() {
                                self.presentSafari(with: newItem)
                            }
                        case let (.some, .some(newItem)):
                            updateSafari(with: newItem)
                        case (.some, .none):
                            dismissSafari()
                        }
                    }
                }

                // MARK: - SFSafariViewControllerDelegate

                func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                    parent.item = nil
                    parent.onDismiss()
                }

                func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                    onInitialRedirect?(URL)
                }

                func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                    onInitialLoad?(didLoadSuccessfully)
                }

                func safariViewController(
                    _ controller: SFSafariViewController,
                    activityItemsFor URL: URL,
                    title: String?
                ) -> [UIActivity] {
                    includedActivities?(url: URL, pageTitle: title) ?? []
                }

                func safariViewController(
                    _ controller: SFSafariViewController,
                    excludedActivityTypesFor URL: URL,
                    title: String?
                ) -> [UIActivity.ActivityType] {
                    excludedActivityTypes?(url: URL, pageTitle: title) ?? []
                }

                func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
                    onOpenInBrowser?()
                }

                // MARK: - Private

                private weak var safari: SFSafariViewController?

                private var onInitialLoad: ((Bool) -> Void)?
                private var onInitialRedirect: ((URL) -> Void)?
                private var onOpenInBrowser: (() -> Void)?
                private var includedActivities: IncludedActivities?
                private var excludedActivityTypes: ExcludedActivityTypes?

                private func presentSafari(with item: Item) {
                    let rep = parent.build(item)
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    onOpenInBrowser = rep.onOpenInBrowser
                    includedActivities = rep.includedActivities
                    excludedActivityTypes = rep.excludedActivityTypes
                    let vc = SFSafariViewController(url: rep.url, configuration: rep.buildConfiguration())
                    vc.delegate = self
                    rep.apply(to: vc)
                    guard let presenting = view.controller else {
                        parent.item = nil
                        return
                    }

                    presenting.present(vc, animated: true)

                    safari = vc
                }

                private func updateSafari(with item: Item) {
                    guard let safari else {
                        return
                    }
                    let rep = parent.build(item)
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    onOpenInBrowser = rep.onOpenInBrowser
                    includedActivities = rep.includedActivities
                    excludedActivityTypes = rep.excludedActivityTypes
                    rep.apply(to: safari)
                }

                private func dismissSafari(completion: (() -> Void)? = nil) {
                    guard let safari else {
                        return
                    }

                    safari.dismiss(animated: true) {
                        self.parent.onDismiss()
                        completion?()
                    }
                }
            }

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
        }
    }

    struct ItemModifier<Item, Identifier>: ViewModifier where Identifier: Hashable {

        // MARK: - Initializers

        init(
            item: Binding<Item?>,
            id: KeyPath<Item, Identifier>,
            onDismiss: (() -> Void)? = nil,
            @ViewBuilder safariView: @escaping (Item) -> SafariView
        ) {
            self.item = item
            self.id = id
            self.onDismiss = onDismiss
            self.safariView = safariView
        }

        // MARK: - ViewModifier

        @ViewBuilder
        func body(content: Content) -> some View {
            content
                .safari(item: binding, onDismiss: onDismiss) { wrappedItem in
                    safariView(wrappedItem.item)
                }
        }

        // MARK: - Private

        private let item: Binding<Item?>
        private let id: KeyPath<Item, Identifier>
        private let onDismiss: (() -> Void)?
        private let safariView: (Item) -> SafariView

        private var binding: Binding<WrappedItem?> {
            Binding<WrappedItem?> {
                guard let item = item.wrappedValue else {
                    return nil
                }
                return WrappedItem(item, id)
            } set: { newValue in
                item.wrappedValue = newValue?.item
            }
        }

        private struct WrappedItem: Identifiable {
            init(_ item: Item,
                 _ keyPath: KeyPath<Item, Identifier>) {
                self.item = item
                self.keyPath = keyPath
            }

            let item: Item
            private let keyPath: KeyPath<Item, Identifier>

            typealias ID = Identifier

            var id: ID {
                item[keyPath: keyPath]
            }
        }
    }

}

private extension UIView {

    var controller: UIViewController? {
        if let nextResponder = next as? UIViewController {
            return nextResponder
        } else if let nextResponder = next as? UIView {
            return nextResponder.controller
        } else {
            return nil
        }
    }

}
