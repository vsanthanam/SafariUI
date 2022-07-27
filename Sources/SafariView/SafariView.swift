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
///
/// A `SafariView` is a wrapper around [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller) for use within SwiftUI applications.
///
/// You can present a `SafariView` using one of our provided view modifers, like so:
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
/// You can also use sheet presentation, or any other presentation mechanism of your choice.
///
/// ## Topics
///
/// ### Initializers
///
/// - ``init(url:)``
/// - ``init(url:configuration:)``
///
/// ### Modifiers
///
/// - ``accentColor(_:)``
/// - ``preferredBarTintColor(_:)``
/// - ``preferredControlTintColor(_:)``
/// - ``dismissButtonStyle(_:)``
/// - ``entersReaderIfAvailable(_:)``
/// - ``barCollapsingEnabled(_:)``
/// - ``activityButton(_:)``
/// - ``eventAttribution(_:)``
/// - ``onInitialLoad(_:)``
/// - ``onInitialRedirect(_:)``
/// - ``activityItems(_:)-3mpe3``
/// - ``activityItems(_:)-2yuvl``
public struct SafariView: View {

    // MARK: - Initializers

    /// Create a `SafariView`
    /// - Parameter url: The URL to load in the view
    public init(url: URL) {
        self.init(url: url,
                  configuration: .init())
    }

    /// Create a `SafariView`
    ///
    /// - Parameters:
    ///   - url: The URL to load in the view
    ///   - configuration: The ``Configuration`` to use
    public init(url: URL, configuration: Configuration) {
        self.url = url
        self.configuration = configuration
    }

    // MARK: - API

    /// A convenience typealias for [`SFSafariViewController.Configuration`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration)
    public typealias Configuration = SFSafariViewController.Configuration

    /// A convenience typealias for [`SFSafariViewController.DismissButtonStyle`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/dismissbuttonstyle)
    public typealias DismissButtonStyle = SFSafariViewController.DismissButtonStyle

    /// A convenience typealias for [`SFSafariViewController.ActivityButton`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/activitybutton)
    public typealias ActivityButton = SFSafariViewController.ActivityButton

    /// A convenience typealias for [`SFSafariViewController.PrewarmingToken`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/prewarmingtoken)
    public typealias PrewarmingToken = SFSafariViewController.PrewarmingToken

    /// Apply an accent color to the view
    ///
    /// Use this modifier to set the view's accent color
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .accentColor(.blue)
    /// ```
    ///
    /// - Parameter color: The color to use
    /// - Returns: The safari view
    public func accentColor(_ accentColor: Color?) -> Self {
        preferredControlTintColor(accentColor)
    }

    /// Apply an bar tint color to the view
    ///
    /// This modifier is equivelent to `SFSafariViewController`'s `.preferredBarTintColor` property
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .preferredBarTintColor(.blue)
    /// ```
    ///
    /// - Parameter color: The color to use
    /// - Returns: The safari view
    public func preferredBarTintColor(_ color: Color?) -> Self {
        var modified = self
        modified.barTintColor = color
        return modified
    }

    /// Apply a control tint color to the view
    ///
    /// This modifier is equivelent to `SFSafariViewController`'s `.preferredControlTintColor` property
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .preferredControlTintColor(.blue)
    /// ```
    ///
    /// - Parameter color: The color to use
    /// - Returns: The safari view
    public func preferredControlTintColor(_ color: Color?) -> Self {
        var modified = self
        modified.controlTintColor = color
        return modified
    }

    /// Set the safari view's dismiss button style
    ///
    /// Use this modifier to set the view's dismiss button style.
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .dismissButtonStyle(.cancel)
    /// ```
    ///
    /// - Parameter style: The dismiss button style of the safari view
    /// - Returns: The safari view
    public func dismissButtonStyle(_ style: DismissButtonStyle) -> Self {
        var modified = self
        modified.dismissButtonStyle = style
        return modified
    }

    /// Set the safari view's automatic reader mode setting
    ///
    /// Set the value to `true` if Reader mode should be entered automatically when it is available for the webpage; otherwise, `false`. The default value is `false`.
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .entersReaderIfAvailable(true)
    /// ```
    ///
    /// This value that specifies whether Safari should enter Reader mode, if it is available.
    /// - Parameter entersReaderIfAvailable: `true` to automatically enter reader mode when available, otherwise `false`
    /// - Returns: The safari view
    public func entersReaderIfAvailable(_ entersReaderIfAvailable: Bool) -> Self {
        configuration.entersReaderIfAvailable = entersReaderIfAvailable
        return self
    }

