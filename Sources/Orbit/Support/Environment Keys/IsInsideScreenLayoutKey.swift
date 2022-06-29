import SwiftUI

/// Environment key for setting the context to be inside the `screenLayout`.
public struct IsInsideScreenLayoutKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {

    /// Indicates whether the content is inside the `screenLayout`.
    var isInsideScreenLayout: Bool {
        get { self[IsInsideScreenLayoutKey.self] }
        set { self[IsInsideScreenLayoutKey.self] = newValue }
    }
}
