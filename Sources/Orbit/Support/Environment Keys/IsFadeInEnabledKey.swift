import SwiftUI

struct IsFadeInEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = true
}

public extension EnvironmentValues {

    /// Indicates whether a fade-in animation is enabled in Orbit views.
    var isFadeInEnabled: Bool {
        get { self[IsFadeInEnabledKey.self] }
        set { self[IsFadeInEnabledKey.self] = newValue }
    }
}
