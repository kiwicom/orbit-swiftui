import SwiftUI

/// Environment key for disabling built-in elevation in Orbit components.
public struct IsElevationEnabledKey: EnvironmentKey {
    public static var defaultValue: Bool = true
}

public extension EnvironmentValues {

    /// Indicates whether an Orbit component should use its built-in elevation.
    ///
    /// Set this to `false` if you want to provide your own elevation.
    var isElevationEnabled: Bool {
        get { self[IsElevationEnabledKey.self] }
        set { self[IsElevationEnabledKey.self] = newValue }
    }
}
