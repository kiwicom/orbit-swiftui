import SwiftUI

struct TextLineHeightKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

public extension EnvironmentValues {

    /// A text line height stored in a view’s environment, used for Orbit text based components, such as `Text` or `Heading`.
    ///
    /// This environment value serves as a replacement for native line height.
    var textLineHeight: CGFloat? {
        get { self[TextLineHeightKey.self] }
        set { self[TextLineHeightKey.self] = newValue }
    }
}

public extension View {

    /// Set the custom line height for any text based Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - height: An overall height that will be used in text based Orbit components such as `Text` or `Heading`.
    ///    Pass `nil` to ignore environment text size and to allow the system or the container to provide its own height.
    ///    If a container-specific override doesn’t exist, the line height will be calculated from text size.
    func textLineHeight(_ height: CGFloat?) -> some View {
        environment(\.textLineHeight, height)
    }
}
