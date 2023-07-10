import SwiftUI

/// Orbit Button priority.
public enum ButtonPriority {
    case primary
    case secondary
}

struct ButtonPriorityKey: EnvironmentKey {
    static let defaultValue: ButtonPriority? = nil
}

public extension EnvironmentValues {

    /// An Orbit `ButtonPriority` value stored in a view’s environment.
    var buttonPriority: ButtonPriority? {
        get { self[ButtonPriorityKey.self] }
        set { self[ButtonPriorityKey.self] = newValue }
    }
}

public extension View {

    /// Set the button priority for this view.
    ///
    /// - Parameters:
    ///   - priority: A button priority that will be used by components in the view hierarchy.
    ///    Pass `nil` to ignore environment button priority and to allow the system or the container to provide its own priority.
    func buttonPriority(_ priority: ButtonPriority?) -> some View {
        environment(\.buttonPriority, priority)
    }
}
