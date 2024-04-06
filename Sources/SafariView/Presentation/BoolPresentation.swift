// SafariUI
// BoolPresentation.swift
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

@available(iOS 14.0, visionOS 1.0, macCatalyst 14.0, *)
public extension View {

    /// Presents a ``SafariView`` when a binding to a Boolean value that you provide is `true`.
    ///
    /// Use this method when you want to present a ``SafariView`` to the user when a Boolean value you provide is true.
    /// The example below displays a modal view of the mockup for a software license agreement when the user toggles the `isShowingSafari` variable by clicking or tapping on the “Show License Agreement” button:
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
    ///         Button {
    ///             isShowingSafari.toggle()
    ///         } label: {
    ///             Text("Show License Agreement")
    ///         }
    ///         .safari(isPresented: $isShowingSafari,
    ///                 onDismiss: didDismiss) {
    ///             SafariView(url: licenseAgreementURL)
    ///         }
    ///     }
    ///
    ///     func didDismiss() {
    ///         // Handle the dismissing action.
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether to present the ``SafariView`` that you create in the modifier’s content closure.
    ///   - presentationStyle: The ``SafariView/PresentationStyle`` used to present the ``SafariView``.
    ///   - onDismiss: The closure to execute when dismissing the ``SafariView``
    ///   - safariView: A closure that returns the ``SafariView`` to present
    /// - Returns: The modified view
    func safari(
        isPresented: Binding<Bool>,
        presentationStyle: SafariView.PresentationStyle = .default,
        onDismiss: (() -> Void)? = nil,
        safariView: () -> SafariView
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: IsPresentedModifier(
                isPresented: isPresented,
                presentationStyle: presentationStyle,
                safariView: safariView(),
                onDismiss: onDismiss
            )
        )
    }

}

@available(iOS 14.0, visionOS 1.0, macCatalyst 14.0, *)
private struct IsPresentedModifier: ViewModifier {

    // MARK: - Initializer

