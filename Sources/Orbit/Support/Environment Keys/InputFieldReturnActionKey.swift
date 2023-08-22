import SwiftUI

struct InputFieldReturnActionKey: EnvironmentKey {
    static let defaultValue: () -> Void = {}
}

struct InputFieldReturnIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: (AnyHashable) -> Void = { _ in }
}

public extension EnvironmentValues {

    /// An Orbit `inputFieldReturnAction` action for `InputField` stored in a view’s environment.
    var inputFieldReturnAction: () -> Void {
        get { self[InputFieldReturnActionKey.self] }
        set { self[InputFieldReturnActionKey.self] = newValue }
    }

    /// An Orbit `inputFieldReturnIdentifiableAction` action for identifiable `InputField` stored in a view’s environment.
    var inputFieldReturnIdentifiableAction: (AnyHashable) -> Void {
        get { self[InputFieldReturnIdentifiableActionKey.self] }
        set { self[InputFieldReturnIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldReturn` action for Orbit `InputField`.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed immediately after keyboard Return action for the `InputField` inside the view hierarchy.
    func inputFieldReturnAction(_ action: @escaping () -> Void) -> some View {
        environment(\.inputFieldReturnAction, action)
    }

    /// Set the `textFieldReturn` action for Orbit identifiable `InputField`.
    ///
    /// Mark the associated Orbit InputField with `identifier()` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed immediately after keyboard Return action for the identifiable `InputField` inside the view hierarchy.
    func inputFieldReturnAction(_ action: @escaping (AnyHashable) -> Void) -> some View {
        environment(\.inputFieldReturnIdentifiableAction, action)
    }
}
