import SwiftUI

/// Environment key for driving expanded animation simultaneously with view transition.
public struct IsExpandedKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {

    /// Indicates whether the view should be animated as a result of being expanded or collapsed.
    ///
    /// Required for proper animations when view is added or removed using transition.
    var isExpanded: Bool {
        get { self[IsExpandedKey.self] }
        set { self[IsExpandedKey.self] = newValue }
    }
}
