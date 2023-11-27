import SwiftUI

struct IconSizeKey: EnvironmentKey {
    static let defaultValue: CGFloat? = nil
}

public extension EnvironmentValues {

    /// An icon size stored in a view’s environment, used for Orbit ``Icon`` component.
    ///
    /// This value has a priority over a `textSize`.
    var iconSize: CGFloat? {
        get { self[IconSizeKey.self] }
        set { self[IconSizeKey.self] = newValue }
    }
}

public extension View {

    /// Set the size for any Orbit ``Icon`` component within the view hierarchy.
    ///
    /// The `iconSize` value has a priority over the `textSize` environment value that can be used to size Icon to match the text size.
    ///
    /// - Parameters:
    ///   - size: A size that will be used in Orbit ``Icon`` components.
    ///    Pass `nil` to ignore environment icon size and to allow the system or the container to provide its own size.
    ///    If a container-specific override doesn’t exist, the `textSize` or default `.normal` size will be used.
    func iconSize(_ size: Icon.Size?) -> some View {
        environment(\.iconSize, size?.value)
    }

    /// Set the size for any Orbit ``Icon`` component within the view hierarchy.
    ///
    /// The `iconSize` value has a priority over the `textSize` environment value that can be used to size Icon to match the text size.
    ///
    /// - Parameters:
    ///   - size: A size that will be used in Orbit ``Icon`` components.
    ///    Pass `nil` to ignore environment icon size and to allow the system or the container to provide its own size.
    ///    If a container-specific override doesn’t exist, the `textSize` or default `.normal` size will be used.
    func iconSize(custom size: CGFloat?) -> some View {
        environment(\.iconSize, size)
    }

    /// Set the size, matching line height of a provided text size, for any Orbit ``Icon`` component within the view hierarchy.
    ///
    /// The `iconSize` value has a priority over the `textSize` environment value that can be used to size Icon to match the text size.
    ///
    /// - Parameters:
    ///   - size: A size that will be used in Orbit ``Icon`` components.
    ///    Pass `nil` to ignore environment icon size and to allow the system or the container to provide its own size.
    ///    If a container-specific override doesn’t exist, the `textSize` or default `.normal` size will be used.
    func iconSize(textSize: Text.Size?) -> some View {
        environment(\.iconSize, textSize?.lineHeight)
    }
}
