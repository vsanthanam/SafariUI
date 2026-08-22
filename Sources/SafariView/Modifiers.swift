// SafariUI
// Modifiers.swift
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

import SwiftUI
#if os(iOS)
    import UIKit
#endif

@available(iOS 14.0, macCatalyst 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension View {

    @available(iOS, introduced: 14.0, deprecated: 26.0)
    @available(macCatalyst, introduced: 14.0, deprecated: 26.0)
    public func safariViewBarTintColor(
        _ barTintColor: Color?
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewBarTintColorModifier(
                    barTintColor: barTintColor
                )
            )
        #else
            self
        #endif
    }

    @available(iOS, introduced: 14.0, deprecated: 26.0)
    @available(macCatalyst, introduced: 14.0, deprecated: 26.0)
    public func safariViewControlTintColor(
        _ controlTintColor: Color?
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewControlTintColorModifier(
                    controlTintColor: controlTintColor
                )
            )
        #else
            self
        #endif
    }

    /// Set the configuration of safari views within this view
    ///
    /// - Important: Configuration values are consumed once, when the underlying `SFSafariViewController` is created — when an embedded ``SafariView`` first appears, or when a presentation modifier presents one. `SFSafariViewController` does not support changing its configuration after creation, so changing this value has no effect on an existing view. The new value applies to the next Safari view that is created or presented.
    /// - Parameter configuration: The configuration to use
    /// - Returns: The modified view
    public func safariViewConfiguration(
        _ configuration: SafariView.Configuration
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewConfigurationModifier(
                    configuration: configuration
                )
            )
        #else
            self
        #endif
    }

    public func safariViewDismissButtonStyle(
        _ dismissButtonStyle: SafariView.DismissButtonStyle
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewDismissButtonStyleModifier(
                    dismissButtonStyle: dismissButtonStyle
                )
            )
        #else
            self
        #endif
    }

    public func safariViewOnInitialLoad(
        _ onInitialLoad: @escaping @MainActor (Bool) -> Void
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewOnInitialLoadModifier(
                    onInitialLoad: onInitialLoad
                )
            )
        #else
            self
        #endif
    }

    public func safariViewOnDismiss(
        _ onDismiss: @escaping @MainActor () -> Void
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewOnDismissModifier(
                    onDismiss: onDismiss
                )
            )
        #else
            self
        #endif
    }

    public func safariViewOnInitialRedirect(
        _ onInitialRedirect: @escaping @MainActor (URL) -> Void
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewOnInitialRedirectModifier(
                    onInitialRedirect: onInitialRedirect
                )
            )
        #else
            self
        #endif
    }

    public func safariViewOnOpenInBrowser(
        _ onOpenInBrowser: @escaping @MainActor () -> Void
    ) -> some View {
        #if os(iOS)
            modifier(
                SafariViewOnOpenInBrowserModifier(
                    onOpenInBrowser: onOpenInBrowser
                )
            )
        #else
            self
        #endif
    }

}

