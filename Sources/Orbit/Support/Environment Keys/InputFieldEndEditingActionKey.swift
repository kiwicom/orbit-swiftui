import SwiftUI

struct InputFieldEndEditingActionKey: EnvironmentKey {
    static var defaultValue: () -> Void = {}
}

struct InputFieldEndEditingIdentifiableActionKey: EnvironmentKey {
    static var defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {

    /// An Orbit `textFieldDidEndEditing` action for `InputField` stored in a view’s environment.
    var inputFieldEndEditingAction: () -> Void {
        get { self[InputFieldEndEditingActionKey.self] }
        set { self[InputFieldEndEditingActionKey.self] = newValue }
    }

    /// An Orbit `textFieldDidEndEditing` action for an identifiable `InputField` stored in a view’s environment.
    var inputFieldEndEditingIdentifiableAction: (AnyHashable) -> Void {
        get { self[InputFieldEndEditingIdentifiableActionKey.self] }
        set { self[InputFieldEndEditingIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldDidEndEditing` action for Orbit `InputField`.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed after the user ends editing `InputField` inside the view hierarchy.
    func inputFieldEndEditingAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldEndEditingAction, action)
    }

    /// Set the `textFieldDidEndEditing` action for Orbit identifiable `InputField`.
    ///
    /// Mark the associated Orbit InputField with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed after the user ends editing a specific identifiable `InputField` inside the view hierarchy.
    ///   The action parameter specifies the identifier of the `InputField`.
    func inputFieldEndEditingAction(_ action: @escaping (AnyHashable) -> Void) -> some View {
        environment(\.inputFieldEndEditingIdentifiableAction, action)
    }
}
