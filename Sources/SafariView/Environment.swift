// SafariUI
// Environment.swift
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
public extension EnvironmentValues {

    /// The additional activies to include the share sheet displayed inside a ``SafariView``
    ///
    /// You can retrieve this value for the currnet scope using the `@Environment` property wrapper
    ///
    /// ```swift
    /// struct MyView: View {
    ///
    ///     @Environment(\.safariViewIncludedActivities)
    ///     var safariViewIncludedActivities
    ///
    /// }
    /// ```
    var safariViewIncludedActivities: SafariView.IncludedActivities {
        get { self[SafariViewIncludedActivitiesEnvironmentKey.self] }
        set { self[SafariViewIncludedActivitiesEnvironmentKey.self] = newValue }
    }

    /// The activity types to exclude from the share sheet displayed inside a ``SafariView``
    ///
    /// You can retrieve this value for the currnet scope using the `@Environment` property wrapper
    ///
    /// ```swift
    /// struct MyView: View {
    ///
    ///     @Environment(\.safariViewExcludedActivityTypes)
    ///     var safariViewExcludedActivityTypes
    ///
    /// }
    /// ```
    var safariViewExcludedActivityTypes: SafariView.ExcludedActivityTypes {
        get { self[SafariViewExcludedActivityTypesEnvironmentKey.self] }
        set { self[SafariViewExcludedActivityTypesEnvironmentKey.self] = newValue }
    }

    /// The presentation style used by the ``SafariView`` presentation view modifiers.
    ///
    /// You can retrieve this value for the current scope using the `@Environment` property wrapper
    ///
    /// ```swift
    /// struct MyView {
    ///
    ///     @Environment(\.safariViewPresentationStyle)
    ///     var safariViewPresentationStyle
    ///
    /// }
    /// ```
    var safariViewPresentationStyle: SafariView.PresentationStyle {
        get { self[SafariViewPresentationStyleEnvironmentKey.self] }
        set { self[SafariViewPresentationStyleEnvironmentKey.self] = newValue }
    }
}

@available(iOS 14.0, macCatalyst 14.0, *)
extension EnvironmentValues {

    var safariViewEntersReaderIfAvailable: Bool {
        get { self[SafariViewEntersReaderIfAvailableEnvironmentKey.self] }
        set { self[SafariViewEntersReaderIfAvailableEnvironmentKey.self] = newValue }
    }

    var safariViewBarCollapsingEnabled: Bool {
        get { self[SafariViewBarCollapsingEnabledEnvironmentKey.self] }
        set { self[SafariViewBarCollapsingEnabledEnvironmentKey.self] = newValue }
    }

    var safariViewControlTintColor: Color {
        get { self[SafariViewControlTintColorEnvironmentKey.self] }
        set { self[SafariViewControlTintColorEnvironmentKey.self] = newValue }
    }

    var safariViewBarTintColor: Color? {
        get { self[SafariViewBarTintColorEnvironmentKey.self] }
        set { self[SafariViewBarTintColorEnvironmentKey.self] = newValue }
    }

    var safariViewDismissButtonStyle: SafariView.DismissButtonStyle {
        get { self[SafariViewDismissButtonStyleEnvironmentKey.self] }
        set { self[SafariViewDismissButtonStyleEnvironmentKey.self] = newValue }
    }

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewEntersReaderIfAvailableEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = Bool

    static let defaultValue: Value = false

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewBarCollapsingEnabledEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = Bool

    static let defaultValue: Value = false

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewControlTintColorEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = Color

    static var defaultValue: Value { .accentColor }

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewBarTintColorEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = Color?

    static var defaultValue: Value { nil }

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewDismissButtonStyleEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = SafariView.DismissButtonStyle

    static var defaultValue: Value { .default }

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewIncludedActivitiesEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = SafariView.IncludedActivities

    static let defaultValue: Value = .default

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewExcludedActivityTypesEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = SafariView.ExcludedActivityTypes

    static let defaultValue: Value = .default

}

@available(iOS 14.0, macCatalyst 14.0, *)
private struct SafariViewPresentationStyleEnvironmentKey: EnvironmentKey {

    // MARK: - EnvironmentKey

    typealias Value = SafariView.PresentationStyle

    static let defaultValue: Value = .default

}
