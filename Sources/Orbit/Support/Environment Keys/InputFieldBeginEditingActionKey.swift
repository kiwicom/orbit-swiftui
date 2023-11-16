import SwiftUI

struct InputFieldBeginEditingActionKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

struct InputFieldBeginEditingIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {

    /// An Orbit `textFieldDidBeginEditing` action for `InputField` stored in a view’s environment.
    @available(iOS, deprecated: 15.0, message: "Use native @FocusState to manage focus for Orbit text fields")
    var inputFieldBeginEditingAction: () -> Void {
        get { self[InputFieldBeginEditingActionKey.self] }
        set { self[InputFieldBeginEditingActionKey.self] = newValue }
    }

    /// An Orbit `textFieldDidBeginEditing` action for an identifiable `InputField` stored in a view’s environment.
    @available(iOS, deprecated: 15.0, message: "Use native @FocusState to manage focus for Orbit text fields")
    var inputFieldBeginEditingIdentifiableAction: (AnyHashable) -> Void {
        get { self[InputFieldBeginEditingIdentifiableActionKey.self] }
        set { self[InputFieldBeginEditingIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldDidBeginEditing` action for Orbit `InputField`.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed when the user starts editing `InputField` inside the view hierarchy.
    @available(iOS, deprecated: 15.0, renamed: "onChange(_:)", message: "Use native @FocusState in combination with `onChange` to monitor focus changes of Orbit text fields")
    func inputFieldBeginEditingAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldBeginEditingAction, action)
    }

    /// Set the `textFieldDidBeginEditing` action for Orbit identifiable `InputField`.
    ///
    /// Mark the associated Orbit InputField with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed when the user starts editing an identifiable `InputField` inside the view hierarchy.
    ///   The action parameter specifies the identifier of the `InputField`.
    @available(iOS, deprecated: 15.0, renamed: "onChange(_:)", message: "Use native @FocusState in combination with `onChange` to monitor focus changes of Orbit text fields")
    func inputFieldBeginEditingAction(_ action: @escaping (AnyHashable) -> Void) -> some View {
        environment(\.inputFieldBeginEditingIdentifiableAction, action)
    }
}
