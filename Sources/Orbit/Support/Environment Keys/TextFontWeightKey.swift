import SwiftUI

struct TextFontWeightKey: EnvironmentKey {
    static let defaultValue: Font.Weight? = nil
}

public extension EnvironmentValues {

    /// A font weight stored in a view’s environment, used for Orbit text based components.
    var textFontWeight: Font.Weight? {
        get { self[TextFontWeightKey.self] }
        set { self[TextFontWeightKey.self] = newValue }
    }
}

public extension View {

    /// Set the font weight for any text based Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - fontWeight: A font weight that will be used in text based Orbit components.
    ///                 Pass `nil` to ignore environment font weight and to allow the system
    ///                 or the container to provide its own font weight.
    ///                 If a container-specific override doesn’t exist, the `regular` will be used.
    @available(iOS, introduced: 13, obsoleted: 16, renamed: "fontWeight")
    func textFontWeight(_ fontWeight: Font.Weight?) -> some View {
        environment(\.textFontWeight, fontWeight)
    }
}
