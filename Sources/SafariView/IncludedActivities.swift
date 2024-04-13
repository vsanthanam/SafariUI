// SafariUI
// IncludedActivities.swift
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
import UIKit

@available(iOS 14.0, macCatalyst 14.0, *)
public extension SafariView {

    /// A struct used to include custom activities in the share sheet of a ``SafariView``
    struct IncludedActivities: ExpressibleByArrayLiteral {

        // MARK: - Initializers

        /// Include activities conditionally, based on the URL and/or page title.
        /// - Parameter includedActivities: Closure used to provide activitues
        public init(_ includedActivities: @escaping (_ url: URL, _ pageTitle: String?) -> [UIActivity]) {
            self.includedActivities = includedActivities
        }

        /// Include activities using a predefined list
        /// - Parameter includedActivities: A list of activities to include in the share sheet
        public init(_ includedActivities: [UIActivity]) {
            self.includedActivities = { _, _ in includedActivities }
        }

        // MARK: - API

        public static func + (lhs: IncludedActivities, rhs: IncludedActivities) -> IncludedActivities {
            .init { url, pageTitle in
                lhs(url: url, pageTitle: pageTitle) + rhs(url: url, pageTitle: pageTitle)
            }
        }

        // MARK: - ExpressiblyByArrayLiteral

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = UIActivity

        /// Creates an `IncludedActivities` containing the elements of the given array literal
        ///
        /// Do not call this initializer directly. It is used by the compiler when you use an array literal. Instead, create a new `IncludedActivities` using an array literal as its value by enclosing a comma-separated list of values in square brackets. You can use an array literal anywhere an `IncludedActivities` is expected by the type context. For example:
        ///
        /// ```swift
        /// let included: SafariView.IncludedActivities = [someActivity, someOtherActivity]
        /// ```
        ///
        /// In this example, the assignment to the `included` constant calls this array literal initializer behind the scenes.
        /// - Parameter elements: A variadic list of activities.
        public init(arrayLiteral elements: ArrayLiteralElement...) {
            self.init { _, _ in elements }
        }

        // MARK: - Private

        static let `default`: IncludedActivities = .init()

        func callAsFunction(url: URL, pageTitle: String?) -> [UIActivity] {
            includedActivities(url, pageTitle)
        }

        private let includedActivities: (_ url: URL, _ pageTitle: String?) -> [UIActivity]

    }

}
