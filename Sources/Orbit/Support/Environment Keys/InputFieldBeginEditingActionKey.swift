import SwiftUI

struct InputFieldBeginEditingActionKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

public extension EnvironmentValues {

    /// An `InputField` begin editing action stored in a view’s environment.
    var inputFieldBeginEditingAction: () -> Void {
        get { self[InputFieldBeginEditingActionKey.self] }
        set { self[InputFieldBeginEditingActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `InputField` begin editing action for this view.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed when the user focuses the `InputField` inside the view hierarchy.
    func inputFieldBeginEditingAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldBeginEditingAction, action)
    }
}
