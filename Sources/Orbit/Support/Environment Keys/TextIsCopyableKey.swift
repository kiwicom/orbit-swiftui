import SwiftUI

struct TextIsCopyableKey: EnvironmentKey {
    static let defaultValue = false
}

public extension EnvironmentValues {

    /// A text copyable status stored in a view’s environment, used for Orbit text components, such as `Text` or `Heading`.
    var textIsCopyable: Bool {
        get { self[TextIsCopyableKey.self] }
        set { self[TextIsCopyableKey.self] = newValue }
    }
}

public extension View {

    /// Set the copyable status for any text based Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - enabled: A value that will be used to decide whether text based Orbit components
    ///   such as `Text` or `Heading` can be copied using long tap gesture.
    func textIsCopyable(_ enabled: Bool = true) -> some View {
        environment(\.textIsCopyable, enabled)
    }
}
