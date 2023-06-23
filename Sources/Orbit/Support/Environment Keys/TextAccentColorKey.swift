import SwiftUI

struct TextAccentColorKey: EnvironmentKey {
    static let defaultValue: Color? = nil
}

public extension EnvironmentValues {

    /// A text accent color stored in a view’s environment.
    ///
    /// - Important: The environment value is different from the native deprecated internal `accentColor` value.
    var textAccentColor: Color? {
        get { self[TextAccentColorKey.self] }
        set { self[TextAccentColorKey.self] = newValue }
    }
}

public extension View {

    /// Set the text accent color for any Orbit formatted text in this view.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in `<ref>` tags in texts within the view hierarchy.
    func textAccentColor(_ color: Color?) -> some View {
        environment(\.textAccentColor, color)
    }
}
