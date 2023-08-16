import SwiftUI

struct IconColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

public extension EnvironmentValues {

    /// An icon color stored in a view’s environment, used for Orbit Icon component.
    ///
    /// This environment value serves as a replacement for non-public `foregroundColor` environment value.
    /// This value has a priority over a `textColor`.
    var iconColor: Color? {
        get { self[IconColorKey.self] }
        set { self[IconColorKey.self] = newValue }
    }
}

public extension View {

    /// Set the color for any Orbit `Icon` component within the view hierarchy.
    ///
    /// The `iconColor` value has a priority over the `textColor` environment value.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in Orbit `Icon` components.
    ///    Pass `nil` to ignore environment icon color and to allow the system or the container to provide its own color. If a container-specific override doesn’t exist, the `textColor` color will be used.
    func iconColor(_ color: Color?) -> some View {
        environment(\.iconColor, color)
    }
}
