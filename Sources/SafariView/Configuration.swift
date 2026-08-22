// SafariUI
// Configuration.swift
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

#if os(iOS)
    import SafariServices
    import UIKit
#endif

@available(iOS 14.0, macCatalyst 14.0, *)
@available(macOS, unavailable)
@available(tvOS, unavailable)
@available(watchOS, unavailable)
extension SafariView {

    #if os(iOS)
        @available(iOS 15.0, macCatalyst 15.0, *)
        public typealias ActivityButton = SFSafariViewController.ActivityButton
    #endif

    @MainActor
    public struct Configuration: @MainActor Equatable, @MainActor Hashable {

        public nonisolated init(
            entersReaderIfAvailable: Bool = false,
            barCollapsingEnabled: Bool = true
        ) {
            self.entersReaderIfAvailable = entersReaderIfAvailable
            self.barCollapsingEnabled = barCollapsingEnabled
        }

        #if os(iOS)
            @available(iOS 15.0, macCatalyst 15.0, *)
            public init(
                entersReaderIfAvailable: Bool = false,
                barCollapsingEnabled: Bool = true,
                activityButton: ActivityButton?
            ) {
                self.entersReaderIfAvailable = entersReaderIfAvailable
                self.barCollapsingEnabled = barCollapsingEnabled
                storedActivityButton = activityButton
            }

            @available(iOS 15.2, macCatalyst 15.2, *)
            public init(
                entersReaderIfAvailable: Bool = false,
                barCollapsingEnabled: Bool = true,
                activityButton: ActivityButton? = nil,
                eventAttribution: UIEventAttribution?
            ) {
                self.entersReaderIfAvailable = entersReaderIfAvailable
                self.barCollapsingEnabled = barCollapsingEnabled
                storedActivityButton = activityButton
                storedEventAttribution = eventAttribution
            }
        #endif

        public var entersReaderIfAvailable: Bool

        public var barCollapsingEnabled: Bool

        #if os(iOS)
            @available(iOS 15.0, macCatalyst 15.0, *)
            public var activityButton: ActivityButton? {
                get {
                    guard let storedActivityButton else {
                        return nil
                    }
                    return unsafeDowncast(
                        storedActivityButton,
                        to: ActivityButton.self
                    )
                }
                set {
                    storedActivityButton = newValue
                }
            }

            @available(iOS 15.2, macCatalyst 15.2, *)
            public var eventAttribution: UIEventAttribution? {
                get {
                    guard let storedEventAttribution else {
                        return nil
                    }
                    return unsafeDowncast(
                        storedEventAttribution,
                        to: UIEventAttribution.self
                    )
                }
                set {
                    storedEventAttribution = newValue
                }
            }
        #endif

        public nonisolated static let `default`: Configuration = .init()

        public static func == (
            lhs: Configuration,
            rhs: Configuration
        ) -> Bool {
            lhs.entersReaderIfAvailable == rhs.entersReaderIfAvailable
                && lhs.barCollapsingEnabled == rhs.barCollapsingEnabled
                && lhs.storedActivityButton === rhs.storedActivityButton
                && lhs.storedEventAttribution === rhs.storedEventAttribution
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(entersReaderIfAvailable)
            hasher.combine(barCollapsingEnabled)
            storedActivityButton.map { hasher.combine(ObjectIdentifier($0)) }
            storedEventAttribution.map { hasher.combine(ObjectIdentifier($0)) }
        }

        #if os(iOS)
            var uikit: SFSafariViewController.Configuration {
                let configuration = SFSafariViewController.Configuration()
                configuration.entersReaderIfAvailable = entersReaderIfAvailable
                configuration.barCollapsingEnabled = barCollapsingEnabled
                if #available(iOS 15.0, macCatalyst 15.0, *) {
                    configuration.activityButton = activityButton
                }
                if #available(iOS 15.2, macCatalyst 15.2, *) {
                    configuration.eventAttribution = eventAttribution
                }
                return configuration
            }
        #endif

        private var storedActivityButton: AnyObject?
        private var storedEventAttribution: AnyObject?

    }

}
