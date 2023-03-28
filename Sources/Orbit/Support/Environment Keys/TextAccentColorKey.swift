import SwiftUI

struct TextAccentColorKey: EnvironmentKey {
    static var defaultValue: UIColor? = nil
}

public extension EnvironmentValues {

    /// A text accent color stored in a view’s environment.
    ///
    /// - Important: The environment value is different from the native deprecated `accentColor` value that only works with `Color` type and is internal.
    var textAccentColor: UIColor? {
        get { self[TextAccentColorKey.self] }
        set { self[TextAccentColorKey.self] = newValue }
    }
}

public extension View {

    /// Override the text accent color for any text in this view.
    ///
    /// - Parameters:
    ///   - color: A color that will be used in `<ref>` tags in texts within the view hierarchy.
    func textAccentColor(_ color: UIColor?) -> some View {
        environment(\.textAccentColor, color)
    }
}
