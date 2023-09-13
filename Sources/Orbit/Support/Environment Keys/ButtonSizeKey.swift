import SwiftUI

/// Orbit size used for various button components.
public enum ButtonSize {
    case regular
    case compact
}

struct ButtonSizeKey: EnvironmentKey {
    static let defaultValue: ButtonSize? = nil
}

public extension EnvironmentValues {

    /// An Orbit `ButtonSize` value stored in a view’s environment.
    var buttonSize: ButtonSize? {
        get { self[ButtonSizeKey.self] }
        set { self[ButtonSizeKey.self] = newValue }
    }
}

public extension View {

    /// Set the button size for this view.
    ///
    /// - Parameters:
    ///   - size: A button size that will be used by all components in the view hierarchy.
    ///    Pass `nil` to ignore environment button size and to allow the system or the container to provide its own size.
    func buttonSize(_ size: ButtonSize?) -> some View {
        environment(\.buttonSize, size)
    }
}
