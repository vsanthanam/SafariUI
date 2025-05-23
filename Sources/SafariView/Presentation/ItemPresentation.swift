// SafariUI
// ItemPresentation.swift
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

@available(iOS 14.0, macCatalyst 14.0, *)
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
    /// struct InventoryItem: Identifiable {
    ///     let id: Int
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
    ///         List(inventory) { inventoryItem in
    ///             Button(action: {
    ///                 self.selectedItem = inventoryItem
    ///             }) {
    ///                 Text(inventoryItem.title)
    ///             }
    ///         }
    ///         .safari(item: $selectedItem,
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
    ///   - presentationStyle: The ``SafariView/PresentationStyle`` used to present the ``SafariView``.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari<Item>(
        item: Binding<Item?>,
        presentationStyle: SafariView.PresentationStyle = .default,
        onDismiss: (@MainActor () -> Void)? = nil,
        safariView: @escaping (Item) -> SafariView
    ) -> some View where Item: Identifiable {
        ModifiedContent(
            content: self,
            modifier: ItemModifier(
                item: item,
                presentationStyle: presentationStyle,
                safariView: safariView
            )
        )
    }

}

private struct ItemModifier<Item>: ViewModifier where Item: Identifiable {

    // MARK: - Initializers

    init(
        item: Binding<Item?>,
        presentationStyle: SafariView.PresentationStyle,
        safariView: @escaping (Item) -> SafariView,
        onDismiss: (@MainActor () -> Void)? = nil
    ) {
        _item = item
        self.presentationStyle = presentationStyle
        self.safariView = safariView
        self.onDismiss = onDismiss
    }

    // MARK: - ViewModifier

