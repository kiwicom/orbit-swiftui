import SwiftUI

struct IsElevationEnabledKey: EnvironmentKey {
    static let defaultValue: Bool = true
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