#if os(iOS)

    @available(iOS 14.0, macCatalyst 14.0, *)
    extension View {

        public func includingSafariViewActivities(
            _ includedActivities: SafariView.IncludedActivities
        ) -> some View {
            modifier(
                SafariViewAddIncludedActivitiesModifier(
                    includedActivities: includedActivities
                )
            )
        }

        public func includingSafariViewActivities(
            _ includedActivities: [UIActivity]
        ) -> some View {
            modifier(
                SafariViewAddIncludedActivitiesModifier(
                    includedActivities: .init(includedActivities)
                )
            )
        }

        public func includingSafariViewActivities(
            _ includedActivities: @escaping @MainActor (_ url: URL, _ pageTitle: String?) -> [UIActivity]
        ) -> some View {
            modifier(
                SafariViewAddIncludedActivitiesModifier(
                    includedActivities: .init(includedActivities)
                )
            )
        }

        public func safariViewIncludedActivities(
            _ includedActivities: SafariView.IncludedActivities
        ) -> some View {
            modifier(
                SafariViewReplaceIncludedActivitiesModifier(
                    includedActivities: includedActivities
                )
            )
        }

        public func safariViewIncludedActivities(
            _ includedActivities: [UIActivity]
        ) -> some View {
            modifier(
                SafariViewReplaceIncludedActivitiesModifier(
                    includedActivities: .init(includedActivities)
                )
            )
        }

        public func safariViewIncludedActivities(
            _ includedActivities: @escaping @MainActor (_ url: URL, _ pageTitle: String?) -> [UIActivity]
        ) -> some View {
            modifier(
                SafariViewReplaceIncludedActivitiesModifier(
                    includedActivities: .init(includedActivities)
                )
            )
        }

        public func excludingSafariViewActivityTypes(
            _ excluedActivityTypes: SafariView.ExcludedActivityTypes
        ) -> some View {
            modifier(
                SafariViewAddExcludedActivityTypesModifier(
                    excludedActivityTypes: excluedActivityTypes
                )
            )
        }

        public func excludingSafariViewActivityTypes(
            _ excludedActivityTypes: [UIActivity.ActivityType]
        ) -> some View {
            modifier(
                SafariViewAddExcludedActivityTypesModifier(
                    excludedActivityTypes: .init(excludedActivityTypes)
                )
            )
        }

        public func excludingSafariViewActivityTypes(
            _ excludedActivityTypes: @escaping @MainActor (URL, String?) -> [UIActivity.ActivityType]
        ) -> some View {
            modifier(
                SafariViewAddExcludedActivityTypesModifier(
                    excludedActivityTypes: .init(excludedActivityTypes)
                )
            )
        }

        public func safariViewExcludedActivityTypes(
            _ excludedActivityTypes: SafariView.ExcludedActivityTypes
        ) -> some View {
            modifier(
                SafariViewReplaceExcludedActivityTypesModifier(
                    excludedActivityTypes: excludedActivityTypes
                )
            )
        }

        public func safariViewExcludedActivityTypes(
            _ excludedActivityTypes: [UIActivity.ActivityType]
        ) -> some View {
            modifier(
                SafariViewReplaceExcludedActivityTypesModifier(
                    excludedActivityTypes: .init(excludedActivityTypes)
                )
            )
        }

        public func safariViewExcludedActivityTypes(
            _ excludedActivityTypes: @escaping @MainActor (URL, String?) -> [UIActivity.ActivityType]
        ) -> some View {
            modifier(
                SafariViewReplaceExcludedActivityTypesModifier(
                    excludedActivityTypes: .init(excludedActivityTypes)
                )
            )
        }
    }

    @available(iOS, introduced: 14.0, deprecated: 26.0)
    @available(macCatalyst, introduced: 14.0, deprecated: 26.0)
    private struct SafariViewBarTintColorModifier: ViewModifier {

        let barTintColor: Color?

        func body(content: Content) -> some View {
            content
                .environment(
                    \.safariViewBarTintColor,
                    barTintColor
                )
        }

    }

    @available(iOS, introduced: 14.0, deprecated: 26.0)
    @available(macCatalyst, introduced: 14.0, deprecated: 26.0)
    private struct SafariViewControlTintColorModifier: ViewModifier {

        let controlTintColor: Color?

        func body(content: Content) -> some View {
            content
                .environment(
                    \.safariViewControlTintColor,
                    controlTintColor
                )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewConfigurationModifier: ViewModifier {

        let configuration: SafariView.Configuration

        func body(content: Content) -> some View {
            content
                .environment(
                    \.safariViewConfiguration,
                    configuration
                )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewDismissButtonStyleModifier: ViewModifier {

        let dismissButtonStyle: SafariView.DismissButtonStyle

        func body(content: Content) -> some View {
            content
                .environment(
                    \.safariViewDismissButtonStyle,
                    dismissButtonStyle
                )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewAddIncludedActivitiesModifier: ViewModifier {

        let includedActivities: SafariView.IncludedActivities

        func body(content: Content) -> some View {
            content.transformEnvironment(
                \.safariViewIncludedActivities
            ) { activities in
                activities = activities + includedActivities
            }
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewReplaceIncludedActivitiesModifier: ViewModifier {

        let includedActivities: SafariView.IncludedActivities

        func body(content: Content) -> some View {
            content.environment(
                \.safariViewIncludedActivities,
                includedActivities
            )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewAddExcludedActivityTypesModifier: ViewModifier {

        let excludedActivityTypes: SafariView.ExcludedActivityTypes

        func body(content: Content) -> some View {
            content.transformEnvironment(
                \.safariViewExcludedActivityTypes,
            ) { activityTypes in
                activityTypes = activityTypes + excludedActivityTypes
            }
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewReplaceExcludedActivityTypesModifier: ViewModifier {

        let excludedActivityTypes: SafariView.ExcludedActivityTypes

        func body(content: Content) -> some View {
            content.environment(
                \.safariViewExcludedActivityTypes,
                excludedActivityTypes
            )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewOnInitialLoadModifier: ViewModifier {

        let onInitialLoad: @MainActor (Bool) -> Void

        func body(content: Content) -> some View {
            content.environment(
                \.safariViewOnInitialLoad,
                onInitialLoad
            )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewOnDismissModifier: ViewModifier {

        let onDismiss: @MainActor () -> Void

        func body(content: Content) -> some View {
            content.environment(
                \.safariViewOnDismiss,
                onDismiss
            )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewOnInitialRedirectModifier: ViewModifier {

        let onInitialRedirect: @MainActor (URL) -> Void

        func body(content: Content) -> some View {
            content.environment(
                \.safariViewOnInitialRedirect,
                onInitialRedirect
            )
        }

    }

    @available(iOS 14.0, macCatalyst 14.0, *)
    private struct SafariViewOnOpenInBrowserModifier: ViewModifier {

        let onOpenInBrowser: @MainActor () -> Void

        func body(content: Content) -> some View {
            content.environment(
                \.safariViewOnOpenInBrowser,
                onOpenInBrowser
            )
        }

    }

#endif
