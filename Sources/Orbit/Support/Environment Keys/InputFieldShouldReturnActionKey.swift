import SwiftUI

struct InputFieldShouldReturnActionKey: EnvironmentKey {
    static let defaultValue: (() -> Bool)? = nil
}

struct InputFieldShouldReturnIdentifiableActionKey: EnvironmentKey {
    static let defaultValue: ((AnyHashable) -> Bool)? = nil
}

public extension EnvironmentValues {

    /// An Orbit `textFieldShouldReturn` action for text fields stored in a view’s environment.
    var inputFieldShouldReturnAction: (() -> Bool)? {
        get { self[InputFieldShouldReturnActionKey.self] }
        set { self[InputFieldShouldReturnActionKey.self] = newValue }
    }

    /// An Orbit `textFieldShouldReturn` action for identifiable text field stored in a view’s environment.
    var inputFieldShouldReturnIdentifiableAction: ((AnyHashable) -> Bool)? {
        get { self[InputFieldShouldReturnIdentifiableActionKey.self] }
        set { self[InputFieldShouldReturnIdentifiableActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `textFieldShouldReturn` action for Orbit text fields that decides whether to process the keyboard Return button. 
    /// 
    /// By default, pressing the Return button will be processed and the keyboard will be dismissed, 
    /// triggering the optional ``inputFieldReturnAction(_:)-9w13u`` after the processing.
    /// 
    /// If the Return button should be ignored instead, return `false` from the provided action. 
    /// If the focus should be switched to another field, modify the focus value in the provided action.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed to ask whether to process the pressing of the Return button for text fields inside the view hierarchy.
    func inputFieldShouldReturnAction(_ action: @escaping () -> Bool) -> some View {
        environment(\.inputFieldShouldReturnAction, action)
    }

    /// Set the `textFieldShouldReturn` action for Orbit identifiable text fields that decides whether to process the keyboard Return button.
    /// 
    /// By default, pressing the Return button will be processed and the keyboard will be dismissed, 
    /// triggering the optional ``inputFieldReturnAction(_:)-1mvv4`` after the processing.
    /// 
    /// If the Return button should be ignored instead, return `false` from the provided action. 
    /// If the focus should be switched to another field, modify the focus value in the provided action.
    ///
    /// - Important: Mark the associated Orbit text field with ``identifier(_:)`` modifier to set its identity.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed to ask whether to process the pressing of the Return button for the identifiable text field inside the view hierarchy.
    func inputFieldShouldReturnAction(_ action: @escaping (AnyHashable) -> Bool) -> some View {
        environment(\.inputFieldShouldReturnIdentifiableAction, action)
    }
}
