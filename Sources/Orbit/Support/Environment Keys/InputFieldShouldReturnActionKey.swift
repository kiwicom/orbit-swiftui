import SwiftUI

struct InputFieldShouldReturnActionKey: EnvironmentKey {
    static let defaultValue: (() -> Bool)? = nil
}

struct InputFieldShouldReturnIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: ((AnyHashable) -> Bool)? = nil
}

public extension EnvironmentValues {

    /// An Orbit `textFieldShouldReturn` action for `InputField` stored in a view’s environment.
    var inputFieldShouldReturnAction: (() -> Bool)? {
        get { self[InputFieldShouldReturnActionKey.self] }
        set { self[InputFieldShouldReturnActionKey.self] = newValue }
    }

    /// An Orbit `textFieldShouldReturn` action for identifiable `InputField` stored in a view’s environment.
    var inputFieldShouldReturnIdentifiableAction: ((AnyHashable) -> Bool)? {
        get { self[InputFieldShouldReturnIdentifiableActionKey.self] }
        set { self[InputFieldShouldReturnIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldShouldReturn` action for Orbit `InputField`.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed to ask whether to process the pressing of the Return button for the `InputField` inside the view hierarchy.
    func inputFieldShouldReturnAction(_ action: @escaping () -> Bool) -> some View {
        environment(\.inputFieldShouldReturnAction, action)
    }

    /// Set the `textFieldShouldReturn` action for Orbit identifiable `InputField`.
    ///
    /// Mark the associated Orbit InputField with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed to ask whether to process the pressing of the Return button for the identifiable `InputField` inside the view hierarchy.
    func inputFieldShouldReturnAction(_ action: @escaping (AnyHashable) -> Bool) -> some View {
        environment(\.inputFieldShouldReturnIdentifiableAction, action)
    }
}
