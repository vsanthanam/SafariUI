// SafariView
// Modifiers.swift
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

import SwiftUI

public extension View {

    /// Set the configuration of safari views within this view.
    /// - Parameter configuration: The safari configuration to use
    /// - Returns: The modified view
    func safariConfiguration(_ configuration: SafariView.Configuration) -> some View {
        let modifier = SafariViewConfigurationModifier(configuration: configuration)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Set the bar tint color of safari views within this view
    ///
    /// This modifier is the equivelent of the [`.preferredBarTintColor`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/2274394-preferredbartintcolor) property of a [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
    /// - Parameter color: The color to use, or `nil` for the system default
    /// - Returns: The modified view
    func safariBarTintColor(_ color: Color?) -> some View {
        let modifier = SafariViewBarTintColorModifier(safariViewBarTintColor: color)
        return ModifiedContent(content: self, modifier: modifier)
    }

    /// Set the controk tint color of safari views within this view
    ///
    /// This modifier is the equivelent of the [`.preferredControlTintColor`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller/2274393-preferredcontroltintcolor) property of a [`SFSafariViewController`](https://developer.apple.com/documentation/safariservices/sfsafariviewcontroller)
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

    func includedSafariActivities(_ includedActivities: SafariView.IncludedActivities) -> some View {
        let modifier = SafariViewIncludedActivitiesModifier(includedActivities: includedActivities)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func includedSafariActivities(_ includedActivities: @escaping (_ url: URL, _ pageTitle: String?) -> [UIActivity]) -> some View {
        let activities = SafariView.IncludedActivities(includedActivities)
        let modifier = SafariViewIncludedActivitiesModifier(includedActivities: activities)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func excludedSafariActivityTypes(_ excludedActivityTypes: SafariView.ExcludedActivityTypes) -> some View {
        let modifier = SafariViewExcludedActivityTypesModifier(excludedActivityTypes: excludedActivityTypes)
        return ModifiedContent(content: self, modifier: modifier)
    }

    func excludedSafariActivityTypes(_ excludedActivityTypes: @escaping (_ url: URL, _ pageTitle: String?) -> [UIActivity.ActivityType]) -> some View {
        let activityTypes = SafariView.ExcludedActivityTypes(excludedActivityTypes)
        let modifier = SafariViewExcludedActivityTypesModifier(excludedActivityTypes: activityTypes)
        return ModifiedContent(content: self, modifier: modifier)
    }

}

private struct SafariViewConfigurationModifier: ViewModifier {

    // MARK: - Initializers

    init(configuration: SafariView.Configuration) {
        self.configuration = configuration
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewConfiguration, configuration)
    }

    // MARK: - Private

    private let configuration: SafariView.Configuration

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

    init(includedActivities: SafariView.IncludedActivities) {
        self.includedActivities = includedActivities
    }

    // MARK: - ViewModifier

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewIncludedActivities, includedActivities)
    }

    // MARK: - Private

    private let includedActivities: SafariView.IncludedActivities

}

private struct SafariViewExcludedActivityTypesModifier: ViewModifier {

    // MARK: - Initializers

    init(excludedActivityTypes: SafariView.ExcludedActivityTypes) {
        self.excludedActivityTypes = excludedActivityTypes
    }

    // MARK: - ViewBuilder

    @ViewBuilder
    func body(content: Content) -> some View {
        content
            .environment(\.safariViewExcludedActivityTypes, excludedActivityTypes)
    }

    // MARK: - Private

    private let excludedActivityTypes: SafariView.ExcludedActivityTypes

}
