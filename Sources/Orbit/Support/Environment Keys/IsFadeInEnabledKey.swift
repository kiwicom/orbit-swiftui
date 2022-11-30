import SwiftUI

/// Environment key for driving fade in animation.
public struct IsFadeInEnabledKey: EnvironmentKey {
    public static var defaultValue: Bool = true
}

public extension EnvironmentValues {

    /// Indicates whether a fade-in animation is enabled.
    var isFadeInEnabled: Bool {
        get { self[IsFadeInEnabledKey.self] }
        set { self[IsFadeInEnabledKey.self] = newValue }
    }
}
