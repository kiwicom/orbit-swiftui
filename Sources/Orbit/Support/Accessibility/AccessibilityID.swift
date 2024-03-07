import SwiftUI

/// Orbit accessibility identifier that identifies embedded sub-components.
///
/// Can be extended to provide custom accessibility identifiers.
public struct AccessibilityID: RawRepresentable, Equatable, Hashable, Sendable {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension View {

    /// Uses the specified Orbit identifier to identify the view inside a component.
    @available(iOS 14.0, *)
    func accessibilityIdentifier(_ accessibilityID: AccessibilityID) -> some View {
        self.accessibilityIdentifier(accessibilityID.rawValue)
    }

    /// Uses the specified Orbit identifier to identify the view inside a component.
    @available(iOS, introduced: 13.0, deprecated: 16.1, renamed: "accessibilityIdentifier(_:)")
    func accessibility(_ accessibilityID: AccessibilityID) -> some View {
        self.accessibility(identifier: accessibilityID.rawValue)
    }
}
