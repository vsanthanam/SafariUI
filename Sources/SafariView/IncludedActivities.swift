// SafariView
// IncludedActivities.swift
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

public extension SafariView {

    struct IncludedActivities: ExpressibleByArrayLiteral {

        // MARK: - Initializers

        public init(_ includedActivities: @escaping (_ url: URL, _ pageTitle: String?) -> [UIActivity]) {
            self.includedActivities = includedActivities
        }

        // MARK: - API

        public static let `default`: IncludedActivities = .init { _, _ in [] }

        public func callAsFunction(url: URL, pageTitle: String?) -> [UIActivity] {
            includedActivities(url, pageTitle)
        }

        public static func + (lhs: IncludedActivities, rhs: IncludedActivities) -> IncludedActivities {
            .init { url, pageTitle in
                lhs(url: url, pageTitle: pageTitle) + rhs(url: url, pageTitle: pageTitle)
            }
        }

        // MARK: - ExpressiblyByArrayLiteral

        public typealias ArrayLiteralElement = UIActivity

        public init(arrayLiteral elements: ArrayLiteralElement...) {
            self.init { _, _ in elements }
        }

        // MARK: - Private

        private let includedActivities: (_ url: URL, _ pageTitle: String?) -> [UIActivity]

    }

}
