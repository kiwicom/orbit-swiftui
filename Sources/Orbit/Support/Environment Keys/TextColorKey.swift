import SwiftUI

struct TextColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

public extension EnvironmentValues {

    /// A text color stored in a view’s environment, used for Orbit text based components, such as ``Text``, ``Heading`` or ``Icon``.
    ///
    /// This environment value serves as a replacement for non-public `foregroundColor` environment value.
    var textColor: Color? {
        get { self[TextColorKey.self] }
        set { self[TextColorKey.self] = newValue }
    }
}

public extension View {

    /// Set the text color for any text based Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in text based Orbit components such as ``Text``, ``Heading`` or ``Icon``.
    ///    Pass `nil` to ignore environment text color and to allow the system or the container to provide its own color. If a container-specific override doesn’t exist, the `inkDark` color will be used.
    func textColor(_ color: Color?) -> some View {
        environment(\.textColor, color)
    }
}
