// SafariUI
// InlineSafariView.swift
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

    import Foundation
    import SafariServices
    import SwiftUI
    import UIKit

    @available(iOS 14.0, macCatalyst 14.0, *)
    struct InlineSafariView: UIViewControllerRepresentable {

        init(
            url: URL
        ) {
            self.url = url
        }

        typealias UIViewControllerType = SFSafariViewController

        private let url: URL

        func makeCoordinator() -> SafariView.Delegate {
            SafariView.Delegate()
        }

        func makeUIViewController(
            context: Context
        ) -> UIViewControllerType {
            context.coordinator.install(context.environment)
            let controller = SFSafariViewController(url: url, configuration: context.environment.safariViewConfiguration.uikit)
            controller.delegate = context.coordinator
            controller.modalPresentationStyle = .none
            if #unavailable(iOS 26.0, macCatalyst 26.0) {
                controller.preferredBarTintColor = context.environment.safariViewBarTintColor.map(UIColor.init)
                controller.preferredControlTintColor = context.environment.safariViewControlTintColor.map(UIColor.init)
            }
            controller.dismissButtonStyle = context.environment.safariViewDismissButtonStyle.uikit
            return controller
        }

        func updateUIViewController(
            _ uiViewController: UIViewControllerType,
            context: Context
        ) {
            context.coordinator.install(context.environment)
            uiViewController.delegate = context.coordinator
            uiViewController.modalPresentationStyle = .none
            if #unavailable(iOS 26.0, macCatalyst 26.0) {
                uiViewController.preferredBarTintColor = context.environment.safariViewBarTintColor.map(UIColor.init)
                uiViewController.preferredControlTintColor = context.environment.safariViewControlTintColor.map(UIColor.init)
            }
            uiViewController.dismissButtonStyle = context.environment.safariViewDismissButtonStyle.uikit
        }

    }

#endif
