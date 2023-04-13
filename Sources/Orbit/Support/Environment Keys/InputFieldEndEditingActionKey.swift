import SwiftUI

struct InputFieldEndEditingActionKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

public extension EnvironmentValues {

    /// An `InputField` end editing action stored in a view’s environment.
    var inputFieldEndEditingAction: () -> Void {
        get { self[InputFieldEndEditingActionKey.self] }
        set { self[InputFieldEndEditingActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `InputField` end editing action for this view.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed after the user ends editing `InputField` inside the view hierarchy.
    func inputFieldEndEditingAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldEndEditingAction, action)
    }
}