    /// Set the safari view's bar collapsing setting
    ///
    /// Use this modifier to set the bar collapsing behavior of the view
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .barCollapsingEnabled(true)
    /// ```
    ///
    /// - Parameter barCollapsingEnabled: `true` to enable bar collapsing, otherwise `false`
    /// - Returns: The safari view
    public func barCollapsingEnabled(_ barCollapsingEnabled: Bool) -> Self {
        configuration.barCollapsingEnabled = barCollapsingEnabled
        return self
    }

    /// Set the safari view's activity button
    ///
    /// Use this modifier to set the view's activity button. See ``ActivityButton`` for more information,
    ///
    /// ```swift
    /// let activityButton = SafarView.ActivityButton( ... )
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .activityButton(activityButton)
    /// ```
    ///
    /// - Parameter activityButton: The activity button
    /// - Returns: The safari view
    public func activityButton(_ activityButton: ActivityButton?) -> Self {
        configuration.activityButton = activityButton
        return self
    }

    /// Set the safari view's event attribution
    ///
    /// Use this modifier to set the view's event attribution.
    /// For more information about preparing event attribution data, see [`UIEventAttribution`](https://developer.apple.com/documentation/uikit/uieventattribution).
    ///
    /// ```swift
    /// let attribution = UIEventAttribution( ... )
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .eventAttribution(attribution)
    /// ```
    ///
    /// - Parameter eventAttribution: The event attribution to use
    /// - Returns: The safari view
    @available(iOS 15.2, *)
    public func eventAttribution(_ eventAttribution: UIEventAttribution?) -> Self {
        configuration.eventAttribution = eventAttribution
        return self
    }

    /// Set a function to call when the page first loads
    ///
    /// This closure is invoked when `SafariView` completes the loading of the URL that you pass to its initializer. The closure is not invoked for any subsequent page loads in the same `SafariView` instance.
    ///
    /// This method behaves similarly to [`SFSafariViewControllerDelegate`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontrollerdelegate) method [`safariViewController(_:didCompleteInitialLoad:)`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontrollerdelegate/1621215-safariviewcontroller)
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .onInitialLoad { didLoadSuccessfully in
    ///         if didLoadSuccessfully {
    ///             print("Success!")
    ///         } else {
    ///             print("Failre!")
    ///         }
    ///     }
    /// ```
    ///
    /// - Parameter onInitialLoad: The function to execute when page first loads
    /// - Returns: The safari view
    public func onInitialLoad(_ onInitialLoad: ((_ didLoadSuccessfully: Bool) -> Void)? = nil) -> Self {
        var modified = self
        modified.onInitialLoad = onInitialLoad ?? { _ in }
        return modified
    }

    /// Set a function to call if the first page load causes a redirection
    ///
    /// This closure is invoked when `SafariView`'s initial URL results in a redirection. The closure is not invoked for any subsequent page loads in the same `SafariView` instance.
    ///
    /// This method behaves similarly to [`SFSafariViewControllerDelegate`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontrollerdelegate) method [`safariViewController(_:initialLoadDidRedirectTo:)`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontrollerdelegate/2923545-safariviewcontroller)
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .onInitialRedirect { newURL in
    ///         print("Redirected to URL \(newURL.description)")
    ///     }
    /// ```
    ///
    /// - Parameter onInitialRedirect: The function to execute when the initial page load causes a redirection
    /// - Returns: The safari view
    public func onInitialRedirect(_ onInitialRedirect: ((_ url: URL) -> Void)? = nil) -> Self {
        var modified = self
        modified.onInitialRedirect = onInitialRedirect ?? { _ in }
        return modified
    }

    /// Add [`UIActivity`](https://developer.apple.com/documentation/uikit/uiactivity) items to the Safari View
    ///
    /// Use this modifier to conditionally add activity items to the view based on the user's current URL or page title.
    /// If you wish to show activity items that persiste regardless of the user's activity, use the ``activityItems(_:)-3mpe3`` modifier instead
    ///
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .activtyItems { url, title in
    ///         if title == "MyTitle" {
    ///             return [item1, item2]
    ///         } else {
    ///             return [item3, item4]
    ///         }
    ///     }
    /// ```
    ///
    /// - Parameter items: The items to show in the `SafariView`
    /// - Returns: The safari view
    public func activityItems(_ itemProvider: ((_ url: URL, _ pageTitle: String?) -> [UIActivity])? = nil) -> Self {
        var modified = self
        modified.itemProvider = itemProvider ?? { _, _ in [] }
        return modified
    }

    /// Add [`UIActivity`](https://developer.apple.com/documentation/uikit/uiactivity) items to the Safari View
    ///
    /// The items you provided are shown with every URL the user might view in the `SafariView`.
    /// If you wish to conditionally show items based on the current URL or page title, use the ``activityItems(_:)-2yuvl`` modifier instead.
    ///
    /// ```swift
    /// let url = URL(string: "https://www.apple.com")!
    /// let view = SafariView(url: url)
    ///     .activtyItems([item1, item1])
    /// ```
    ///
    /// - Parameter items: The items to show in the `SafariView`
    /// - Returns: The safari view
    public func activityItems(_ items: [UIActivity]) -> Self {
        var modified = self
        modified.activityItems = items
        return modified
    }

    /// Prewarm the connection to a list of provided URLs
    ///
    /// You can use this returned value of this method  to invalidate the prewarmed cache by invoking the `invaldate()` method on the token.
    ///
    /// - Parameter URLs: The URLs to prewarm
    /// - Returns: A prewarming token for the provided URLs.
    public static func prewarmConnections(to URLs: [URL]) -> PrewarmingToken {
        SFSafariViewController.prewarmConnections(to: URLs)
    }

    // MARK: - View

    public var body: some View {
        Safari(parent: self)
            .ignoresSafeArea(.container, edges: .all)
    }

    // MARK: - Private

    struct Modifier: ViewModifier {

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
                    onInitialLoad(didLoadSuccessfully)
                }

                func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                    onInitialRedirect(URL)
                }

                func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                    parent.isPresented = false
                    parent.onDismiss()
                }

                func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
                    withActivityItems(URL, title)
                }

