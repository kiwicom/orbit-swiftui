import SwiftUI

struct InputFieldEndEditingActionKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

struct InputFieldEndEditingIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {

    /// An Orbit `textFieldDidEndEditing` action for text fields stored in a view’s environment.
    @available(iOS, deprecated: 15.0, message: "Use native @FocusState to manage focus for Orbit text fields")
    var inputFieldEndEditingAction: () -> Void {
        get { self[InputFieldEndEditingActionKey.self] }
        set { self[InputFieldEndEditingActionKey.self] = newValue }
    }

    /// An Orbit `textFieldDidEndEditing` action for an identifiable text field stored in a view’s environment.
    @available(iOS, deprecated: 15.0, message: "Use native @FocusState to manage focus for Orbit text fields")
    var inputFieldEndEditingIdentifiableAction: (AnyHashable) -> Void {
        get { self[InputFieldEndEditingIdentifiableActionKey.self] }
        set { self[InputFieldEndEditingIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldDidEndEditing` action for Orbit text fields.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed after the user ends editing text field inside the view hierarchy.
    @available(iOS, deprecated: 15.0, renamed: "onChange(_:)", message: "Use native @FocusState in combination with `onChange` to monitor focus changes of Orbit text fields")
    func inputFieldEndEditingAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldEndEditingAction, action)
    }

    /// Set the `textFieldDidEndEditing` action for Orbit identifiable text fields.
    ///
    /// Mark the associated Orbit text field with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed after the user ends editing a specific identifiable text field inside the view hierarchy.
    ///   The action parameter specifies the identifier of the text field.
    @available(iOS, deprecated: 15.0, renamed: "onChange(_:)", message: "Use native @FocusState in combination with `onChange` to monitor focus changes of Orbit text fields")
    func inputFieldEndEditingAction(_ action: @escaping (AnyHashable) -> Void) -> some View {
        environment(\.inputFieldEndEditingIdentifiableAction, action)
    }
}
