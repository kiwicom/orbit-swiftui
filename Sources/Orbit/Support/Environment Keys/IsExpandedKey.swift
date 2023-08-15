import SwiftUI

struct IsExpandedKey: EnvironmentKey {
    static let defaultValue: Bool = false
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
