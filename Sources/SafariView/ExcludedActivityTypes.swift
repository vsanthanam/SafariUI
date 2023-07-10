// SafariView
// ExcludedActivityTypes.swift
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

import Foundation
import UIKit

@available(iOS 15.0, *)
public extension SafariView {

    /// A struct used to exclude activity types from the share sheet of a ``SafariView``.
    struct ExcludedActivityTypes: ExpressibleByArrayLiteral {

        /// Exclude activity types conditionally, based on the URL and/or page title.
        /// - Parameter excludedActivityTypes: Closure used to exclude activity types
        public init(_ excludedActivityTypes: @escaping (URL, String?) -> [UIActivity.ActivityType]) {
            self.excludedActivityTypes = excludedActivityTypes
        }

        /// Exclude activity types using a predefined list
        /// - Parameter excludedActivityTypes: A list of activity types to exclude from the share sheet
        public init(_ excludedActivityTypes: [UIActivity.ActivityType] = []) {
            self.excludedActivityTypes = { _, _ in excludedActivityTypes }
        }

        // MARK: - API

        public static func + (lhs: ExcludedActivityTypes, rhs: ExcludedActivityTypes) -> ExcludedActivityTypes {
            .init { url, pageTitle in
                lhs(url: url, pageTitle: pageTitle) + rhs(url: url, pageTitle: pageTitle)
            }
        }

        // MARK: - ExpressiblyByArrayLiteral

        /// The type of the elements of an array literal.
        public typealias ArrayLiteralElement = UIActivity.ActivityType

        /// Creates an `ExcludedActivityTypes` containing the elements of the given array literal
        ///
        /// Do not call this initializer directly. It is used by the compiler when you use an array literal. Instead, create a new `ExcludedActivityTypes` using an array literal as its value by enclosing a comma-separated list of values in square brackets. You can use an array literal anywhere an `ExcludedActivityTypes` is expected by the type context. For example:
        ///
        /// ```swift
        /// let excluded: SafariView.ExcludedActivityTypes = [.addToReadingList, .airDrop, .print, .sharePlay]
        /// ```
        ///
        /// In this example, the assignment to the `excluded` constant calls this array literal initializer behind the scenes.
        /// - Parameter elements: A variadic list of activity types.
        public init(arrayLiteral elements: ArrayLiteralElement...) {
            self.init { _, _ in elements }
        }

        // MARK: - Private

        static let `default`: ExcludedActivityTypes = .init()

        func callAsFunction(url: URL, pageTitle: String?) -> [UIActivity.ActivityType] {
            excludedActivityTypes(url, pageTitle)
        }

        private let excludedActivityTypes: (URL, String?) -> [UIActivity.ActivityType]

    }

}
