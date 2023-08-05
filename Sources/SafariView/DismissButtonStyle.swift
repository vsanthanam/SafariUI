// SafariView
// DismissButtonStyle.swift
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

import SafariServices

public extension SafariView {

    /// An enumeration describing the various dismiss buttons styles available in a ``SafariView``
    enum DismissButtonStyle: Equatable, Hashable, Sendable {

        /// The done dismiss button style.
        case done

        /// The close dismiss button style.
        case close

        /// The cancel dismiss button style.
        case cancel

        /// The default dismiss button style.
        public static var `default`: DismissButtonStyle = .close

        var uikit: SFSafariViewController.DismissButtonStyle {
            switch self {
            case .done: return .done
            case .close: return .close
            case .cancel: return .cancel
            }
        }

    }

}
