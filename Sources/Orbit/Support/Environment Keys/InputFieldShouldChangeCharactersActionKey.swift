import SwiftUI

struct InputFieldShouldChangeCharactersActionKey: EnvironmentKey {
    static var defaultValue: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)?
}

struct InputFieldShouldChangeCharactersIdentifiableActionKey: EnvironmentKey {
    static var defaultValue: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)?
}

public extension EnvironmentValues {

    /// An Orbit `textField(shouldChangeCharactersIn:)` action for `InputField` stored in a view’s environment.
    var inputFieldShouldChangeCharactersAction: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)? {
        get { self[InputFieldShouldChangeCharactersActionKey.self] }
        set { self[InputFieldShouldChangeCharactersActionKey.self] = newValue }
    }

    /// An Orbit `textField(shouldChangeCharactersIn:)` action for `InputField` stored in a view’s environment.
    var inputFieldShouldChangeCharactersIdentifiableAction: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)? {
        get { self[InputFieldShouldChangeCharactersIdentifiableActionKey.self] }
        set { self[InputFieldShouldChangeCharactersIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textField(shouldChangeCharactersIn:)` action for Orbit `InputField`.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed for `InputField` inside the view hierarchy when deciding whether to change the specified text.
    ///   Parameters follow the `textField(shouldChangeCharactersIn:)` method - `(textField.text, range, replacementString)`.
    ///   A return value specifies whether the changes should be accepted and if not, whether the InputField value should be replaced with provided modified value.
    func inputFieldShouldChangeCharactersAction(_ action: @escaping (NSString, NSRange, String) -> InputFieldShouldChangeResult) -> some View {
        environment(\.inputFieldShouldChangeCharactersAction, action)
    }

    /// Set the `textField(shouldChangeCharactersIn:)` action for Orbit identifiable `InputField`.
    ///
    /// Mark the associated Orbit InputField with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed for identifiable `InputField` inside the view hierarchy when deciding whether to change the specified text.
    ///   The first parameter is an InputField identifier. The rest of parameters follow the `textField(shouldChangeCharactersIn:)` method - `(textField.text, range, replacementString)`.
    ///   A return value specifies whether the changes should be accepted and if not, whether the InputField value should be replaced with provided modified value.
    func inputFieldShouldChangeCharactersAction(_ action: @escaping (AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult) -> some View {
        environment(\.inputFieldShouldChangeCharactersIdentifiableAction, action)
    }
}
