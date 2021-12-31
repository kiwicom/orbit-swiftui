import SwiftUI

/// Envoronment key for driving fade in animation. WIP.
public struct IsFadeInKey: EnvironmentKey {
    public static var defaultValue: Bool = false
}

public extension EnvironmentValues {
    /// Indicates presence of fade-in animation. WIP.
    var isFadeIn: Bool {
        get { self[IsFadeInKey.self] }
        set { self[IsFadeInKey.self] = newValue }
    }
}
