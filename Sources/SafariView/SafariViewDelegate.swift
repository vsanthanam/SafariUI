// SafariUI
// SafariViewDelegate.swift
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
    import SwiftUI
    import UIKit

    @available(iOS 14.0, macCatalyst 14.0, *)
    extension SafariView {

        @MainActor
        class Delegate: NSObject, @MainActor SFSafariViewControllerDelegate {

            var includedActivities: SafariView.IncludedActivities = []
            var excludedActivityTypes: SafariView.ExcludedActivityTypes = []
            var onInitialLoad: @MainActor (Bool) -> Void = { _ in }
            var onDismiss: @MainActor () -> Void = {}
            var onInitialRedirect: @MainActor (URL) -> Void = { _ in }
            var onOpenInBrowser: @MainActor () -> Void = {}

            func install(_ environment: EnvironmentValues) {
                includedActivities = environment.safariViewIncludedActivities
                excludedActivityTypes = environment.safariViewExcludedActivityTypes
                onInitialLoad = environment.safariViewOnInitialLoad
                onDismiss = environment.safariViewOnDismiss
                onInitialRedirect = environment.safariViewOnInitialRedirect
                onOpenInBrowser = environment.safariViewOnOpenInBrowser
            }

            func safariViewController(
                _ controller: SFSafariViewController,
                activityItemsFor URL: URL,
                title: String?
            ) -> [UIActivity] {
                includedActivities(
                    url: URL,
                    pageTitle: title
                )
            }

            func safariViewController(
                _ controller: SFSafariViewController,
                excludedActivityTypesFor URL: URL,
                title: String?
            ) -> [UIActivity.ActivityType] {
                excludedActivityTypes(
                    url: URL,
                    pageTitle: title
                )
            }

            func safariViewController(
                _ controller: SFSafariViewController,
                didCompleteInitialLoad didLoadSuccessfully: Bool
            ) {
                onInitialLoad(didLoadSuccessfully)
            }

            func safariViewControllerDidFinish(
                _ controller: SFSafariViewController
            ) {
                onDismiss()
            }

            func safariViewController(
                _ controller: SFSafariViewController,
                initialLoadDidRedirectTo URL: URL
            ) {
                onInitialRedirect(URL)
            }

            func safariViewControllerWillOpenInBrowser(
                _ controller: SFSafariViewController
            ) {
                onOpenInBrowser()
            }
        }

    }

#endif
