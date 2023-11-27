import SwiftUI

struct TextLinkColorKey: EnvironmentKey {
    static let defaultValue: TextLink.Color? = nil
}

public extension EnvironmentValues {

    /// Orbit `TextLink` ``TextLink/Color`` color stored in a view’s environment.
    var textLinkColor: TextLink.Color? {
        get { self[TextLinkColorKey.self] }
        set { self[TextLinkColorKey.self] = newValue }
    }
}

public extension View {

    /// Override the default Orbit `TextLink` ``TextLink/Color` for this view.
    ///
    /// - Parameters:
    ///   - color: A color that will be used by all ``TextLink``s inside the view hierarchy.
    func textLinkColor(_ color: TextLink.Color?) -> some View {
        environment(\.textLinkColor, color)
    }
}
