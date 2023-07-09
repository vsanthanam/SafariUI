// SafariView
// Configuration.swift
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

import UIKit

@available(iOS 15.0, *)
public extension SafariView {

    /// The configuration for a ``SafariView/SafariView``
    ///
    /// To change the configuration for the current scope, see the ``SwiftUI/View/safariConfiguration(_:)`` view modifier.
    struct Configuration {

        /// Create a new safari view configuration
        /// - Parameters:
        ///   - entersReaderIfAvailable: Whether or not the view should enter reader mode automatically, if available.
        ///   - barCollapsingEnabled: Whether or not the view should support bar collapsing.
        ///   - activityButton: A custom activity button.
        ///   - eventAttribution: Event attribution data for Private Click Measurement.
        @available(iOS 15.2, *)
        public init(
            entersReaderIfAvailable: Bool = false,
            barCollapsingEnabled: Bool = false,
            activityButton: ActivityButton? = nil,
            eventAttribution: UIEventAttribution? = nil
        ) {
            self.entersReaderIfAvailable = entersReaderIfAvailable
            self.barCollapsingEnabled = barCollapsingEnabled
            self.activityButton = activityButton
            _eventAttribution = eventAttribution
        }

        /// Create a new safari view configuration
        /// - Parameters:
        ///   - entersReaderIfAvailable: Whether or not the view should enter reader mode automatically, if available.
        ///   - barCollapsingEnabled: Whether or not the view should support bar collapsing.
        ///   - activityButton: A custom activity button.
        @available(iOS, deprecated: 15.2)
        public init(
            entersReaderIfAvailable: Bool = false,
            barCollapsingEnabled: Bool = false,
            activityButton: ActivityButton? = nil
        ) {
            self.entersReaderIfAvailable = entersReaderIfAvailable
            self.barCollapsingEnabled = barCollapsingEnabled
            self.activityButton = activityButton
            _eventAttribution = nil
        }

        /// A value that specifies whether Safari should enter Reader mode, if it is available.
        ///
        /// Set the value to `true` if Reader mode should be entered automatically when it is available for the webpage; otherwise, false. The default value is `false`.
        public var entersReaderIfAvailable: Bool

        /// A value that specifies whether Safari should allow bar collapsing
        ///
        /// Set the value `true` if bar collapsing should be enabled when the user scrolls; otherwise, false. The default value is `false`.
        public var barCollapsingEnabled: Bool

        /// The activity button to use in the Safari View.
        public var activityButton: ActivityButton?

        /// An object you use to send tap event attribution data to the browser for Private Click Measurement.
        ///
        /// For more information about preparing event attribution data, see [`UIEventAttribution`](https://developer.apple.com/documentation/uikit/uieventattribution).
        @available(iOS 15.2, *)
        public var eventAttribution: UIEventAttribution? {
            get {
                _eventAttribution as? UIEventAttribution? ?? nil
            }
            set {
                _eventAttribution = newValue
            }
        }

        private var _eventAttribution: Any?
    }

}
