import SwiftUI

struct TextLinkActionKey: EnvironmentKey {
    static let defaultValue: TextLink.Action? = nil
}

public extension EnvironmentValues {

    /// Orbit `TextLink` ``TextLink/Action`` stored in a view’s environment.
    var textLinkAction: TextLink.Action? {
        get { self[TextLinkActionKey.self] }
        set { self[TextLinkActionKey.self] = newValue }
    }
}

public extension View {

    /// Set the `TextLink` ``TextLink/Action`` for text links found in this view.
    ///
    /// - Parameters:
    ///   - action: A  handler that is executed when the user taps on any ``TextLink`` inside the view hierarchy.
    func textLinkAction(_ action: @escaping TextLink.Action) -> some View {
        environment(\.textLinkAction, action)
    }
}