    @MainActor
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .background(
                Presenter(
                    item: $item,
                    presentationStyle: presentationStyle,
                    safariView: safariView,
                    onDismiss: { onDismiss?() }
                )
            )
    }

    // MARK: - Private

    private struct Presenter: UIViewRepresentable {

        // MARK: - Initializers

        init(
            item: Binding<Item?>,
            presentationStyle: SafariView.PresentationStyle,
            safariView: @escaping (Item) -> SafariView,
            onDismiss: (@MainActor () -> Void)?
        ) {
            _item = item
            self.presentationStyle = presentationStyle
            self.safariView = safariView
            self.onDismiss = onDismiss
        }

        // MARK: - UIViewRepresentable

        typealias UIViewType = UIView

        @MainActor
        final class Coordinator: NSObject, SFSafariViewControllerDelegate {

            // MARK: - Initializer

            init(
                item: Item? = nil,
                presentationStyle: SafariView.PresentationStyle,
                safariView: @escaping (Item) -> SafariView,
                bindingSetter: @escaping (Item?) -> Void,
                onDismiss: (@MainActor () -> Void)?
            ) {
                self.item = item
                self.presentationStyle = presentationStyle
                self.safariView = safariView
                self.bindingSetter = bindingSetter
                self.onDismiss = onDismiss
            }

            // MARK: - API

            var item: Item? = nil {
                didSet {
                    switch (oldValue, item) {
                    case (.none, .none):
                        break
                    case let (.none, .some(item)):
                        presentSafari(item)
                    case (.some, .none):
                        dismissSafari()
                    case (.some, .some):
                        updateSafari()
                    }
                }
            }

            let view = UIView()
            var entersReaderIfAvailable: Bool = false
            var barCollapsingEnabled: Bool = false
            var barTintColor: Color? = nil
            var controlTintColor: Color = .accentColor
            var dismissButtonStyle: SafariView.DismissButtonStyle = .default
            var includedActivities: SafariView.IncludedActivities = []
            var excludedActivityTypes: SafariView.ExcludedActivityTypes = []

            // MARK: - SFSafariViewDelegate

            nonisolated func safariViewController(
                _ controller: SFSafariViewController,
                didCompleteInitialLoad didLoadSuccessfully: Bool
            ) {
                MainActor.assumeIsolated {
                    onInitialLoad?(didLoadSuccessfully)
                }
            }

            nonisolated func safariViewController(
                _ controller: SFSafariViewController,
                initialLoadDidRedirectTo URL: URL
            ) {
                MainActor.assumeIsolated {
                    onInitialRedirect?(URL)
                }
            }

            nonisolated func safariViewControllerDidFinish(
                _ controller: SFSafariViewController
            ) {
                MainActor.assumeIsolated {
                    onDismiss?()
                    bindingSetter(nil)
                }
            }

            nonisolated func safariViewController(
                _ controller: SFSafariViewController,
                activityItemsFor URL: URL,
                title: String?
            ) -> [UIActivity] {
                MainActor.assumeIsolated {
                    includedActivities(url: URL, pageTitle: title)
                }
            }

            nonisolated func safariViewController(
                _ controller: SFSafariViewController,
                excludedActivityTypesFor URL: URL,
                title: String?
            ) -> [UIActivity.ActivityType] {
                MainActor.assumeIsolated {
                    excludedActivityTypes(url: URL, pageTitle: title)
                }
            }

            nonisolated func safariViewControllerWillOpenInBrowser(_ controller: SFSafariViewController) {
                MainActor.assumeIsolated {
                    onOpenInBrowser?()
                }
            }

            // MARK: - Private

            private weak var safariViewController: SFSafariViewController?
            private let presentationStyle: SafariView.PresentationStyle
            private let safariView: (Item) -> SafariView
            private var bindingSetter: (Item?) -> Void
            private var onInitialLoad: (@MainActor (Bool) -> Void)?
            private var onInitialRedirect: (@MainActor (URL) -> Void)?
            private var onOpenInBrowser: (@MainActor () -> Void)?
            private var onDismiss: (@MainActor () -> Void)?
            private var activityButton: AnyObject?
            private var eventAttribution: AnyObject?

            private func presentSafari(_ item: Item) {
                let safari = safariView(item)
                onInitialLoad = safari.onInitialLoad
                onInitialRedirect = safari.onInitialRedirect
                onOpenInBrowser = safari.onOpenInBrowser
                activityButton = safari.activityButton
                eventAttribution = safari.eventAttribution
                let vc = SFSafariViewController(url: safari.url, configuration: buildConfiguration())
                vc.delegate = self
                vc.preferredBarTintColor = barTintColor.map(UIColor.init)
                vc.preferredControlTintColor = UIColor(controlTintColor)
                vc.dismissButtonStyle = dismissButtonStyle.uikit
                switch presentationStyle {
                case .standard:
                    break
                case .formSheet:
                    vc.modalPresentationStyle = .formSheet
                case .pageSheet:
                    vc.modalPresentationStyle = .pageSheet
                }
                guard let presenting = view.controller else {
                    bindingSetter(nil)
                    return
                }
                presenting.present(vc, animated: true)
                safariViewController = vc

            }

            private func dismissSafari() {
                safariViewController?.dismiss(animated: true)
            }

            private func updateSafari() {
                safariViewController?.preferredBarTintColor = barTintColor.map(UIColor.init)
                safariViewController?.preferredControlTintColor = UIColor(controlTintColor)
                safariViewController?.dismissButtonStyle = dismissButtonStyle.uikit
            }

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

        func makeCoordinator() -> Coordinator {
            .init(
                item: item,
                presentationStyle: presentationStyle,
                safariView: safariView,
                bindingSetter: { newValue in item = newValue },
                onDismiss: onDismiss
            )
        }

        func makeUIView(context: Context) -> UIViewType {
            context.coordinator.entersReaderIfAvailable = context.environment.safariViewEntersReaderIfAvailable
            context.coordinator.barCollapsingEnabled = context.environment.safariViewBarCollapsingEnabled
            context.coordinator.barTintColor = context.environment.safariViewBarTintColor
            context.coordinator.controlTintColor = context.environment.safariViewControlTintColor
            context.coordinator.dismissButtonStyle = context.environment.safariViewDismissButtonStyle
            context.coordinator.includedActivities = context.environment.safariViewIncludedActivities
            context.coordinator.excludedActivityTypes = context.environment.safariViewExcludedActivityTypes
            context.coordinator.item = item
            return context.coordinator.view
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.entersReaderIfAvailable = context.environment.safariViewEntersReaderIfAvailable
            context.coordinator.barCollapsingEnabled = context.environment.safariViewBarCollapsingEnabled
            context.coordinator.barTintColor = context.environment.safariViewBarTintColor
            context.coordinator.controlTintColor = context.environment.safariViewControlTintColor
            context.coordinator.dismissButtonStyle = context.environment.safariViewDismissButtonStyle
            context.coordinator.includedActivities = context.environment.safariViewIncludedActivities
            context.coordinator.excludedActivityTypes = context.environment.safariViewExcludedActivityTypes
            context.coordinator.item = item
        }

        // MARK: - Private

        @Binding
        private var item: Item?

        private let presentationStyle: SafariView.PresentationStyle
        private let safariView: (Item) -> SafariView
        private let onDismiss: (@MainActor () -> Void)?

    }

    @Binding
    private var item: Item?

    private let presentationStyle: SafariView.PresentationStyle
    private let safariView: (Item) -> SafariView
    private let onDismiss: (() -> Void)?

}

extension UIView {

    var controller: UIViewController? {
        if let nextResponder = next as? UIViewController {
            nextResponder
        } else if let nextResponder = next as? UIView {
            nextResponder.controller
        } else {
            nil
        }
    }

}

extension UIActivity: @retroactive @unchecked Sendable {}