                // MARK: - Private

                private weak var safari: SFSafariViewController?

                private var onInitialLoad: (Bool) -> Void = { _ in }
                private var onInitialRedirect: (URL) -> Void = { _ in }
                private var withActivityItems: (URL, String?) -> [UIActivity] = { _, _ in [] }

                private func presentSafari() {
                    let rep = parent.build()
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    withActivityItems = rep.withActivityItems
                    let vc = SFSafariViewController(url: rep.url, configuration: rep.configuration)
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
                    guard let safari = safari else {
                        return
                    }
                    let rep = parent.build()
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    withActivityItems = rep.withActivityItems
                    rep.apply(to: safari)
                }

                private func dismissSafari() {
                    guard let safari = safari else {
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

    struct ItemModitifer<Item>: ViewModifier where Item: Identifiable {

        // MARK: - API

        @Binding
        var item: Item?

        var build: (Item) -> SafariView
        var onDismiss: () -> Void

        // MARK: - ViewModifier

        func body(content: Content) -> some View {
            content.background(
                Presenter<Item>(item: $item,
                                build: build,
                                onDismiss: onDismiss)
            )
        }

        // MARK: - Private

        private struct Presenter<Item>: UIViewRepresentable where Item: Identifiable {

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
                    onInitialRedirect(URL)
                }

                func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                    onInitialLoad(didLoadSuccessfully)
                }

                func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
                    withActivityItems(URL, title)
                }

                // MARK: - Private

                private weak var safari: SFSafariViewController?

                private var onInitialLoad: (Bool) -> Void = { _ in }
                private var onInitialRedirect: (URL) -> Void = { _ in }
                private var withActivityItems: (URL, String?) -> [UIActivity] = { _, _ in [] }

                private func presentSafari(with item: Item) {
                    let rep = parent.build(item)
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    withActivityItems = rep.withActivityItems
                    let vc = SFSafariViewController(url: rep.url, configuration: rep.configuration)
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
                    guard let safari = safari else {
                        return
                    }
                    let rep = parent.build(item)
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    withActivityItems = rep.withActivityItems
                    rep.apply(to: safari)
                }

                private func dismissSafari(completion: (() -> Void)? = nil) {
                    guard let safari = safari else {
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

    struct URLModifier: ViewModifier {

        @Binding
        var url: URL?

        var build: (URL) -> SafariView
        var onDismiss: () -> Void

        func body(content: Content) -> some View {
            content
                .background(
                    Presenter(url: $url,
                              build: build,
                              onDismiss: onDismiss)
                )
        }

        private struct Presenter: UIViewRepresentable {

            @Binding
            var url: URL?

            var build: (URL) -> SafariView
            var onDismiss: () -> Void

            final class Coordinator: NSObject, SFSafariViewControllerDelegate {

                // MARK: - Initializers

                init(parent: Presenter) {
                    self.parent = parent
                }

                // MARK: - API

                let view = UIView()

                var parent: Presenter

                var url: URL? {
                    didSet {
                        switch (oldValue, url) {
                        case (.none, .none):
                            break
                        case let (.none, .some(new)):
                            presentSafari(with: new)
                        case let (.some(old), .some(new)) where old != new:
                            dismissSafari() { [presentSafari] in
                                presentSafari(new)
                            }
                        case let (.some, .some(new)):
                            updateSafari(with: new)
                        case (.some, .none):
                            dismissSafari()
                        }
                    }
                }

                // MARK: - SFSafariViewControllerDelegate

                func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                    parent.url = nil
                    parent.onDismiss()
                }

                func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                    onInitialRedirect(URL)
                }

                func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                    onInitialLoad(didLoadSuccessfully)
                }

                func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
                    withActivityItems(URL, title)
                }

                // MARK: - Private

                private weak var safari: SFSafariViewController?

                private var onInitialLoad: (Bool) -> Void = { _ in }
                private var onInitialRedirect: (URL) -> Void = { _ in }
                private var withActivityItems: (URL, String?) -> [UIActivity] = { _, _ in [] }

                private func presentSafari(with url: URL) {
                    let rep = parent.build(url)
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    withActivityItems = rep.withActivityItems
                    let vc = SFSafariViewController(url: rep.url, configuration: rep.configuration)
                    vc.delegate = self
                    rep.apply(to: vc)
                    guard let presenting = view.controller else {
                        parent.url = url
                        return
                    }

                    presenting.present(vc, animated: true)

                    safari = vc
                }

                private func updateSafari(with url: URL) {
                    guard let safari = safari else {
                        return
                    }
                    let rep = parent.build(url)
                    onInitialLoad = rep.onInitialLoad
                    onInitialRedirect = rep.onInitialRedirect
                    withActivityItems = rep.withActivityItems
                    rep.apply(to: safari)
                }

                private func dismissSafari(_ completion: (() -> Void)? = nil) {
                    guard let safari = safari else {
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
                context.coordinator.url = url
            }

        }

    }

    private struct Safari: UIViewControllerRepresentable {

        // MARK: - Initializers

        init(parent: SafariView) {
            self.parent = parent
            delegate = Delegate(onInitialLoad: parent.onInitialLoad,
                                onInitialRedirect: parent.onInitialRedirect,
                                withActivityItems: parent.withActivityItems)
        }

        // MARK: - UIViewControllerRepresentable

        func makeUIViewController(context: Context) -> SFSafariViewController {
            let safari = SFSafariViewController(url: parent.url,
                                                configuration: parent.configuration)

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

            init(onInitialLoad: @escaping (Bool) -> Void,
                 onInitialRedirect: @escaping (URL) -> Void,
                 withActivityItems: @escaping (URL, String?) -> [UIActivity]) {
                self.onInitialLoad = onInitialLoad
                self.onInitialRedirect = onInitialRedirect
                self.withActivityItems = withActivityItems
            }

            // MARK: - SFSafariViewDelegate

            func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                onInitialLoad(didLoadSuccessfully)
            }

            func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                onInitialRedirect(URL)
            }

            func safariViewController(_ controller: SFSafariViewController, activityItemsFor URL: URL, title: String?) -> [UIActivity] {
                withActivityItems(URL, title)
            }

            private let onInitialLoad: (Bool) -> Void
            private let onInitialRedirect: (URL) -> Void
            private let withActivityItems: (URL, String?) -> [UIActivity]
        }

    }

    private let url: URL
    private var configuration: Configuration
    private var barTintColor: Color?
    private var controlTintColor: Color?
    private var dismissButtonStyle: DismissButtonStyle = .done
    private var onInitialLoad: (Bool) -> Void = { _ in }
    private var onInitialRedirect: (URL) -> Void = { _ in }
    private var itemProvider: (URL, String?) -> [UIActivity] = { _, _ in [] }
    private var activityItems: [UIActivity] = []

    private func withActivityItems(_ url: URL, _ title: String?) -> [UIActivity] {
        itemProvider(url, title) + activityItems
    }

    private func apply(to controller: SFSafariViewController) {
        controller.preferredBarTintColor = barTintColor.map(UIColor.init)
        controller.preferredControlTintColor = controlTintColor.map(UIColor.init)
        controller.dismissButtonStyle = dismissButtonStyle
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
