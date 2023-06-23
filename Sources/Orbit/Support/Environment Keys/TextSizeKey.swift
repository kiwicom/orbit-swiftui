import SwiftUI

struct TextSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

public extension EnvironmentValues {

    /// A text size stored in a view’s environment, used for Orbit text based components, such as `Text`, `Heading` or `Icon`.
    ///
    /// This environment value serves as a replacement for non-public `font` environment value.
    var textSize: CGFloat? {
        get { self[TextSizeKey.self] }
        set { self[TextSizeKey.self] = newValue }
    }
}

public extension View {

    /// Set the text size for any text based Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - size: A size that will be used in text based Orbit components such as `Text` or `Icon`.
    ///    Pass `nil` to ignore environment text size and to allow the system or the container to provide its own size.
    ///    If a container-specific override doesn’t exist, the `.normal` size will be used.
    func textSize(_ size: Text.Size?) -> some View {
        environment(\.textSize, size?.value)
    }


    /// Set the custom text size for any text based Orbit component within the view hierarchy.
    ///
    /// - Parameters:
    ///   - size: A size that will be used in text based Orbit components such as `Text` or `Icon`.
    ///    Pass `nil` to ignore environment text size and to allow the system or the container to provide its own size.
    ///    If a container-specific override doesn’t exist, the `.normal` size will be used.
    func textSize(custom size: CGFloat?) -> some View {
        environment(\.textSize, size)
    }
}
