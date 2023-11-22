import SwiftUI

struct InputFieldReturnActionKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

struct InputFieldReturnIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {

    /// An Orbit `inputFieldReturnAction` action for text fields stored in a view’s environment.
    var inputFieldReturnAction: () -> Void {
        get { self[InputFieldReturnActionKey.self] }
        set { self[InputFieldReturnActionKey.self] = newValue }
    }

    /// An Orbit `inputFieldReturnIdentifiableAction` action for identifiable text field stored in a view’s environment.
    var inputFieldReturnIdentifiableAction: (AnyHashable) -> Void {
        get { self[InputFieldReturnIdentifiableActionKey.self] }
        set { self[InputFieldReturnIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldReturn` action for Orbit text fields.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed immediately after keyboard Return action for the text field inside the view hierarchy.
    func inputFieldReturnAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldReturnAction, action)
    }

    /// Set the `textFieldReturn` action for Orbit identifiable text fields.
    ///
    /// Mark the associated Orbit text field with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed immediately after keyboard Return action for the identifiable text field inside the view hierarchy.
    func inputFieldReturnAction(_ action: @escaping (AnyHashable) -> Void) -> some View {
        environment(\.inputFieldReturnIdentifiableAction, action)
    }
}
