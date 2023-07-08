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

public extension SafariView {

    struct ExcludedActivityTypes: ExpressibleByArrayLiteral {

        public init(_ excludedActivityTypes: @escaping (URL, String?) -> [UIActivity.ActivityType]) {
            self.excludedActivityTypes = excludedActivityTypes
        }

        public init(_ excludedActivityTypes: [UIActivity.ActivityType] = []) {
            self.excludedActivityTypes = { _, _ in excludedActivityTypes }
        }

        // MARK: - API

        public static let `default`: ExcludedActivityTypes = .init()

        public func callAsFunction(url: URL, pageTitle: String?) -> [UIActivity.ActivityType] {
            excludedActivityTypes(url, pageTitle)
        }

        public static func + (lhs: ExcludedActivityTypes, rhs: ExcludedActivityTypes) -> ExcludedActivityTypes {
            .init { url, pageTitle in
                lhs(url: url, pageTitle: pageTitle) + rhs(url: url, pageTitle: pageTitle)
            }
        }

        // MARK: - ExpressiblyByArrayLiteral

        public typealias ArrayLiteralElement = UIActivity.ActivityType

        public init(arrayLiteral elements: ArrayLiteralElement...) {
            self.init { _, _ in elements }
        }

        // MARK: - Sequence

        public typealias Element = UIActivity.ActivityType

        // MARK: - Private

        private let excludedActivityTypes: (URL, String?) -> [UIActivity.ActivityType]

    }

}
