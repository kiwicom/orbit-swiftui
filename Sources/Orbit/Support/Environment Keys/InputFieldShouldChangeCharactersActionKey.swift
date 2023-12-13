import SwiftUI

struct InputFieldShouldChangeCharactersActionKey: EnvironmentKey {
    static let defaultValue: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)? = nil
}

struct InputFieldShouldChangeCharactersIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)? = nil
}

public extension EnvironmentValues {

    /// An Orbit `textField(shouldChangeCharactersIn:)` action for text fields stored in a view’s environment.
    var inputFieldShouldChangeCharactersAction: ((NSString, NSRange, String) -> InputFieldShouldChangeResult)? {
        get { self[InputFieldShouldChangeCharactersActionKey.self] }
        set { self[InputFieldShouldChangeCharactersActionKey.self] = newValue }
    }

    /// An Orbit `textField(shouldChangeCharactersIn:)` action for identifiable text field stored in a view’s environment.
    var inputFieldShouldChangeCharactersIdentifiableAction: ((AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult)? {
        get { self[InputFieldShouldChangeCharactersIdentifiableActionKey.self] }
        set { self[InputFieldShouldChangeCharactersIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textField(shouldChangeCharactersIn:)` action for Orbit text fields.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed for text fields inside the view hierarchy when deciding whether to change the specified text.
    ///   Parameters follow the `textField(shouldChangeCharactersIn:)` method - `(textField.text, range, replacementString)`.
    ///   A return value specifies whether the changes should be accepted and if not, whether the text field value should be replaced with provided modified value.
    func inputFieldShouldChangeCharactersAction(_ action: @escaping (NSString, NSRange, String) -> InputFieldShouldChangeResult) -> some View {
        environment(\.inputFieldShouldChangeCharactersAction, action)
    }

    /// Set the `textField(shouldChangeCharactersIn:)` action for Orbit identifiable text fields.
    ///
    /// - Important: Mark the associated Orbit text field with ``identifier(_:)`` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed for identifiable text fields inside the view hierarchy when deciding whether to change the specified text.
    ///   The first parameter is a text field identifier. The rest of parameters follow the `textField(shouldChangeCharactersIn:)` method - `(textField.text, range, replacementString)`.
    ///   A return value specifies whether the changes should be accepted and if not, whether the text field value should be replaced with provided modified value.
    func inputFieldShouldChangeCharactersAction(_ action: @escaping (AnyHashable, NSString, NSRange, String) -> InputFieldShouldChangeResult) -> some View {
        environment(\.inputFieldShouldChangeCharactersIdentifiableAction, action)
    }
}
