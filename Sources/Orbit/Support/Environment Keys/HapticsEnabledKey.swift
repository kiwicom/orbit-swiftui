import SwiftUI

struct HapticsEnabledKey: EnvironmentKey {
    static let defaultValue = true
}

public extension EnvironmentValues {

    /// Whether Orbit haptic feedback on controls is enabled.
    var isHapticsEnabled: Bool {
        get { self[HapticsEnabledKey.self] }
        set { self[HapticsEnabledKey.self] = newValue }
    }
}

public extension View {

    /// Disables Orbit haptic feedback on controls.
    func hapticsDisabled(_ disabled: Bool = true) -> some View {
        environment(\.isHapticsEnabled, disabled == false)
    }
}
