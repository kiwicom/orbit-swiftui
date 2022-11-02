import SwiftUI

/// Orbit accessibility identifier for use in wrapper components.
///
/// Can be extended to provide custom accessibility identifiers.
public struct AccessibilityID: RawRepresentable {

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

public extension View {

    /// Uses the specified identifier to identify the view inside a component.
    @available(iOS 14.0, *)
    func accessibilityIdentifier(_ accessibilityID: AccessibilityID) -> some View {
        self.accessibilityIdentifier(accessibilityID.rawValue)
    }

    /// Uses the specified identifier to identify the view inside a component.
    @available(iOS, introduced: 13.0, deprecated: 16.1, renamed: "accessibilityIdentifier(_:)")
    func accessibility(_ accessibilityID: AccessibilityID) -> some View {
        self.accessibility(identifier: accessibilityID.rawValue)
    }
}
