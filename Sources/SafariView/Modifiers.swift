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

@available(iOS 14.0, macCatalyst 14.0, *)
public extension View {

    /// Set the automatic reader behavior of safari views within this view
    ///
    /// This modifier is the equivelent of the of the [`entersReaderIfAvailable`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration/1648471-entersreaderifavailable) property of a [`SFSafariViewController.Configuration`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration)
    ///
    /// - Parameter entersReaderIfAvailable: Whether or not the safari view should automatically enter reader mode if available.
    /// - Returns: The modified view
    func safariEntersReaderIfAvailable(_ entersReaderIfAvailable: Bool = true) -> some View {
        let modifier = SafariViewEntersReaderIfAvailableModifier(entersReaderIfAvailable: entersReaderIfAvailable)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Set the bar collapsing behavior of safari views within this view
    ///
    /// This modifier is the equivelent of the of the [`barCollapsingEnabled`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration/2887469-barcollapsingenabled) property of a [`SFSafariViewController.Configuration`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/configuration)
    ///
    /// - Parameter barCollapsingEnabled: Whether or not bar collpasing should be enabled.
    /// - Returns: The modified view
    func safariBarCollapsingEnabled(_ barCollapsingEnabled: Bool = true) -> some View {
        let modifier = SafariViewBarCollapsingEnabledModifier(barCollapsingEnabled: barCollapsingEnabled)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Set the bar tint color of safari views within this view
    ///
    /// This modifier is the equivelent of the [`.preferredBarTintColor`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/2274394-preferredbartintcolor) property of a [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
    ///
    /// - Parameter color: The color to use, or `nil` for the system default
    /// - Returns: The modified view
    func safariBarTintColor(_ color: Color?) -> some View {
        let modifier = SafariViewBarTintColorModifier(safariViewBarTintColor: color)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Set the control tint color of safari views within this view
    ///
    /// This modifier is the equivelent of the [`.preferredControlTintColor`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/2274393-preferredcontroltintcolor) property of a [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
    ///
    /// - Parameter color: The color to use
    /// - Returns: The modified view
    func safariControlTintColor(_ color: Color) -> some View {
        let modifier = SafariViewControlTintColorModifier(safariViewControlTintColor: color)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Set the safari view's dismiss button style
    ///
    /// This modifer is the equivelent of the [`.dismissButtonStyle` ](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/2875838-dismissbuttonstyle) property of a  [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
    ///
    /// - Parameter dismissButtonStyle: The desired dismiss button style
    /// - Returns: The modified content
    func safariDismissButtonStyle(_ dismissButtonStyle: SafariView.DismissButtonStyle) -> some View {
        let modifier = SafariViewDismissButtonStyleModifier(safariViewDismissButtonStyle: dismissButtonStyle)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Include additional activities in the share sheet of safari views within this view.
    ///
    /// Use this modifier to include a list of activities to display in the share sheet of a ``SafariView``
    ///
    /// This modifier replaces the previous values in the environment with the supplied values.
    /// If you wish to append values to the existing environment instead, you'll need to retrieve them first, like so:
    ///
    /// ```swift
    /// struct MyView: View {
    ///
    ///     @Environment(\.safariViewIncludedActivities)
    ///     var safariActivities
    ///
    ///     var body: some View {
    ///         SafariView(url: some_url)
    ///             .includedSafariActivities(safariActivities + newValues)
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameter activities: The activities to include. You may use an array literal of `UIActivity` types.
    /// - Returns: The modified content
    func includedSafariActivities(_ activities: SafariView.IncludedActivities) -> some View {
        let modifier = SafariViewIncludedActivitiesModifier(activities: activities)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Conditionally include activities in the share sheet of safari views within this view.
    ///
    /// Use this modifier to conditionally include additional activities to display in the share sheet of a ``SafariView``, based in the URL and page title.
    ///
    /// This modifier replaces the previous values in the environment with the supplied values.
    /// If you wish to append values to the existing environment instead, you'll need to retrieve them first, like so:
    ///
    /// ```swift
    /// struct MyView: View {
    ///
    ///     @Environment(\.safariViewIncludedActivities)
    ///     var safariActivities
    ///
    ///     var body: some View {
    ///         SafariView(url: some_url)
    ///             .includedSafariActivities { url, pageTitle in
    ///                 // custom logic
    ///                 return safariActivities + newValues
    ///             }
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameter activities: Closure used to conditionally include activities
    /// - Returns: The modified content
    func includedSafariActivities(_ activities: @escaping (_ url: URL, _ pageTitle: String?) -> [UIActivity]) -> some View {
        let activities = SafariView.IncludedActivities(activities)
        let modifier = SafariViewIncludedActivitiesModifier(activities: activities)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Exclude activity types from the share sheet of safari views within this view.
    ///
    /// Use this modifier to exclude a list of activity types from the share sheet of a ``SafariView``
    ///
    /// This modifier replaces the previous values in the environment with the supplied values.
    /// If you wish to append values to the existing environment instead, you'll need to retrieve them first, like so:
    ///
    /// ```swift
    /// struct MyView: View {
    ///
    ///     @Environment(\.safariViewExcludedActivityTypes)
    ///     var excludedTypes
    ///
    ///     var body: some View {
    ///         SafariView(url: some_url)
    ///             .excludedSafariActivityTypes(excludedTypes + newValues)
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameter activityTypes: The activity types to exclude. You may use an array literal of `UIActivity.ActivityType` values.
    /// - Returns: The modified content
    func excludedSafariActivityTypes(_ activityTypes: SafariView.ExcludedActivityTypes) -> some View {
        let modifier = SafariViewExcludedActivityTypesModifier(activityTypes: activityTypes)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Conditionally exclude activity types from the share sheet of safari views within this view.
    ///
    /// Use this modifier to conditionally exclude activity types from the share sheet of a ``SafariView``, based on the URL and page title.
    ///
    /// This modifier replaces the previous values in the environment with the supplied values.
    /// If you wish to append values to the existing environment instead, you'll need to retrieve them first, like so:
    ///
    /// ```swift
    /// struct MyView: View {
    ///
    ///     @Environment(\.safariViewExcludedActivityTypes)
    ///     var excludedTypes
    ///
    ///     var body: some View {
    ///         SafariView(url: some_url) { url, pageTitle in
    ///             // custom logic
    ///             return excludedTypes + newValues
    ///         }
    ///     }
    ///
    /// }
    /// ```
    ///
    /// - Parameter activityTypes: Closure used to conditionally exclude activities
    /// - Returns: The modified content
    func excludedSafariActivityTypes(_ activityTypes: @escaping (_ url: URL, _ pageTitle: String?) -> [UIActivity.ActivityType]) -> some View {
        let activityTypes = SafariView.ExcludedActivityTypes(activityTypes)
        let modifier = SafariViewExcludedActivityTypesModifier(activityTypes: activityTypes)
        return ModifiedContent(content: self, modifier: modifier)
    }

}

private struct SafariViewEntersReaderIfAvailableModifier: ViewModifier {

    // MARK: - Initializers

    init(entersReaderIfAvailable: Bool) {
        self.entersReaderIfAvailable = entersReaderIfAvailable
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewEntersReaderIfAvailable, entersReaderIfAvailable)
    }

    // MARK: - Private

    private let entersReaderIfAvailable: Bool

}

private struct SafariViewBarCollapsingEnabledModifier: ViewModifier {

    // MARK: - Initializers

    init(barCollapsingEnabled: Bool) {
        self.barCollapsingEnabled = barCollapsingEnabled
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewBarCollapsingEnabled, barCollapsingEnabled)
    }

    // MARK: - Private

    private let barCollapsingEnabled: Bool
}

private struct SafariViewControlTintColorModifier: ViewModifier {

    // MARK: - Initializers

    init(safariViewControlTintColor: Color) {
        self.safariViewControlTintColor = safariViewControlTintColor
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewControlTintColor, safariViewControlTintColor)
    }

    // MARK: - Private

    private let safariViewControlTintColor: Color

}

private struct SafariViewBarTintColorModifier: ViewModifier {

    // MARK: - Initializers

    init(safariViewBarTintColor: Color?) {
        self.safariViewBarTintColor = safariViewBarTintColor
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewBarTintColor, safariViewBarTintColor)
    }

    // MARK: - Private

    private let safariViewBarTintColor: Color?

}

private struct SafariViewDismissButtonStyleModifier: ViewModifier {

    // MARK: - Initializers

    init(safariViewDismissButtonStyle: SafariView.DismissButtonStyle) {
        self.safariViewDismissButtonStyle = safariViewDismissButtonStyle
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewDismissButtonStyle, safariViewDismissButtonStyle)
    }

    // MARK: - Private

    private let safariViewDismissButtonStyle: SafariView.DismissButtonStyle

}

private struct SafariViewIncludedActivitiesModifier: ViewModifier {

    // MARK: - Initializers

    init(activities: SafariView.IncludedActivities) {
        self.activities = activities
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewIncludedActivities, activities)
    }

    // MARK: - Private

    private let activities: SafariView.IncludedActivities

}

private struct SafariViewExcludedActivityTypesModifier: ViewModifier {

    // MARK: - Initializers

    init(activityTypes: SafariView.ExcludedActivityTypes) {
        self.activityTypes = activityTypes
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewExcludedActivityTypes, activityTypes)
    }

    // MARK: - Private

    private let activityTypes: SafariView.ExcludedActivityTypes

}
