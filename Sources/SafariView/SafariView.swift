// SafariUI
// SafariView.swift
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

import Foundation
import SafariServices
import SwiftUI
import UIKit

/// A wrapper for `SFSafariViewController` in SwiftUI
@available(iOS 14.0, visionOS 1.0, macCatalyst 14.0, *)
public struct SafariView: View {

    // MARK: - Initializers

    /// Create a SafariView
    /// - Parameters:
    ///   - url: URL to load
    ///   - onInitialLoad: Closure to execute on initial load
    ///   - onInitialRedirect: Closure to execute on intial redirect
    ///   - onOpenInBrowser: Closure to execute if a user moves from a `SafariView` to `Safari.app`
    public init(
        url: URL,
        onInitialLoad: ((_ didLoadSuccessfully: Bool) -> Void)? = nil,
        onInitialRedirect: ((_ url: URL) -> Void)? = nil,
        onOpenInBrowser: (() -> Void)? = nil
    ) {
        self.url = url
        activityButton = nil
        eventAttribution = nil
        self.onInitialLoad = onInitialLoad
        self.onInitialRedirect = onInitialRedirect
        self.onOpenInBrowser = onOpenInBrowser
    }

    /// Create a SafariView with a custom activity button
    /// - Parameters:
    ///   - url: URL to load
    ///   - activityButton: Custom activity button to include in the safari view
    ///   - onInitialLoad: Closure to execute on initial load
    ///   - onInitialRedirect: Closure to execute on intial redirect
    ///   - onOpenInBrowser: Closure to execute if a user moves from a `SafariView` to `Safari.app`
    @available(iOS 15.0, visionOS 1.0, macCatalyst 15.0, *)
    public init(
        url: URL,
        activityButton: ActivityButton?,
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

    /// Create a `SafariView` with tap attribution for Private Click Measurement
    ///
    /// For more information about preparing event attribution data, see [`UIEventAttribution`](https://developer.apple.com/documentation/uikit/uieventattribution)
    /// - Parameters:
    ///   - url: URL to load
    ///   - activityButton: Custom activity button to include in the safari view
    ///   - eventAttribution: An object you use to send tap event attribution data to the browser for Private Click Measurement.
    ///   - onInitialLoad: Closure to execute on initial load
    ///   - onInitialRedirect: Closure to execute on intial redirect
    ///   - onOpenInBrowser: Closure to execute if a user moves from a `SafariView` to `Safari.app`
    @available(iOS 15.2, visionOS 1.0, macCatalyst 15.2, *)
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

    /// A convenience typealias for [`SFSafariViewController.ActivityButton`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/activitybutton)
    @available(iOS 15.0, visionOS 1.0, macCatalyst 15.0, *)
    public typealias ActivityButton = SFSafariViewController.ActivityButton

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
    @available(iOS 15.0, visionOS 1.0, macCatalyst 15.0, *)
    @discardableResult
    public static func prewarmConnections(to URLs: [URL]) -> PrewarmingToken {
        let token = SFSafariViewController.prewarmConnections(to: URLs)
        return .init(token, urls: URLs)
    }

    /// Clears the safari view's cache using [Swift Concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/).
    @available(iOS 16.0, visionOS 1.0, macCatalyst 16.0, *)
    public static func clearWebsiteData() async {
        await SFSafariViewController.DataStore.default.clearWebsiteData()
    }

    /// Clears the safari view's cache using a completion handler.
    /// - Parameter completionHandler: Closure to execute after the operation completes
    @available(iOS 16.0, visionOS 1.0, macCatalyst 16.0, *)
    public static func clearWebsiteData(completionHandler: (() -> Void)?) {
        SFSafariViewController.DataStore.default.clearWebsiteData(completionHandler: completionHandler)
    }

    @_documentation(visibility: internal)
    @MainActor
    @ViewBuilder
    public var body: some View {
        Safari(
            url: url,
            onInitialLoad: onInitialLoad,
            onInitialRedirect: onInitialRedirect,
            onOpenInBrowser: onOpenInBrowser,
            activityButton: activityButton,
            eventAttribution: eventAttribution
        )
        .ignoresSafeArea(
            .container,
            edges: .all
        )
    }

    // MARK: - Private

    private struct Safari: UIViewControllerRepresentable {

        // MARK: - Initializers

        init(
            url: URL,
            onInitialLoad: ((Bool) -> Void)?,
            onInitialRedirect: ((URL) -> Void)?,
            onOpenInBrowser: (() -> Void)?,
            activityButton: AnyObject?,
            eventAttribution: AnyObject?
        ) {
            self.url = url
            delegate = .init(
                onInitialLoad: onInitialLoad,
                onInitialRedirect: onInitialRedirect,
                onOpenInBrowser: onOpenInBrowser
            )
            self.activityButton = activityButton
            self.eventAttribution = eventAttribution
        }

        // MARK: - UIViewControllerRepresentable

        typealias UIViewControllerType = SFSafariViewController

        func makeUIViewController(context: Context) -> UIViewControllerType {
            let controller = SFSafariViewController(url: url, configuration: buildConfiguration())
            controller.delegate = delegate
            delegate.includedActivities = includedActivities
            delegate.excludedActivityTypes = excludedActivityTypes
            controller.modalPresentationStyle = .none
            controller.preferredBarTintColor = barTintColor.map(UIColor.init)
            controller.preferredControlTintColor = UIColor(controlTintColor)
            controller.dismissButtonStyle = dismissButtonStyle.uikit
            return controller
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
            delegate.includedActivities = includedActivities
            delegate.excludedActivityTypes = excludedActivityTypes
            uiViewController.preferredBarTintColor = barTintColor.map(UIColor.init)
            uiViewController.preferredControlTintColor = UIColor(controlTintColor)
            uiViewController.dismissButtonStyle = dismissButtonStyle.uikit
        }

        // MARK: - Private

        private final class Delegate: NSObject, SFSafariViewControllerDelegate {

            // MARK: - Initializers

            init(
                onInitialLoad: ((Bool) -> Void)?,
                onInitialRedirect: ((URL) -> Void)?,
                onOpenInBrowser: (() -> Void)?
            ) {
                self.onInitialLoad = onInitialLoad
                self.onInitialRedirect = onInitialRedirect
                self.onOpenInBrowser = onOpenInBrowser
            }

            // MARK: - API

            var includedActivities: SafariView.IncludedActivities = []
            var excludedActivityTypes: SafariView.ExcludedActivityTypes = []

            // MARK: - Private

            private let onInitialLoad: ((Bool) -> Void)?
            private let onInitialRedirect: ((URL) -> Void)?
            private let onOpenInBrowser: (() -> Void)?

        }

        private let url: URL
        private let delegate: Delegate
        private let activityButton: AnyObject?
        private let eventAttribution: AnyObject?

        @Environment(\.safariViewEntersReaderIfAvailable)
        private var entersReaderIfAvailable: Bool

        @Environment(\.safariViewBarCollapsingEnabled)
        private var barCollapsingEnabled: Bool

        @Environment(\.safariViewBarTintColor)
        private var barTintColor: Color?

        @Environment(\.safariViewControlTintColor)
        private var controlTintColor: Color

        @Environment(\.safariViewDismissButtonStyle)
        private var dismissButtonStyle: SafariView.DismissButtonStyle

        @Environment(\.safariViewIncludedActivities)
        private var includedActivities: SafariView.IncludedActivities

        @Environment(\.safariViewExcludedActivityTypes)
        private var excludedActivityTypes: SafariView.ExcludedActivityTypes

        private func buildConfiguration() -> SFSafariViewController.Configuration {
            let configuration = SFSafariViewController.Configuration()
            configuration.entersReaderIfAvailable = entersReaderIfAvailable
            configuration.barCollapsingEnabled = barCollapsingEnabled
            if #available(iOS 15.0, macCatalyst 15.0, *),
               let activityButton {
                configuration.activityButton = unsafeDowncast(activityButton, to: SafariView.ActivityButton.self)
            }
            if #available(iOS 15.2, *),
               let eventAttribution {
                configuration.eventAttribution = unsafeDowncast(eventAttribution, to: UIEventAttribution.self)
            }
            return configuration
        }

    }

    package let url: URL
    package let onInitialLoad: ((Bool) -> Void)?
    package let onInitialRedirect: ((URL) -> Void)?
    package let onOpenInBrowser: (() -> Void)?
    package let activityButton: AnyObject?
    package let eventAttribution: AnyObject?

}