    init(
        isPresented: Binding<Bool>,
        presentationStyle: SafariView.PresentationStyle,
        safariView: SafariView,
        onDismiss: (() -> Void)?
    ) {
        self.isPresented = isPresented
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
                    isPresented: isPresented,
                    url: safariView.url,
                    presentationStyle: presentationStyle,
                    onInitialLoad: safariView.onInitialLoad,
                    onInitialRedirect: safariView.onInitialRedirect,
                    onOpenInBrowser: safariView.onOpenInBrowser,
                    onDismiss: onDismiss,
                    activityButton: safariView.activityButton,
                    eventAttribution: safariView.eventAttribution
                )
            )
    }

    // MARK: - Private

    private struct Presenter: UIViewRepresentable {

        init(
            isPresented: Binding<Bool>,
            url: URL,
            presentationStyle: SafariView.PresentationStyle,
            onInitialLoad: ((Bool) -> Void)?,
            onInitialRedirect: ((URL) -> Void)?,
            onOpenInBrowser: (() -> Void)?,
            onDismiss: (() -> Void)?,
            activityButton: AnyObject?,
            eventAttribution: AnyObject?
        ) {
            _isPresented = isPresented
            self.url = url
            self.presentationStyle = presentationStyle
            self.onInitialLoad = onInitialLoad
            self.onInitialRedirect = onInitialRedirect
            self.onOpenInBrowser = onOpenInBrowser
            self.onDismiss = onDismiss
            self.activityButton = activityButton
            self.eventAttribution = eventAttribution
        }

        typealias UIViewType = UIView

        func makeCoordinator() -> Coordinator {
            .init(
                isPresented: isPresented,
                url: url,
                presentationStyle: presentationStyle,
                bindingSetter: { newValue in isPresented = newValue },
                onInitialLoad: onInitialLoad,
                onInitialRedirect: onInitialRedirect,
                onOpenInBrowser: onOpenInBrowser,
                onDismiss: onDismiss,
                activityButton: activityButton,
                eventAttribution: eventAttribution
            )
        }

        func makeUIView(context: Context) -> UIViewType {
            context.coordinator.entersReaderIfAvailable = entersReaderIfAvailable
            context.coordinator.barCollapsingEnabled = barCollapsingEnabled
            context.coordinator.barTintColor = barTintColor
            context.coordinator.controlTintColor = controlTintColor
            context.coordinator.dismissButtonStyle = dismissButtonStyle
            context.coordinator.includedActivities = includedActivities
            context.coordinator.excludedActivityTypes = excludedActivityTypes
            context.coordinator.isPresented = isPresented
            return context.coordinator.view
        }

        func updateUIView(_ uiView: UIViewType, context: Context) {
            context.coordinator.entersReaderIfAvailable = entersReaderIfAvailable
            context.coordinator.barCollapsingEnabled = barCollapsingEnabled
            context.coordinator.barTintColor = barTintColor
            context.coordinator.controlTintColor = controlTintColor
            context.coordinator.dismissButtonStyle = dismissButtonStyle
            context.coordinator.includedActivities = includedActivities
            context.coordinator.excludedActivityTypes = excludedActivityTypes
            context.coordinator.isPresented = isPresented
        }

        final class Coordinator: NSObject, SFSafariViewControllerDelegate {

            init(
                isPresented: Bool,
                url: URL,
                presentationStyle: SafariView.PresentationStyle,
                bindingSetter: @escaping (Bool) -> Void,
                onInitialLoad: ((Bool) -> Void)?,
                onInitialRedirect: ((URL) -> Void)?,
                onOpenInBrowser: (() -> Void)?,
                onDismiss: (() -> Void)?,
                activityButton: AnyObject?,
                eventAttribution: AnyObject?
            ) {
                self.isPresented = isPresented
                self.url = url
                self.presentationStyle = presentationStyle
                self.bindingSetter = bindingSetter
                self.onInitialLoad = onInitialLoad
                self.onInitialRedirect = onInitialRedirect
                self.onOpenInBrowser = onOpenInBrowser
                self.onDismiss = onDismiss
                self.activityButton = activityButton
                self.eventAttribution = eventAttribution
            }

            let view = UIView()

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

            var entersReaderIfAvailable: Bool = false
            var barCollapsingEnabled: Bool = false
            var barTintColor: Color? = nil
            var controlTintColor: Color = .accentColor
            var dismissButtonStyle: SafariView.DismissButtonStyle = .default
            var includedActivities: SafariView.IncludedActivities = []
            var excludedActivityTypes: SafariView.ExcludedActivityTypes = []

            func safariViewController(_ controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
                onInitialLoad?(didLoadSuccessfully)
            }

            func safariViewController(_ controller: SFSafariViewController, initialLoadDidRedirectTo URL: URL) {
                onInitialRedirect?(URL)
            }

            func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
                onDismiss?()
                bindingSetter(false)
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

            private weak var safariViewController: SFSafariViewController?
            private let url: URL
            private let presentationStyle: SafariView.PresentationStyle
            private let bindingSetter: (Bool) -> Void
            private let onInitialLoad: ((Bool) -> Void)?
            private let onInitialRedirect: ((URL) -> Void)?
            private let onOpenInBrowser: (() -> Void)?
            private let onDismiss: (() -> Void)?
            private let activityButton: AnyObject?
            private let eventAttribution: AnyObject?

            private func presentSafari() {
                let vc = SFSafariViewController(url: url, configuration: buildConfiguration())
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
                    bindingSetter(false)
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

        @Binding
        private var isPresented: Bool

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

        private let url: URL
        private let presentationStyle: SafariView.PresentationStyle
        private let onInitialLoad: ((Bool) -> Void)?
        private let onInitialRedirect: ((URL) -> Void)?
        private let onOpenInBrowser: (() -> Void)?
        private let onDismiss: (() -> Void)?
        private let activityButton: AnyObject?
        private let eventAttribution: AnyObject?

    }

    private let isPresented: Binding<Bool>
    private let presentationStyle: SafariView.PresentationStyle
    private let safariView: SafariView
    private let onDismiss: (() -> Void)?

}
